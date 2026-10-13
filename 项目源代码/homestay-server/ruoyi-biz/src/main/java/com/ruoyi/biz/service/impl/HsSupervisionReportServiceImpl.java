package com.ruoyi.biz.service.impl;

import com.alibaba.fastjson2.JSON;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.biz.domain.hs.HsOrder;
import com.ruoyi.biz.domain.hs.HsStatusConstants;
import com.ruoyi.biz.domain.hs.HsSupervisionReport;
import com.ruoyi.biz.domain.hs.bo.HsSupervisionPushBo;
import com.ruoyi.biz.mapper.HsOrderMapper;
import com.ruoyi.biz.mapper.HsSupervisionReportMapper;
import com.ruoyi.biz.service.IHsSupervisionReportService;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

/**
 * Supervision report service implementation.
 */
@Service
@RequiredArgsConstructor
public class HsSupervisionReportServiceImpl implements IHsSupervisionReportService {

    private static final String REPORT_TYPE_HOMESTAY = "1";
    private static final String REPORT_TYPE_CHECKIN = "2";
    private static final String REPORT_TYPE_ORDER_STAT = "3";

    private final HsSupervisionReportMapper reportMapper;
    private final HsOrderMapper orderMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public HsSupervisionReport pushMock(HsSupervisionPushBo bo) {
        HsSupervisionReport report = new HsSupervisionReport();
        report.setTenantId(getTenantId());
        report.setReportNo(generateNo("SUP"));
        report.setReportType(bo.getReportType());
        report.setBizId(bo.getBizId());
        report.setReportStatus(HsStatusConstants.SUP_PENDING);
        report.setRetryCount(0);
        report.setRequestJson(bo.getRequestJson());
        reportMapper.insert(report);
        return report;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int generateOrderReports(int limit) {
        int safeLimit = Math.max(1, Math.min(limit, 500));
        LambdaQueryWrapper<HsOrder> orderQuery = Wrappers.lambdaQuery();
        orderQuery.in(HsOrder::getOrderStatus, HsStatusConstants.ORDER_CONFIRMED, HsStatusConstants.ORDER_FINISHED);
        orderQuery.orderByDesc(HsOrder::getUpdateTime, HsOrder::getCreateTime);
        orderQuery.last("limit " + safeLimit);
        List<HsOrder> orders = orderMapper.selectList(orderQuery);
        if (orders.isEmpty()) {
            return 0;
        }

        List<Long> orderIds = orders.stream()
            .map(HsOrder::getId)
            .filter(Objects::nonNull)
            .toList();
        if (orderIds.isEmpty()) {
            return 0;
        }

        LambdaQueryWrapper<HsSupervisionReport> existsQuery = Wrappers.lambdaQuery();
        existsQuery.select(HsSupervisionReport::getBizId);
        existsQuery.eq(HsSupervisionReport::getReportType, REPORT_TYPE_CHECKIN);
        existsQuery.in(HsSupervisionReport::getBizId, orderIds);
        Set<Long> existsOrderIds = reportMapper.selectList(existsQuery).stream()
            .map(HsSupervisionReport::getBizId)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());

        int created = 0;
        for (HsOrder order : orders) {
            if (order.getId() == null || existsOrderIds.contains(order.getId())) {
                continue;
            }
            HsSupervisionReport report = new HsSupervisionReport();
            report.setTenantId(StringUtils.isBlank(order.getTenantId()) ? "000000" : order.getTenantId());
            report.setReportNo(generateNo("SUP"));
            report.setReportType(REPORT_TYPE_CHECKIN);
            report.setBizId(order.getId());
            report.setReportStatus(HsStatusConstants.SUP_PENDING);
            report.setRetryCount(0);
            report.setRequestJson(buildOrderReportPayload(order));
            created += reportMapper.insert(report);
        }
        return created;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int processPendingReports(int limit) {
        int safeLimit = Math.max(1, Math.min(limit, 200));
        LambdaQueryWrapper<HsSupervisionReport> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsSupervisionReport::getReportStatus, HsStatusConstants.SUP_PENDING);
        lqw.orderByAsc(HsSupervisionReport::getCreateTime);
        lqw.last("limit " + safeLimit);
        List<HsSupervisionReport> pending = reportMapper.selectList(lqw);

        int processed = 0;
        for (HsSupervisionReport row : pending) {
            HsSupervisionReport update = new HsSupervisionReport();
            update.setId(row.getId());
            update.setRetryCount((row.getRetryCount() == null ? 0 : row.getRetryCount()) + 1);
            update.setLastReportTime(new Date());
            if (REPORT_TYPE_ORDER_STAT.equals(row.getReportType())) {
                update.setReportStatus(HsStatusConstants.SUP_FAILED);
                update.setResponseJson(JSON.toJSONString(Map.of("code", 500, "msg", "mock push failed")));
            } else {
                update.setReportStatus(HsStatusConstants.SUP_SUCCESS);
                update.setResponseJson(JSON.toJSONString(Map.of("code", 0, "msg", "mock push success")));
            }
            processed += reportMapper.updateById(update);
        }
        return processed;
    }

