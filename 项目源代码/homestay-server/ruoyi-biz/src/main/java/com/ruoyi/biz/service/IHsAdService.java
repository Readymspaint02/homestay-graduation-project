package com.ruoyi.biz.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.biz.domain.hs.HsAd;
import com.ruoyi.biz.domain.hs.bo.HsAdBo;

import java.util.List;

/**
 * Ad service.
 */
public interface IHsAdService {

    IPage<HsAd> list(IPage<HsAd> page, HsAd query);

    List<HsAd> listActive();

    List<HsAd> listActive(String keyword);

    HsAd selectById(Long id);

    Long create(HsAdBo bo);

    boolean update(HsAdBo bo);

    boolean delete(Long id);
}
