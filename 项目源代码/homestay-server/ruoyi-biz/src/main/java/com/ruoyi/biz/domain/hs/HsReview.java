package com.ruoyi.biz.domain.hs;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * Review entity.
 */
@Data
@TableName("hs_review")
public class HsReview {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String tenantId;

    private Long orderId;

    private Long homestayId;

    private Long tenantUserId;

    private Integer rating;

    private String content;

    private String isAnonymous;

    private Date createTime;

    private Date updateTime;
}
