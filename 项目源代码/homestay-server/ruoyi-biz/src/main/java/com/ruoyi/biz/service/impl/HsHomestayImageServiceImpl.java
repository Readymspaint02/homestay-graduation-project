package com.ruoyi.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.biz.domain.hs.HsHomestayImage;
import com.ruoyi.biz.mapper.HsHomestayImageMapper;
import com.ruoyi.biz.service.IHsHomestayImageService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 房源图片 Service 实现类
 */
@Service
public class HsHomestayImageServiceImpl extends ServiceImpl<HsHomestayImageMapper, HsHomestayImage>
        implements IHsHomestayImageService {

    @Override
    public List<HsHomestayImage> listByHomestay(Long homestayId) {
        LambdaQueryWrapper<HsHomestayImage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(HsHomestayImage::getHomestayId, homestayId);
        wrapper.orderByAsc(HsHomestayImage::getSortOrder);
        return list(wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveImages(Long homestayId, List<HsHomestayImage> images) {
        if (images != null && !images.isEmpty()) {
            for (HsHomestayImage image : images) {
                image.setHomestayId(homestayId);
            }
            saveBatch(images);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteByHomestay(Long homestayId) {
        LambdaQueryWrapper<HsHomestayImage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(HsHomestayImage::getHomestayId, homestayId);
        remove(wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void setCover(Long imageId) {
        HsHomestayImage targetImage = getById(imageId);
        if (targetImage == null) {
            return;
        }
        // 先将该房源的所有图片取消封面
        LambdaQueryWrapper<HsHomestayImage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(HsHomestayImage::getHomestayId, targetImage.getHomestayId());
        List<HsHomestayImage> images = list(wrapper);
        for (HsHomestayImage image : images) {
            image.setIsCover("0");
        }
        updateBatchById(images);
        // 再设置目标图片为封面
        targetImage.setIsCover("1");
        updateById(targetImage);
    }
}
