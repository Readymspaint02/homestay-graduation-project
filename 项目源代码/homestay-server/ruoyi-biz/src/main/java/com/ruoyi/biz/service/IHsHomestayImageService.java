package com.ruoyi.biz.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ruoyi.biz.domain.hs.HsHomestayImage;

import java.util.List;

/**
 * 房源图片 Service 接口
 */
public interface IHsHomestayImageService extends IService<HsHomestayImage> {

    /**
     * 获取房源图片列表
     *
     * @param homestayId 房源 ID
     * @return 图片列表
     */
    List<HsHomestayImage> listByHomestay(Long homestayId);

    /**
     * 保存房源图片
     *
     * @param homestayId 房源 ID
     * @param images     图片列表
     */
    void saveImages(Long homestayId, List<HsHomestayImage> images);

    /**
     * 删除房源图片
     *
     * @param homestayId 房源 ID
     */
    void deleteByHomestay(Long homestayId);

    /**
     * 设置封面图片
     *
     * @param imageId 图片 ID
     */
    void setCover(Long imageId);
}
