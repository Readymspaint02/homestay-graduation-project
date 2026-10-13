package com.ruoyi.biz.domain.hs;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * User behavior for recommendation.
 */
@Data
@TableName("hs_user_behavior")
public class HsUserBehavior {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String tenantId;

    private Long userId;

    private Long homestayId;

    /**
     * Behavior type: view, collect, order
     */
    private String behaviorType;

    private Double score;

    private Date createTime;
}
