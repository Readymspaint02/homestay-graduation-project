package com.ruoyi.biz.aspect;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

/**
 * 接口性能监控切面
 * 
 * 用于监控关键接口的响应时间，帮助定位性能瓶颈
 */
@Slf4j
@Aspect
@Component
public class PerformanceAspect {

    /**
     * 监控民宿相关接口
     */
    @Pointcut("execution(* com.ruoyi.biz.controller..*.*(..))")
    public void bizControllerPointcut() {}

    @Around("bizControllerPointcut()")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        long startTime = System.currentTimeMillis();
        String className = point.getTarget().getClass().getSimpleName();
        String methodName = point.getSignature().getName();
        
        try {
            Object result = point.proceed();
            long costTime = System.currentTimeMillis() - startTime;
            
            // 超过500ms的慢接口记录warn日志
            if (costTime > 500) {
                log.warn("[性能告警] {}.{} 耗时: {}ms", className, methodName, costTime);
            } else if (costTime > 200) {
                log.info("[性能监控] {}.{} 耗时: {}ms", className, methodName, costTime);
            } else {
                log.debug("[性能监控] {}.{} 耗时: {}ms", className, methodName, costTime);
            }
            
            return result;
        } catch (Throwable e) {
            long costTime = System.currentTimeMillis() - startTime;
            log.error("[性能监控] {}.{} 异常，耗时: {}ms, 错误: {}", 
                className, methodName, costTime, e.getMessage());
            throw e;
        }
    }
}
