package com.ruoyi.biz.controller.homestay;

import com.ruoyi.biz.service.IHsFavoriteService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * Favorite APIs for thingCollect endpoints.
 */
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/thingCollect")
public class HsFavoriteController extends BaseController {

    private final IHsFavoriteService favoriteService;

    @GetMapping("/getUserCollectList")
    public AjaxResult getUserCollectList(@RequestParam(required = false) Long userId) {
        List<Map<String, Object>> list = favoriteService.listFavorites(userId);
        return AjaxResult.success(list);
    }

    @GetMapping("/isCollected")
    public AjaxResult isCollected(@RequestParam Long userId, @RequestParam Long homestayId) {
        boolean collected = favoriteService.isFavorited(userId, homestayId);
        return AjaxResult.success(collected);
    }

    @Log(title = "收藏管理", businessType = BusinessType.INSERT)
    @PostMapping("/collect")
    public AjaxResult collect(@RequestParam Long thingId) {
        boolean result = favoriteService.addFavorite(thingId);
        return result ? AjaxResult.success("收藏成功") : AjaxResult.error("收藏失败");
    }

    @Log(title = "收藏管理", businessType = BusinessType.DELETE)
    @PostMapping("/unCollect")
    public AjaxResult unCollect(@RequestParam Long thingId) {
        favoriteService.removeFavorite(thingId);
        return AjaxResult.success("取消收藏成功");
    }
}
