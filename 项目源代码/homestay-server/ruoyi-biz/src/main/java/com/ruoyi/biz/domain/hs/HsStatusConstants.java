package com.ruoyi.biz.domain.hs;

/**
 * Homestay business status constants.
 */
public interface HsStatusConstants {

    String AUDIT_PENDING = "0";
    String AUDIT_APPROVED = "1";
    String AUDIT_REJECTED = "2";

    String PUBLISH_DRAFT = "0";
    String PUBLISH_ONLINE = "1";
    String PUBLISH_OFFLINE = "2";

    String CAL_AVAILABLE = "0";
    String CAL_LOCKED = "1";
    String CAL_BOOKED = "2";
    String CAL_BLOCKED = "3";
    String CAL_MAINTENANCE = "4";

    String PAY_UNPAID = "0";
    String PAY_PAID = "1";
    String PAY_REFUNDED = "2";

    String ORDER_WAIT_PAY = "0";
    String ORDER_WAIT_CONFIRM = "1";
    String ORDER_PAID = "1";  // 兼容旧代码：支付后即为已确认
    String ORDER_CONFIRMED = "2";
    String ORDER_FINISHED = "3";
    String ORDER_CANCELLED = "4";
    String ORDER_REJECTED = "5";
    String ORDER_CHECKED_IN = "6";

    String MSG_UNREAD = "0";
    String MSG_READ = "1";

    String SUP_PENDING = "0";
    String SUP_SUCCESS = "1";
    String SUP_FAILED = "2";
}
