package com.ruoyi.biz.service.impl;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
public class MessageSseService {

    private final Map<Long, SseEmitter> userEmitters = new ConcurrentHashMap<>();

    public SseEmitter subscribe(Long userId) {
        SseEmitter emitter = new SseEmitter(0L);
        userEmitters.put(userId, emitter);
        emitter.onCompletion(() -> userEmitters.remove(userId));
        emitter.onTimeout(() -> userEmitters.remove(userId));
        emitter.onError(e -> userEmitters.remove(userId));
        try {
            emitter.send(SseEmitter.event().name("connected").data("ok"));
        } catch (IOException e) {
            userEmitters.remove(userId);
        }
        return emitter;
    }

    public void sendSystemNotification(Long userId, String title, String content, String relatedOrderNo) {
        SseEmitter emitter = userEmitters.get(userId);
        if (emitter != null) {
            try {
                String data = String.format("{\"title\":\"%s\",\"content\":\"%s\",\"relatedOrderNo\":\"%s\"}",
                    escapeJson(title), escapeJson(content), relatedOrderNo != null ? relatedOrderNo : "");
                emitter.send(SseEmitter.event().name("system_notification").data(data));
            } catch (IOException e) {
                userEmitters.remove(userId);
            }
        }
    }

    public void sendOrderStatusChange(Long userId, String orderNo, String status, String message) {
        SseEmitter emitter = userEmitters.get(userId);
        if (emitter != null) {
            try {
                String data = String.format("{\"orderNo\":\"%s\",\"status\":\"%s\",\"message\":\"%s\"}",
                    orderNo, status, escapeJson(message));
                emitter.send(SseEmitter.event().name("order_status").data(data));
            } catch (IOException e) {
                userEmitters.remove(userId);
            }
        }
    }

    public void sendPaymentNotification(Long userId, String orderNo, String payStatus) {
        SseEmitter emitter = userEmitters.get(userId);
        if (emitter != null) {
            try {
                String data = String.format("{\"orderNo\":\"%s\",\"payStatus\":\"%s\"}", orderNo, payStatus);
                emitter.send(SseEmitter.event().name("payment_status").data(data));
            } catch (IOException e) {
                userEmitters.remove(userId);
            }
        }
    }

    public void sendToUser(Long userId, String event, String data) {
        SseEmitter emitter = userEmitters.get(userId);
        if (emitter != null) {
            try {
                emitter.send(SseEmitter.event().name(event).data(data));
            } catch (IOException e) {
                userEmitters.remove(userId);
            }
        }
    }

    public void sendToUser(Long userId, String event, Object data) {
        sendToUser(userId, event, data == null ? "" : data.toString());
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n");
    }
}
