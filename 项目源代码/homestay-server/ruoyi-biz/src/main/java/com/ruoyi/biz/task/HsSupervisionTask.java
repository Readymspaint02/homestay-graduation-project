package com.ruoyi.biz.task;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import com.ruoyi.biz.service.IHsSupervisionReportService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Periodic mock push task for supervision reports.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class HsSupervisionTask {

    private final IHsSupervisionReportService supervisionReportService;

    @Scheduled(cron = "0 */2 * * * ?")
    public void processPendingReports() {
        int generated = supervisionReportService.generateOrderReports(50);
        int processed = supervisionReportService.processPendingReports(50);
        if (generated > 0 || processed > 0) {
            log.info("Supervision task run completed, generated={}, processed={}", generated, processed);
        }
    }
}
