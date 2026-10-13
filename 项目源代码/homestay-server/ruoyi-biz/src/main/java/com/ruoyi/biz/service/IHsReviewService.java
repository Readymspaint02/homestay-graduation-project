package com.ruoyi.biz.service;

import com.ruoyi.biz.domain.hs.HsReview;
import com.ruoyi.biz.domain.hs.bo.HsReviewCreateBo;
import com.ruoyi.biz.domain.hs.vo.HsReviewWithHomestayVo;

import java.util.List;

/**
 * Review service.
 */
public interface IHsReviewService {

    boolean createReview(HsReviewCreateBo bo);

    List<HsReview> listByHomestay(Long homestayId);

    /**
     * Get reviews by current user.
     */
    List<HsReview> listByCurrentUser();

    /**
     * Get reviews by current user with homestay info.
     */
    List<HsReviewWithHomestayVo> listByCurrentUserWithHomestay();
}
