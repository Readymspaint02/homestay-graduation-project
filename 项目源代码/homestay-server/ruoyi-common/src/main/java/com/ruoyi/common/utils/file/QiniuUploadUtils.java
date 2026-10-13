package com.ruoyi.common.utils.file;

import com.google.gson.Gson;
import com.qiniu.http.Response;
import com.qiniu.storage.Configuration;
import com.qiniu.storage.Region;
import com.qiniu.storage.UploadManager;
import com.qiniu.storage.model.DefaultPutRet;
import com.qiniu.util.Auth;
import com.ruoyi.common.config.QiniuConfig;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;

@Slf4j
public class QiniuUploadUtils {

    private static QiniuConfig qiniuConfig;
    private static UploadManager uploadManager;
    private static Auth auth;

    public static void init(QiniuConfig config) {
        qiniuConfig = config;
        if (config != null && config.isEnabled() && StringUtils.isNotBlank(config.getAccessKey())) {
            Configuration cfg = new Configuration(Region.autoRegion());
            cfg.useHttpsDomains = true;
            uploadManager = new UploadManager(cfg);
            auth = Auth.create(config.getAccessKey(), config.getSecretKey());
            log.info("Qiniu OSS initialized successfully, bucket: {}, domain: {}", config.getBucket(), config.getDomain());
        } else {
            log.warn("Qiniu OSS not initialized: enabled={}, accessKey={}", 
                config != null && config.isEnabled(), 
                config != null ? (StringUtils.isNotBlank(config.getAccessKey()) ? "set" : "empty") : "null");
        }
    }

    public static boolean isEnabled() {
        return qiniuConfig != null && qiniuConfig.isEnabled() && auth != null;
    }

    public static String getUploadToken() {
        if (!isEnabled()) {
            return null;
        }
        return auth.uploadToken(qiniuConfig.getBucket());
    }

    public static String upload(MultipartFile file, String basePath) throws IOException {
        if (!isEnabled()) {
            return null;
        }
        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (StringUtils.isNotBlank(originalFilename) && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        String key = basePath + IdUtils.fastUUID() + extension;
        return upload(file.getInputStream(), key);
    }

    public static String upload(InputStream inputStream, String key) throws IOException {
        if (!isEnabled()) {
            return null;
        }
        try {
            String upToken = auth.uploadToken(qiniuConfig.getBucket());
            Response response = uploadManager.put(inputStream, key, upToken, null, null);
            if (response.isOK()) {
                DefaultPutRet putRet = new Gson().fromJson(response.bodyString(), DefaultPutRet.class);
                String url = qiniuConfig.getDomain();
                if (StringUtils.isNotBlank(url)) {
                    if (!url.endsWith("/")) {
                        url += "/";
                    }
                    return url + putRet.key;
                }
                return putRet.key;
            } else {
                log.error("Qiniu upload failed: {}", response.bodyString());
                throw new IOException("Qiniu upload failed: " + response.bodyString());
            }
        } finally {
            if (inputStream != null) {
                inputStream.close();
            }
        }
    }

    public static String getDomain() {
        if (qiniuConfig != null && StringUtils.isNotBlank(qiniuConfig.getDomain())) {
            String domain = qiniuConfig.getDomain();
            if (!domain.endsWith("/")) {
                domain += "/";
            }
            return domain;
        }
        return "";
    }
}
