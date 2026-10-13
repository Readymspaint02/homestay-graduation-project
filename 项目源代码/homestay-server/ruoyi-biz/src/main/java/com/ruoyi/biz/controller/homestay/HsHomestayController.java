package com.ruoyi.biz.controller.homestay;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.domain.hs.bo.HsHomestayAuditBo;
import com.ruoyi.biz.domain.hs.bo.HsHomestayCreateBo;
import com.ruoyi.biz.service.HsCacheService;
import com.ruoyi.biz.service.IHsHomestayService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * Homestay APIs.
 */
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/homestay")
public class HsHomestayController extends BaseController {

    private final IHsHomestayService homestayService;
    private final HsCacheService cacheService;

    /**
     * 房源列表（公开）- 仅显示已审核已上架
     */
@Anonymous
    @GetMapping("/list")
    public TableDataInfo list(HsHomestay query,
                              BigDecimal minPrice,
                              BigDecimal maxPrice,
                              String keyword,
                              Long classificationId,
                              Long tagId,
                              String sort) {
        IPage<HsHomestay> page = homestayService.selectPage(query, minPrice, maxPrice, keyword, classificationId, tagId, sort, getPage());
        return getDataTableByPage(page);
    }

    /**
     * 房东房源列表
     */
    @GetMapping("/landlord/list")
    public TableDataInfo landlordList(String auditStatus,
                                       String publishStatus,
                                       String title) {
        Long userId = SecurityUtils.getUserId();
        IPage<HsHomestay> page = homestayService.landlordList(userId, auditStatus, publishStatus, title, getPage());
        return getDataTableByPage(page);
    }

    /**
     * 管理员房源审核列表（查看所有房东的房源）
     */
    @GetMapping("/admin/list")
    public TableDataInfo adminList(String auditStatus,
                                    String publishStatus,
                                    String title) {
        IPage<HsHomestay> page = homestayService.adminList(auditStatus, publishStatus, title, getPage());
        return getDataTableByPage(page);
    }

    /**
     * 房源详情（含设施和图片）
     */
    @Anonymous
    @GetMapping("/detail/{id}")
    public AjaxResult detail(@PathVariable Long id) {
        return success(homestayService.getDetail(id));
    }

    /**
     * 创建房源
     */
    @Log(title = "房源管理", businessType = BusinessType.INSERT)
    @PostMapping("/create")
    public AjaxResult create(@Valid @RequestBody HsHomestayCreateBo bo) {
        return success(homestayService.create(bo));
    }

    /**
     * 更新房源
     */
    @Log(title = "房源管理", businessType = BusinessType.UPDATE)
    @PostMapping("/update")
    public AjaxResult update(@Valid @RequestBody HsHomestayCreateBo bo) {
        return toAjax(homestayService.update(bo));
    }

    /**
     * 上架房源
     */
    @Log(title = "房源管理", businessType = BusinessType.UPDATE)
    @PostMapping("/{id}/publish")
    public AjaxResult publish(@PathVariable Long id) {
        return toAjax(homestayService.publish(id));
    }

    /**
     * 下架房源
     */
    @Log(title = "房源管理", businessType = BusinessType.UPDATE)
    @PostMapping("/{id}/offline")
    public AjaxResult offline(@PathVariable Long id) {
        return toAjax(homestayService.offline(id));
    }

    /**
     * 删除房源
     */
    @Log(title = "房源管理", businessType = BusinessType.DELETE)
    @PostMapping("/{id}/delete")
    public AjaxResult delete(@PathVariable Long id) {
        return toAjax(homestayService.delete(id));
    }

    /**
     * 审核房源
     */
    @Log(title = "房源管理", businessType = BusinessType.UPDATE)
    @PostMapping("/audit")
    public AjaxResult audit(@Valid @RequestBody HsHomestayAuditBo bo) {
        return toAjax(homestayService.audit(bo));
    }

    /**
     * 热门房源 TOP N 排行榜
     * 
     * 【面试知识点 -Redis ZSet 应用】
     * 使用 ZSet 存储房源热度，按 score 排序
     */
    @Anonymous
    @GetMapping("/hot/top/{n}")
    public AjaxResult hotRanking(@PathVariable int n) {
        Set<Long> hotHomestayIds = cacheService.getHotRanking(n);
        return success(hotHomestayIds);
    }
}
