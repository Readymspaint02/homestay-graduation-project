package com.ruoyi.biz.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.biz.domain.Region;

import java.util.List;

/**
 * Region mapper.
 */
public interface RegionMapper extends BaseMapper<Region> {

    /**
     * Query region list by condition.
     */
    List<Region> selectRegionList(Region region);
}