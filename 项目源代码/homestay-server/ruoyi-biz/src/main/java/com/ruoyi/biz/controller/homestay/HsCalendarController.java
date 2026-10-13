package com.ruoyi.biz.controller.homestay;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.biz.domain.hs.HsRoomCalendar;
import com.ruoyi.biz.domain.hs.bo.HsCalendarUpdateBo;
import com.ruoyi.biz.service.IHsCalendarService;
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

import java.util.List;
import java.util.Map;

/**
 * Calendar APIs.
 */
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/homestay")
public class HsCalendarController extends BaseController {

    private final IHsCalendarService calendarService;

    /**
     * 获取房态日历数据
     */
    @GetMapping("/{homestayId}/calendar")
    public AjaxResult getCalendarData(@PathVariable Long homestayId,
                                       @RequestParam(required = false) String year,
                                       @RequestParam(required = false) String month) {
        Map<String, Object> data = calendarService.getCalendarData(homestayId, year, month);
        return success(data);
    }

    /**
     * 查询日历列表
     */
    @Anonymous
    @GetMapping("/{homestayId}/calendar/list")
    public AjaxResult list(@PathVariable Long homestayId,
                           @RequestParam(required = false) String startDate,
                           @RequestParam(required = false) String endDate) {
        List<HsRoomCalendar> list = calendarService.list(homestayId, startDate, endDate);
        return success(list);
    }

    /**
     * 批量更新日历
     */
    @Log(title = "房态日历", businessType = com.ruoyi.common.enums.BusinessType.UPDATE)
    @PostMapping("/calendar/update")
    public AjaxResult update(@Valid @RequestBody HsCalendarUpdateBo bo) {
        return toAjax(calendarService.updateRange(bo) > 0);
    }

    /**
     * 锁定日期（设为维护中）
     */
    @Log(title = "房态日历", businessType = com.ruoyi.common.enums.BusinessType.UPDATE)
    @PostMapping("/{homestayId}/calendar/lock")
    public AjaxResult lockDate(@PathVariable Long homestayId,
                                @RequestParam String date) {
        return toAjax(calendarService.lockDate(homestayId, date));
    }

    /**
     * 解锁日期（恢复可订）
     */
    @Log(title = "房态日历", businessType = com.ruoyi.common.enums.BusinessType.UPDATE)
    @PostMapping("/{homestayId}/calendar/unlock")
    public AjaxResult unlockDate(@PathVariable Long homestayId,
                                  @RequestParam String date) {
        return toAjax(calendarService.unlockDate(homestayId, date));
    }
}
