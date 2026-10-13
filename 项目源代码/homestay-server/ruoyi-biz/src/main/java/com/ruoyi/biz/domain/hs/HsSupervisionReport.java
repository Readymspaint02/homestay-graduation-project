package com.ruoyi.biz.domain.hs;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * Supervision report entity.
 */
@Data
@TableName("hs_supervision_report")
public class HsSupervisionReport {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String tenantId;

    private String reportNo;

    private String reportType;

    private Long bizId;

    private String reportStatus;

    private Integer retryCount;

    private String requestJson;

    private String responseJson;

    private Date lastReportTime;

    private Date createTime;

    private Date updateTime;
}
