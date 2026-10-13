package com.ruoyi.biz.domain.hs;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * 清洁任务表 hs_cleaning_task
 */
@Data
@TableName("hs_cleaning_task")
public class HsCleaningTask {

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 房源 ID
     */
    private Long homestayId;

    /**
     * 房源名称（非数据库字段）
     */
    private String homestayName;

    /**
     * 关联订单号
     */
    private String orderNo;

    /**
     * 清洁日期
     */
    private Date cleaningDate;

    /**
     * 状态：0-待清洁 1-已清洁
     */
    private String status;

    /**
     * 备注
     */
    private String remark;

    /**
     * 清洁完成照片 URL
     */
    private String imageUrl;

    private String cleanerPhone;

    private Date createTime;

    private Date updateTime;
}
