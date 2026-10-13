package com.ruoyi.biz.domain.hs;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 房源设施关联表 hs_homestay_facility
 */
@Data
@TableName("hs_homestay_facility")
public class HsHomestayFacility {

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 房源 ID
     */
    private Long homestayId;

    /**
     * 设施编码
     */
    private String facilityCode;

    /**
     * 设施名称
     */
    private String facilityName;
}
