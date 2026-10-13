package com.ruoyi.biz.controller.homestay;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.biz.domain.hs.HsAd;
import com.ruoyi.biz.domain.hs.bo.HsAdBo;
import com.ruoyi.biz.service.IHsAdService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Ad/Carousel APIs.
 */
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/ad")
public class HsAdController extends BaseController {

    private final IHsAdService adService;

    @Anonymous
    @GetMapping(value = "/list", params = "pageNum")
    public TableDataInfo list(HsAd query) {
        IPage<HsAd> page = adService.list(getPage(), query);
        return getDataTableByPage(page);
    }

    @Anonymous
    @GetMapping("/active")
    public AjaxResult listActive() {
        List<HsAd> ads = adService.listActive();
        return success(ads);
    }

    @GetMapping("/{id}")
    public AjaxResult detail(@PathVariable Long id) {
        return success(adService.selectById(id));
    }

    @PostMapping(value = "/create", consumes = MediaType.APPLICATION_JSON_VALUE)
    public AjaxResult create(@Valid @RequestBody HsAdBo bo) {
        return success(adService.create(bo));
    }

    @PostMapping(value = "/update", consumes = MediaType.APPLICATION_JSON_VALUE)
    public AjaxResult update(@Valid @RequestBody HsAdBo bo) {
        return toAjax(adService.update(bo));
    }

    @PostMapping(value = "/delete", params = {"id", "!ids"})
    public AjaxResult delete(@RequestParam Long id) {
        return toAjax(adService.delete(id));
    }
}
