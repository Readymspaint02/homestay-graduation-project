package com.ruoyi.biz.service.impl;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.alipay.api.request.AlipayTradeQueryRequest;
import com.alipay.api.response.AlipayTradeQueryResponse;
import com.ruoyi.biz.config.HsAlipayConfig;
import com.ruoyi.biz.domain.hs.HsOrder;
import com.ruoyi.biz.mapper.HsOrderMapper;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class HsAlipayService {

    private static final String ALIPAY_TRADE_NO_PREFIX = "ALIPAY_SANDBOX_";

    private final HsAlipayConfig alipayConfig;
    private final HsOrderMapper orderMapper;
    private final RedisCache redisCache;
    private final MessageSseService messageSseService;

    private AlipayClient alipayClient;

    private AlipayClient getAlipayClient() {
        if (alipayClient == null) {
            alipayClient = new DefaultAlipayClient(
                alipayConfig.getGatewayUrl(),
                alipayConfig.getAppId(),
                alipayConfig.getAppPrivateKey(),
                alipayConfig.getFormat(),
                alipayConfig.getCharset(),
                alipayConfig.getAlipayPublicKey(),
                alipayConfig.getSignType()
            );
        }
        return alipayClient;
    }

    private AlipayClient createAlipayClientWithRetry() {
        try {
            return getAlipayClient();
        } catch (Exception e) {
            log.warn("创建支付宝客户端失败，尝试重置: {}", e.getMessage());
            alipayClient = null;
            return getAlipayClient();
        }
    }

    public Map<String, Object> createTrade(Long orderId, BigDecimal amount) {
        HsOrder order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new ServiceException("订单不存在");
        }
        if (!"0".equals(order.getOrderStatus())) {
            throw new ServiceException("订单状态不允许支付");
        }

        String tradeNo = ALIPAY_TRADE_NO_PREFIX + orderId + "_" + System.currentTimeMillis();
        String formHtml = buildAlipayFormHtml(order, tradeNo, amount);

        redisCache.setCacheObject("alipay:trade:" + tradeNo, orderId, 30, TimeUnit.MINUTES);
        redisCache.setCacheObject("alipay:order:" + orderId, tradeNo, 30, TimeUnit.MINUTES);

        Map<String, Object> result = new HashMap<>();
        result.put("tradeNo", tradeNo);
        result.put("formHtml", formHtml);
        result.put("amount", amount);
        result.put("orderId", orderId);
        return result;
    }

    @Transactional(rollbackFor = Exception.class)
    public String handleNotify(Map<String, String> params) {
        String tradeNo = params.get("out_trade_no");
        String tradeStatus = params.get("trade_status");

        if (StringUtils.isBlank(tradeNo)) {
            return "fail";
        }

        Long orderId = redisCache.getCacheObject("alipay:trade:" + tradeNo);
        if (orderId == null) {
            try {
                String idPart = tradeNo.replace(ALIPAY_TRADE_NO_PREFIX, "").split("_")[0];
                orderId = Long.valueOf(idPart);
            } catch (Exception e) {
                log.error("解析订单号失败: {}", tradeNo);
                return "fail";
            }
        }

        HsOrder order = orderMapper.selectById(orderId);
        if (order == null) {
            return "fail";
        }

        if ("TRADE_SUCCESS".equals(tradeStatus) || "TRADE_FINISHED".equals(tradeStatus)) {
            if (!"1".equals(order.getPayStatus())) {
                order.setPayStatus("1");
                order.setOrderStatus("1");
                order.setPayTime(new Date());
                order.setUpdateBy(order.getTenantUserId());
                orderMapper.updateById(order);

                messageSseService.sendToUser(order.getLandlordUserId(), "new_order",
                        "{\"type\":\"new_order\",\"orderId\":" + orderId + ",\"orderNo\":\"" + order.getOrderNo() + "\",\"orderStatus\":\"1\"}");
            }
            return "success";
        }

        return "success";
    }

    public String queryTradeStatus(Long orderId) {
        HsOrder order = orderMapper.selectById(orderId);
        if (order == null) {
            return "WAIT_BUYER_PAY";
        }
        if ("1".equals(order.getPayStatus())) {
            return "TRADE_SUCCESS";
        }
        
        String tradeNo = redisCache.getCacheObject("alipay:order:" + orderId);
        if (tradeNo == null) {
            tradeNo = ALIPAY_TRADE_NO_PREFIX + orderId + "_";
        }
        
        int retryCount = 0;
        int maxRetries = 2;
        
        while (retryCount < maxRetries) {
            try {
                AlipayClient client = createAlipayClientWithRetry();
                AlipayTradeQueryRequest queryRequest = new AlipayTradeQueryRequest();
                queryRequest.setBizContent("{\"out_trade_no\":\"" + tradeNo + "\"}");
                AlipayTradeQueryResponse queryResponse = client.execute(queryRequest);
                if (queryResponse.isSuccess()) {
                    String status = queryResponse.getTradeStatus();
                    if ("TRADE_SUCCESS".equals(status) || "TRADE_FINISHED".equals(status)) {
                        if (!"1".equals(order.getPayStatus())) {
                            order.setPayStatus("1");
                            order.setOrderStatus("2");
                            order.setPayTime(new Date());
                            orderMapper.updateById(order);
                        }
                    }
                    return status;
                }
            } catch (AlipayApiException e) {
                retryCount++;
                log.warn("查询支付宝交易状态失败(第{}次): {}", retryCount, e.getMessage());
                alipayClient = null;
            }
        }
        
        if ("1".equals(order.getPayStatus())) {
            return "TRADE_SUCCESS";
        }
        return "WAIT_BUYER_PAY";
    }

    private String buildAlipayFormHtml(HsOrder order, String tradeNo, BigDecimal amount) {
        String subject = "民宿订单-" + order.getOrderNo();
        Long orderId = order.getId();
        
        int retryCount = 0;
        int maxRetries = 3;
        Exception lastException = null;
        
        while (retryCount < maxRetries) {
            try {
                AlipayClient client = createAlipayClientWithRetry();
                AlipayTradePagePayRequest payRequest = new AlipayTradePagePayRequest();
                String returnUrl = alipayConfig.getReturnUrl() + "?payReturn=1&orderId=" + orderId + "&amount=" + amount;
                payRequest.setReturnUrl(returnUrl);
                payRequest.setNotifyUrl(alipayConfig.getNotifyUrl());
                
                Map<String, Object> bizContent = new HashMap<>();
                bizContent.put("out_trade_no", tradeNo);
                bizContent.put("total_amount", amount.setScale(2, BigDecimal.ROUND_HALF_UP).toString());
                bizContent.put("subject", subject);
                bizContent.put("product_code", "FAST_INSTANT_TRADE_PAY");
                payRequest.setBizContent(com.alibaba.fastjson.JSON.toJSONString(bizContent));
                
                String form = client.pageExecute(payRequest).getBody();
                log.info("支付宝支付表单生成成功, tradeNo: {}", tradeNo);
                return form;
            } catch (AlipayApiException e) {
                lastException = e;
                retryCount++;
                log.warn("生成支付宝支付表单失败(第{}次), 将重试: {}", retryCount, e.getMessage());
                alipayClient = null;
                try {
                    Thread.sleep(1000 * retryCount);
                } catch (InterruptedException ie) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }
        }
        
        log.error("生成支付宝支付表单失败，已重试{}次: {}", maxRetries, lastException != null ? lastException.getMessage() : "unknown");
        throw new ServiceException("支付宝服务暂时不可用，请稍后重试或使用微信模拟支付");
    }
}
