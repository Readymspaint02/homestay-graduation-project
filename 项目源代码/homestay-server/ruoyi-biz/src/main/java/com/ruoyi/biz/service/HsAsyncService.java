package com.ruoyi.biz.service;

import com.ruoyi.biz.domain.hs.HsOrder;
import com.ruoyi.biz.mapper.HsOrderMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

/**
 * 异步任务服务
 * 
 * 【面试知识点 - 并发编程篇 - 异步任务】
 * 
 * 面试官：你们项目中哪里用到了多线程/异步任务？
 * 
 * 我：在民宿项目中，我使用了异步任务来优化性能：
 * 
 * 1. **异步邮件/短信通知**
 *    - 订单创建成功后，异步发送邮件/短信通知
 *    - 使用@Async 注解，不阻塞主流程
 * 
 * 2. **异步数据统计**
 *    - 异步更新房源热度、订单统计
 *    - 使用 CompletableFuture 并行聚合多个统计结果
 * 
 * 3. **异步日志记录**
 *    - 用户行为日志异步写入数据库
 *    - 避免影响主业务流程
 * 
 * 好处：
 * - 提升响应速度：主流程不等待耗时操作
 * - 提高吞吐量：异步任务在线程池中并行执行
 * - 解耦业务：通知、统计等逻辑与核心业务解耦
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class HsAsyncService {

    private final HsOrderMapper orderMapper;
    private final HsCacheService cacheService;

    /**
     * 异步发送邮件通知
     * 
     * 【面试知识点 - @Async 注解】
     * - 方法必须是 public
     * - 同类调用无效 (需要 AOP 代理)
     * - 返回值可以是 void/CompletableFuture/Future
     */
    @Async("asyncTaskExecutor")
    public void sendOrderEmail(String toEmail, String subject, String content) {
        log.info("开始发送邮件：to={}, subject={}", toEmail, subject);
        
        try {
            // 模拟邮件发送耗时操作 (实际调用邮件服务)
            Thread.sleep(500);
            log.info("邮件发送成功：to={}", toEmail);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            log.error("邮件发送中断：to={}", toEmail, e);
        } catch (Exception e) {
            log.error("邮件发送失败：to={}", toEmail, e);
        }
    }

    /**
     * 异步发送短信通知
     */
    @Async("asyncTaskExecutor")
    public void sendOrderSms(String phoneNumber, String message) {
        log.info("开始发送短信：to={}, message={}", phoneNumber, message);
        
        try {
            // 模拟短信发送耗时操作 (实际调用短信服务)
            Thread.sleep(300);
            log.info("短信发送成功：to={}", phoneNumber);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            log.error("短信发送中断：to={}", phoneNumber, e);
        } catch (Exception e) {
            log.error("短信发送失败：to={}", phoneNumber, e);
        }
    }

    /**
     * 异步更新房源热度
     * 
     * 【面试知识点 - 异步更新统计】
     * 为什么异步更新？
     * - 热度更新不影响核心业务
     * - 可以容忍短暂的数据不一致
     * - 避免 Redis 故障影响订单创建
     */
    @Async("asyncTaskExecutor")
    public void updateHomestayPopularity(Long homestayId, double score) {
        try {
            cacheService.updateHotRanking(homestayId, score);
            log.info("房源热度已更新：homestayId={}, score={}", homestayId, score);
        } catch (Exception e) {
            log.error("更新房源热度失败：homestayId={}", homestayId, e);
        }
    }

    /**
     * 异步记录用户行为日志
     */
    @Async("asyncTaskExecutor")
    public void logUserAction(Long userId, String action, String targetId) {
        log.info("记录用户行为：userId={}, action={}, targetId={}", userId, action, targetId);
        
        try {
            // 实际场景中会写入数据库或消息队列
            Thread.sleep(100);
            log.info("用户行为日志已记录：userId={}, action={}", userId, action);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            log.error("用户行为日志记录中断：userId={}", userId, e);
        } catch (Exception e) {
            log.error("用户行为日志记录失败：userId={}", userId, e);
        }
    }

    /**
     * 使用 CompletableFuture 并行查询订单统计
     * 
     * 【面试知识点 - CompletableFuture】
     * 用于并行执行多个独立任务，然后聚合结果
     * 
     * 场景：订单详情页需要展示：
     * - 订单基本信息
     * - 房源信息
     * - 用户评价
     * - 支付信息
     * 
     * 这些信息可以并行查询，最后聚合
     */
    public CompletableFuture<String> getOrderStatistics(Long orderId) {
        return CompletableFuture.supplyAsync(() -> {
            log.info("开始并行查询订单统计：orderId={}", orderId);
            
            try {
                // 模拟查询耗时
                Thread.sleep(200);
                
                HsOrder order = orderMapper.selectById(orderId);
                if (order == null) {
                    return "订单不存在";
                }
                
                String result = String.format("订单号：%s, 金额：%.2f, 状态：%s",
                    order.getOrderNo(),
                    order.getAmountPayable(),
                    order.getOrderStatus());
                
                log.info("订单统计查询完成：orderId={}", orderId);
                return result;
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return "查询中断";
            } catch (Exception e) {
                log.error("订单统计查询失败：orderId={}", orderId, e);
                return "查询失败";
            }
        });
    }

    /**
     * 并行聚合多个任务的结果
     * 
     * 【面试知识点 - CompletableFuture 组合】
     * allOf: 等待所有任务完成
     * anyOf: 任一任务完成即可
     * thenCombine: 组合两个任务的结果
     */
    public CompletableFuture<String> getHomestayFullDetail(Long homestayId) {
        // 并行查询房源详情、评价、房态
        CompletableFuture<String> detailFuture = CompletableFuture.supplyAsync(() -> {
            log.info("查询房源详情：homestayId={}", homestayId);
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            return "房源详情数据";
        });

        CompletableFuture<String> reviewFuture = CompletableFuture.supplyAsync(() -> {
            log.info("查询房源评价：homestayId={}", homestayId);
            try {
                Thread.sleep(150);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            return "房源评价数据";
        });

        CompletableFuture<String> calendarFuture = CompletableFuture.supplyAsync(() -> {
            log.info("查询房态日历：homestayId={}", homestayId);
            try {
                Thread.sleep(120);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            return "房态日历数据";
        });

        // 等待所有任务完成并聚合结果
        return CompletableFuture.allOf(detailFuture, reviewFuture, calendarFuture)
            .thenApply(v -> {
                String result = String.format("房源 ID: %d | %s | %s | %s",
                    homestayId,
                    detailFuture.join(),
                    reviewFuture.join(),
                    calendarFuture.join());
                log.info("房源完整详情查询完成：homestayId={}", homestayId);
                return result;
            });
    }
}
