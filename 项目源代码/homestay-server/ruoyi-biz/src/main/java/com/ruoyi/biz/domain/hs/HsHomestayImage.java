package com.ruoyi.biz.domain.hs;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * 房源图片表 hs_homestay_image
 */
@Data
@TableName("hs_homestay_image")
public class HsHomestayImage {

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 房源 ID
     */
    private Long homestayId;

    /**
     * 图片 URL
     */
    private String imageUrl;

    /**
     * 排序
     */
    private Integer sortOrder;

    /**
     * 是否封面：0-否 1-是
     */
    private String isCover;

    private Date createTime;
}
