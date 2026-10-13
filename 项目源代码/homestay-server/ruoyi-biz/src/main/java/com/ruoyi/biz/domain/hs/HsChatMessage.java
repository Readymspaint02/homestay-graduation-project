package com.ruoyi.biz.domain.hs;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

@Data
@TableName("hs_chat_message")
public class HsChatMessage {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String tenantId;

    private Long senderUserId;

    private Long receiverUserId;

    private String content;

    private String isRead;

    private Date createTime;

    private Date readTime;
}
