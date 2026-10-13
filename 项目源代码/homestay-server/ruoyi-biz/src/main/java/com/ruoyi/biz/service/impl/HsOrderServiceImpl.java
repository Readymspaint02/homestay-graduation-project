package com.ruoyi.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.biz.domain.hs.HsCleaningTask;
import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.domain.hs.HsMessage;
import com.ruoyi.biz.domain.hs.HsOrder;
import com.ruoyi.biz.domain.hs.HsRoomCalendar;
import com.ruoyi.biz.domain.hs.HsStatusConstants;
import com.ruoyi.biz.domain.hs.bo.HsOrderActionBo;
import com.ruoyi.biz.domain.hs.bo.HsOrderCreateBo;
import com.ruoyi.biz.mapper.HsCleaningTaskMapper;
import com.ruoyi.biz.mapper.HsHomestayMapper;
import com.ruoyi.biz.mapper.HsMessageMapper;
import com.ruoyi.biz.mapper.HsOrderMapper;
import com.ruoyi.biz.mapper.HsRoomCalendarMapper;
import com.ruoyi.biz.service.HsCacheService;
import com.ruoyi.biz.service.IHsOrderService;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Order service implementation.
 * 
 * 【面试知识点 -Redis 应用场景】
 * 热门房源排行榜：使用 ZSet 数据结构
 * - score = 热度值 (订单金额 * 权重)
 * - 自动排序，查询 TOP N 高效
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class HsOrderServiceImpl implements IHsOrderService {

    private static final Duration ORDER_LOCK_TTL = Duration.ofSeconds(10);

    private final HsOrderMapper orderMapper;
    private final HsHomestayMapper homestayMapper;
    private final HsRoomCalendarMapper roomCalendarMapper;
    private final HsMessageMapper messageMapper;
    private final HsCleaningTaskMapper cleaningTaskMapper;
    private final RedisCache redisCache;
    private final HsCacheService cacheService;
    private final MessageSseService messageSseService;
    private final SysUserMapper userMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public HsOrder createOrder(HsOrderCreateBo bo) {
        Long userId = SecurityUtils.getUserId();
        LocalDate checkinDate = parseDate(bo.getCheckinDate(), "checkinDate");
        LocalDate checkoutDate = parseDate(bo.getCheckoutDate(), "checkoutDate");
        if (!checkoutDate.isAfter(checkinDate)) {
            throw new ServiceException("checkoutDate must be after checkinDate");
        }

        int nights = (int) (checkoutDate.toEpochDay() - checkinDate.toEpochDay());
        if (nights > 30) {
            throw new ServiceException("single order nights cannot exceed 30");
        }

        HsHomestay homestay = homestayMapper.selectById(bo.getHomestayId());
        if (homestay == null) {
            throw new ServiceException("homestay not found");
        }
        if (!HsStatusConstants.AUDIT_APPROVED.equals(homestay.getAuditStatus())
            || !HsStatusConstants.PUBLISH_ONLINE.equals(homestay.getPublishStatus())) {
            throw new ServiceException("homestay is not available for booking");
        }
        if (bo.getGuestCount() > homestay.getMaxGuests()) {
            throw new ServiceException("guestCount exceeds maxGuests");
        }

        String orderLockKey = buildOrderLockKey(homestay.getId(), checkinDate, checkoutDate);
        boolean locked = tryAcquireLock(orderLockKey, String.valueOf(userId), ORDER_LOCK_TTL);
        if (!locked) {
            throw new ServiceException("another booking is in progress, please retry");
        }

        try {
            List<HsRoomCalendar> calendars = queryDateRangeCalendars(homestay.getId(), checkinDate, checkoutDate);
            Map<LocalDate, HsRoomCalendar> calendarMap = buildCalendarMap(calendars);
            initMissingCalendars(homestay, checkinDate, checkoutDate, calendarMap);

            String orderNo = generateNo("OD");
            BigDecimal total = bookCalendarsWithVersion(orderNo, checkinDate, checkoutDate, calendarMap, homestay.getBasePrice());

            HsOrder order = new HsOrder();
            order.setTenantId(getTenantId());
            order.setOrderNo(orderNo);
            order.setHomestayId(homestay.getId());
            order.setTenantUserId(userId);
            order.setLandlordUserId(homestay.getLandlordUserId());
            order.setCheckinDate(DateUtils.toDate(checkinDate));
            order.setCheckoutDate(DateUtils.toDate(checkoutDate));
            order.setNights(nights);
            order.setGuestCount(bo.getGuestCount());
            order.setAmountTotal(total);
            order.setAmountPayable(total);
            order.setPayStatus(HsStatusConstants.PAY_UNPAID);
            order.setOrderStatus(HsStatusConstants.ORDER_WAIT_PAY);
            order.setCreateBy(userId);
            order.setUpdateBy(userId);
            if (orderMapper.insert(order) <= 0) {
                throw new ServiceException("create order failed");
            }
            insertMessage(order.getLandlordUserId(), "2", "新订单通知", "新订单：" + orderNo, orderNo);
            
            messageSseService.sendToUser(order.getLandlordUserId(), "new_order",
                "{\"type\":\"new_order\",\"orderId\":" + order.getId() + ",\"orderNo\":\"" + orderNo + "\",\"orderStatus\":\"" + HsStatusConstants.ORDER_WAIT_PAY + "\"}");
            
            // 【面试知识点 - 热门房源排行榜】
            // 订单创建成功后，更新房源热度 (异步更新，不影响主流程)
            // 热度值 = 订单金额 * 权重 (这里简化为直接加订单金额)
            try {
                cacheService.updateHotRanking(homestay.getId(), order.getAmountTotal().doubleValue());
                log.info("已更新房源热度：homestayId={}, score={}", homestay.getId(), order.getAmountTotal());
            } catch (Exception e) {
                // 热度更新失败不影响主流程，记录日志即可
                log.error("更新房源热度失败：homestayId={}", homestay.getId(), e);
            }
            
            return order;
        } finally {
            releaseLock(orderLockKey);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean cancelOrder(HsOrderActionBo bo) {
        HsOrder order = orderMapper.selectById(bo.getOrderId());
        if (order == null) {
            throw new ServiceException("order not found");
        }

        Long currentUserId = SecurityUtils.getUserId();
        if (!isSuperAdmin() && !currentUserId.equals(order.getTenantUserId())) {
            throw new ServiceException("no permission to cancel this order");
        }
        if (HsStatusConstants.ORDER_CANCELLED.equals(order.getOrderStatus())
            || HsStatusConstants.ORDER_REJECTED.equals(order.getOrderStatus())
            || HsStatusConstants.ORDER_FINISHED.equals(order.getOrderStatus())
            || HsStatusConstants.ORDER_CHECKED_IN.equals(order.getOrderStatus())) {
            throw new ServiceException("order cannot be cancelled in current status");
        }

            order.setOrderStatus(HsStatusConstants.ORDER_CANCELLED);
        order.setCancelReason(bo.getReason());
        order.setUpdateBy(currentUserId);
        int rows = orderMapper.updateById(order);
        if (rows <= 0) {
            throw new ServiceException("cancel order failed");
        }

        releaseBookedCalendars(order);
        insertMessage(order.getLandlordUserId(), "2", "订单已取消", "订单已取消：" + order.getOrderNo(), order.getOrderNo());
        messageSseService.sendToUser(order.getTenantUserId(), "order_status",
            "{\"type\":\"cancelled\",\"orderId\":" + order.getId() + ",\"orderNo\":\"" + order.getOrderNo() + "\"}");
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean confirmOrder(HsOrderActionBo bo) {
        HsOrder order = orderMapper.selectById(bo.getOrderId());
        if (order == null) {
            throw new ServiceException("order not found");
        }

        Long currentUserId = SecurityUtils.getUserId();
        if (!isSuperAdmin() && !currentUserId.equals(order.getLandlordUserId())) {
            throw new ServiceException("no permission to confirm this order");
        }
        if (!HsStatusConstants.ORDER_PAID.equals(order.getOrderStatus())) {
            throw new ServiceException("order is not in paid status");
        }

        order.setOrderStatus(HsStatusConstants.ORDER_CONFIRMED);
        order.setConfirmTime(new Date());
        order.setUpdateBy(currentUserId);
        int rows = orderMapper.updateById(order);
        if (rows <= 0) {
            throw new ServiceException("confirm order failed");
        }

        insertMessage(order.getTenantUserId(), "2", "订单已确认", "房东已确认：" + order.getOrderNo(), order.getOrderNo());
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean rejectOrder(HsOrderActionBo bo) {
        HsOrder order = orderMapper.selectById(bo.getOrderId());
        if (order == null) {
            throw new ServiceException("order not found");
        }

        Long currentUserId = SecurityUtils.getUserId();
        if (!isSuperAdmin() && !currentUserId.equals(order.getLandlordUserId())) {
            throw new ServiceException("no permission to reject this order");
        }
        if (!HsStatusConstants.ORDER_PAID.equals(order.getOrderStatus())) {
            throw new ServiceException("order is not in paid status");
        }

        order.setOrderStatus(HsStatusConstants.ORDER_REJECTED);
        order.setPayStatus(HsStatusConstants.PAY_REFUNDED);
        order.setCancelReason(StringUtils.isBlank(bo.getReason()) ? "rejected-by-landlord" : bo.getReason());
        order.setUpdateBy(currentUserId);
        int rows = orderMapper.updateById(order);
        if (rows <= 0) {
            throw new ServiceException("reject order failed");
        }

        releaseBookedCalendars(order);
        insertMessage(order.getTenantUserId(), "2", "订单已拒绝", "房东已拒绝：" + order.getOrderNo(), order.getOrderNo());
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean checkinOrder(HsOrderActionBo bo) {
        HsOrder order = orderMapper.selectById(bo.getOrderId());
        if (order == null) {
            throw new ServiceException("order not found");
        }

        Long currentUserId = SecurityUtils.getUserId();
        if (!isSuperAdmin() && !currentUserId.equals(order.getTenantUserId())) {
            throw new ServiceException("no permission to check in this order");
        }
        if (!HsStatusConstants.ORDER_CONFIRMED.equals(order.getOrderStatus())) {
            throw new ServiceException("order is not ready for check-in");
        }

        order.setOrderStatus(HsStatusConstants.ORDER_CHECKED_IN);
        order.setUpdateBy(currentUserId);
        int rows = orderMapper.updateById(order);
        if (rows <= 0) {
            throw new ServiceException("check in failed");
        }

        insertMessage(order.getLandlordUserId(), "2", "租客已入住", "租客已确认入住：" + order.getOrderNo(), order.getOrderNo());
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean checkoutOrder(HsOrderActionBo bo) {
        HsOrder order = orderMapper.selectById(bo.getOrderId());
        if (order == null) {
            throw new ServiceException("order not found");
        }

        Long currentUserId = SecurityUtils.getUserId();
        if (!isSuperAdmin() && !currentUserId.equals(order.getTenantUserId())) {
            throw new ServiceException("no permission to check out this order");
        }
        if (!HsStatusConstants.ORDER_CHECKED_IN.equals(order.getOrderStatus())) {
            throw new ServiceException("order is not checked in");
        }

        order.setOrderStatus(HsStatusConstants.ORDER_FINISHED);
        order.setUpdateBy(currentUserId);
        int rows = orderMapper.updateById(order);
        if (rows <= 0) {
            throw new ServiceException("check out failed");
        }

        HsCleaningTask cleaningTask = new HsCleaningTask();
        cleaningTask.setHomestayId(order.getHomestayId());
        cleaningTask.setOrderNo(order.getOrderNo());
        cleaningTask.setCleaningDate(new Date());
        cleaningTask.setStatus("0");
        cleaningTaskMapper.insert(cleaningTask);

        LambdaUpdateWrapper<HsHomestay> updateWrapper = Wrappers.lambdaUpdate();
        updateWrapper.eq(HsHomestay::getId, order.getHomestayId());
        updateWrapper.set(HsHomestay::getCleaningStatus, "0");
        homestayMapper.update(null, updateWrapper);

        insertMessage(order.getLandlordUserId(), "2", "租客已退房", "租客已退房：" + order.getOrderNo() + "，已创建清洁任务", order.getOrderNo());
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean mockPay(HsOrderActionBo bo) {
        HsOrder order = orderMapper.selectById(bo.getOrderId());
        if (order == null) {
            throw new ServiceException("order not found");
        }

        Long currentUserId = SecurityUtils.getUserId();
        if (!isSuperAdmin() && !currentUserId.equals(order.getTenantUserId())) {
            throw new ServiceException("no permission to pay this order");
        }
        if (!HsStatusConstants.ORDER_WAIT_PAY.equals(order.getOrderStatus())) {
            throw new ServiceException("order is not waiting for pay");
        }

        order.setPayStatus(HsStatusConstants.PAY_PAID);
        order.setOrderStatus(HsStatusConstants.ORDER_WAIT_CONFIRM);
        order.setPayTime(new Date());
        order.setUpdateBy(currentUserId);
        int rows = orderMapper.updateById(order);
        if (rows <= 0) {
            throw new ServiceException("pay failed");
        }

        insertMessage(order.getLandlordUserId(), "2", "订单已支付", "订单已支付：" + order.getOrderNo(), order.getOrderNo());
        messageSseService.sendToUser(order.getLandlordUserId(), "new_order",
            "{\"type\":\"new_order\",\"orderId\":" + order.getId() + ",\"orderNo\":\"" + order.getOrderNo() + "\",\"orderStatus\":\"1\"}");
        return true;
    }

    @Override
    public IPage<HsOrder> myOrders(String roleType, String orderStatus, String payStatus, String orderNo, Page<HsOrder> page) {
        Long userId = SecurityUtils.getUserId();
        boolean superAdmin = isSuperAdmin();
        LambdaQueryWrapper<HsOrder> lqw = Wrappers.lambdaQuery();
        if (!superAdmin) {
            if ("landlord".equalsIgnoreCase(roleType)) {
                lqw.eq(HsOrder::getLandlordUserId, userId);
            } else {
                lqw.eq(HsOrder::getTenantUserId, userId);
            }
        }
        if (StringUtils.isNotBlank(orderStatus)) {
            lqw.eq(HsOrder::getOrderStatus, orderStatus);
        }
        if (StringUtils.isNotBlank(payStatus)) {
            lqw.eq(HsOrder::getPayStatus, payStatus);
        }
        if (StringUtils.isNotBlank(orderNo)) {
            lqw.like(HsOrder::getOrderNo, orderNo.trim());
        }
        lqw.orderByDesc(HsOrder::getCreateTime);
        return orderMapper.selectPage(page, lqw);
    }

    @Override
    public IPage<HsOrder> landlordList(Long userId, String orderStatus, String checkinDate, String homestayName, Page<HsOrder> page) {
        LambdaQueryWrapper<HsOrder> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsOrder::getLandlordUserId, userId);
        if (StringUtils.isNotBlank(orderStatus)) {
            lqw.eq(HsOrder::getOrderStatus, orderStatus);
        }
        if (StringUtils.isNotBlank(checkinDate)) {
            lqw.ge(HsOrder::getCheckinDate, checkinDate);
        }
        if (StringUtils.isNotBlank(homestayName)) {
            List<Long> homestayIds = homestayMapper.selectList(
                Wrappers.<HsHomestay>lambdaQuery()
                    .like(HsHomestay::getTitle, homestayName)
                    .select(HsHomestay::getId)
            ).stream().map(HsHomestay::getId).toList();
            if (!homestayIds.isEmpty()) {
                lqw.in(HsOrder::getHomestayId, homestayIds);
            } else {
                lqw.eq(HsOrder::getId, -1L);
            }
        }
        lqw.orderByDesc(HsOrder::getCreateTime);
        IPage<HsOrder> result = orderMapper.selectPage(page, lqw);
        
        if (!result.getRecords().isEmpty()) {
            List<Long> homestayIds = result.getRecords().stream()
                .map(HsOrder::getHomestayId)
                .distinct()
                .toList();
            Map<Long, String> homestayNameMap = homestayMapper.selectBatchIds(homestayIds)
                .stream()
                .collect(java.util.stream.Collectors.toMap(HsHomestay::getId, HsHomestay::getTitle));
            result.getRecords().forEach(order -> 
                order.setHomestayName(homestayNameMap.get(order.getHomestayId())));
        }
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean acceptOrder(Long orderId) {
        Long userId = SecurityUtils.getUserId();
        HsOrder order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new ServiceException("order not found");
        }
        if (!userId.equals(order.getLandlordUserId())) {
            throw new ServiceException("no permission to accept this order");
        }
        if (!HsStatusConstants.ORDER_WAIT_CONFIRM.equals(order.getOrderStatus())) {
            throw new ServiceException("order is not in wait-confirm status");
        }

        order.setOrderStatus(HsStatusConstants.ORDER_CONFIRMED);
        order.setConfirmTime(new Date());
        order.setUpdateBy(userId);
        int rows = orderMapper.updateById(order);
        if (rows <= 0) {
            throw new ServiceException("accept order failed");
        }

        // 发送消息通知租客
        insertMessage(order.getTenantUserId(), "1", "订单已确认", "您的订单已被房东确认：" + order.getOrderNo(), order.getOrderNo());
        return true;
    }

    private void initMissingCalendars(HsHomestay homestay, LocalDate checkinDate, LocalDate checkoutDate,
                                      Map<LocalDate, HsRoomCalendar> calendarMap) {
        LocalDate cursor = checkinDate;
        while (cursor.isBefore(checkoutDate)) {
            if (!calendarMap.containsKey(cursor)) {
                HsRoomCalendar create = new HsRoomCalendar();
                create.setTenantId(homestay.getTenantId());
                create.setHomestayId(homestay.getId());
                create.setBizDate(DateUtils.toDate(cursor));
                create.setStatus(HsStatusConstants.CAL_AVAILABLE);
                create.setPrice(homestay.getBasePrice());
                create.setVersion(1);
                roomCalendarMapper.insert(create);
                calendarMap.put(cursor, create);
            }
            cursor = cursor.plusDays(1);
        }
    }

    private BigDecimal bookCalendarsWithVersion(String orderNo, LocalDate checkinDate, LocalDate checkoutDate,
                                                Map<LocalDate, HsRoomCalendar> calendarMap,
                                                BigDecimal fallbackPrice) {
        BigDecimal total = BigDecimal.ZERO;
        LocalDate cursor = checkinDate;
        while (cursor.isBefore(checkoutDate)) {
            HsRoomCalendar calendar = calendarMap.get(cursor);
            if (calendar == null) {
                throw new ServiceException("calendar missing at " + cursor);
            }
            if (!HsStatusConstants.CAL_AVAILABLE.equals(calendar.getStatus())) {
                throw new ServiceException("date " + cursor + " is not available");
            }

            BigDecimal dayPrice = calendar.getPrice() == null ? fallbackPrice : calendar.getPrice();
            total = total.add(dayPrice);

            LambdaUpdateWrapper<HsRoomCalendar> uw = Wrappers.lambdaUpdate();
            uw.eq(HsRoomCalendar::getId, calendar.getId());
            uw.eq(HsRoomCalendar::getVersion, calendar.getVersion());
            uw.eq(HsRoomCalendar::getStatus, HsStatusConstants.CAL_AVAILABLE);
            uw.set(HsRoomCalendar::getStatus, HsStatusConstants.CAL_BOOKED);
            uw.set(HsRoomCalendar::getLockOrderNo, orderNo);
            int nextVersion = calendar.getVersion() == null ? 1 : calendar.getVersion() + 1;
            uw.set(HsRoomCalendar::getVersion, nextVersion);
            int rows = roomCalendarMapper.update(null, uw);
            if (rows <= 0) {
                throw new ServiceException("booking conflict, please retry");
            }
            cursor = cursor.plusDays(1);
        }
        return total.setScale(2, RoundingMode.HALF_UP);
    }

    private void releaseBookedCalendars(HsOrder order) {
        LocalDate checkin = toLocalDate(order.getCheckinDate());
        LocalDate checkout = toLocalDate(order.getCheckoutDate());
        List<HsRoomCalendar> rows = queryDateRangeCalendars(order.getHomestayId(), checkin, checkout);
        for (HsRoomCalendar calendar : rows) {
            if (!order.getOrderNo().equals(calendar.getLockOrderNo())) {
                continue;
            }
            LambdaUpdateWrapper<HsRoomCalendar> uw = Wrappers.lambdaUpdate();
            uw.eq(HsRoomCalendar::getId, calendar.getId());
            uw.eq(HsRoomCalendar::getLockOrderNo, order.getOrderNo());
            uw.set(HsRoomCalendar::getStatus, HsStatusConstants.CAL_AVAILABLE);
            uw.set(HsRoomCalendar::getLockOrderNo, null);
            int nextVersion = calendar.getVersion() == null ? 1 : calendar.getVersion() + 1;
            uw.set(HsRoomCalendar::getVersion, nextVersion);
            roomCalendarMapper.update(null, uw);
        }
    }

    private List<HsRoomCalendar> queryDateRangeCalendars(Long homestayId, LocalDate checkinDate, LocalDate checkoutDate) {
        LambdaQueryWrapper<HsRoomCalendar> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsRoomCalendar::getHomestayId, homestayId);
        lqw.ge(HsRoomCalendar::getBizDate, DateUtils.toDate(checkinDate));
        lqw.lt(HsRoomCalendar::getBizDate, DateUtils.toDate(checkoutDate));
        lqw.orderByAsc(HsRoomCalendar::getBizDate);
        return roomCalendarMapper.selectList(lqw);
    }

    private Map<LocalDate, HsRoomCalendar> buildCalendarMap(List<HsRoomCalendar> rows) {
        Map<LocalDate, HsRoomCalendar> result = new HashMap<>(rows.size());
        for (HsRoomCalendar row : rows) {
            result.put(toLocalDate(row.getBizDate()), row);
        }
        return result;
    }

    private LocalDate parseDate(String date, String fieldName) {
        try {
            return LocalDate.parse(date);
        } catch (Exception e) {
            throw new ServiceException(fieldName + " must be yyyy-MM-dd");
        }
    }

    private String buildOrderLockKey(Long homestayId, LocalDate checkinDate, LocalDate checkoutDate) {
        return StringUtils.format("hs:order:lock:{}:{}:{}", homestayId, checkinDate, checkoutDate);
    }

    private void insertMessage(Long receiverId, String msgType, String title, String content, String relatedOrderNo) {
        HsMessage message = new HsMessage();
        message.setTenantId(getTenantId());
        message.setReceiverUserId(receiverId);
        message.setMsgType(msgType);
        message.setTitle(title);
        message.setContent(content);
        message.setRelatedOrderNo(relatedOrderNo);
        message.setIsRead(HsStatusConstants.MSG_UNREAD);
        messageMapper.insert(message);

        Long msgId = message.getId();
        String json = String.format(
            "{\"id\":%d,\"type\":\"%s\",\"title\":\"%s\",\"content\":\"%s\",\"orderNo\":\"%s\"}",
            msgId, msgType, title.replace("\"", "\\\""), content.replace("\"", "\\\""), relatedOrderNo
        );
        messageSseService.sendToUser(receiverId, "new_message", json);
    }

    private LocalDate toLocalDate(Date date) {
        return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    }

    private String getTenantId() {
        Long tenantId = SecurityUtils.getLoginUser().getUser().getTenantId();
        return tenantId == null ? "000000" : String.valueOf(tenantId);
    }

    private boolean isSuperAdmin() {
        Long userId = SecurityUtils.getUserId();
        return SecurityUtils.isAdmin(userId) || SecurityUtils.hasRole(Constants.SUPER_ADMIN);
    }

    private boolean tryAcquireLock(String key, String value, Duration ttl) {
        Boolean locked = redisCache.redisTemplate.opsForValue().setIfAbsent(key, value, ttl);
        return Boolean.TRUE.equals(locked);
    }

    private void releaseLock(String key) {
        redisCache.deleteObject(key);
    }

    private String generateNo(String prefix) {
        int random = ThreadLocalRandom.current().nextInt(100, 1000);
        return prefix + DateUtils.getYYYYMMDDHHMMSSSSS(new Date()) + random;
    }

    @Override
    public Map<String, Object> getMonitorStats() {
        Map<String, Object> stats = new HashMap<>();
        
        LambdaQueryWrapper<HsOrder> unpaidLqw = Wrappers.lambdaQuery();
        unpaidLqw.eq(HsOrder::getPayStatus, HsStatusConstants.PAY_UNPAID);
        unpaidLqw.eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_WAIT_PAY);
        stats.put("unpaid", orderMapper.selectCount(unpaidLqw));
        
        Instant timeoutThreshold = Instant.now().minus(Duration.ofMinutes(25));
        LambdaQueryWrapper<HsOrder> expiringLqw = Wrappers.lambdaQuery();
        expiringLqw.eq(HsOrder::getPayStatus, HsStatusConstants.PAY_UNPAID);
        expiringLqw.eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_WAIT_PAY);
        expiringLqw.lt(HsOrder::getCreateTime, java.sql.Timestamp.from(timeoutThreshold));
        stats.put("expiring", orderMapper.selectCount(expiringLqw));
        
        LambdaQueryWrapper<HsOrder> paidLqw = Wrappers.lambdaQuery();
        paidLqw.eq(HsOrder::getPayStatus, HsStatusConstants.PAY_PAID);
        paidLqw.eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_PAID);
        stats.put("paid", orderMapper.selectCount(paidLqw));
        
        LocalDate today = LocalDate.now();
        LambdaQueryWrapper<HsOrder> closedLqw = Wrappers.lambdaQuery();
        closedLqw.eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_CANCELLED);
        closedLqw.ge(HsOrder::getUpdateTime, DateUtils.toDate(today));
        stats.put("autoClosed", orderMapper.selectCount(closedLqw));
        
        return stats;
    }

    @Override
    public IPage<HsOrder> getUnpaidOrders(Page<HsOrder> page) {
        LambdaQueryWrapper<HsOrder> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsOrder::getPayStatus, HsStatusConstants.PAY_UNPAID);
        lqw.eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_WAIT_PAY);
        lqw.orderByAsc(HsOrder::getCreateTime);
        IPage<HsOrder> result = orderMapper.selectPage(page, lqw);
        fillOrderExtraInfo(result.getRecords());
        return result;
    }

    @Override
    public IPage<HsOrder> getPaidOrders(Page<HsOrder> page) {
        LambdaQueryWrapper<HsOrder> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsOrder::getPayStatus, HsStatusConstants.PAY_PAID);
        lqw.eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_PAID);
        lqw.orderByDesc(HsOrder::getPayTime);
        IPage<HsOrder> result = orderMapper.selectPage(page, lqw);
        fillOrderExtraInfo(result.getRecords());
        return result;
    }

    @Override
    public IPage<HsOrder> getClosedOrders(Page<HsOrder> page) {
        LambdaQueryWrapper<HsOrder> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_CANCELLED);
        lqw.orderByDesc(HsOrder::getUpdateTime);
        IPage<HsOrder> result = orderMapper.selectPage(page, lqw);
        fillOrderExtraInfo(result.getRecords());
        return result;
    }

    private void fillOrderExtraInfo(List<HsOrder> orders) {
        if (orders == null || orders.isEmpty()) {
            return;
        }
        long startTime = System.currentTimeMillis();
        
        // 批量查询房源名称
        List<Long> homestayIds = orders.stream()
            .map(HsOrder::getHomestayId)
            .distinct()
            .toList();
        Map<Long, String> homestayNameMap = homestayMapper.selectBatchIds(homestayIds)
            .stream()
            .collect(java.util.stream.Collectors.toMap(HsHomestay::getId, HsHomestay::getTitle));
        
        // 【性能优化】批量查询租户信息，避免N+1查询
        List<Long> tenantUserIds = orders.stream()
            .map(HsOrder::getTenantUserId)
            .distinct()
            .toList();
        
        Map<Long, String> tenantNameMap = new HashMap<>();
        if (!tenantUserIds.isEmpty()) {
            // 使用批量查询替代逐个查询
            List<SysUser> users = userMapper.selectUserByIds(tenantUserIds);
            for (SysUser user : users) {
                if (user != null) {
                    tenantNameMap.put(user.getUserId(), 
                        user.getNickName() != null ? user.getNickName() : user.getUserName());
                }
            }
        }
        
        orders.forEach(order -> {
            order.setHomestayTitle(homestayNameMap.get(order.getHomestayId()));
            order.setTenantName(tenantNameMap.get(order.getTenantUserId()));
        });
        
        log.debug("fillOrderExtraInfo 完成，订单数: {}, 耗时: {}ms", 
            orders.size(), System.currentTimeMillis() - startTime);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean cancelTimeoutOrder(Long orderId, String reason) {
        HsOrder order = orderMapper.selectById(orderId);
        if (order == null) {
            return false;
        }
        order.setOrderStatus(HsStatusConstants.ORDER_CANCELLED);
        order.setCancelReason(reason);
        order.setUpdateTime(new Date());
        int rows = orderMapper.updateById(order);
        if (rows > 0) {
            releaseBookedCalendars(order);
            return true;
        }
        return false;
    }
}
