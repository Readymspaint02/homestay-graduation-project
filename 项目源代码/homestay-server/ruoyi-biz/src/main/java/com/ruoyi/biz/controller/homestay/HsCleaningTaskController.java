package com.ruoyi.biz.controller.homestay;

import com.ruoyi.biz.domain.hs.HsCleaningTask;
import com.ruoyi.biz.service.IHsCleaningTaskService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Cleaning task APIs.
 */
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/cleaning")
public class HsCleaningTaskController extends BaseController {

    private final IHsCleaningTaskService cleaningTaskService;

    /**
     * 清洁任务列表
     */
    @GetMapping("/list")
    public AjaxResult list(@RequestParam(required = false) Long homestayId,
                           @RequestParam(required = false) String startDate,
                           @RequestParam(required = false) String endDate,
                           @RequestParam(required = false) String status) {
        Long userId = SecurityUtils.getUserId();
        List<HsCleaningTask> list = cleaningTaskService.listByCondition(userId, homestayId, startDate, endDate, status);
        return success(list);
    }

    /**
     * 标记清洁状态
     */
    @Log(title = "清洁任务", businessType = BusinessType.UPDATE)
    @PostMapping("/mark")
    public AjaxResult markStatus(@RequestParam Long taskId,
                                  @RequestParam String status,
                                  @RequestParam(required = false) String imageUrl) {
        return toAjax(cleaningTaskService.markStatus(taskId, status, imageUrl));
    }

    /**
     * 删除清洁任务
     */
    @Log(title = "清洁任务", businessType = BusinessType.DELETE)
    @PostMapping("/delete/{id}")
    public AjaxResult delete(Long id) {
        return toAjax(cleaningTaskService.deleteTask(id));
    }

    /**
     * 创建清洁任务
     */
    @Log(title = "清洁任务", businessType = BusinessType.INSERT)
    @PostMapping("/create")
    public AjaxResult create(@RequestParam Long homestayId,
                              @RequestParam(required = false) String orderNo,
                              @RequestParam String cleaningDate) {
        cleaningTaskService.createTask(homestayId, orderNo, cleaningDate);
        return success();
    }
}
