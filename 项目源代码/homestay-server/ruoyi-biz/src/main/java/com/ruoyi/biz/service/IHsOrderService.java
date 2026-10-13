package com.ruoyi.biz.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.biz.domain.hs.HsOrder;
import com.ruoyi.biz.domain.hs.bo.HsOrderActionBo;
import com.ruoyi.biz.domain.hs.bo.HsOrderCreateBo;

/**
 * Order service.
 */
public interface IHsOrderService {

    /**
     * 创建订单
     */
    HsOrder createOrder(HsOrderCreateBo bo);

    /**
     * 取消订单
     */
    boolean cancelOrder(HsOrderActionBo bo);

    /**
     * 确认订单
     */
    boolean confirmOrder(HsOrderActionBo bo);

    /**
     * 拒绝订单
     */
    boolean rejectOrder(HsOrderActionBo bo);

    /**
     * 办理入住
     */
    boolean checkinOrder(HsOrderActionBo bo);

    /**
     * 办理退房
     */
    boolean checkoutOrder(HsOrderActionBo bo);

    /**
     * 模拟支付
     */
    boolean mockPay(HsOrderActionBo bo);

    /**
     * 我的订单（租客/房东）
     */
    IPage<HsOrder> myOrders(String roleType, String orderStatus, String payStatus, String orderNo, Page<HsOrder> page);

    /**
     * 房东订单列表
     *
     * @param userId 房东用户 ID
     * @param orderStatus 订单状态
     * @param checkinDate 入住日期
     * @param homestayName 房源名称
     * @param page 分页
     * @return 订单列表
     */
    IPage<HsOrder> landlordList(Long userId, String orderStatus, String checkinDate, String homestayName, Page<HsOrder> page);

    /**
     * 房东接受订单
     *
     * @param orderId 订单 ID
     * @return 是否成功
     */
    boolean acceptOrder(Long orderId);

    /**
     * 获取订单监控统计数据
     */
    java.util.Map<String, Object> getMonitorStats();

    /**
     * 获取待支付订单列表
     */
    IPage<HsOrder> getUnpaidOrders(Page<HsOrder> page);

    /**
     * 获取已支付待确认订单列表
     */
    IPage<HsOrder> getPaidOrders(Page<HsOrder> page);

    /**
     * 获取已关闭订单列表
     */
    IPage<HsOrder> getClosedOrders(Page<HsOrder> page);

    /**
     * 取消超时订单（定时任务调用）
     * @param orderId 订单ID
     * @param reason 取消原因
     * @return 是否成功
     */
    boolean cancelTimeoutOrder(Long orderId, String reason);
}
