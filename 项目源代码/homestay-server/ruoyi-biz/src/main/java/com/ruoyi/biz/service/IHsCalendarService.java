package com.ruoyi.biz.service;

import com.ruoyi.biz.domain.hs.HsRoomCalendar;
import com.ruoyi.biz.domain.hs.bo.HsCalendarUpdateBo;

import java.util.List;
import java.util.Map;

/**
 * Calendar service.
 */
public interface IHsCalendarService {

    /**
     * 查询日历数据
     */
    List<HsRoomCalendar> list(Long homestayId, String startDate, String endDate);

    /**
     * 批量更新日历
     */
    int updateRange(HsCalendarUpdateBo bo);

    /**
     * 锁定日期（设为维护中）
     */
    boolean lockDate(Long homestayId, String date);

    /**
     * 解锁日期（恢复可订）
     */
    boolean unlockDate(Long homestayId, String date);

    /**
     * 获取房态日历数据（含订单信息）
     */
    Map<String, Object> getCalendarData(Long homestayId, String year, String month);
}
