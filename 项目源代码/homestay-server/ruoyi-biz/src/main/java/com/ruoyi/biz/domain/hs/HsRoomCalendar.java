package com.ruoyi.biz.domain.hs;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.Version;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Room calendar entity.
 */
@Data
@TableName("hs_room_calendar")
public class HsRoomCalendar {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String tenantId;

    private Long homestayId;

    private Date bizDate;

    private String status;

    private BigDecimal price;

    private String lockOrderNo;

    @Version
    private Integer version;

    private Date createTime;

    private Date updateTime;
}
