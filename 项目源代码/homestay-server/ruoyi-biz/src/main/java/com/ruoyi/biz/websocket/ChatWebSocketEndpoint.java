package com.ruoyi.biz.websocket;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.biz.service.impl.ChatWebSocketService;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.framework.web.service.TokenService;
import com.ruoyi.common.core.domain.model.LoginUser;
import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
@ServerEndpoint("/ws/chat/{token}")
public class ChatWebSocketEndpoint {

    private static TokenService tokenService;
    private static ChatWebSocketService chatWebSocketService;
    private static final ObjectMapper objectMapper = new ObjectMapper();

    private static final Map<Long, Session> userSessions = new ConcurrentHashMap<>();

    private Long userId;

    @Autowired
    public void setTokenService(TokenService tokenService) {
        ChatWebSocketEndpoint.tokenService = tokenService;
    }

    @Autowired
    public void setChatWebSocketService(ChatWebSocketService chatWebSocketService) {
        ChatWebSocketEndpoint.chatWebSocketService = chatWebSocketService;
    }

    @OnOpen
    public void onOpen(Session session, @PathParam("token") String token) {
        try {
            LoginUser loginUser = tokenService.getLoginUser("Bearer " + token);
            if (loginUser == null) {
                log.warn("WebSocket连接失败: 无效token");
                session.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "Invalid token"));
                return;
            }
            this.userId = loginUser.getUserId();
            userSessions.put(userId, session);
            log.info("WebSocket连接成功: userId={}", userId);
            sendMessage(userId, "{\"type\":\"connected\",\"data\":\"ok\"}");
        } catch (Exception e) {
            log.error("WebSocket连接异常", e);
            try {
                session.close();
            } catch (IOException ignored) {
            }
        }
    }

    @OnClose
    public void onClose() {
        if (userId != null) {
            userSessions.remove(userId);
            log.info("WebSocket断开: userId={}", userId);
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        if (userId == null) {
            return;
        }
        try {
            Map<String, Object> msg = objectMapper.readValue(message, Map.class);
            String type = (String) msg.get("type");
            
            if ("chat".equals(type)) {
                Long receiverUserId = Long.valueOf(String.valueOf(msg.get("receiverUserId")));
                String content = (String) msg.get("content");
                chatWebSocketService.handleChatMessage(userId, receiverUserId, content);
            } else if ("image".equals(type)) {
                Long receiverUserId = Long.valueOf(String.valueOf(msg.get("receiverUserId")));
                String imageUrl = (String) msg.get("content");
                chatWebSocketService.handleImageMessage(userId, receiverUserId, imageUrl);
            } else if ("typing".equals(type)) {
                Long receiverUserId = Long.valueOf(String.valueOf(msg.get("receiverUserId")));
                sendToUser(receiverUserId, "{\"type\":\"typing\",\"fromUserId\":" + userId + "}");
            }
        } catch (Exception e) {
            log.error("WebSocket消息处理异常", e);
        }
    }

    @OnError
    public void onError(Session session, Throwable error) {
        log.error("WebSocket错误: userId={}", userId, error);
        if (userId != null) {
            userSessions.remove(userId);
        }
    }

    public static void sendToUser(Long targetUserId, String message) {
        Session session = userSessions.get(targetUserId);
        if (session != null && session.isOpen()) {
            try {
                session.getBasicRemote().sendText(message);
            } catch (IOException e) {
                log.error("发送WebSocket消息失败: userId={}", targetUserId, e);
                userSessions.remove(targetUserId);
            }
        }
    }

    public static void sendMessage(Long targetUserId, String message) {
        sendToUser(targetUserId, message);
    }

    public static boolean isOnline(Long targetUserId) {
        Session session = userSessions.get(targetUserId);
        return session != null && session.isOpen();
    }
}
