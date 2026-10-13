package com.ruoyi.biz.service;

import java.util.List;
import java.util.Map;

/**
 * Favorite service.
 */
public interface IHsFavoriteService {

    List<Map<String, Object>> listFavorites(Long requestUserId);

    boolean addFavorite(Long homestayId);

    boolean removeFavorite(Long homestayId);

    boolean isFavorited(Long userId, Long homestayId);
}
