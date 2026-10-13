package com.ruoyi.biz.domain.hs.vo;

import com.ruoyi.biz.domain.hs.HsReview;
import lombok.Data;

import java.util.Date;

@Data
public class HsReviewWithHomestayVo {

    private Long id;
    private String tenantId;
    private Long orderId;
    private Long homestayId;
    private Long tenantUserId;
    private Integer rating;
    private String content;
    private String isAnonymous;
    private Date createTime;
    private Date updateTime;

    private String title;
    private String cover;

    public static HsReviewWithHomestayVo from(HsReview review, String title, String cover) {
        HsReviewWithHomestayVo vo = new HsReviewWithHomestayVo();
        vo.setId(review.getId());
        vo.setTenantId(review.getTenantId());
        vo.setOrderId(review.getOrderId());
        vo.setHomestayId(review.getHomestayId());
        vo.setTenantUserId(review.getTenantUserId());
        vo.setRating(review.getRating());
        vo.setContent(review.getContent());
        vo.setIsAnonymous(review.getIsAnonymous());
        vo.setCreateTime(review.getCreateTime());
        vo.setUpdateTime(review.getUpdateTime());
        vo.setTitle(title);
        vo.setCover(cover);
        return vo;
    }
}
