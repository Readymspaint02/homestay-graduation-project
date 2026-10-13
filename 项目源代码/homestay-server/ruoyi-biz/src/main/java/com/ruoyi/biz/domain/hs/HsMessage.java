package com.ruoyi.biz.domain.hs;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * In-app message entity.
 */
@Data
@TableName("hs_message")
public class HsMessage {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String tenantId;

    private Long receiverUserId;

    private String msgType;

    private String title;

    private String content;

    private String relatedOrderNo;

    private String isRead;

    private Date createTime;

    private Date readTime;
}
