package com.ruoyi.biz.controller.homestay;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.biz.domain.hs.HsSupervisionReport;
import com.ruoyi.biz.domain.hs.bo.HsSupervisionPushBo;
import com.ruoyi.biz.service.IHsSupervisionReportService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Supervision APIs.
 */
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/supervision")
public class HsSupervisionController extends BaseController {

    private final IHsSupervisionReportService supervisionReportService;

    @PostMapping("/report/push")
    public AjaxResult push(@Valid @RequestBody HsSupervisionPushBo bo) {
        return success(supervisionReportService.pushMock(bo));
    }

    @PostMapping("/report/order/{orderId}")
    public AjaxResult reportOrder(@PathVariable Long orderId) {
        return success(supervisionReportService.reportSingleOrder(orderId));
    }

    @GetMapping("/report/order/status/{orderId}")
    public AjaxResult getOrderReportStatus(@PathVariable Long orderId) {
        return success(supervisionReportService.getOrderReportStatus(orderId));
    }

    @PostMapping("/report/generate")
    public AjaxResult generate(@RequestParam(defaultValue = "20") Integer limit) {
        return success(supervisionReportService.generateOrderReports(limit));
    }

    @PostMapping("/report/process")
    public AjaxResult process(@RequestParam(defaultValue = "20") Integer limit) {
        return success(supervisionReportService.processPendingReports(limit));
    }

    @GetMapping("/report/list")
    public TableDataInfo list(@RequestParam(required = false) String reportType,
                              @RequestParam(required = false) String reportStatus,
                              @RequestParam(required = false) Long bizId,
                              @RequestParam(required = false) String reportNo) {
        IPage<HsSupervisionReport> page = supervisionReportService.page(reportType, reportStatus, bizId, reportNo, getPage());
        return getDataTableByPage(page);
    }

    @Anonymous
    @GetMapping("/report/stats")
    public AjaxResult stats() {
        return success(supervisionReportService.stats());
    }
}
