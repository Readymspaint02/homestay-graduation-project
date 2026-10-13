package com.ruoyi.biz.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.biz.websocket.ChatWebSocketEndpoint;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.stereotype.Service;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatWebSocketService {

    private final JdbcTemplate jdbcTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public void handleChatMessage(Long senderUserId, Long receiverUserId, String content) {
        if (content == null || content.trim().isEmpty()) {
            return;
        }
        Long messageId = saveMessage(senderUserId, receiverUserId, content.trim());
        Map<String, Object> messageData = getMessageById(messageId);
        try {
            String json = objectMapper.writeValueAsString(Map.of(
                "type", "chat",
                "data", messageData
            ));
            ChatWebSocketEndpoint.sendToUser(receiverUserId, json);
            ChatWebSocketEndpoint.sendToUser(senderUserId, json);
        } catch (Exception e) {
            log.error("发送聊天消息失败", e);
        }
    }

    public void handleImageMessage(Long senderUserId, Long receiverUserId, String imageUrl) {
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            return;
        }
        Long messageId = saveMessage(senderUserId, receiverUserId, imageUrl.trim());
        Map<String, Object> messageData = getMessageById(messageId);
        try {
            String json = objectMapper.writeValueAsString(Map.of(
                "type", "chat",
                "data", messageData
            ));
            ChatWebSocketEndpoint.sendToUser(receiverUserId, json);
            ChatWebSocketEndpoint.sendToUser(senderUserId, json);
        } catch (Exception e) {
            log.error("发送图片消息失败", e);
        }
    }

    private Long saveMessage(Long senderUserId, Long receiverUserId, String content) {
        GeneratedKeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(
                "INSERT INTO hs_chat_message(tenant_id, sender_user_id, receiver_user_id, content, is_read, create_time) VALUES ('0', ?, ?, ?, '0', NOW())",
                Statement.RETURN_GENERATED_KEYS
            );
            ps.setLong(1, senderUserId);
            ps.setLong(2, receiverUserId);
            ps.setString(3, content);
            return ps;
        }, keyHolder);
        return keyHolder.getKey() != null ? keyHolder.getKey().longValue() : 0L;
    }

    private Map<String, Object> getMessageById(Long messageId) {
        return jdbcTemplate.queryForMap(
            "SELECT id, sender_user_id AS senderUserId, receiver_user_id AS receiverUserId, content, create_time AS createTime, is_read AS isRead " +
                "FROM hs_chat_message WHERE id = ?",
            messageId
        );
    }
}
