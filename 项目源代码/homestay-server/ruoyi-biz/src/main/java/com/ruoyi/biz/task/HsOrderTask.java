package com.ruoyi.biz.task;

import com.ruoyi.biz.domain.hs.HsOrder;
import com.ruoyi.biz.domain.hs.HsStatusConstants;
import com.ruoyi.biz.mapper.HsOrderMapper;
import com.ruoyi.biz.service.IHsOrderService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.time.Instant;
import java.util.List;

/**
 * Homestay order timeout task.
 * Auto-cancel unpaid orders after 30 minutes.
 */
@Slf4j
@Component("hsOrderTask")
@RequiredArgsConstructor
public class HsOrderTask {

    private final HsOrderMapper orderMapper;
    private final IHsOrderService orderService;

    /**
     * Check and cancel timeout unpaid orders every 5 minutes.
     * Timeout: 30 minutes after order creation.
     */
    public void checkTimeoutOrders() {
        log.info("Start checking timeout unpaid orders...");

        // Find unpaid orders older than 30 minutes
        Instant timeoutThreshold = Instant.now().minus(Duration.ofMinutes(30));

        LambdaQueryWrapper<HsOrder> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsOrder::getPayStatus, HsStatusConstants.PAY_UNPAID);
        lqw.eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_WAIT_PAY);
        lqw.lt(HsOrder::getCreateTime, java.sql.Timestamp.from(timeoutThreshold));

        List<HsOrder> timeoutOrders = orderMapper.selectList(lqw);

        if (timeoutOrders.isEmpty()) {
            log.info("No timeout orders found");
            return;
        }

        log.info("Found {} timeout unpaid orders, start cancelling...", timeoutOrders.size());

        int successCount = 0;
        int failCount = 0;

        for (HsOrder order : timeoutOrders) {
            try {
                boolean success = orderService.cancelTimeoutOrder(order.getId(), "系统自动取消：超时未支付");
                if (success) {
                    successCount++;
                    log.info("Cancelled timeout order: {}, released calendar slots", order.getOrderNo());
                } else {
                    failCount++;
                    log.warn("Failed to cancel timeout order: {}", order.getOrderNo());
                }
            } catch (Exception e) {
                failCount++;
                log.error("Failed to cancel timeout order: {}", order.getOrderNo(), e);
            }
        }

        log.info("Timeout order check completed. Success: {}, Failed: {}", successCount, failCount);
    }

    /**
     * Auto-confirm orders if landlord didn't respond within 24 hours.
     */
    public void autoConfirmOrders() {
        log.info("Start checking auto-confirm orders...");

        Instant autoConfirmThreshold = Instant.now().minus(Duration.ofHours(24));

        LambdaQueryWrapper<HsOrder> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsOrder::getOrderStatus, HsStatusConstants.ORDER_PAID);
        lqw.lt(HsOrder::getCreateTime, java.sql.Timestamp.from(autoConfirmThreshold));

        List<HsOrder> pendingOrders = orderMapper.selectList(lqw);

        if (pendingOrders.isEmpty()) {
            log.info("No pending auto-confirm orders found");
            return;
        }

        log.info("Found {} orders to auto-confirm", pendingOrders.size());

        int successCount = 0;
        for (HsOrder order : pendingOrders) {
            try {
                order.setOrderStatus(HsStatusConstants.ORDER_CONFIRMED);
                order.setConfirmTime(new java.util.Date());
                orderMapper.updateById(order);

                successCount++;
                log.info("Auto-confirmed order: {}", order.getOrderNo());
            } catch (Exception e) {
                log.error("Failed to auto-confirm order: {}", order.getOrderNo(), e);
            }
        }

        log.info("Auto-confirm completed. Success: {}", successCount);
    }
}
