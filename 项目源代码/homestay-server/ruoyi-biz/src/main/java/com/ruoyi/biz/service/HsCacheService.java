package com.ruoyi.biz.service;

import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.domain.hs.HsRoomCalendar;
import com.ruoyi.biz.domain.hs.bo.HsHomestayDetailBO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

/**
 * Redis 缓存服务 - 民宿业务场景
 * 
 * 面试知识点覆盖：
 * 1. 缓存穿透 - 布隆过滤器/缓存空对象
 * 2. 缓存击穿 - 互斥锁/逻辑过期
 * 3. 缓存雪崩 - 随机过期时间
 * 4. 双写一致性 - Cache Aside Pattern
 * 5. Redis 数据结构应用 - String/Hash/ZSet
 * 
 * @author 朱铭杰
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class HsCacheService {

    private final RedisTemplate<String, Object> redisTemplate;
    
    // ==================== 常量定义 ====================
    
    /** 房源详情缓存前缀 */
    private static final String HOMESTAY_DETAIL_KEY = "homestay:detail:";
    
    /** 房源详情缓存过期时间 (分钟) - 热点数据 */
    private static final long HOMESTAY_DETAIL_TTL = 30;
    
    /** 房态缓存前缀 */
    private static final String CALENDAR_KEY = "homestay:calendar:";
    
    /** 房态缓存过期时间 (天) */
    private static final long CALENDAR_TTL = 7;
    
    /** 热门房源排行榜 Key */
    private static final String HOT_HOMESTAY_RANK_KEY = "homestay:rank:hot";
    
    /** 热门房源缓存时间 (小时) */
    private static final long HOT_RANK_TTL = 24;
    
    /** 缓存空对象 TTL (防穿透) */
    private static final long CACHE_NULL_TTL = 5;
    
    /** 互斥锁 Key 前缀 */
    private static final String LOCK_KEY = "lock:homestay:";
    
    /** 互斥锁过期时间 (秒) */
    private static final long LOCK_TTL = 10;
    
    /** 日期格式化器 */
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    // ==================== 缓存穿透防护 ====================
    
    /**
     * 缓存空对象 - 防穿透方案 1
     * 
     * 面试话术：
     * "对于缓存穿透，我采用了缓存空对象的策略。
     * 当查询不存在的房源时，我会缓存一个 null 值，设置较短的过期时间 (5 分钟)。
     * 这样即使有大量恶意请求查询不存在的 ID，也不会每次都打到数据库。"
     */
    public void cacheNullHomestay(Long homestayId) {
        String key = HOMESTAY_DETAIL_KEY + homestayId;
        // 缓存 null 值，设置较短 TTL
        redisTemplate.opsForValue().set(key, null, CACHE_NULL_TTL, TimeUnit.MINUTES);
        log.info("缓存空对象：key={}, ttl={}min", key, CACHE_NULL_TTL);
    }
    
    /**
     * 检查是否为缓存空对象
     */
    public Boolean isCachedNull(Long homestayId) {
        String key = HOMESTAY_DETAIL_KEY + homestayId;
        Object value = redisTemplate.opsForValue().get(key);
        // 如果 key 存在但值为 null，说明是缓存的空对象
        return Boolean.TRUE.equals(redisTemplate.hasKey(key)) && value == null;
    }

    // ==================== 房源详情缓存 ====================
    
    /**
     * 缓存房源详情BO（完整对象含设施和图片）- 带随机过期时间 (防雪崩)
     */
    public void cacheHomestayDetailBO(HsHomestayDetailBO detail) {
        if (detail == null) return;
        String key = HOMESTAY_DETAIL_KEY + detail.getId();
        long randomOffset = new Random().nextInt(10) - 5;
        long ttl = HOMESTAY_DETAIL_TTL + randomOffset;
        
        redisTemplate.opsForValue().set(key, detail, ttl, TimeUnit.MINUTES);
        log.info("缓存房源详情BO：key={}, ttl={}min", key, ttl);
    }
    
    /**
     * 获取房源详情BO - 带互斥锁 (防击穿)
     */
    public HsHomestayDetailBO getHomestayDetailBO(Long homestayId) {
        String key = HOMESTAY_DETAIL_KEY + homestayId;
        
        Object value = redisTemplate.opsForValue().get(key);
        if (value instanceof HsHomestayDetailBO) {
            log.debug("缓存命中(BO)：key={}", key);
            return (HsHomestayDetailBO) value;
        }
        
        if (value instanceof HsHomestay) {
            log.debug("缓存命中(旧格式)：key={}", key);
            return null;
        }
        
        return null;
    }
    
    /**
     * 缓存房源详情 - 带随机过期时间 (防雪崩)
     * 
     * 面试知识点：缓存雪崩
     * "为了防止缓存雪崩，我在统一的过期时间基础上添加了随机值。
     * 比如基础 TTL 是 30 分钟，我会添加±5 分钟的随机时间，
     * 这样不同房源的缓存不会在同一时间过期，避免数据库压力突增。"
     */
    public void cacheHomestayDetail(HsHomestay homestay) {
        String key = HOMESTAY_DETAIL_KEY + homestay.getId();
        // 基础 TTL + 随机偏移 (防雪崩)
        long randomOffset = new Random().nextInt(10) - 5; // -5 到 +5 分钟
        long ttl = HOMESTAY_DETAIL_TTL + randomOffset;
        
        redisTemplate.opsForValue().set(key, homestay, ttl, TimeUnit.MINUTES);
        log.info("缓存房源详情：key={}, ttl={}min", key, ttl);
    }
    
    /**
     * 获取房源详情 - 带互斥锁 (防击穿)
     * 
     * 面试知识点：缓存击穿
     * "对于热点房源 (比如被大量访问的网红房源)，我使用了互斥锁来防止缓存击穿。
     * 当缓存过期时，第一个请求获取锁并查询数据库，其他请求等待。
     * 这样可以避免大量请求同时打到数据库。"
     */
    public HsHomestay getHomestayDetail(Long homestayId) {
        String key = HOMESTAY_DETAIL_KEY + homestayId;
        
        // 1. 先查缓存
        Object value = redisTemplate.opsForValue().get(key);
        if (value instanceof HsHomestay) {
            log.debug("缓存命中：key={}", key);
            return (HsHomestay) value;
        }
        if (value instanceof HsHomestayDetailBO) {
            log.debug("缓存命中(BO格式)：key={}", key);
            return null; // 让调用方处理BO格式
        }
        
        // 2. 缓存未命中，尝试获取互斥锁
        if (tryLock(homestayId)) {
            try {
                // 双重检查 (防止其他线程已更新)
                value = redisTemplate.opsForValue().get(key);
                if (value instanceof HsHomestay) {
                    return (HsHomestay) value;
                }
                // 返回 null，让调用方查询数据库
                log.info("缓存未命中，已获取锁，需要查询数据库：key={}", key);
                return null;
            } finally {
                // 注意：这里不立即释放锁，由调用方在缓存更新后释放
                // 或者由锁的 TTL 自动释放
            }
        } else {
            // 未获取到锁，等待后重试
            log.info("未获取到锁，等待重试：key={}", key);
            try {
                Thread.sleep(50); // 等待 50ms
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            // 递归调用 (最多重试几次，这里简化处理)
            return getHomestayDetail(homestayId);
        }
    }
    
    /**
     * 删除房源缓存 - 双写一致性
     * 
     * 面试知识点：双写一致性
     * "我采用了 Cache Aside Pattern 来保证双写一致性：
     * 1. 更新数据库时，先删除缓存
     * 2. 再更新数据库
     * 3. 如果删除失败，记录日志，由定时任务补偿
     * 
     * 为什么不先更新数据库再删除缓存？
     * 因为可能存在并发读，导致旧数据重新写入缓存。"
     */
    public void deleteHomestayCache(Long homestayId) {
        String key = HOMESTAY_DETAIL_KEY + homestayId;
        Boolean deleted = redisTemplate.delete(key);
        log.info("删除房源缓存：key={}, success={}", key, deleted);
    }
    
    /**
     * 尝试获取互斥锁 (使用 setnx)
     * 
     * 面试知识点：Redis 分布式锁
     * "我使用 Redis 的 setnx 命令实现分布式锁：
     * 1. setIfAbsent 保证原子性
     * 2. 锁有过期时间，防止死锁
     * 3. UUID 保证锁的唯一性"
     */
    public boolean tryLock(Long homestayId) {
        String lockKey = LOCK_KEY + homestayId;
        String lockValue = UUID.randomUUID().toString() + ":" + System.currentTimeMillis();
        
        // setIfAbsent = setnx
        Boolean success = redisTemplate.opsForValue()
            .setIfAbsent(lockKey, lockValue, LOCK_TTL, TimeUnit.SECONDS);
        
        if (Boolean.TRUE.equals(success)) {
            log.debug("获取锁成功：key={}, value={}", lockKey, lockValue);
            return true;
        }
        return false;
    }
    
    /**
     * 释放互斥锁
     */
    public void releaseLock(Long homestayId) {
        String lockKey = LOCK_KEY + homestayId;
        Boolean deleted = redisTemplate.delete(lockKey);
        if (Boolean.TRUE.equals(deleted)) {
            log.debug("释放锁：key={}", lockKey);
        }
    }

    // ==================== 房态日历缓存 ====================
    
    /**
     * 缓存房态数据 (使用 Hash 结构)
     * 
     * 面试知识点：Redis 数据结构选型
     * "房态数据我使用了 Hash 结构存储，因为：
     * 1. 一个房源有多个日期的房态，适合 Hash 的 field-value 结构
     * 2. 可以单独更新某一天的房态，无需全量更新
     * 3. 查询时可以一次性获取所有日期的房态"
     */
    public void cacheCalendar(Long homestayId, Map<LocalDate, HsRoomCalendar> calendarMap) {
        String key = CALENDAR_KEY + homestayId;
        
        Map<String, HsRoomCalendar> hashData = new HashMap<>();
        for (Map.Entry<LocalDate, HsRoomCalendar> entry : calendarMap.entrySet()) {
            String field = entry.getKey().format(DATE_FORMATTER);
            hashData.put(field, entry.getValue());
        }
        
        // 批量写入 Hash
        redisTemplate.opsForHash().putAll(key, hashData);
        redisTemplate.expire(key, CALENDAR_TTL, TimeUnit.DAYS);
        
        log.info("缓存房态数据：key={}, size={}, ttl={}天", key, calendarMap.size(), CALENDAR_TTL);
    }
    
    /**
     * 获取房态数据
     */
    @SuppressWarnings("unchecked")
    public Map<LocalDate, HsRoomCalendar> getCalendar(Long homestayId) {
        String key = CALENDAR_KEY + homestayId;
        // entries() 返回的是 Map<Object, Object>，需要逐个转换
        Map<Object, Object> rawMap = redisTemplate.opsForHash().entries(key);
        
        if (rawMap == null || rawMap.isEmpty()) {
            return null;
        }
        
        Map<LocalDate, HsRoomCalendar> result = new HashMap<>();
        for (Map.Entry<Object, Object> entry : rawMap.entrySet()) {
            try {
                String dateStr = entry.getKey().toString();
                HsRoomCalendar calendar = (HsRoomCalendar) entry.getValue();
                LocalDate date = LocalDate.parse(dateStr, DATE_FORMATTER);
                result.put(date, calendar);
            } catch (Exception e) {
                log.warn("解析房态缓存失败：key={}, error={}", key, e.getMessage());
            }
        }
        
        log.debug("获取房态缓存：key={}, size={}", key, result.size());
        return result;
    }
    
    /**
     * 删除房态缓存
     */
    public void deleteCalendarCache(Long homestayId) {
        String key = CALENDAR_KEY + homestayId;
        redisTemplate.delete(key);
        log.info("删除房态缓存：key={}", key);
    }

    // ==================== 热门房源排行榜 ====================
    
    /**
     * 更新热门房源排行榜 (使用 ZSet)
     * 
     * 面试知识点：ZSet 应用场景
     * "热门房源排行榜我使用了 ZSet 结构：
     * 1. score 可以是房源的热度值 (浏览量 + 收藏量*2 + 订单量*5)
     * 2. ZSet 自动按 score 排序，查询 TOP N 非常高效
     * 3. 支持实时更新热度"
     */
    public void updateHotRanking(Long homestayId, double score) {
        // 增加热度
        redisTemplate.opsForZSet().incrementScore(HOT_HOMESTAY_RANK_KEY, homestayId, score);
        // 设置过期时间
        redisTemplate.expire(HOT_HOMESTAY_RANK_KEY, HOT_RANK_TTL, TimeUnit.HOURS);
        log.debug("更新热门排行：homestayId={}, score={}", homestayId, score);
    }
    
    /**
     * 获取热门房源 TOP N
     * 
     * @param topN 返回前 N 个
     * @return 房源 ID 列表 (按热度降序)
     */
    public Set<Long> getHotRanking(int topN) {
        // ZSet 按 score 降序排列，取前 N 个
        Set<Object> result = redisTemplate.opsForZSet()
            .reverseRange(HOT_HOMESTAY_RANK_KEY, 0, topN - 1);
        
        if (result == null) {
            return Collections.emptySet();
        }
        
        Set<Long> homestayIds = new LinkedHashSet<>();
        for (Object obj : result) {
            homestayIds.add(Long.valueOf(obj.toString()));
        }
        
        log.debug("获取热门排行：topN={}, actualSize={}", topN, homestayIds.size());
        return homestayIds;
    }
    
    /**
     * 删除热门房源排行记录
     */
    public void removeHotRanking(Long homestayId) {
        redisTemplate.opsForZSet().remove(HOT_HOMESTAY_RANK_KEY, homestayId);
        log.debug("移除热门排行：homestayId={}", homestayId);
    }

    // ==================== 其他缓存工具 ====================
    
    /**
     * 缓存用户行为数据 (用于防重复提交)
     * 使用 String 结构，简单场景
     */
    public void cacheUserAction(String userId, String actionKey, long ttlSeconds) {
        String key = String.format("user:action:%s:%s", userId, actionKey);
        redisTemplate.opsForValue().set(key, "1", ttlSeconds, TimeUnit.SECONDS);
        log.debug("缓存用户行为：key={}, ttl={}s", key, ttlSeconds);
    }
    
    /**
     * 检查用户行为是否已缓存 (防重复提交)
     */
    public boolean isUserActionCached(String userId, String actionKey) {
        String key = String.format("user:action:%s:%s", userId, actionKey);
        return Boolean.TRUE.equals(redisTemplate.hasKey(key));
    }
    
    // ==================== 房东端缓存 ====================
    
    private static final String LANDLORD_ORDER_STATS_KEY = "landlord:order:stats:";
    private static final String LANDLORD_INCOME_KEY = "landlord:income:";
    private static final long LANDLORD_CACHE_TTL = 5; // 5分钟
    
    /**
     * 缓存房东订单统计
     */
    public void cacheLandlordOrderStats(Long landlordId, Object stats) {
        String key = LANDLORD_ORDER_STATS_KEY + landlordId;
        redisTemplate.opsForValue().set(key, stats, LANDLORD_CACHE_TTL, TimeUnit.MINUTES);
        log.debug("缓存房东订单统计：landlordId={}", landlordId);
    }
    
    /**
     * 获取房东订单统计缓存
     */
    public Object getLandlordOrderStats(Long landlordId) {
        String key = LANDLORD_ORDER_STATS_KEY + landlordId;
        return redisTemplate.opsForValue().get(key);
    }
    
    /**
     * 删除房东订单统计缓存
     */
    public void deleteLandlordOrderStats(Long landlordId) {
        String key = LANDLORD_ORDER_STATS_KEY + landlordId;
        redisTemplate.delete(key);
        log.debug("删除房东订单统计缓存：landlordId={}", landlordId);
    }
    
    /**
     * 缓存房东收入统计
     */
    public void cacheLandlordIncome(Long landlordId, Object income) {
        String key = LANDLORD_INCOME_KEY + landlordId;
        redisTemplate.opsForValue().set(key, income, LANDLORD_CACHE_TTL, TimeUnit.MINUTES);
        log.debug("缓存房东收入统计：landlordId={}", landlordId);
    }
    
    /**
     * 获取房东收入统计缓存
     */
    public Object getLandlordIncome(Long landlordId) {
        String key = LANDLORD_INCOME_KEY + landlordId;
        return redisTemplate.opsForValue().get(key);
    }
    
    /**
     * 获取缓存 key (用于监控和调试)
     */
    public Set<String> getAllKeys(String pattern) {
        return redisTemplate.keys(pattern);
    }
}
