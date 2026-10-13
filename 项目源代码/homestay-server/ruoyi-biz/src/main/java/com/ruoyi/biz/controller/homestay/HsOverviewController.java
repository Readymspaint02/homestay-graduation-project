package com.ruoyi.biz.controller.homestay;

import com.ruoyi.biz.service.IHsOverviewService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Overview APIs for admin dashboard.
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/overview")
public class HsOverviewController extends BaseController {

    private final IHsOverviewService overviewService;

    @Anonymous
    @GetMapping("/count")
    public AjaxResult count() {
        return success(overviewService.count());
    }

    @Anonymous
    @GetMapping("/sysInfo")
    public AjaxResult sysInfo() {
        return success(overviewService.sysInfo());
    }

    /**
     * Get landlord income statistics.
     */
    @GetMapping("/landlord/income")
    public AjaxResult landlordIncome(@RequestParam(defaultValue = "6") int months) {
        return success(overviewService.getLandlordIncomeStats(months));
    }

    /**
     * Get landlord order statistics.
     */
    @GetMapping("/landlord/orders")
    public AjaxResult landlordOrders() {
        return success(overviewService.getLandlordOrderStats());
    }

    /**
     * Get landlord daily income for recent 30 days.
     */
    @GetMapping("/landlord/daily-income")
    public AjaxResult landlordDailyIncome() {
        return success(overviewService.getLandlordDailyIncome());
    }
}
