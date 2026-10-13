package com.ruoyi.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.domain.hs.HsOrder;
import com.ruoyi.biz.domain.hs.HsReview;
import com.ruoyi.biz.domain.hs.HsStatusConstants;
import com.ruoyi.biz.domain.hs.vo.HsReviewWithHomestayVo;
import com.ruoyi.biz.domain.hs.bo.HsReviewCreateBo;
import com.ruoyi.biz.mapper.HsHomestayMapper;
import com.ruoyi.biz.mapper.HsOrderMapper;
import com.ruoyi.biz.mapper.HsReviewMapper;
import com.ruoyi.biz.service.IHsReviewService;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Review service implementation.
 */
@Service
@RequiredArgsConstructor
public class HsReviewServiceImpl implements IHsReviewService {

    private final HsReviewMapper reviewMapper;
    private final HsOrderMapper orderMapper;
    private final HsHomestayMapper homestayMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean createReview(HsReviewCreateBo bo) {
        Long userId = SecurityUtils.getUserId();
        HsOrder order = orderMapper.selectById(bo.getOrderId());
        if (order == null) {
            throw new ServiceException("order not found");
        }
        if (!userId.equals(order.getTenantUserId())) {
            throw new ServiceException("you can only review your own order");
        }
        if (!HsStatusConstants.ORDER_CONFIRMED.equals(order.getOrderStatus())
            && !HsStatusConstants.ORDER_FINISHED.equals(order.getOrderStatus())
            && !HsStatusConstants.ORDER_CHECKED_IN.equals(order.getOrderStatus())) {
            throw new ServiceException("current order status cannot be reviewed");
        }

        HsReview existed = reviewMapper.selectOne(
            Wrappers.<HsReview>lambdaQuery().eq(HsReview::getOrderId, bo.getOrderId())
        );
        if (existed != null) {
            throw new ServiceException("order has already been reviewed");
        }

        HsReview review = new HsReview();
        review.setTenantId(order.getTenantId());
        review.setOrderId(order.getId());
        review.setHomestayId(order.getHomestayId());
        review.setTenantUserId(userId);
        review.setRating(bo.getRating());
        review.setContent(bo.getContent());
        review.setIsAnonymous(bo.getIsAnonymous() == null ? "0" : bo.getIsAnonymous());
        int rows = reviewMapper.insert(review);
        if (rows <= 0) {
            throw new ServiceException("create review failed");
        }

        refreshHomestayRating(order.getHomestayId());
        return true;
    }

    @Override
    public List<HsReview> listByHomestay(Long homestayId) {
        LambdaQueryWrapper<HsReview> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsReview::getHomestayId, homestayId);
        lqw.orderByDesc(HsReview::getCreateTime);
        return reviewMapper.selectList(lqw);
    }

    @Override
    public List<HsReview> listByCurrentUser() {
        Long userId = SecurityUtils.getUserId();
        LambdaQueryWrapper<HsReview> lqw = Wrappers.lambdaQuery();
        lqw.eq(HsReview::getTenantUserId, userId);
        lqw.orderByDesc(HsReview::getCreateTime);
        return reviewMapper.selectList(lqw);
    }

    @Override
    public List<HsReviewWithHomestayVo> listByCurrentUserWithHomestay() {
        List<HsReview> reviews = listByCurrentUser();
        if (reviews.isEmpty()) {
            return new ArrayList<>();
        }

        Set<Long> homestayIds = reviews.stream()
            .map(HsReview::getHomestayId)
            .filter(id -> id != null)
            .collect(Collectors.toSet());

        Map<Long, HsHomestay> homestayMap = Map.of();
        if (!homestayIds.isEmpty()) {
            List<HsHomestay> homestays = homestayMapper.selectBatchIds(homestayIds);
            homestayMap = homestays.stream()
                .collect(Collectors.toMap(HsHomestay::getId, h -> h));
        }

        final Map<Long, HsHomestay> finalHomestayMap = homestayMap;
        return reviews.stream()
            .map(review -> {
                HsHomestay homestay = finalHomestayMap.get(review.getHomestayId());
                String title = homestay != null ? homestay.getTitle() : null;
                String cover = homestay != null ? homestay.getCoverImage() : null;
                return HsReviewWithHomestayVo.from(review, title, cover);
            })
            .collect(Collectors.toList());
    }

    private void refreshHomestayRating(Long homestayId) {
        List<HsReview> rows = reviewMapper.selectList(
            Wrappers.<HsReview>lambdaQuery().eq(HsReview::getHomestayId, homestayId)
        );
        if (rows.isEmpty()) {
            return;
        }

        BigDecimal sum = BigDecimal.ZERO;
        for (HsReview row : rows) {
            sum = sum.add(BigDecimal.valueOf(row.getRating()));
        }
        BigDecimal avg = sum.divide(BigDecimal.valueOf(rows.size()), 2, RoundingMode.HALF_UP);

        HsHomestay homestay = new HsHomestay();
        homestay.setId(homestayId);
        homestay.setRatingAvg(avg);
        homestay.setRatingCount(rows.size());
        homestayMapper.updateById(homestay);
    }
}
