package com.ruoyi.biz.domain.hs;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
@TableName("hs_order")
public class HsOrder {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String tenantId;

    private String orderNo;

    private Long homestayId;

    private Long tenantUserId;

    private Long landlordUserId;

    private Date checkinDate;

    private Date checkoutDate;

    private Integer nights;

    private Integer guestCount;

    private BigDecimal amountTotal;

    private BigDecimal amountPayable;

    private String payStatus;

    private String orderStatus;

    private String cancelReason;

    private Date payTime;

    private Date confirmTime;

    private Long createBy;

    private Date createTime;

    private Long updateBy;

    private Date updateTime;

    private String remark;

    @TableField(exist = false)
    private String homestayName;

    @TableField(exist = false)
    private String homestayTitle;

    @TableField(exist = false)
    private String tenantName;
}
