package com.ruoyi.biz.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.biz.domain.hs.HsMessage;

/**
 * Message service.
 */
public interface IHsMessageService {

    IPage<HsMessage> myMessages(Page<HsMessage> page);

    boolean read(Long messageId);
}
