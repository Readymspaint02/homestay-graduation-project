package com.ruoyi.biz.controller.homestay;

import com.ruoyi.biz.domain.hs.HsReview;
import com.ruoyi.biz.domain.hs.bo.HsReviewCreateBo;
import com.ruoyi.biz.domain.hs.vo.HsReviewWithHomestayVo;
import com.ruoyi.biz.service.IHsReviewService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Review APIs.
 */
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/review")
public class HsReviewController extends BaseController {

    private final IHsReviewService reviewService;

    @PostMapping("/create")
    public AjaxResult create(@Valid @RequestBody HsReviewCreateBo bo) {
        return toAjax(reviewService.createReview(bo));
    }

    @Anonymous
    @GetMapping("/list")
    public AjaxResult list(@RequestParam Long homestayId) {
        return success(reviewService.listByHomestay(homestayId));
    }

    /**
     * Get my reviews (current user's reviews).
     */
    @GetMapping("/my")
    public AjaxResult my() {
        List<HsReviewWithHomestayVo> reviews = reviewService.listByCurrentUserWithHomestay();
        return success(reviews);
    }
}
