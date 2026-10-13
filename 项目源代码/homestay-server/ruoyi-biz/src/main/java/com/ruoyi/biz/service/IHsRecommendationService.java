package com.ruoyi.biz.service;

import com.ruoyi.biz.domain.hs.HsHomestay;

import java.util.List;

/**
 * Homestay recommendation service.
 */
public interface IHsRecommendationService {

    /**
     * Get recommended homestays for user (collaborative filtering).
     */
    List<HsHomestay> recommendForUser(Long userId, int limit);

    /**
     * Get similar homestays (item-based CF).
     */
    List<HsHomestay> similarHomestays(Long homestayId, int limit);

    /**
     * Record user behavior for recommendation.
     */
    void recordBehavior(Long userId, Long homestayId, String behaviorType);
}
