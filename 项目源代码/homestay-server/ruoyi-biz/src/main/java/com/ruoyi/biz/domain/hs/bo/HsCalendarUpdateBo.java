package com.ruoyi.biz.domain.hs.bo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

import java.math.BigDecimal;

/**
 * Update calendar range request.
 */
@Data
public class HsCalendarUpdateBo {

    @NotNull(message = "homestayId cannot be null")
    private Long homestayId;

    @NotBlank(message = "startDate cannot be blank")
    private String startDate;

    @NotBlank(message = "endDate cannot be blank")
    private String endDate;

    @Pattern(regexp = "[03]", message = "status must be 0 or 3")
    private String status;

    private BigDecimal price;
}
