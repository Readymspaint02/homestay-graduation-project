package com.ruoyi.biz.domain.hs.bo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

/**
 * Create/Update homestay request.
 */
@Data
public class HsHomestayCreateBo {

    private Long id;

    @NotBlank(message = "title cannot be blank")
    private String title;

    /**
     * 封面图片URL
     */
    private String coverImage;

    private String description;

    /**
     * 房型：整套/独立/合租
     */
    private String roomType;

    /**
     * 卧室数
     */
    private Integer bedroomCount;

    /**
     * 床型信息
     */
    private String bedInfo;

    private String province;

    private String city;

    private String district;

    private String address;

    private BigDecimal longitude;

    private BigDecimal latitude;

    /**
     * 平日价
     */
    @NotNull(message = "basePrice cannot be null")
    @Positive(message = "basePrice must be > 0")
    private BigDecimal basePrice;

    /**
     * 周末价
     */
    private BigDecimal weekendPrice;

    /**
     * 清洁费
     */
    private BigDecimal cleaningFee;

    /**
     * 押金
     */
    private BigDecimal deposit;

    @NotNull(message = "maxGuests cannot be null")
    @Positive(message = "maxGuests must be > 0")
    private Integer maxGuests;

    /**
     * 设施列表
     */
    private List<FacilityBO> facilities;

    /**
     * 图片列表
     */
    private List<ImageBO> images;

    private String remark;

    @Data
    public static class FacilityBO {
        private String facilityCode;
        private String facilityName;
    }

    @Data
    public static class ImageBO {
        private String imageUrl;
        private Integer sortOrder;
        private String isCover;
    }
}
