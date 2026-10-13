package com.ruoyi.biz.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.domain.hs.bo.HsHomestayAuditBo;
import com.ruoyi.biz.domain.hs.bo.HsHomestayCreateBo;
import com.ruoyi.biz.domain.hs.bo.HsHomestayDetailBO;

import java.math.BigDecimal;

/**
 * Homestay service.
 */
public interface IHsHomestayService {

    /**
     * 分页查询房源
     */
    IPage<HsHomestay> selectPage(HsHomestay query, BigDecimal minPrice, BigDecimal maxPrice, String keyword, Long classificationId, Long tagId, String sort, Page<HsHomestay> page);

    /**
     * 根据 ID 查询房源
     */
    HsHomestay selectById(Long id);

    /**
     * 创建房源
     */
    Long create(HsHomestayCreateBo bo);

    /**
     * 审核房源
     */
    boolean audit(HsHomestayAuditBo bo);

    /**
     * 更新房源
     */
    boolean update(HsHomestayCreateBo bo);

    /**
     * 房东房源列表
     *
     * @param userId 房东用户 ID
     * @param auditStatus 审核状态
     * @param publishStatus 上架状态
     * @param title 房源名称
     * @param page 分页
     * @return 房源列表
     */
    IPage<HsHomestay> landlordList(Long userId, String auditStatus, String publishStatus, String title, Page<HsHomestay> page);

    /**
     * 管理员房源审核列表（查看所有房东的房源）
     *
     * @param auditStatus 审核状态
     * @param publishStatus 上架状态
     * @param title 房源名称
     * @param page 分页
     * @return 房源列表
     */
    IPage<HsHomestay> adminList(String auditStatus, String publishStatus, String title, Page<HsHomestay> page);

    /**
     * 上架房源
     */
    boolean publish(Long id);

    /**
     * 下架房源
     */
    boolean offline(Long id);

    /**
     * 删除房源
     */
    boolean delete(Long id);

    /**
     * 获取房源详情（含设施和图片）
     */
    com.ruoyi.biz.domain.hs.bo.HsHomestayDetailBO getDetail(Long id);
}
