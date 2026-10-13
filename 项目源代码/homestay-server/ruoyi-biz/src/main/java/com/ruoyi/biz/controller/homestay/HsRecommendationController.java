package com.ruoyi.biz.controller.homestay;

import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.service.IHsHomestayService;
import com.ruoyi.biz.service.IHsRecommendationService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import java.util.List;

/**
 * Recommendation APIs.
 */
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/recommend")
public class HsRecommendationController extends BaseController {

    private final IHsRecommendationService recommendationService;
    private final IHsHomestayService homestayService;

    /**
     * Get recommended homestays for current user.
     */
    @GetMapping("/for-you")
    public AjaxResult recommendForYou(@RequestParam(defaultValue = "6") int limit) {
        Long userId = SecurityUtils.getUserId();
        List<HsHomestay> recommendations = recommendationService.recommendForUser(userId, limit);
        return success(recommendations);
    }

    /**
     * Get similar homestays.
     */
    @Anonymous
    @GetMapping("/similar/{homestayId}")
    public AjaxResult similarHomestays(@PathVariable Long homestayId,
                                       @RequestParam(defaultValue = "6") int limit) {
        List<HsHomestay> similar = recommendationService.similarHomestays(homestayId, limit);
        return success(similar);
    }

    /**
     * Record user behavior.
     */
    @PostMapping("/behavior")
    public AjaxResult recordBehavior(@RequestParam Long homestayId,
                                     @RequestParam(defaultValue = "view") String type) {
        Long userId = SecurityUtils.getUserId();
        recommendationService.recordBehavior(userId, homestayId, type);
        return success();
    }

    /**
     * Get popular homestays (fallback for cold start).
     */
    @Anonymous
    @GetMapping("/popular")
    public AjaxResult popular(@RequestParam(defaultValue = "6") int limit) {
        List<HsHomestay> all = homestayService.selectPage(null, null, null, null, null, null, null,
                Page.of(1, limit + 10)).getRecords();
        List<HsHomestay> popular = all.stream()
                .filter(h -> "1".equals(h.getAuditStatus()) && "1".equals(h.getPublishStatus()))
                .sorted((a, b) -> b.getRatingCount().compareTo(a.getRatingCount()))
                .limit(limit)
                .toList();
        return success(popular);
    }
}
