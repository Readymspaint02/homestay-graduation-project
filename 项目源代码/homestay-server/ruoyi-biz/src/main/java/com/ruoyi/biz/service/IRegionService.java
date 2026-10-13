package com.ruoyi.biz.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ruoyi.biz.domain.Region;

import java.util.List;

/**
 * Region service.
 */
public interface IRegionService extends IService<Region> {

    IPage<Region> pageRegion(Page<Region> page, QueryWrapper<Region> queryWrapper);

    String idsToNames(String ids);

    String namesToIds(String names);

    Region selectRegionById(String id);

    List<Region> selectRegionList(Region region);

    int insertRegion(Region region);

    int updateRegion(Region region);

    int deleteRegionByIds(String[] ids);

    int deleteRegionById(String id);

    String importRegion(List<Region> list, int titleNum, Boolean isUpdateSupport, String operName);
}