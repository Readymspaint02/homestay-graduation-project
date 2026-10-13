package com.ruoyi.biz.domain.hs;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * Ad entity for carousel/banner.
 */
@Data
@TableName("hs_ad")
public class HsAd {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String tenantId;

    private String title;

    private String imageUrl;

    private String targetUrl;

    private Integer sortOrder;

    private String status;

    private String remark;

    private Long createBy;

    private Date createTime;

    private Long updateBy;

    private Date updateTime;

    private String delFlag;
}
