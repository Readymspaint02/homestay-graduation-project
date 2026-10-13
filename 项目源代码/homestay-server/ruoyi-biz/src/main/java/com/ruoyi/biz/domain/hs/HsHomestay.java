package com.ruoyi.biz.domain.hs;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Homestay main table entity.
 */
@Data
@TableName("hs_homestay")
public class HsHomestay {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String tenantId;

    private String homestayNo;

    private Long landlordUserId;

    private Long classificationId;

    private String title;

    /**
     * 封面图片URL
     */
    private String coverImage;

    private String description;

    /**
     * 房型：整套/独立/合租
     */
    private String roomType;

    /**
     * 卧室数
     */
    private Integer bedroomCount;

    /**
     * 床型信息
     */
    private String bedInfo;

    private String province;

    private String city;

    private String district;

    private String address;

    private BigDecimal longitude;

    private BigDecimal latitude;

    /**
     * 平日价
     */
    private BigDecimal basePrice;

    /**
     * 周末价
     */
    private BigDecimal weekendPrice;

    /**
     * 清洁费
     */
    private BigDecimal cleaningFee;

    /**
     * 押金
     */
    private BigDecimal deposit;

    /**
     * 设施 JSON 数组
     */
    private String facilitiesJson;

    private Integer maxGuests;

    private String auditStatus;

    private String publishStatus;

    private String cleaningStatus;

    private BigDecimal ratingAvg;

    private Integer ratingCount;

    @TableLogic
    private String delFlag;

    private Long createBy;

    private Date createTime;

    private Long updateBy;

    private Date updateTime;

    private String remark;

    @com.baomidou.mybatisplus.annotation.TableField(exist = false)
    private String landlordName;
}
