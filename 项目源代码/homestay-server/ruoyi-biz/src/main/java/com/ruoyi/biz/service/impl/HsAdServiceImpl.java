package com.ruoyi.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.biz.domain.hs.HsAd;
import com.ruoyi.biz.domain.hs.bo.HsAdBo;
import com.ruoyi.biz.mapper.HsAdMapper;
import com.ruoyi.biz.service.IHsAdService;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * Ad service implementation.
 */
@Service
@RequiredArgsConstructor
public class HsAdServiceImpl implements IHsAdService {

    private final HsAdMapper adMapper;

    @Override
    public IPage<HsAd> list(IPage<HsAd> page, HsAd query) {
        LambdaQueryWrapper<HsAd> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsAd::getDelFlag, "0");
        lqw.eq(StringUtils.isNotBlank(query.getStatus()), HsAd::getStatus, query.getStatus());
        lqw.like(StringUtils.isNotBlank(query.getTitle()), HsAd::getTitle, query.getTitle());
        lqw.orderByAsc(HsAd::getSortOrder);
        return adMapper.selectPage(page, lqw);
    }

    @Override
    public List<HsAd> listActive() {
        LambdaQueryWrapper<HsAd> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsAd::getDelFlag, "0");
        lqw.eq(HsAd::getStatus, "1");
        lqw.orderByAsc(HsAd::getSortOrder);
        return adMapper.selectList(lqw);
    }

    @Override
    public List<HsAd> listActive(String keyword) {
        LambdaQueryWrapper<HsAd> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsAd::getDelFlag, "0");
        lqw.eq(HsAd::getStatus, "1");
        lqw.like(StringUtils.isNotBlank(keyword), HsAd::getTitle, keyword);
        lqw.orderByAsc(HsAd::getSortOrder);
        return adMapper.selectList(lqw);
    }

    @Override
    public HsAd selectById(Long id) {
        return adMapper.selectById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long create(HsAdBo bo) {
        Long userId = SecurityUtils.getUserId();
        HsAd ad = new HsAd();
        ad.setTenantId("000000");
        ad.setTitle(bo.getTitle());
        ad.setImageUrl(bo.getImageUrl());
        ad.setTargetUrl(bo.getTargetUrl());
        ad.setSortOrder(bo.getSortOrder() == null ? 0 : bo.getSortOrder());
        ad.setStatus(bo.getStatus() == null ? "1" : bo.getStatus());
        ad.setRemark(bo.getRemark());
        ad.setDelFlag("0");
        ad.setCreateBy(userId);
        ad.setUpdateBy(userId);
        ad.setCreateTime(new Date());
        ad.setUpdateTime(new Date());

        int rows = adMapper.insert(ad);
        if (rows <= 0) {
            throw new ServiceException("create ad failed");
        }
        return ad.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean update(HsAdBo bo) {
        if (bo.getId() == null) {
            throw new ServiceException("id required");
        }
        HsAd existed = adMapper.selectById(bo.getId());
        if (existed == null) {
            throw new ServiceException("ad not found");
        }

        Long userId = SecurityUtils.getUserId();
        existed.setTitle(bo.getTitle());
        existed.setImageUrl(bo.getImageUrl());
        existed.setTargetUrl(bo.getTargetUrl());
        if (bo.getSortOrder() != null) {
            existed.setSortOrder(bo.getSortOrder());
        }
        if (bo.getStatus() != null) {
            existed.setStatus(bo.getStatus());
        }
        existed.setRemark(bo.getRemark());
        existed.setUpdateBy(userId);
        existed.setUpdateTime(new Date());

        int rows = adMapper.updateById(existed);
        return rows > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean delete(Long id) {
        HsAd existed = adMapper.selectById(id);
        if (existed == null) {
            throw new ServiceException("ad not found");
        }

        existed.setDelFlag("1");
        existed.setUpdateTime(new Date());
        int rows = adMapper.updateById(existed);
        return rows > 0;
    }
}
