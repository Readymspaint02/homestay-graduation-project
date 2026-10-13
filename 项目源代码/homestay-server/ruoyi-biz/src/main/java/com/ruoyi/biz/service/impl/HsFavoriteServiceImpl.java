package com.ruoyi.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.biz.domain.hs.HsFavorite;
import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.mapper.HsFavoriteMapper;
import com.ruoyi.biz.mapper.HsHomestayMapper;
import com.ruoyi.biz.service.IHsFavoriteService;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Favorite service implementation.
 */
@Service
@RequiredArgsConstructor
public class HsFavoriteServiceImpl implements IHsFavoriteService {

    private final HsFavoriteMapper favoriteMapper;
    private final HsHomestayMapper homestayMapper;

    @Override
    public List<Map<String, Object>> listFavorites(Long requestUserId) {
        Long currentUserId = SecurityUtils.getUserId();
        Long targetUserId = resolveTargetUserId(currentUserId, requestUserId);

        LambdaQueryWrapper<HsFavorite> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsFavorite::getTenantId, getTenantId());
        lqw.eq(HsFavorite::getTenantUserId, targetUserId);
        lqw.orderByDesc(HsFavorite::getCreateTime);
        List<HsFavorite> favorites = favoriteMapper.selectList(lqw);
        if (favorites.isEmpty()) {
            return List.of();
        }

        List<Long> homestayIds = favorites.stream()
            .map(HsFavorite::getHomestayId)
            .distinct()
            .collect(Collectors.toList());
        List<HsHomestay> homestays = homestayMapper.selectBatchIds(homestayIds);
        Map<Long, HsHomestay> homestayMap = homestays.stream()
            .collect(Collectors.toMap(HsHomestay::getId, v -> v));

        List<Map<String, Object>> result = new ArrayList<>();
        for (HsFavorite favorite : favorites) {
            HsHomestay homestay = homestayMap.get(favorite.getHomestayId());
            if (homestay == null) {
                continue;
            }
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("id", homestay.getId());
            row.put("favoriteId", favorite.getId());
            row.put("thingId", homestay.getId());
            row.put("title", homestay.getTitle());
            row.put("price", homestay.getBasePrice());
            row.put("city", homestay.getCity());
            row.put("address", homestay.getAddress());
            String cover = homestay.getCoverImage();
            row.put("cover", cover != null ? cover : "/images/demo.jpg");
            result.add(row);
        }
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean addFavorite(Long homestayId) {
        Long userId = SecurityUtils.getUserId();
        if (homestayId == null) {
            throw new ServiceException("thingId cannot be null");
        }
        HsHomestay homestay = homestayMapper.selectById(homestayId);
        if (homestay == null) {
            throw new ServiceException("homestay not found");
        }

        LambdaQueryWrapper<HsFavorite> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsFavorite::getTenantId, getTenantId());
        lqw.eq(HsFavorite::getTenantUserId, userId);
        lqw.eq(HsFavorite::getHomestayId, homestayId);
        if (favoriteMapper.selectCount(lqw) > 0) {
            return true;
        }

        HsFavorite favorite = new HsFavorite();
        favorite.setTenantId(getTenantId());
        favorite.setTenantUserId(userId);
        favorite.setHomestayId(homestayId);
        try {
            return favoriteMapper.insert(favorite) > 0;
        } catch (DuplicateKeyException ignored) {
            return true;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean removeFavorite(Long homestayId) {
        Long userId = SecurityUtils.getUserId();
        if (homestayId == null) {
            throw new ServiceException("id cannot be null");
        }
        LambdaQueryWrapper<HsFavorite> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsFavorite::getTenantId, getTenantId());
        lqw.eq(HsFavorite::getTenantUserId, userId);
        lqw.eq(HsFavorite::getHomestayId, homestayId);
        favoriteMapper.delete(lqw);
        return true;
    }

    private Long resolveTargetUserId(Long currentUserId, Long requestUserId) {
        if (isSuperAdmin() && requestUserId != null) {
            return requestUserId;
        }
        return currentUserId;
    }

    private String getTenantId() {
        Long tenantId = SecurityUtils.getLoginUser().getUser().getTenantId();
        return tenantId == null ? "000000" : String.valueOf(tenantId);
    }

private boolean isSuperAdmin() {
        Long userId = SecurityUtils.getUserId();
        return SecurityUtils.isAdmin(userId) || SecurityUtils.hasRole(Constants.SUPER_ADMIN);
    }

    @Override
    public boolean isFavorited(Long userId, Long homestayId) {
        if (userId == null || homestayId == null) {
            return false;
        }
        LambdaQueryWrapper<HsFavorite> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsFavorite::getTenantUserId, userId);
        lqw.eq(HsFavorite::getHomestayId, homestayId);
        lqw.last("LIMIT 1");
        return favoriteMapper.selectCount(lqw) > 0;
    }
}
