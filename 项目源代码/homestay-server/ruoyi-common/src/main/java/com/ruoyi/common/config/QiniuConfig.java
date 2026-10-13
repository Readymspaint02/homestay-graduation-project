package com.ruoyi.common.config;

import com.ruoyi.common.utils.file.QiniuUploadUtils;
import jakarta.annotation.PostConstruct;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "qiniu")
public class QiniuConfig {

    private String accessKey;

    private String secretKey;

    private String bucket;

    private String domain;

    private boolean enabled = false;

    @PostConstruct
    public void init() {
        QiniuUploadUtils.init(this);
    }
}
