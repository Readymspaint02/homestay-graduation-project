package com.ruoyi.biz.domain.hs;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * Favorite entity.
 */
@Data
@TableName("hs_favorite")
public class HsFavorite {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String tenantId;

    private Long tenantUserId;

    private Long homestayId;

    private Date createTime;
}
