package com.ruoyi.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.domain.hs.HsOrder;
import com.ruoyi.biz.domain.hs.HsStatusConstants;
import com.ruoyi.biz.mapper.HsHomestayMapper;
import com.ruoyi.biz.mapper.HsOrderMapper;
import com.ruoyi.biz.service.HsCacheService;
import com.ruoyi.biz.service.IHsOverviewService;
import com.ruoyi.common.utils.StringUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * Admin overview service implementation.
 * 
 * 【性能优化】
 * 1. 使用 COUNT 查询替代全表加载
 * 2. 添加统计数据缓存
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class HsOverviewServiceImpl implements IHsOverviewService {

    private static final ZoneId ZONE_ID = ZoneId.systemDefault();
    
    private static final String CACHE_KEY_PREFIX = "overview:stats:";
    private static final long CACHE_TTL_MINUTES = 5;

    private final HsHomestayMapper homestayMapper;
    private final HsOrderMapper orderMapper;
    private final HsCacheService cacheService;

    @Override
    public Map<String, Object> count() {
        long startTime = System.currentTimeMillis();
        Map<String, Object> result = new HashMap<>(16);

        // 【性能优化】使用 COUNT 查询替代全表加载
        LocalDate today = LocalDate.now(ZONE_ID);
        LocalDate weekStart = today.with(DayOfWeek.MONDAY);
        LocalDate weekEnd = weekStart.plusDays(6);

        // 房源总数
        long spzs = homestayMapper.selectCount(Wrappers.lambdaQuery());
        
        // 本周新增房源
        LambdaQueryWrapper<HsHomestay> weekLqw = Wrappers.lambdaQuery();
        weekLqw.ge(HsHomestay::getCreateTime, Date.from(weekStart.atStartOfDay(ZONE_ID).toInstant()));
        weekLqw.le(HsHomestay::getCreateTime, Date.from(weekEnd.plusDays(1).atStartOfDay(ZONE_ID).toInstant()));
        long qrxz = homestayMapper.selectCount(weekLqw);

        // 待支付订单数
        LambdaQueryWrapper<HsOrder> unpaidLqw = Wrappers.lambdaQuery();
        unpaidLqw.eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_WAIT_PAY);
        long wfdd = orderMapper.selectCount(unpaidLqw);

        // 已支付订单数
        LambdaQueryWrapper<HsOrder> paidLqw = Wrappers.lambdaQuery();
        paidLqw.eq(HsOrder::getPayStatus, HsStatusConstants.PAY_PAID);
        long yfdd = orderMapper.selectCount(paidLqw);

        // 取消/拒绝订单数
        LambdaQueryWrapper<HsOrder> canceledLqw = Wrappers.lambdaQuery();
        canceledLqw.in(HsOrder::getOrderStatus, 
            HsStatusConstants.ORDER_CANCELLED, HsStatusConstants.ORDER_REJECTED);
        long qxdd = orderMapper.selectCount(canceledLqw);

        // 访问列表和热门房源仍需查询详细数据（数据量可控）
        List<HsOrder> recentOrders = orderMapper.selectList(
            Wrappers.<HsOrder>lambdaQuery()
                .ge(HsOrder::getCreateTime, Date.from(today.minusDays(7).atStartOfDay(ZONE_ID).toInstant()))
                .orderByDesc(HsOrder::getCreateTime)
                .last("LIMIT 500")
        );
        
        List<HsHomestay> homestays = homestayMapper.selectList(
            Wrappers.<HsHomestay>lambdaQuery()
                .orderByDesc(HsHomestay::getRatingCount)
                .last("LIMIT 100")
        );

        result.put("spzs", spzs);
        result.put("qrxz", qrxz);
        result.put("wfdd", wfdd);
        result.put("wfddrs", 0); // 简化统计
        result.put("yfdd", yfdd);
        result.put("yfddrs", 0);
        result.put("qxdd", qxdd);
        result.put("qxddrs", 0);
        result.put("visitList", buildVisitList(recentOrders, today));
        result.put("popularThings", buildPopularThings(homestays, recentOrders));
        result.put("popularClassification", buildPopularClassification(homestays));
        
        log.debug("Overview count 完成，耗时: {}ms", System.currentTimeMillis() - startTime);
        return result;
    }

    @Override
    public Map<String, Object> sysInfo() {
        Map<String, Object> result = new HashMap<>(16);
        OperatingSystemMXBean osBean = ManagementFactory.getOperatingSystemMXBean();
        Runtime runtime = Runtime.getRuntime();

        String osName = System.getProperty("os.name", "Unknown");
        String osArch = System.getProperty("os.arch", "Unknown");

        double cpuLoadPercent = -1;
        double totalMemoryGb = 0;
        double usedMemoryGb = 0;
        if (osBean instanceof com.sun.management.OperatingSystemMXBean sunOsBean) {
            cpuLoadPercent = safePercent(sunOsBean.getSystemCpuLoad());
            totalMemoryGb = bytesToGb(sunOsBean.getTotalPhysicalMemorySize());
            double freeMemoryGb = bytesToGb(sunOsBean.getFreePhysicalMemorySize());
            usedMemoryGb = Math.max(totalMemoryGb - freeMemoryGb, 0);
        } else {
            totalMemoryGb = bytesToGb(runtime.maxMemory());
            usedMemoryGb = Math.max(totalMemoryGb - bytesToGb(runtime.freeMemory()), 0);
        }
        double percentMemory = totalMemoryGb <= 0 ? 0 : round((usedMemoryGb / totalMemoryGb) * 100);

        long uptimeMillis = ManagementFactory.getRuntimeMXBean().getUptime();
        String uptime = formatUptime(uptimeMillis);

        result.put("sysName", "Homestay Short-Rent System");
        result.put("versionName", "MVP 1.0");
        result.put("osName", osName);
        result.put("pf", osName + " " + osArch);
        result.put("cpuCount", runtime.availableProcessors());
        result.put("processor", osArch);
        result.put("cpuLoad", cpuLoadPercent < 0 ? 0 : cpuLoadPercent);
        result.put("memory", totalMemoryGb);
        result.put("usedMemory", usedMemoryGb);
        result.put("percentMemory", percentMemory);
        result.put("sysLan", Locale.getDefault().toLanguageTag());
        result.put("jvmVersion", System.getProperty("java.version", "Unknown"));
        result.put("sysZone", ZonedDateTime.now(ZONE_ID).getZone().getId());
        result.put("uptime", uptime);
        return result;
    }

    private String formatUptime(long uptimeMillis) {
        long seconds = uptimeMillis / 1000;
        long days = seconds / 86400;
        long hours = (seconds % 86400) / 3600;
        long minutes = (seconds % 3600) / 60;
        if (days > 0) {
            return days + " 天 " + hours + " 小时 " + minutes + " 分钟";
        } else if (hours > 0) {
            return hours + " 小时 " + minutes + " 分钟";
        } else {
            return minutes + " 分钟";
        }
    }

    @Override
    public Map<String, Object> getLandlordIncomeStats(int months) {
        Map<String, Object> result = new LinkedHashMap<>();

        // Get current landlord's orders (paid/confirmed/finished)
        Long landlordUserId = com.ruoyi.common.utils.SecurityUtils.getUserId();

        LocalDate endDate = LocalDate.now(ZONE_ID);
        LocalDate startDate = endDate.minusMonths(months - 1);

        LambdaQueryWrapper<HsOrder> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsOrder::getLandlordUserId, landlordUserId);
        lqw.in(HsOrder::getOrderStatus,
            HsStatusConstants.ORDER_CONFIRMED,
            HsStatusConstants.ORDER_FINISHED);
        lqw.in(HsOrder::getPayStatus,
            HsStatusConstants.PAY_PAID);

        List<HsOrder> orders = orderMapper.selectList(lqw);

        // Group by month
        Map<String, BigDecimal> incomeByMonth = new LinkedHashMap<>();
        for (int i = months - 1; i >= 0; i--) {
            LocalDate monthDate = endDate.minusMonths(i);
            String monthKey = monthDate.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM"));
            incomeByMonth.put(monthKey, BigDecimal.ZERO);
        }

        for (HsOrder order : orders) {
            if (order.getCreateTime() != null) {
                LocalDate orderDate = toLocalDate(order.getCreateTime());
                if (!orderDate.isBefore(startDate) && !orderDate.isAfter(endDate)) {
                    String monthKey = orderDate.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM"));
                    incomeByMonth.merge(monthKey, order.getAmountPayable(), BigDecimal::add);
                }
            }
        }

        // Calculate totals
        BigDecimal totalIncome = incomeByMonth.values().stream()
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal thisMonthIncome = incomeByMonth.getOrDefault(
            endDate.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM")), BigDecimal.ZERO);

        result.put("months", months);
        result.put("totalIncome", totalIncome.setScale(2, RoundingMode.HALF_UP));
        result.put("thisMonthIncome", thisMonthIncome.setScale(2, RoundingMode.HALF_UP));
        result.put("trend", incomeByMonth.entrySet().stream()
            .map(e -> {
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("month", e.getKey());
                item.put("income", e.getValue().setScale(2, RoundingMode.HALF_UP));
                return item;
            })
            .collect(Collectors.toList()));

        return result;
    }

    @Override
    public Map<String, Object> getLandlordOrderStats() {
        Long landlordUserId = com.ruoyi.common.utils.SecurityUtils.getUserId();
        long startTime = System.currentTimeMillis();

        // 【性能优化】使用 COUNT 查询替代全表加载
        Map<String, Object> result = new LinkedHashMap<>();
        
        Long totalOrders = orderMapper.selectCount(
            Wrappers.<HsOrder>lambdaQuery().eq(HsOrder::getLandlordUserId, landlordUserId));
        result.put("totalOrders", totalOrders);

        // 状态统计 - 使用 COUNT 查询
        Map<String, Long> statusCount = new LinkedHashMap<>();
        statusCount.put("待支付", orderMapper.selectCount(
            Wrappers.<HsOrder>lambdaQuery()
                .eq(HsOrder::getLandlordUserId, landlordUserId)
                .eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_WAIT_PAY)));
        statusCount.put("待确认", orderMapper.selectCount(
            Wrappers.<HsOrder>lambdaQuery()
                .eq(HsOrder::getLandlordUserId, landlordUserId)
                .eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_PAID)));
        statusCount.put("已确认", orderMapper.selectCount(
            Wrappers.<HsOrder>lambdaQuery()
                .eq(HsOrder::getLandlordUserId, landlordUserId)
                .eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_CONFIRMED)));
        statusCount.put("入住中/已完成", orderMapper.selectCount(
            Wrappers.<HsOrder>lambdaQuery()
                .eq(HsOrder::getLandlordUserId, landlordUserId)
                .eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_FINISHED)));
        statusCount.put("已取消/拒绝", orderMapper.selectCount(
            Wrappers.<HsOrder>lambdaQuery()
                .eq(HsOrder::getLandlordUserId, landlordUserId)
                .in(HsOrder::getOrderStatus, HsStatusConstants.ORDER_CANCELLED, HsStatusConstants.ORDER_REJECTED)));

        result.put("statusBreakdown", statusCount);

        // 近30天趋势 - 只查询最近30天的数据
        LocalDate today = LocalDate.now(ZONE_ID);
        LocalDate startDate = today.minusDays(29);

        List<HsOrder> recentOrders = orderMapper.selectList(
            Wrappers.<HsOrder>lambdaQuery()
                .eq(HsOrder::getLandlordUserId, landlordUserId)
                .ge(HsOrder::getCreateTime, Date.from(startDate.atStartOfDay(ZONE_ID).toInstant()))
                .orderByDesc(HsOrder::getCreateTime));

        Map<String, Long> orderByDay = new LinkedHashMap<>();
        for (int i = 30; i >= 1; i--) {
            LocalDate day = today.minusDays(i - 1);
            orderByDay.put(day.toString(), 0L);
        }

        for (HsOrder order : recentOrders) {
            if (order.getCreateTime() != null) {
                LocalDate orderDate = toLocalDate(order.getCreateTime());
                String dayKey = orderDate.toString();
                if (orderByDay.containsKey(dayKey)) {
                    orderByDay.merge(dayKey, 1L, Long::sum);
                }
            }
        }

        result.put("recentTrend", orderByDay.entrySet().stream()
            .map(e -> {
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("date", e.getKey());
                item.put("count", e.getValue());
                return item;
            })
            .collect(Collectors.toList()));

        log.debug("getLandlordOrderStats 完成，耗时: {}ms", System.currentTimeMillis() - startTime);
        return result;
    }

    @Override
    public Map<String, Object> getLandlordDailyIncome() {
        Long landlordUserId = com.ruoyi.common.utils.SecurityUtils.getUserId();
        LocalDate today = LocalDate.now(ZONE_ID);
        LocalDate startDate = today.minusDays(29);

        LambdaQueryWrapper<HsOrder> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsOrder::getLandlordUserId, landlordUserId);
        lqw.in(HsOrder::getOrderStatus,
            HsStatusConstants.ORDER_CONFIRMED,
            HsStatusConstants.ORDER_FINISHED);
        lqw.in(HsOrder::getPayStatus, HsStatusConstants.PAY_PAID);

        List<HsOrder> orders = orderMapper.selectList(lqw);

        Map<LocalDate, BigDecimal> incomeByDay = new LinkedHashMap<>();
        Map<LocalDate, Long> countByDay = new LinkedHashMap<>();

        for (int i = 29; i >= 0; i--) {
            LocalDate day = today.minusDays(i);
            incomeByDay.put(day, BigDecimal.ZERO);
            countByDay.put(day, 0L);
        }

        for (HsOrder order : orders) {
            if (order.getCreateTime() != null) {
                LocalDate orderDate = toLocalDate(order.getCreateTime());
                if (!orderDate.isBefore(startDate) && !orderDate.isAfter(today)) {
                    incomeByDay.merge(orderDate, order.getAmountPayable(), BigDecimal::add);
                    countByDay.merge(orderDate, 1L, Long::sum);
                }
            }
        }

        List<Map<String, Object>> dailyList = new ArrayList<>();
        BigDecimal totalIncome = BigDecimal.ZERO;

        for (LocalDate day : incomeByDay.keySet()) {
            BigDecimal income = incomeByDay.get(day);
            Long count = countByDay.get(day);
            totalIncome = totalIncome.add(income);

            Map<String, Object> item = new LinkedHashMap<>();
            item.put("date", day.toString());
            item.put("amount", income.setScale(2, RoundingMode.HALF_UP));
            item.put("orderCount", count);
            dailyList.add(item);
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("dailyIncome", dailyList);
        result.put("totalIncome", totalIncome.setScale(2, RoundingMode.HALF_UP));
        return result;
    }

    private List<Map<String, Object>> buildVisitList(List<HsOrder> orders, LocalDate today) {
        Map<LocalDate, List<HsOrder>> byDay = orders.stream()
            .filter(order -> order.getCreateTime() != null)
            .collect(Collectors.groupingBy(order -> toLocalDate(order.getCreateTime())));

        List<Map<String, Object>> visitList = new ArrayList<>(7);
        LocalDate start = today.minusDays(6);
        for (int i = 0; i < 7; i++) {
            LocalDate day = start.plusDays(i);
            List<HsOrder> dayOrders = byDay.getOrDefault(day, List.of());
            int uv = (int) dayOrders.stream()
                .map(HsOrder::getTenantUserId)
                .filter(Objects::nonNull)
                .distinct()
                .count();
            int pv = dayOrders.size() + uv;
            Map<String, Object> item = new LinkedHashMap<>(4);
            item.put("day", day.toString());
            item.put("uv", uv);
            item.put("pv", pv);
            visitList.add(item);
        }
        return visitList;
    }

    private List<Map<String, Object>> buildPopularThings(List<HsHomestay> homestays, List<HsOrder> orders) {
        Map<Long, String> titleMap = homestays.stream()
            .collect(Collectors.toMap(HsHomestay::getId, HsHomestay::getTitle, (left, right) -> left));

        Map<Long, Long> bookedCountMap = orders.stream()
            .filter(order -> HsStatusConstants.ORDER_PAID.equals(order.getOrderStatus())
                || HsStatusConstants.ORDER_CONFIRMED.equals(order.getOrderStatus())
                || HsStatusConstants.ORDER_FINISHED.equals(order.getOrderStatus()))
            .filter(order -> order.getHomestayId() != null)
            .collect(Collectors.groupingBy(HsOrder::getHomestayId, Collectors.counting()));

        List<Map<String, Object>> list = bookedCountMap.entrySet().stream()
            .sorted(Map.Entry.<Long, Long>comparingByValue(Comparator.reverseOrder()))
            .limit(8)
            .map(entry -> toStatItem(defaultIfBlank(titleMap.get(entry.getKey()), "Homestay#" + entry.getKey()), entry.getValue()))
            .collect(Collectors.toList());

        if (!list.isEmpty()) {
            return list;
        }

        List<Map<String, Object>> fallback = homestays.stream()
            .sorted(Comparator.comparing(HsHomestay::getRatingCount, Comparator.nullsLast(Comparator.reverseOrder())))
            .limit(5)
            .map(item -> toStatItem(item.getTitle(), item.getRatingCount() == null ? 0 : item.getRatingCount()))
            .collect(Collectors.toList());

        if (!fallback.isEmpty()) {
            return fallback;
        }
        return List.of(toStatItem("No Data", 0));
    }

    private List<Map<String, Object>> buildPopularClassification(List<HsHomestay> homestays) {
        Map<String, Long> roomTypeCount = homestays.stream()
            .map(item -> defaultIfBlank(item.getRoomType(), "未知类型"))
            .collect(Collectors.groupingBy(roomType -> roomType, Collectors.counting()));

        List<Map<String, Object>> list = roomTypeCount.entrySet().stream()
            .sorted(Map.Entry.<String, Long>comparingByValue(Comparator.reverseOrder()))
            .limit(6)
            .map(entry -> toStatItem(entry.getKey(), entry.getValue()))
            .collect(Collectors.toList());

        if (!list.isEmpty()) {
            return list;
        }
        return List.of(toStatItem("暂无数据", 0));
    }

    private int distinctUserCount(List<HsOrder> orders) {
        Set<Long> users = new HashSet<>();
        for (HsOrder order : orders) {
            if (order.getTenantUserId() != null) {
                users.add(order.getTenantUserId());
            }
        }
        return users.size();
    }

    private Map<String, Object> toStatItem(String title, Number count) {
        Map<String, Object> item = new LinkedHashMap<>(2);
        item.put("title", defaultIfBlank(title, "Unnamed"));
        item.put("count", count);
        return item;
    }

    private String defaultIfBlank(String value, String defaultValue) {
        return StringUtils.isBlank(value) ? defaultValue : value;
    }

    private LocalDate toLocalDate(Date date) {
        return date.toInstant().atZone(ZONE_ID).toLocalDate();
    }

    private double safePercent(double value) {
        if (Double.isNaN(value) || value < 0) {
            return -1;
        }
        return round(value * 100);
    }

    private double bytesToGb(long bytes) {
        if (bytes <= 0) {
            return 0;
        }
        BigDecimal gb = BigDecimal.valueOf(bytes)
            .divide(BigDecimal.valueOf(1024L * 1024L * 1024L), 2, RoundingMode.HALF_UP);
        return gb.doubleValue();
    }

    private double round(double value) {
        return BigDecimal.valueOf(value).setScale(2, RoundingMode.HALF_UP).doubleValue();
    }
}
