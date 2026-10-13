package com.ruoyi.biz.controller;

import cn.hutool.json.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.ruoyi.biz.domain.Region;
import com.ruoyi.biz.service.IRegionService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.annotation.RepeatSubmit;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;

/**
 * Region controller.
 */
@RestController
@RequestMapping("/biz/Region")
@RequiredArgsConstructor
public class RegionController extends BaseController {

    private final IRegionService regionService;

    @Anonymous
    @GetMapping("/list")
    public AjaxResult list(Region region) {
        QueryWrapper<Region> queryWrapper = new QueryWrapper<>();
        Integer level = region.getLevel();
        if (level == null) {
            level = 1;
        }
        queryWrapper.eq("level", level);
        if (level > 1) {
            if (StringUtils.isEmpty(region.getParentId())) {
                return error("need parentId");
            }
            queryWrapper.eq("parent_id", region.getParentId());
        }
        return success(regionService.list(queryWrapper));
    }

    @PreAuthorize("@ss.hasPermi('biz:Region:export')")
    @Log(title = "Region", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Region region) {
        List<Region> list = regionService.selectRegionList(region);
        ExcelUtil<Region> util = new ExcelUtil<>(Region.class);
        util.exportExcel(response, list, "Region Data");
    }

    @PreAuthorize("@ss.hasPermi('biz:Region:import')")
    @Log(title = "Region", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file, boolean updateSupport) throws Exception {
        int titleNum = 0;
        ExcelUtil<Region> util = new ExcelUtil<>(Region.class);
        List<Region> list = util.importExcel(file.getInputStream(), titleNum);
        String operName = getUsername();
        String message = regionService.importRegion(list, titleNum, updateSupport, operName);
        return success(message);
    }

    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response, Region region) {
        List<Region> list = new ArrayList<>();
        ExcelUtil<Region> util = new ExcelUtil<>(Region.class);
        util.exportExcel(response, list, "Region Template");
    }

    @Anonymous
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") String id) {
        return success(regionService.selectRegionById(id));
    }

    @PreAuthorize("@ss.hasPermi('biz:Region:add')")
    @Log(title = "Region", businessType = BusinessType.INSERT)
    @PostMapping
    @RepeatSubmit
    public AjaxResult add(@RequestBody Region region) {
        regionService.insertRegion(region);
        JSONObject jsonObject = new JSONObject();
        jsonObject.putOpt("id", region.getId());
        return success(jsonObject);
    }

    @PreAuthorize("@ss.hasPermi('biz:Region:edit')")
    @Log(title = "Region", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Region region) {
        return toAjax(regionService.updateRegion(region));
    }

    @PreAuthorize("@ss.hasPermi('biz:Region:remove')")
    @Log(title = "Region", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable String[] ids) {
        return toAjax(regionService.deleteRegionByIds(ids));
    }
}
