package com.ruoyi.biz.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "alipay")
public class HsAlipayConfig {

    private String appId = "2021000118699999";

    private String appPrivateKey = "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCn";

    private String alipayPublicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA";

    private String gatewayUrl = "https://openapi-sandbox.dl.alipaydev.com/gateway.do";

    private String notifyUrl = "http://localhost:8083/api/order/pay/alipay/notify";

    private String returnUrl = "http://localhost:3000/index/pay";

    private String signType = "RSA2";

    private String charset = "UTF-8";

    private String format = "json";
}
