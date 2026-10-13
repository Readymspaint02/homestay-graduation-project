package com.ruoyi.biz.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ruoyi.biz.domain.hs.HsHomestayFacility;

import java.util.List;

/**
 * 房源设施 Service 接口
 */
public interface IHsHomestayFacilityService extends IService<HsHomestayFacility> {

    /**
     * 获取房源设施列表
     *
     * @param homestayId 房源 ID
     * @return 设施列表
     */
    List<HsHomestayFacility> listByHomestay(Long homestayId);

    /**
     * 保存房源设施
     *
     * @param homestayId 房源 ID
     * @param facilities 设施列表
     */
    void saveFacilities(Long homestayId, List<HsHomestayFacility> facilities);

    /**
     * 删除房源设施
     *
     * @param homestayId 房源 ID
     */
    void deleteByHomestay(Long homestayId);
}