    @Override
    public IPage<HsSupervisionReport> page(String reportType, String reportStatus, Long bizId, String reportNo, Page<HsSupervisionReport> page) {
        LambdaQueryWrapper<HsSupervisionReport> lqw = Wrappers.lambdaQuery();
        if (StringUtils.isNotBlank(reportType)) {
            lqw.eq(HsSupervisionReport::getReportType, reportType);
        }
        if (StringUtils.isNotBlank(reportStatus)) {
            lqw.eq(HsSupervisionReport::getReportStatus, reportStatus);
        }
        if (bizId != null) {
            lqw.eq(HsSupervisionReport::getBizId, bizId);
        }
        if (StringUtils.isNotBlank(reportNo)) {
            lqw.like(HsSupervisionReport::getReportNo, reportNo.trim());
        }
        lqw.orderByDesc(HsSupervisionReport::getCreateTime);
        return reportMapper.selectPage(page, lqw);
    }

    @Override
    public Map<String, Object> stats() {
        Map<String, Object> data = new HashMap<>(16);
        data.put("total", reportMapper.selectCount(Wrappers.lambdaQuery()));
        data.put("pending", reportMapper.selectCount(
            Wrappers.<HsSupervisionReport>lambdaQuery().eq(HsSupervisionReport::getReportStatus, HsStatusConstants.SUP_PENDING)));
        data.put("success", reportMapper.selectCount(
            Wrappers.<HsSupervisionReport>lambdaQuery().eq(HsSupervisionReport::getReportStatus, HsStatusConstants.SUP_SUCCESS)));
        data.put("failed", reportMapper.selectCount(
            Wrappers.<HsSupervisionReport>lambdaQuery().eq(HsSupervisionReport::getReportStatus, HsStatusConstants.SUP_FAILED)));
        data.put("homestayType", reportMapper.selectCount(
            Wrappers.<HsSupervisionReport>lambdaQuery().eq(HsSupervisionReport::getReportType, REPORT_TYPE_HOMESTAY)));
        data.put("checkinType", reportMapper.selectCount(
            Wrappers.<HsSupervisionReport>lambdaQuery().eq(HsSupervisionReport::getReportType, REPORT_TYPE_CHECKIN)));
        data.put("orderStatType", reportMapper.selectCount(
            Wrappers.<HsSupervisionReport>lambdaQuery().eq(HsSupervisionReport::getReportType, REPORT_TYPE_ORDER_STAT)));
        data.put("taskCron", "0 */2 * * * ?");
        data.put("autoGenerateRule", "order_status in [2-confirmed,3-finished]");
        return data;
    }

    private String buildOrderReportPayload(HsOrder order) {
        Map<String, Object> payload = new LinkedHashMap<>(10);
        payload.put("source", "order-auto-task");
        payload.put("orderId", order.getId());
        payload.put("orderNo", order.getOrderNo());
        payload.put("orderStatus", order.getOrderStatus());
        payload.put("payStatus", order.getPayStatus());
        payload.put("tenantUserId", order.getTenantUserId());
        payload.put("landlordUserId", order.getLandlordUserId());
        payload.put("checkinDate", order.getCheckinDate());
        payload.put("checkoutDate", order.getCheckoutDate());
        payload.put("generatedAt", new Date());
        return JSON.toJSONString(payload);
    }

    private String getTenantId() {
        Long tenantId = SecurityUtils.getLoginUser().getUser().getTenantId();
        return tenantId == null ? "000000" : String.valueOf(tenantId);
    }

    private String generateNo(String prefix) {
        int random = ThreadLocalRandom.current().nextInt(100, 1000);
        return prefix + DateUtils.getYYYYMMDDHHMMSSSSS(new Date()) + random;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public HsSupervisionReport reportSingleOrder(Long orderId) {
        if (orderId == null || orderId <= 0) {
            return null;
        }
        HsOrder order = orderMapper.selectById(orderId);
        if (order == null) {
            return null;
        }
        HsSupervisionReport report = new HsSupervisionReport();
        report.setTenantId(StringUtils.isBlank(order.getTenantId()) ? "000000" : order.getTenantId());
        report.setReportNo(generateNo("SUP"));
        report.setReportType(REPORT_TYPE_CHECKIN);
        report.setBizId(orderId);
        report.setReportStatus(HsStatusConstants.SUP_SUCCESS);
        report.setRetryCount(1);
        report.setRequestJson(buildOrderReportPayload(order));
        report.setResponseJson(JSON.toJSONString(Map.of("code", 0, "msg", "上报成功")));
        report.setLastReportTime(new Date());
        reportMapper.insert(report);
        return report;
    }

    @Override
    public Map<String, Object> getOrderReportStatus(Long orderId) {
        Map<String, Object> result = new HashMap<>(4);
        if (orderId == null || orderId <= 0) {
            result.put("reported", false);
            return result;
        }
        LambdaQueryWrapper<HsSupervisionReport> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsSupervisionReport::getBizId, orderId);
        lqw.eq(HsSupervisionReport::getReportType, REPORT_TYPE_CHECKIN);
        lqw.orderByDesc(HsSupervisionReport::getCreateTime);
        lqw.last("limit 1");
        HsSupervisionReport report = reportMapper.selectOne(lqw);
        if (report == null) {
            result.put("reported", false);
        } else {
            result.put("reported", true);
            result.put("reportNo", report.getReportNo());
            result.put("reportStatus", report.getReportStatus());
            result.put("reportTime", report.getLastReportTime());
        }
        return result;
    }
}
