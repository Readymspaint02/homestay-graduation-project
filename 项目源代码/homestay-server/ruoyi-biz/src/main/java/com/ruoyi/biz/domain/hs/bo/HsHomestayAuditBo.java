package com.ruoyi.biz.domain.hs.bo;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * Audit homestay request.
 */
@Data
public class HsHomestayAuditBo {

    @NotNull(message = "id cannot be null")
    private Long id;

    @Pattern(regexp = "[12]", message = "auditStatus must be 1 or 2")
    private String auditStatus;

    private String remark;

    @Pattern(regexp = "[12]", message = "publishStatus must be 1 or 2")
    private String publishStatus;
}
