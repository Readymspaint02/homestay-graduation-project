package com.ruoyi.biz.controller.homestay;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ruoyi.biz.domain.hs.HsOrder;
import com.ruoyi.biz.domain.hs.bo.HsOrderActionBo;
import com.ruoyi.biz.domain.hs.bo.HsOrderCreateBo;
import com.ruoyi.biz.service.IHsOrderService;
import com.ruoyi.biz.service.impl.HsAlipayService;
import com.ruoyi.biz.service.impl.MessageSseService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.framework.web.service.TokenService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.MediaType;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Order APIs.
 */
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/order")
public class HsOrderController extends BaseController {

    private final IHsOrderService orderService;
    private final HsAlipayService alipayService;
    private final MessageSseService messageSseService;
    private final TokenService tokenService;

    /**
     * 创建订单
     */
    @PostMapping("/create")
    public AjaxResult create(@Valid @RequestBody HsOrderCreateBo bo) {
        return success(orderService.createOrder(bo));
    }

    /**
     * 取消订单
     */
    @Log(title = "订单管理", businessType = BusinessType.UPDATE)
    @PostMapping("/cancel")
    public AjaxResult cancel(@Valid @RequestBody HsOrderActionBo bo) {
        return toAjax(orderService.cancelOrder(bo));
    }

    /**
     * 确认订单（租客确认）
     */
    @Log(title = "订单管理", businessType = BusinessType.UPDATE)
    @PostMapping("/confirm")
    public AjaxResult confirm(@Valid @RequestBody HsOrderActionBo bo) {
        return toAjax(orderService.confirmOrder(bo));
    }

    /**
     * 拒绝订单
     */
    @Log(title = "订单管理", businessType = BusinessType.UPDATE)
    @PostMapping("/reject")
    public AjaxResult reject(@Valid @RequestBody HsOrderActionBo bo) {
        return toAjax(orderService.rejectOrder(bo));
    }

    /**
     * 办理入住
     */
    @Log(title = "订单管理", businessType = BusinessType.UPDATE)
    @PostMapping("/checkin")
    public AjaxResult checkin(@Valid @RequestBody HsOrderActionBo bo) {
        return toAjax(orderService.checkinOrder(bo));
    }

    /**
     * 办理退房
     */
    @Log(title = "订单管理", businessType = BusinessType.UPDATE)
    @PostMapping("/checkout")
    public AjaxResult checkout(@Valid @RequestBody HsOrderActionBo bo) {
        return toAjax(orderService.checkoutOrder(bo));
    }

    /**
     * 模拟支付
     */
    @Log(title = "订单管理", businessType = BusinessType.UPDATE)
    @PostMapping("/pay/mock")
    public AjaxResult payMock(@Valid @RequestBody HsOrderActionBo bo) {
        return toAjax(orderService.mockPay(bo));
    }

    /**
     * 我的订单（租客/房东）
     */
    @GetMapping("/my")
    public TableDataInfo myOrders(@RequestParam(required = false) String roleType,
                                  @RequestParam(required = false) String orderStatus,
                                  @RequestParam(required = false) String payStatus,
                                  @RequestParam(required = false) String orderNo) {
        IPage<HsOrder> page = orderService.myOrders(roleType, orderStatus, payStatus, orderNo, getPage());
        return getDataTableByPage(page);
    }

    /**
     * 房东订单列表
     */
    @GetMapping("/landlord/list")
    public TableDataInfo landlordList(@RequestParam(required = false) String orderStatus,
                                       @RequestParam(required = false) String checkinDate,
                                       @RequestParam(required = false) String homestayName) {
        Long userId = SecurityUtils.getUserId();
        IPage<HsOrder> page = orderService.landlordList(userId, orderStatus, checkinDate, homestayName, getPage());
        return getDataTableByPage(page);
    }

    /**
     * 房东接受订单
     */
    @Log(title = "订单管理", businessType = BusinessType.UPDATE)
    @PostMapping("/{id}/accept")
    public AjaxResult accept(@PathVariable Long id) {
        return toAjax(orderService.acceptOrder(id));
    }

    // ========== 支付宝沙箱支付 ==========

    @PostMapping("/pay/alipay/create")
    public AjaxResult alipayCreate(@RequestBody Map<String, Object> params) {
        Long orderId = Long.valueOf(String.valueOf(params.get("orderId")));
        BigDecimal amount = new BigDecimal(String.valueOf(params.getOrDefault("amount", "0")));
        return success(alipayService.createTrade(orderId, amount));
    }

    @Anonymous
    @PostMapping("/pay/alipay/notify")
    public String alipayNotify(@RequestParam Map<String, String> params) {
        return alipayService.handleNotify(params);
    }

    @Anonymous
    @GetMapping("/pay/alipay/status")
    public AjaxResult alipayStatus(@RequestParam Long orderId) {
        return success(Map.of("tradeStatus", alipayService.queryTradeStatus(orderId)));
    }

    // ========== 入住人信息 ==========

    @GetMapping("/checkin-guest/list")
    public AjaxResult checkinGuestList(@RequestParam Long orderId) {
        return success(new ArrayList<>());
    }

    @PostMapping("/checkin-guest/save")
    public AjaxResult checkinGuestSave(@RequestBody Map<String, Object> params) {
        return success();
    }

    // ========== SSE 实时消息推送 ==========

    @GetMapping(value = "/message/subscribe", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter subscribeMessages(@RequestParam(required = false) String token) {
        Long userId = null;
        if (token != null && !token.isEmpty()) {
            LoginUser loginUser = tokenService.getLoginUser("Bearer " + token);
            if (loginUser != null) {
                userId = loginUser.getUserId();
            }
        }
        if (userId == null) {
            userId = SecurityUtils.getUserId();
        }
        return messageSseService.subscribe(userId);
    }

    // ========== 订单监控 ==========

    @GetMapping("/monitor/stats")
    public AjaxResult monitorStats() {
        return success(orderService.getMonitorStats());
    }

    @GetMapping("/monitor/unpaid")
    public TableDataInfo monitorUnpaid() {
        IPage<HsOrder> page = orderService.getUnpaidOrders(getPage());
        return getDataTableByPage(page);
    }

    @GetMapping("/monitor/paid")
    public TableDataInfo monitorPaid() {
        IPage<HsOrder> page = orderService.getPaidOrders(getPage());
        return getDataTableByPage(page);
    }

    @GetMapping("/monitor/closed")
    public TableDataInfo monitorClosed() {
        IPage<HsOrder> page = orderService.getClosedOrders(getPage());
        return getDataTableByPage(page);
    }
}
