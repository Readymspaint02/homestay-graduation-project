package com.ruoyi.biz.service;

import java.util.Map;

/**
 * Admin overview service.
 */
public interface IHsOverviewService {

    Map<String, Object> count();

    Map<String, Object> sysInfo();

    /**
     * Get landlord income statistics for recent months.
     */
    Map<String, Object> getLandlordIncomeStats(int months);

    /**
     * Get landlord order statistics.
     */
    Map<String, Object> getLandlordOrderStats();

    /**
     * Get landlord daily income for recent 30 days.
     */
    Map<String, Object> getLandlordDailyIncome();
}
