package com.ruoyi.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.domain.hs.HsUserBehavior;
import com.ruoyi.biz.mapper.HsHomestayMapper;
import com.ruoyi.biz.mapper.HsUserBehaviorMapper;
import com.ruoyi.biz.service.IHsRecommendationService;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Recommendation service implementation (simplified collaborative filtering).
 */
@Service
@RequiredArgsConstructor
public class HsRecommendationServiceImpl implements IHsRecommendationService {

    private final HsUserBehaviorMapper behaviorMapper;
    private final HsHomestayMapper homestayMapper;

    @Override
    public void recordBehavior(Long userId, Long homestayId, String behaviorType) {
        HsUserBehavior behavior = new HsUserBehavior();
        behavior.setTenantId("000000");
        behavior.setUserId(userId);
        behavior.setHomestayId(homestayId);
        behavior.setBehaviorType(behaviorType);
        behavior.setScore(calculateScore(behaviorType));
        behavior.setCreateTime(DateUtils.getNowDate());
        behaviorMapper.insert(behavior);
    }

    @Override
    public List<HsHomestay> recommendForUser(Long userId, int limit) {
        // Step 1: Get user's behavior history
        LambdaQueryWrapper<HsUserBehavior> behaviorLqw = Wrappers.lambdaQuery();
        behaviorLqw.eq(HsUserBehavior::getUserId, userId);
        behaviorLqw.orderByDesc(HsUserBehavior::getCreateTime);
        List<HsUserBehavior> userBehaviors = behaviorMapper.selectList(behaviorLqw);

        if (userBehaviors.isEmpty()) {
            // Cold start: return popular homestays
            return getPopularHomestays(limit);
        }

        // Step 2: Get homestays that user already interacted with
        Set<Long> userHomestayIds = userBehaviors.stream()
                .map(HsUserBehavior::getHomestayId)
                .collect(Collectors.toSet());

        // Step 3: Find similar users (users who liked same homestays)
        LambdaQueryWrapper<HsUserBehavior> similarUserLqw = Wrappers.lambdaQuery();
        similarUserLqw.in(HsUserBehavior::getHomestayId, userHomestayIds);
        similarUserLqw.ne(HsUserBehavior::getUserId, userId);
        similarUserLqw.gt(HsUserBehavior::getScore, 0.5);
        List<HsUserBehavior> similarUserBehaviors = behaviorMapper.selectList(similarUserLqw);

        // Step 4: Score homestays from similar users
        Map<Long, Double> homestayScores = new HashMap<>();
        for (HsUserBehavior behavior : similarUserBehaviors) {
            if (!userHomestayIds.contains(behavior.getHomestayId())) {
                homestayScores.merge(behavior.getHomestayId(), behavior.getScore(), Double::sum);
            }
        }

        // Step 5: Sort and get top N
        List<Long> recommendedIds = homestayScores.entrySet().stream()
                .sorted(Map.Entry.<Long, Double>comparingByValue().reversed())
                .limit(limit)
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());

        if (recommendedIds.isEmpty()) {
            return getPopularHomestays(limit);
        }

        // Step 6: Fetch homestay details
        List<HsHomestay> results = new ArrayList<>();
        for (Long id : recommendedIds) {
            HsHomestay homestay = homestayMapper.selectById(id);
            if (homestay != null && "1".equals(homestay.getAuditStatus()) && "1".equals(homestay.getPublishStatus())) {
                results.add(homestay);
            }
        }

        return results.stream().limit(limit).collect(Collectors.toList());
    }

    @Override
    public List<HsHomestay> similarHomestays(Long homestayId, int limit) {
        HsHomestay target = homestayMapper.selectById(homestayId);
        if (target == null) {
            return Collections.emptyList();
        }

        // Item-based CF: find homestays with similar features
        LambdaQueryWrapper<HsHomestay> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsHomestay::getAuditStatus, "1");
        lqw.eq(HsHomestay::getPublishStatus, "1");
        lqw.ne(HsHomestay::getId, homestayId);
        lqw.eq(HsHomestay::getCity, target.getCity());
        lqw.between(HsHomestay::getBasePrice,
                target.getBasePrice().multiply(new BigDecimal("0.8")),
                target.getBasePrice().multiply(new BigDecimal("1.2")));
        lqw.orderByDesc(HsHomestay::getRatingAvg);
        lqw.last("LIMIT " + limit);

        return homestayMapper.selectList(lqw);
    }

    private Double calculateScore(String behaviorType) {
        switch (behaviorType) {
            case "view":
                return 0.1;
            case "collect":
                return 0.5;
            case "order":
                return 1.0;
            default:
                return 0.1;
        }
    }

    private List<HsHomestay> getPopularHomestays(int limit) {
        LambdaQueryWrapper<HsHomestay> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsHomestay::getAuditStatus, "1");
        lqw.eq(HsHomestay::getPublishStatus, "1");
        lqw.orderByDesc(HsHomestay::getRatingCount);
        lqw.orderByDesc(HsHomestay::getRatingAvg);
        lqw.last("LIMIT " + limit);
        return homestayMapper.selectList(lqw);
    }
}
