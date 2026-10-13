package com.ruoyi.biz.controller.homestay;

import com.ruoyi.biz.mapper.HsHomestayMapper;
import com.ruoyi.biz.mapper.HsOrderMapper;
import com.ruoyi.biz.mapper.HsSupervisionReportMapper;
import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.domain.hs.HsOrder;
import com.ruoyi.biz.domain.hs.HsSupervisionReport;
import com.ruoyi.biz.domain.hs.HsStatusConstants;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 管理员数据看板 API - 实时数据
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/admin")
public class AdminDashboardController extends BaseController {

    private final HsOrderMapper orderMapper;
    private final HsHomestayMapper homestayMapper;
    private final HsSupervisionReportMapper supervisionReportMapper;
    private final DataSource dataSource;

    private static final ZoneId ZONE_ID = ZoneId.systemDefault();

    @GetMapping("/dashboard/stats")
    public AjaxResult dashboardStats() {
        Map<String, Object> result = new HashMap<>();

        LocalDate today = LocalDate.now(ZONE_ID);
        Date todayStart = Date.from(today.atStartOfDay(ZONE_ID).toInstant());
        Date todayEnd = Date.from(today.plusDays(1).atStartOfDay(ZONE_ID).toInstant());

        int todayOrders = orderMapper.selectCount(
            Wrappers.<HsOrder>lambdaQuery()
                .ge(HsOrder::getCreateTime, todayStart)
                .lt(HsOrder::getCreateTime, todayEnd)
        ).intValue();

        int todayHomestays = homestayMapper.selectCount(
            Wrappers.<HsHomestay>lambdaQuery()
                .ge(HsHomestay::getCreateTime, todayStart)
                .lt(HsHomestay::getCreateTime, todayEnd)
        ).intValue();

        int todayUsers = 0;
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(
                 "SELECT COUNT(*) FROM sys_user WHERE DATE(create_time) = CURDATE() AND del_flag = '0'")) {
            if (rs.next()) {
                todayUsers = rs.getInt(1);
            }
        } catch (Exception ignored) {}

        long totalReports = supervisionReportMapper.selectCount(Wrappers.lambdaQuery());
        long successReports = supervisionReportMapper.selectCount(
            Wrappers.<HsSupervisionReport>lambdaQuery()
                .eq(HsSupervisionReport::getReportStatus, "SUCCESS")
        );
        double successRate = totalReports > 0 ? Math.round(successReports * 100.0 / totalReports * 10) / 10.0 : 0;

        result.put("todayOrders", todayOrders);
        result.put("todayUsers", todayUsers);
        result.put("todayHomestays", todayHomestays);
        result.put("successRate", successRate);

        return success(result);
    }
}
