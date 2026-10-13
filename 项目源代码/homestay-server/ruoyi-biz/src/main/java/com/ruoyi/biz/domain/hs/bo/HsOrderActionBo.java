package com.ruoyi.biz.domain.hs.bo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * Order action request.
 */
@Data
public class HsOrderActionBo {

    @NotNull(message = "orderId cannot be null")
    private Long orderId;

    private String reason;
}
