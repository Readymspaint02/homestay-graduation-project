package com.ruoyi.biz.controller.homestay;

import com.ruoyi.biz.domain.hs.HsChatMessage;
import com.ruoyi.biz.service.HsChatService;
import com.ruoyi.biz.service.impl.MessageSseService;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/chat")
public class HsChatController {

    private final HsChatService chatService;
    private final MessageSseService messageSseService;

    @GetMapping("/contacts")
    public AjaxResult getContacts() {
        Long currentUserId = SecurityUtils.getUserId();
        List<Map<String, Object>> contacts = chatService.getContacts(currentUserId);
        return AjaxResult.success(contacts);
    }

    @GetMapping("/user/{userId}")
    public AjaxResult getUserInfo(@PathVariable Long userId) {
        try {
            com.ruoyi.common.core.domain.entity.SysUser user = 
                com.ruoyi.common.utils.spring.SpringUtils.getBean(com.ruoyi.system.mapper.SysUserMapper.class)
                    .selectUserById(userId);
            if (user != null) {
                java.util.Map<String, Object> result = new java.util.HashMap<>();
                result.put("userId", user.getUserId());
                result.put("nickName", user.getNickName() != null ? user.getNickName() : user.getUserName());
                result.put("userName", user.getUserName());
                result.put("online", false);
                result.put("unread", 0);
                return AjaxResult.success(result);
            }
            return AjaxResult.error("用户不存在");
        } catch (Exception e) {
            return AjaxResult.error("获取用户信息失败");
        }
    }

    @GetMapping("/history/{peerUserId}")
    public AjaxResult getHistory(@PathVariable Long peerUserId) {
        Long currentUserId = SecurityUtils.getUserId();
        List<HsChatMessage> history = chatService.getHistory(currentUserId, peerUserId);
        return AjaxResult.success(history);
    }

    @PostMapping("/send")
    public AjaxResult sendMessage(@RequestBody Map<String, Object> payload) {
        Long receiverUserId = Long.valueOf(payload.get("receiverUserId").toString());
        String content = payload.get("content").toString();
        Long senderUserId = SecurityUtils.getUserId();

        HsChatMessage message = chatService.sendMessage(senderUserId, receiverUserId, content);

        messageSseService.sendToUser(receiverUserId, "chat_message", 
            "{\"type\":\"chat\",\"fromUserId\":" + senderUserId + ",\"content\":\"" + escapeJson(content) + "\",\"time\":\"" + System.currentTimeMillis() + "\"}");

        return AjaxResult.success(message);
    }

    @PostMapping("/upload")
    public AjaxResult uploadImage(@RequestParam("file") MultipartFile file, @RequestParam("receiverUserId") Long receiverUserId) {
        try {
            String fileName = UUID.randomUUID().toString().replace("-", "") + getExtension(file.getOriginalFilename());
            Path uploadPath = Paths.get("uploads/chat");
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            Path filePath = uploadPath.resolve(fileName);
            file.transferTo(filePath.toFile());

            String imageUrl = "/uploads/chat/" + fileName;
            Long senderUserId = SecurityUtils.getUserId();

            HsChatMessage message = chatService.sendMessage(senderUserId, receiverUserId, imageUrl);

            messageSseService.sendToUser(receiverUserId, "chat_message",
                "{\"type\":\"chat\",\"fromUserId\":" + senderUserId + ",\"content\":\"" + imageUrl + "\",\"time\":\"" + System.currentTimeMillis() + "\"}");

            return AjaxResult.success(message);
        } catch (Exception e) {
            return AjaxResult.error("图片上传失败: " + e.getMessage());
        }
    }

    @PostMapping("/read/{peerUserId}")
    public AjaxResult markAsRead(@PathVariable Long peerUserId) {
        Long currentUserId = SecurityUtils.getUserId();
        int rows = chatService.markAsRead(currentUserId, peerUserId);
        return AjaxResult.success(rows);
    }

    private String getExtension(String fileName) {
        if (fileName == null || !fileName.contains(".")) {
            return ".jpg";
        }
        return fileName.substring(fileName.lastIndexOf("."));
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n");
    }
}
