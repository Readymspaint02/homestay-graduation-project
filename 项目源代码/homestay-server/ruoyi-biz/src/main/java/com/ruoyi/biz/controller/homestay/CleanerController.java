package com.ruoyi.biz.controller.homestay;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ruoyi.biz.domain.hs.HsCleaningTask;
import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.mapper.HsHomestayMapper;
import com.ruoyi.biz.service.IHsCleaningTaskService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.utils.StringUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * 清洁阿姨端 API（无需登录，使用图形验证码）
 */
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/cleaner")
public class CleanerController extends BaseController {

    private final IHsCleaningTaskService cleaningTaskService;
    private final HsHomestayMapper homestayMapper;
    private final RedisCache redisCache;

    /**
     * 验证手机号（清洁阿姨端简化验证）
     */
    @PostMapping("/verify")
    public AjaxResult verify(@RequestParam String phone) {
        if (StringUtils.isEmpty(phone) || phone.length() != 11) {
            return error("请输入正确的手机号");
        }
        return success("验证成功");
    }

    /**
     * 获取待清洁任务列表
     */
    @GetMapping("/pending-tasks")
    public AjaxResult pendingTasks() {
        LambdaQueryWrapper<HsCleaningTask> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(HsCleaningTask::getStatus, "0");
        wrapper.orderByDesc(HsCleaningTask::getCleaningDate);
        
        List<HsCleaningTask> tasks = cleaningTaskService.list(wrapper);
        
        if (tasks.isEmpty()) {
            return success(tasks);
        }
        
        List<Long> homestayIds = tasks.stream()
                .map(HsCleaningTask::getHomestayId)
                .distinct()
                .collect(Collectors.toList());
        
        List<HsHomestay> homestays = homestayMapper.selectList(
                new LambdaQueryWrapper<HsHomestay>().in(HsHomestay::getId, homestayIds)
        );
        
        Map<Long, String> homestayNameMap = homestays.stream()
                .collect(Collectors.toMap(HsHomestay::getId, HsHomestay::getTitle));
        
        for (HsCleaningTask task : tasks) {
            task.setHomestayName(homestayNameMap.get(task.getHomestayId()));
        }
        
        return success(tasks);
    }

    /**
     * 完成清洁任务（上传照片）
     */
    @PostMapping("/complete")
    public AjaxResult complete(@RequestParam Long taskId,
                               @RequestParam String imageUrl) {
        HsCleaningTask task = cleaningTaskService.getById(taskId);
        if (task == null) {
            return error("任务不存在");
        }
        
        if ("1".equals(task.getStatus())) {
            return error("该任务已完成");
        }
        
        boolean result = cleaningTaskService.markStatus(taskId, "1", imageUrl);
        if (result) {
            return success("清洁任务已完成，房源已恢复可租状态");
        }
        return error("操作失败");
    }
}