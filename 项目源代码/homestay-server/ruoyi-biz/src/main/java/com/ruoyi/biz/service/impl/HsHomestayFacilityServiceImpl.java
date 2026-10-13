package com.ruoyi.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.biz.domain.hs.HsHomestayFacility;
import com.ruoyi.biz.mapper.HsHomestayFacilityMapper;
import com.ruoyi.biz.service.IHsHomestayFacilityService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 房源设施 Service 实现类
 */
@Service
public class HsHomestayFacilityServiceImpl extends ServiceImpl<HsHomestayFacilityMapper, HsHomestayFacility>
        implements IHsHomestayFacilityService {

    @Override
    public List<HsHomestayFacility> listByHomestay(Long homestayId) {
        LambdaQueryWrapper<HsHomestayFacility> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(HsHomestayFacility::getHomestayId, homestayId);
        return list(wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveFacilities(Long homestayId, List<HsHomestayFacility> facilities) {
        // 先删除旧的
        deleteByHomestay(homestayId);
        // 再添加新的
        if (facilities != null && !facilities.isEmpty()) {
            for (HsHomestayFacility facility : facilities) {
                facility.setHomestayId(homestayId);
            }
            saveBatch(facilities);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteByHomestay(Long homestayId) {
        LambdaQueryWrapper<HsHomestayFacility> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(HsHomestayFacility::getHomestayId, homestayId);
        remove(wrapper);
    }
}
