package com.ruoyi.biz.controller.homestay;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.common.utils.file.QiniuUploadUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/homestay/image")
public class HsImageController {

    @Value("${ruoyi.path.uploadPath}")
    private String uploadPath;

    @Value("${ruoyi.profile}")
    private String profile;

    @GetMapping("/qiniu/status")
    public AjaxResult qiniuStatus() {
        Map<String, Object> result = new HashMap<>();
        result.put("enabled", QiniuUploadUtils.isEnabled());
        result.put("domain", QiniuUploadUtils.getDomain());
        log.info("Qiniu status check: enabled={}, domain={}", QiniuUploadUtils.isEnabled(), QiniuUploadUtils.getDomain());
        return AjaxResult.success(result);
    }

    @Value("${qiniu.upload-url:https://up-z2.qiniup.com}")
    private String qiniuUploadUrl;

    @GetMapping("/qiniu/token")
    public AjaxResult getQiniuToken() {
        if (!QiniuUploadUtils.isEnabled()) {
            return AjaxResult.error("七牛云未启用");
        }
        try {
            String token = QiniuUploadUtils.getUploadToken();
            String domain = QiniuUploadUtils.getDomain();
            Map<String, String> result = new HashMap<>();
            result.put("token", token);
            result.put("domain", domain);
            result.put("uploadUrl", qiniuUploadUrl);
            return AjaxResult.success(result);
        } catch (Exception e) {
            log.error("获取七牛云上传凭证失败: {}", e.getMessage(), e);
            return AjaxResult.error("获取上传凭证失败: " + e.getMessage());
        }
    }

    @PostMapping("/upload")
    public AjaxResult upload(@RequestParam("file") MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return AjaxResult.error("upload file is empty");
        }

        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return AjaxResult.error("only image files are allowed (JPG, PNG, GIF)");
        }

        try {
            String filePath = FileUploadUtils.upload(uploadPath + "homestay/", file);
            String url = filePath;

            log.info("Image uploaded: original={}, resultUrl={}, qiniuEnabled={}", 
                file.getOriginalFilename(), url, QiniuUploadUtils.isEnabled());

            Map<String, String> result = new HashMap<>();
            result.put("imageUrl", url);
            result.put("fileName", file.getOriginalFilename());
            result.put("size", String.valueOf(file.getSize()));

            return AjaxResult.success(result);
        } catch (Exception e) {
            log.error("Upload failed: {}", e.getMessage(), e);
            return AjaxResult.error("upload failed: " + e.getMessage());
        }
    }
}
