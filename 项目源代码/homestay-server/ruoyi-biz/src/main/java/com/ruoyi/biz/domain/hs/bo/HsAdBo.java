package com.ruoyi.biz.domain.hs.bo;

import lombok.Data;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * Ad create/update BO.
 */
@Data
public class HsAdBo {

    private Long id;

    @NotBlank(message = "title required")
    private String title;

    @NotBlank(message = "imageUrl required")
    private String imageUrl;

    private String targetUrl;

    private Integer sortOrder;

    private String status;

    private String remark;

    private String link;

    private String name;
}
