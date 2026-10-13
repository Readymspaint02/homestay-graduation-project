package com.ruoyi.biz.controller.homestay;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.biz.domain.hs.HsMessage;
import com.ruoyi.biz.service.IHsMessageService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Message APIs.
 */
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/message")
public class HsMessageController extends BaseController {

    private final IHsMessageService messageService;

    @GetMapping("/my")
    public TableDataInfo myMessages() {
        IPage<HsMessage> page = messageService.myMessages(getPage());
        return getDataTableByPage(page);
    }

    @PostMapping("/read/{messageId}")
    public AjaxResult read(@PathVariable Long messageId) {
        return toAjax(messageService.read(messageId));
    }
}
