package com.ruoyi.biz.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.biz.domain.hs.HsSupervisionReport;
import com.ruoyi.biz.domain.hs.bo.HsSupervisionPushBo;

import java.util.Map;

/**
 * Supervision report service.
 */
public interface IHsSupervisionReportService {

    HsSupervisionReport pushMock(HsSupervisionPushBo bo);

    int generateOrderReports(int limit);

    int processPendingReports(int limit);

    IPage<HsSupervisionReport> page(String reportType, String reportStatus, Long bizId, String reportNo, Page<HsSupervisionReport> page);

    Map<String, Object> stats();

    HsSupervisionReport reportSingleOrder(Long orderId);

    Map<String, Object> getOrderReportStatus(Long orderId);
}
