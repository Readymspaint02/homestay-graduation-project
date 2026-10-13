package com.ruoyi.biz.domain.hs.bo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

/**
 * Create order request.
 */
@Data
public class HsOrderCreateBo {

    @NotNull(message = "homestayId cannot be null")
    private Long homestayId;

    @NotBlank(message = "checkinDate cannot be blank")
    private String checkinDate;

    @NotBlank(message = "checkoutDate cannot be blank")
    private String checkoutDate;

    @NotNull(message = "guestCount cannot be null")
    @Positive(message = "guestCount must be > 0")
    private Integer guestCount;
}
