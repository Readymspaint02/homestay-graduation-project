package com.ruoyi.biz.domain.hs.bo;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * Create review request.
 */
@Data
public class HsReviewCreateBo {

    @NotNull(message = "orderId cannot be null")
    private Long orderId;

    @NotNull(message = "rating cannot be null")
    @Min(value = 1, message = "rating must be >= 1")
    @Max(value = 5, message = "rating must be <= 5")
    private Integer rating;

    private String content;

    private String isAnonymous;
}
