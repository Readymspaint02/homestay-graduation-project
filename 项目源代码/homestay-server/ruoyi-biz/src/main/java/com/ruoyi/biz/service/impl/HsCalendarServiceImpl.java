package com.ruoyi.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.domain.hs.HsRoomCalendar;
import com.ruoyi.biz.domain.hs.HsStatusConstants;
import com.ruoyi.biz.domain.hs.bo.HsCalendarUpdateBo;
import com.ruoyi.biz.mapper.HsHomestayMapper;
import com.ruoyi.biz.mapper.HsRoomCalendarMapper;
import com.ruoyi.biz.service.HsCacheService;
import com.ruoyi.biz.service.IHsCalendarService;
import com.ruoyi.common.constant.Constants;
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
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class HsCalendarServiceImpl implements IHsCalendarService {

    private final HsRoomCalendarMapper roomCalendarMapper;
    private final HsHomestayMapper homestayMapper;
    private final com.ruoyi.biz.mapper.HsOrderMapper orderMapper;
    private final HsCacheService cacheService;

    @Override
    public List<HsRoomCalendar> list(Long homestayId, String startDate, String endDate) {
        LocalDate start = parseDateOrDefault(startDate, LocalDate.now());
        LocalDate end = parseDateOrDefault(endDate, start.plusDays(30));
        if (start == null || end == null) {
            throw new ServiceException("startDate/endDate must be yyyy-MM-dd");
        }
        if (end.isBefore(start)) {
            throw new ServiceException("endDate must be >= startDate");
        }
        
        int days = (int) (end.toEpochDay() - start.toEpochDay()) + 1;
        if (days > 120) {
            end = start.plusDays(119);
            days = 120;
            log.info("日历查询范围过大，限制为120天: homestayId={}, start={}, end={}", homestayId, start, end);
        }
        
        Map<LocalDate, HsRoomCalendar> cachedMap = cacheService.getCalendar(homestayId);
        if (cachedMap != null && !cachedMap.isEmpty()) {
            log.debug("日历缓存命中: homestayId={}, cachedSize={}", homestayId, cachedMap.size());
            List<HsRoomCalendar> result = new java.util.ArrayList<>();
            LocalDate cursor = start;
            while (!cursor.isAfter(end)) {
                HsRoomCalendar cal = cachedMap.get(cursor);
                if (cal != null) {
                    result.add(cal);
                }
                cursor = cursor.plusDays(1);
            }
            if (!result.isEmpty()) {
                return result;
            }
        }
        
        LambdaQueryWrapper<HsRoomCalendar> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsRoomCalendar::getHomestayId, homestayId);
        lqw.ge(HsRoomCalendar::getBizDate, DateUtils.toDate(start));
        lqw.le(HsRoomCalendar::getBizDate, DateUtils.toDate(end));
        lqw.orderByAsc(HsRoomCalendar::getBizDate);
        List<HsRoomCalendar> list = roomCalendarMapper.selectList(lqw);
        
        if (list != null && !list.isEmpty()) {
            Map<LocalDate, HsRoomCalendar> toCache = new HashMap<>();
            for (HsRoomCalendar cal : list) {
                toCache.put(toLocalDate(cal.getBizDate()), cal);
            }
            cacheService.cacheCalendar(homestayId, toCache);
            log.info("日历数据已缓存: homestayId={}, size={}", homestayId, toCache.size());
        }
        
        return list;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateRange(HsCalendarUpdateBo bo) {
        LocalDate start = parseDateOrDefault(bo.getStartDate(), null);
        LocalDate end = parseDateOrDefault(bo.getEndDate(), null);
        if (start == null || end == null) {
            throw new ServiceException("startDate and endDate must be yyyy-MM-dd");
        }
        if (end.isBefore(start)) {
            throw new ServiceException("endDate must be >= startDate");
        }
        HsHomestay homestay = homestayMapper.selectById(bo.getHomestayId());
        if (homestay == null) {
            throw new ServiceException("homestay not found");
        }

        Long currentUserId = SecurityUtils.getUserId();
        if (!isSuperAdmin() && !currentUserId.equals(homestay.getLandlordUserId())) {
            throw new ServiceException("no permission to update calendar");
        }

        LambdaQueryWrapper<HsRoomCalendar> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsRoomCalendar::getHomestayId, bo.getHomestayId());
        lqw.ge(HsRoomCalendar::getBizDate, DateUtils.toDate(start));
        lqw.le(HsRoomCalendar::getBizDate, DateUtils.toDate(end));
        List<HsRoomCalendar> existing = roomCalendarMapper.selectList(lqw);

        Map<LocalDate, HsRoomCalendar> map = new HashMap<>(existing.size());
        for (HsRoomCalendar item : existing) {
            map.put(toLocalDate(item.getBizDate()), item);
        }

        int changed = 0;
        LocalDate cursor = start;
        while (!cursor.isAfter(end)) {
            HsRoomCalendar target = map.get(cursor);
            if (target == null) {
                target = new HsRoomCalendar();
                target.setTenantId(homestay.getTenantId());
                target.setHomestayId(homestay.getId());
                target.setBizDate(DateUtils.toDate(cursor));
                target.setStatus(StringUtils.isBlank(bo.getStatus()) ? HsStatusConstants.CAL_AVAILABLE : bo.getStatus());
                target.setPrice(bo.getPrice() == null ? homestay.getBasePrice() : normalizePrice(bo.getPrice()));
                target.setVersion(1);
                changed += roomCalendarMapper.insert(target);
            } else {
                target.setStatus(StringUtils.isBlank(bo.getStatus()) ? target.getStatus() : bo.getStatus());
                if (bo.getPrice() != null) {
                    target.setPrice(normalizePrice(bo.getPrice()));
                }
                changed += roomCalendarMapper.updateById(target);
            }
            cursor = cursor.plusDays(1);
        }
        
        cacheService.deleteCalendarCache(bo.getHomestayId());
        log.info("日历更新后删除缓存: homestayId={}", bo.getHomestayId());
        
        return changed;
    }

    private BigDecimal normalizePrice(BigDecimal price) {
        return price == null ? null : price.setScale(2, RoundingMode.HALF_UP);
    }

    private LocalDate parseDateOrDefault(String date, LocalDate defaultValue) {
        if (StringUtils.isBlank(date)) {
            return defaultValue;
        }
        try {
            return LocalDate.parse(date);
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    private LocalDate toLocalDate(Date date) {
        return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    }

    private boolean isSuperAdmin() {
        Long userId = SecurityUtils.getUserId();
        return SecurityUtils.isAdmin(userId) || SecurityUtils.hasRole(Constants.SUPER_ADMIN);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean lockDate(Long homestayId, String date) {
        HsHomestay homestay = homestayMapper.selectById(homestayId);
        if (homestay == null) {
            throw new ServiceException("homestay not found");
        }
        Long currentUserId = SecurityUtils.getUserId();
        if (!currentUserId.equals(homestay.getLandlordUserId())) {
            throw new ServiceException("no permission to update calendar");
        }

        LocalDate targetDate = parseDateOrDefault(date, null);
        if (targetDate == null) {
            throw new ServiceException("invalid date format");
        }

        LambdaQueryWrapper<HsRoomCalendar> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsRoomCalendar::getHomestayId, homestayId);
        lqw.eq(HsRoomCalendar::getBizDate, DateUtils.toDate(targetDate));
        HsRoomCalendar calendar = roomCalendarMapper.selectOne(lqw);

        if (calendar == null) {
            calendar = new HsRoomCalendar();
            calendar.setTenantId(homestay.getTenantId());
            calendar.setHomestayId(homestayId);
            calendar.setBizDate(DateUtils.toDate(targetDate));
            calendar.setStatus(HsStatusConstants.CAL_MAINTENANCE);
            calendar.setPrice(homestay.getBasePrice());
            calendar.setVersion(1);
            return roomCalendarMapper.insert(calendar) > 0;
        } else {
            // 只有可订状态才能锁定
            if (!HsStatusConstants.CAL_AVAILABLE.equals(calendar.getStatus())) {
                throw new ServiceException("can only lock available dates");
            }
            calendar.setStatus(HsStatusConstants.CAL_MAINTENANCE);
            return roomCalendarMapper.updateById(calendar) > 0;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean unlockDate(Long homestayId, String date) {
        HsHomestay homestay = homestayMapper.selectById(homestayId);
        if (homestay == null) {
            throw new ServiceException("homestay not found");
        }
        Long currentUserId = SecurityUtils.getUserId();
        if (!currentUserId.equals(homestay.getLandlordUserId())) {
            throw new ServiceException("no permission to update calendar");
        }

        LocalDate targetDate = parseDateOrDefault(date, null);
        if (targetDate == null) {
            throw new ServiceException("invalid date format");
        }

        LambdaQueryWrapper<HsRoomCalendar> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsRoomCalendar::getHomestayId, homestayId);
        lqw.eq(HsRoomCalendar::getBizDate, DateUtils.toDate(targetDate));
        HsRoomCalendar calendar = roomCalendarMapper.selectOne(lqw);

        if (calendar != null && HsStatusConstants.CAL_MAINTENANCE.equals(calendar.getStatus())) {
            calendar.setStatus(HsStatusConstants.CAL_AVAILABLE);
            return roomCalendarMapper.updateById(calendar) > 0;
        }
        return false;
    }

    @Override
    public Map<String, Object> getCalendarData(Long homestayId, String year, String month) {
        Map<String, Object> result = new HashMap<>();

        // 解析年月
        int yearInt = StringUtils.isNotBlank(year) ? Integer.parseInt(year) : LocalDate.now().getYear();
        int monthInt = StringUtils.isNotBlank(month) ? Integer.parseInt(month) : LocalDate.now().getMonthValue();

        LocalDate firstDay = LocalDate.of(yearInt, monthInt, 1);
        LocalDate lastDay = firstDay.withDayOfMonth(firstDay.lengthOfMonth());

        // 查询该月的日历数据
        List<HsRoomCalendar> calendars = list(homestayId, firstDay.toString(), lastDay.toString());
        result.put("calendars", calendars);

        // 查询该月的订单数据
        LambdaQueryWrapper<com.ruoyi.biz.domain.hs.HsOrder> orderLqw = Wrappers.lambdaQuery();
        orderLqw.eq(com.ruoyi.biz.domain.hs.HsOrder::getHomestayId, homestayId);
        orderLqw.ge(com.ruoyi.biz.domain.hs.HsOrder::getCheckinDate, DateUtils.toDate(firstDay));
        orderLqw.le(com.ruoyi.biz.domain.hs.HsOrder::getCheckoutDate, DateUtils.toDate(lastDay));
        orderLqw.in(com.ruoyi.biz.domain.hs.HsOrder::getOrderStatus, "1", "2"); // 已确认/待确认
        List<com.ruoyi.biz.domain.hs.HsOrder> orders = orderMapper.selectList(orderLqw);
        result.put("orders", orders);

        // 查询房源信息
        HsHomestay homestay = homestayMapper.selectById(homestayId);
        result.put("homestay", homestay);

        // 当前年月
        result.put("currentYear", yearInt);
        result.put("currentMonth", monthInt);

        return result;
    }
}
