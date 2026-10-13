package com.ruoyi.biz.service;

import com.ruoyi.biz.domain.hs.HsChatMessage;
import com.ruoyi.biz.mapper.HsChatMessageMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class HsChatService {

    private final HsChatMessageMapper chatMessageMapper;

    public List<Map<String, Object>> getContacts(Long currentUserId) {
        return chatMessageMapper.selectContacts(currentUserId);
    }

    public List<HsChatMessage> getHistory(Long currentUserId, Long peerUserId) {
        return chatMessageMapper.selectHistory(currentUserId, peerUserId);
    }

    public HsChatMessage sendMessage(Long senderUserId, Long receiverUserId, String content) {
        HsChatMessage message = new HsChatMessage();
        message.setSenderUserId(senderUserId);
        message.setReceiverUserId(receiverUserId);
        message.setContent(content);
        message.setIsRead("0");
        message.setTenantId("000000");
        chatMessageMapper.insert(message);
        return message;
    }

    public int markAsRead(Long currentUserId, Long peerUserId) {
        return chatMessageMapper.markAsRead(currentUserId, peerUserId);
    }
}