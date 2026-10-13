package com.ruoyi.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.domain.hs.HsHomestayFacility;
import com.ruoyi.biz.domain.hs.HsHomestayImage;
import com.ruoyi.biz.domain.hs.HsRoomCalendar;
import com.ruoyi.biz.domain.hs.HsStatusConstants;
import com.ruoyi.biz.domain.hs.bo.HsHomestayAuditBo;
import com.ruoyi.biz.domain.hs.bo.HsHomestayCreateBo;
import com.ruoyi.biz.domain.hs.bo.HsHomestayDetailBO;
import com.ruoyi.biz.mapper.HsHomestayMapper;
import com.ruoyi.biz.mapper.HsRoomCalendarMapper;
import com.ruoyi.biz.service.HsCacheService;
import com.ruoyi.biz.service.IHsHomestayFacilityService;
import com.ruoyi.biz.service.IHsHomestayImageService;
import com.ruoyi.biz.service.IHsHomestayService;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Homestay service implementation.
 * 
 * 【面试知识点 -Redis 缓存篇】
 * 1. 缓存穿透：查询不存在的房源时缓存 null 值
 * 2. 缓存击穿：热点房源使用互斥锁
 * 3. 缓存雪崩：缓存过期时间添加随机值
 * 4. 双写一致性：更新数据库时删除缓存
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class HsHomestayServiceImpl implements IHsHomestayService {

    private final HsHomestayMapper homestayMapper;
    private final HsRoomCalendarMapper roomCalendarMapper;
    private final IHsHomestayFacilityService facilityService;
    private final IHsHomestayImageService imageService;
    private final HsCacheService cacheService;

    @Override
    public IPage<HsHomestay> selectPage(HsHomestay query, BigDecimal minPrice, BigDecimal maxPrice, String keyword, Long classificationId, Long tagId, String sort, Page<HsHomestay> page) {
        HsHomestay safeQuery = query == null ? new HsHomestay() : query;
        LambdaQueryWrapper<HsHomestay> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsHomestay::getAuditStatus, "1");
        lqw.eq(HsHomestay::getPublishStatus, "1");
        lqw.and(StringUtils.isNotBlank(keyword), wrapper ->
            wrapper.like(HsHomestay::getTitle, keyword).or().like(HsHomestay::getAddress, keyword).or().like(HsHomestay::getCity, keyword));
        lqw.like(StringUtils.isNotBlank(safeQuery.getTitle()), HsHomestay::getTitle, safeQuery.getTitle());
        lqw.eq(StringUtils.isNotBlank(safeQuery.getCity()), HsHomestay::getCity, safeQuery.getCity());
        lqw.eq(safeQuery.getLandlordUserId() != null, HsHomestay::getLandlordUserId, safeQuery.getLandlordUserId());
        lqw.ge(minPrice != null, HsHomestay::getBasePrice, minPrice);
        lqw.le(maxPrice != null, HsHomestay::getBasePrice, maxPrice);
        lqw.eq(classificationId != null && classificationId > 0, HsHomestay::getClassificationId, classificationId);
        if (tagId != null && tagId > 0) {
            lqw.exists("SELECT 1 FROM hs_homestay_tag ht WHERE ht.homestay_id = hs_homestay.id AND ht.tag_id = " + tagId);
        }
        if ("recommend".equals(sort)) {
            lqw.orderByDesc(HsHomestay::getRatingCount);
        } else if ("hot".equals(sort)) {
            lqw.orderByDesc(HsHomestay::getRatingAvg);
        } else {
            lqw.orderByDesc(HsHomestay::getCreateTime);
        }
        return homestayMapper.selectPage(page, lqw);
    }

    @Override
    public HsHomestay selectById(Long id) {
        return homestayMapper.selectById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long create(HsHomestayCreateBo bo) {
        Long userId = SecurityUtils.getUserId();
        HsHomestay homestay = new HsHomestay();
        homestay.setTenantId(getTenantId());
        homestay.setHomestayNo(generateNo("HS"));
        homestay.setLandlordUserId(userId);
        homestay.setTitle(bo.getTitle());
        homestay.setCoverImage(bo.getCoverImage());
        homestay.setDescription(bo.getDescription());
        homestay.setRoomType(bo.getRoomType());
        homestay.setBedroomCount(bo.getBedroomCount());
        homestay.setBedInfo(bo.getBedInfo());
        homestay.setProvince(bo.getProvince());
        homestay.setCity(bo.getCity());
        homestay.setDistrict(bo.getDistrict());
        homestay.setAddress(bo.getAddress());
        homestay.setLongitude(bo.getLongitude());
        homestay.setLatitude(bo.getLatitude());
        homestay.setBasePrice(bo.getBasePrice().setScale(2, RoundingMode.HALF_UP));
        homestay.setWeekendPrice(bo.getWeekendPrice() != null ? bo.getWeekendPrice().setScale(2, RoundingMode.HALF_UP) : null);
        homestay.setCleaningFee(bo.getCleaningFee() != null ? bo.getCleaningFee().setScale(2, RoundingMode.HALF_UP) : null);
        homestay.setDeposit(bo.getDeposit() != null ? bo.getDeposit().setScale(2, RoundingMode.HALF_UP) : null);
        homestay.setMaxGuests(bo.getMaxGuests());
        homestay.setAuditStatus(HsStatusConstants.AUDIT_PENDING);
        homestay.setPublishStatus(HsStatusConstants.PUBLISH_DRAFT);
        homestay.setRatingAvg(new BigDecimal("5.00"));
        homestay.setRatingCount(0);
        homestay.setDelFlag("0");
        homestay.setCreateBy(userId);
        homestay.setUpdateBy(userId);
        homestay.setRemark(bo.getRemark());

        int rows = homestayMapper.insert(homestay);
        if (rows <= 0) {
            throw new ServiceException("create homestay failed");
        }
        initDefaultCalendar(homestay);
        return homestay.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean audit(HsHomestayAuditBo bo) {
        if (!isSuperAdmin()) {
            throw new ServiceException("only admin can audit");
        }

        HsHomestay homestay = homestayMapper.selectById(bo.getId());
        if (homestay == null) {
            throw new ServiceException("homestay not found");
        }

        homestay.setAuditStatus(bo.getAuditStatus());
        if (HsStatusConstants.AUDIT_APPROVED.equals(bo.getAuditStatus())) {
            homestay.setPublishStatus(StringUtils.isBlank(bo.getPublishStatus())
                ? HsStatusConstants.PUBLISH_ONLINE
                : bo.getPublishStatus());
        } else {
            homestay.setPublishStatus(HsStatusConstants.PUBLISH_OFFLINE);
        }
        homestay.setUpdateBy(SecurityUtils.getUserId());
        homestay.setRemark(bo.getRemark());
        return homestayMapper.updateById(homestay) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean update(HsHomestayCreateBo bo) {
        Long userId = SecurityUtils.getUserId();
        HsHomestay homestay = homestayMapper.selectById(bo.getId());
        if (homestay == null) {
            throw new ServiceException("homestay not found");
        }
        if (!homestay.getLandlordUserId().equals(userId)) {
            throw new ServiceException("no permission to update this homestay");
        }

        homestay.setTitle(bo.getTitle());
        homestay.setCoverImage(bo.getCoverImage());
        homestay.setDescription(bo.getDescription());
        homestay.setRoomType(bo.getRoomType());
        homestay.setBedroomCount(bo.getBedroomCount());
        homestay.setBedInfo(bo.getBedInfo());
        homestay.setProvince(bo.getProvince());
        homestay.setCity(bo.getCity());
        homestay.setDistrict(bo.getDistrict());
        homestay.setAddress(bo.getAddress());
        homestay.setLongitude(bo.getLongitude());
        homestay.setLatitude(bo.getLatitude());
        homestay.setBasePrice(bo.getBasePrice().setScale(2, RoundingMode.HALF_UP));
        homestay.setWeekendPrice(bo.getWeekendPrice() != null ? bo.getWeekendPrice().setScale(2, RoundingMode.HALF_UP) : null);
        homestay.setCleaningFee(bo.getCleaningFee() != null ? bo.getCleaningFee().setScale(2, RoundingMode.HALF_UP) : null);
        homestay.setDeposit(bo.getDeposit() != null ? bo.getDeposit().setScale(2, RoundingMode.HALF_UP) : null);
        homestay.setMaxGuests(bo.getMaxGuests());
        // 更新后需要重新审核
        homestay.setAuditStatus(HsStatusConstants.AUDIT_PENDING);
        homestay.setUpdateBy(userId);
        homestay.setRemark(bo.getRemark());

        int rows = homestayMapper.updateById(homestay);
        if (rows <= 0) {
            throw new ServiceException("update homestay failed");
        }

        // 【面试知识点 - 双写一致性】
        // 先删除缓存，再更新数据库 (Cache Aside Pattern)
        // 注意：这里是在事务内删除，保证原子性
        cacheService.deleteHomestayCache(homestay.getId());
        log.info("已删除房源缓存 (双写一致性): id={}", homestay.getId());

        // 更新设施
        if (bo.getFacilities() != null) {
            List<HsHomestayFacility> facilities = new ArrayList<>();
            for (HsHomestayCreateBo.FacilityBO facBo : bo.getFacilities()) {
                HsHomestayFacility facility = new HsHomestayFacility();
                facility.setFacilityCode(facBo.getFacilityCode());
                facility.setFacilityName(facBo.getFacilityName());
                facilities.add(facility);
            }
            facilityService.saveFacilities(homestay.getId(), facilities);
        }

        // 更新图片
        if (bo.getImages() != null) {
            List<HsHomestayImage> images = new ArrayList<>();
            for (HsHomestayCreateBo.ImageBO imgBo : bo.getImages()) {
                HsHomestayImage image = new HsHomestayImage();
                image.setImageUrl(imgBo.getImageUrl());
                image.setSortOrder(imgBo.getSortOrder());
                image.setIsCover(imgBo.getIsCover());
                images.add(image);
            }
            imageService.saveImages(homestay.getId(), images);
        }

        return true;
    }

    @Override
    public IPage<HsHomestay> landlordList(Long userId, String auditStatus, String publishStatus, String title, Page<HsHomestay> page) {
        LambdaQueryWrapper<HsHomestay> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsHomestay::getDelFlag, "0");
        lqw.eq(userId != null, HsHomestay::getLandlordUserId, userId);
        lqw.eq(StringUtils.isNotBlank(auditStatus), HsHomestay::getAuditStatus, auditStatus);
        lqw.eq(StringUtils.isNotBlank(publishStatus), HsHomestay::getPublishStatus, publishStatus);
        lqw.like(StringUtils.isNotBlank(title), HsHomestay::getTitle, title);
        lqw.orderByDesc(HsHomestay::getCreateTime);
        return homestayMapper.selectPage(page, lqw);
    }

    @Override
    public IPage<HsHomestay> adminList(String auditStatus, String publishStatus, String title, Page<HsHomestay> page) {
        LambdaQueryWrapper<HsHomestay> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsHomestay::getDelFlag, "0");
        lqw.eq(StringUtils.isNotBlank(auditStatus), HsHomestay::getAuditStatus, auditStatus);
        lqw.eq(StringUtils.isNotBlank(publishStatus), HsHomestay::getPublishStatus, publishStatus);
        lqw.like(StringUtils.isNotBlank(title), HsHomestay::getTitle, title);
        lqw.orderByDesc(HsHomestay::getCreateTime);
        IPage<HsHomestay> result = homestayMapper.selectPage(page, lqw);
        for (HsHomestay h : result.getRecords()) {
            fillLandlordName(h);
        }
        return result;
    }

    private void fillLandlordName(HsHomestay h) {
        if (h.getLandlordUserId() != null) {
            try {
                com.ruoyi.common.core.domain.entity.SysUser user = 
                    com.ruoyi.common.utils.spring.SpringUtils.getBean(com.ruoyi.system.mapper.SysUserMapper.class)
                        .selectUserById(h.getLandlordUserId());
                if (user != null) {
                    h.setLandlordName(user.getNickName() != null ? user.getNickName() : user.getUserName());
                } else {
                    h.setLandlordName("用户已删除");
                }
            } catch (Exception e) {
                h.setLandlordName("未知");
            }
        } else {
            h.setLandlordName("无房东");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean publish(Long id) {
        HsHomestay homestay = homestayMapper.selectById(id);
        if (homestay == null) {
            throw new ServiceException("homestay not found");
        }
        if (!HsStatusConstants.AUDIT_APPROVED.equals(homestay.getAuditStatus())) {
            throw new ServiceException("homestay not approved yet");
        }
        homestay.setPublishStatus(HsStatusConstants.PUBLISH_ONLINE);
        homestay.setUpdateBy(SecurityUtils.getUserId());
        return homestayMapper.updateById(homestay) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean offline(Long id) {
        HsHomestay homestay = homestayMapper.selectById(id);
        if (homestay == null) {
            throw new ServiceException("homestay not found");
        }
        homestay.setPublishStatus(HsStatusConstants.PUBLISH_OFFLINE);
        homestay.setUpdateBy(SecurityUtils.getUserId());
        return homestayMapper.updateById(homestay) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean delete(Long id) {
        HsHomestay homestay = homestayMapper.selectById(id);
        if (homestay == null) {
            throw new ServiceException("homestay not found");
        }
        // 只能删除草稿或已拒绝的房源
        if (HsStatusConstants.AUDIT_APPROVED.equals(homestay.getAuditStatus())) {
            throw new ServiceException("cannot delete approved homestay, please offline it first");
        }
        homestay.setDelFlag("1");
        homestay.setUpdateBy(SecurityUtils.getUserId());
        return homestayMapper.updateById(homestay) > 0;
    }

    @Override
    public HsHomestayDetailBO getDetail(Long id) {
        long startTime = System.currentTimeMillis();
        
        // 【性能优化 - 先尝试从缓存获取完整BO】
        HsHomestayDetailBO cachedDetail = cacheService.getHomestayDetailBO(id);
        if (cachedDetail != null) {
            log.info("缓存命中(完整BO)，耗时：{}ms, id={}", System.currentTimeMillis() - startTime, id);
            return cachedDetail;
        }
        
        // 检查是否是空对象 (防穿透)
        if (cacheService.isCachedNull(id)) {
            log.info("命中缓存空对象，房源不存在：id={}", id);
            return null;
        }
        
        // 【面试知识点 - 缓存击穿防护】
        // 尝试获取互斥锁
        if (!Boolean.TRUE.equals(cacheService.tryLock(id))) {
            // 未获取到锁，等待后重试读取缓存
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            cachedDetail = cacheService.getHomestayDetailBO(id);
            if (cachedDetail != null) {
                return cachedDetail;
            }
        }
        
        try {
            log.info("缓存未命中，查询数据库：id={}", id);
            
            // 从数据库查询
            HsHomestay homestay = homestayMapper.selectById(id);
            
            if (homestay == null) {
                // 缓存空对象 (防穿透)
                cacheService.cacheNullHomestay(id);
                return null;
            }
            
            // 构建详情对象（包含设施和图片）
            HsHomestayDetailBO detail = buildHomestayDetailBO(homestay);
            
            // 缓存完整的详情BO（带随机 TTL 防雪崩）
            cacheService.cacheHomestayDetailBO(detail);
            
            log.info("已缓存房源详情BO，总耗时：{}ms, id={}", System.currentTimeMillis() - startTime, id);
            
            return detail;
        } finally {
            // 释放互斥锁
            cacheService.releaseLock(id);
        }
    }
    
    /**
     * 构建房源详情 BO(提取公共逻辑)
     */
    private HsHomestayDetailBO buildHomestayDetailBO(HsHomestay homestay) {
        HsHomestayDetailBO detail = new HsHomestayDetailBO();
        detail.setId(homestay.getId());
        detail.setTenantId(homestay.getTenantId());
        detail.setHomestayNo(homestay.getHomestayNo());
        detail.setLandlordUserId(homestay.getLandlordUserId());
        detail.setTitle(homestay.getTitle());
        detail.setDescription(homestay.getDescription());
        detail.setRoomType(homestay.getRoomType());
        detail.setBedroomCount(homestay.getBedroomCount());
        detail.setBedInfo(homestay.getBedInfo());
        detail.setProvince(homestay.getProvince());
        detail.setCity(homestay.getCity());
        detail.setDistrict(homestay.getDistrict());
        detail.setAddress(homestay.getAddress());
        detail.setLongitude(homestay.getLongitude());
        detail.setLatitude(homestay.getLatitude());
        detail.setBasePrice(homestay.getBasePrice());
        detail.setWeekendPrice(homestay.getWeekendPrice());
        detail.setCleaningFee(homestay.getCleaningFee());
        detail.setDeposit(homestay.getDeposit());
        detail.setMaxGuests(homestay.getMaxGuests());
        detail.setAuditStatus(homestay.getAuditStatus());
        detail.setPublishStatus(homestay.getPublishStatus());
        detail.setRatingAvg(homestay.getRatingAvg());
        detail.setRatingCount(homestay.getRatingCount());
        detail.setDelFlag(homestay.getDelFlag());
        detail.setCreateTime(homestay.getCreateTime());
        detail.setUpdateTime(homestay.getUpdateTime());
        detail.setRemark(homestay.getRemark());
        detail.setCoverImage(homestay.getCoverImage());

        // 批量查询设施和图片
        detail.setFacilities(facilityService.listByHomestay(homestay.getId()));
        detail.setImages(imageService.listByHomestay(homestay.getId()));
        return detail;
    }

    private void initDefaultCalendar(HsHomestay homestay) {
        LocalDate today = LocalDate.now();
        for (int i = 0; i < 30; i++) {
            HsRoomCalendar calendar = new HsRoomCalendar();
            calendar.setTenantId(homestay.getTenantId());
            calendar.setHomestayId(homestay.getId());
            calendar.setBizDate(DateUtils.toDate(today.plusDays(i)));
            calendar.setStatus(HsStatusConstants.CAL_AVAILABLE);
            calendar.setPrice(homestay.getBasePrice());
            calendar.setVersion(1);
            roomCalendarMapper.insert(calendar);
        }
    }

    private String getTenantId() {
        Long tenantId = SecurityUtils.getLoginUser().getUser().getTenantId();
        return tenantId == null ? "000000" : String.valueOf(tenantId);
    }

    private boolean isSuperAdmin() {
        Long userId = SecurityUtils.getUserId();
        return SecurityUtils.isAdmin(userId) || SecurityUtils.hasRole(Constants.SUPER_ADMIN);
    }

    private String generateNo(String prefix) {
        int random = ThreadLocalRandom.current().nextInt(100, 1000);
        return prefix + DateUtils.getYYYYMMDDHHMMSSSSS(new Date()) + random;
    }
}
