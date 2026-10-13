package com.ruoyi.biz.domain.hs.bo;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * Push supervision report request.
 */
@Data
public class HsSupervisionPushBo {

    @Pattern(regexp = "[123]", message = "reportType must be 1/2/3")
    private String reportType;

    @NotNull(message = "bizId cannot be null")
    private Long bizId;

    private String requestJson;
}
