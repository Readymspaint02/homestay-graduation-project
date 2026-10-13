package com.ruoyi.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.biz.domain.hs.HsMessage;
import com.ruoyi.biz.domain.hs.HsStatusConstants;
import com.ruoyi.biz.mapper.HsMessageMapper;
import com.ruoyi.biz.service.IHsMessageService;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Date;

/**
 * Message service implementation.
 */
@Service
@RequiredArgsConstructor
public class HsMessageServiceImpl implements IHsMessageService {

    private final HsMessageMapper messageMapper;

    @Override
    public IPage<HsMessage> myMessages(Page<HsMessage> page) {
        LambdaQueryWrapper<HsMessage> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsMessage::getReceiverUserId, SecurityUtils.getUserId());
        lqw.orderByDesc(HsMessage::getCreateTime);
        return messageMapper.selectPage(page, lqw);
    }

    @Override
    public boolean read(Long messageId) {
        HsMessage message = messageMapper.selectById(messageId);
        if (message == null) {
            throw new ServiceException("message not found");
        }
        Long userId = SecurityUtils.getUserId();
        if (!isSuperAdmin() && !userId.equals(message.getReceiverUserId())) {
            throw new ServiceException("no permission to read this message");
        }
        message.setIsRead(HsStatusConstants.MSG_READ);
        message.setReadTime(new Date());
        return messageMapper.updateById(message) > 0;
    }

    private boolean isSuperAdmin() {
        Long userId = SecurityUtils.getUserId();
        return SecurityUtils.isAdmin(userId) || SecurityUtils.hasRole(Constants.SUPER_ADMIN);
    }
}
