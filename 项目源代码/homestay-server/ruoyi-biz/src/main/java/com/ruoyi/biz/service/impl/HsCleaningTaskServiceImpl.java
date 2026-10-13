package com.ruoyi.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.biz.domain.hs.HsCleaningTask;
import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.mapper.HsCleaningTaskMapper;
import com.ruoyi.biz.mapper.HsHomestayMapper;
import com.ruoyi.biz.service.IHsCleaningTaskService;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.system.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 清洁任务 Service 实现类
 * 
 * 【性能优化】批量查询替代N+1查询
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class HsCleaningTaskServiceImpl extends ServiceImpl<HsCleaningTaskMapper, HsCleaningTask>
        implements IHsCleaningTaskService {

    private final HsHomestayMapper homestayMapper;
    private final SysUserMapper userMapper;

    @Override
    public List<HsCleaningTask> listByCondition(Long userId, Long homestayId, String startDate, String endDate, String status) {
        long startTime = System.currentTimeMillis();
        
        LambdaQueryWrapper<HsHomestay> homestayWrapper = new LambdaQueryWrapper<>();
        homestayWrapper.eq(HsHomestay::getLandlordUserId, userId);
        List<HsHomestay> homestays = homestayMapper.selectList(homestayWrapper);
        
        if (homestays.isEmpty()) {
            return new ArrayList<>();
        }
        
        List<Long> homestayIds = homestays.stream().map(HsHomestay::getId).collect(Collectors.toList());
        Map<Long, String> homestayNameMap = homestays.stream().collect(Collectors.toMap(HsHomestay::getId, HsHomestay::getTitle));
        Map<Long, Long> homestayLandlordMap = homestays.stream().collect(Collectors.toMap(HsHomestay::getId, HsHomestay::getLandlordUserId));
        
        LambdaQueryWrapper<HsCleaningTask> wrapper = new LambdaQueryWrapper<>();
        wrapper.in(HsCleaningTask::getHomestayId, homestayIds);
        wrapper.eq(homestayId != null, HsCleaningTask::getHomestayId, homestayId);
        wrapper.ge(startDate != null && !startDate.isEmpty(), HsCleaningTask::getCleaningDate, startDate);
        wrapper.le(endDate != null && !endDate.isEmpty(), HsCleaningTask::getCleaningDate, endDate);
        wrapper.eq(status != null && !status.isEmpty(), HsCleaningTask::getStatus, status);
        wrapper.orderByDesc(HsCleaningTask::getCleaningDate);
        
        List<HsCleaningTask> tasks = list(wrapper);
        
        // 【性能优化】批量查询房东信息，避免N+1查询
        Set<Long> landlordIds = homestays.stream().map(HsHomestay::getLandlordUserId).collect(Collectors.toSet());
        Map<Long, String> landlordPhoneMap = new java.util.HashMap<>();
        if (!landlordIds.isEmpty()) {
            List<SysUser> landlords = userMapper.selectUserByIds(new ArrayList<>(landlordIds));
            for (SysUser user : landlords) {
                if (user != null) {
                    landlordPhoneMap.put(user.getUserId(), 
                        user.getPhonenumber() != null ? user.getPhonenumber() : "");
                }
            }
        }
        
        for (HsCleaningTask task : tasks) {
            task.setHomestayName(homestayNameMap.get(task.getHomestayId()));
            Long landlordId = homestayLandlordMap.get(task.getHomestayId());
            if (landlordId != null && task.getCleanerPhone() == null) {
                task.setCleanerPhone(landlordPhoneMap.getOrDefault(landlordId, ""));
            }
        }
        
        log.debug("listByCondition 完成，任务数: {}, 耗时: {}ms", 
            tasks.size(), System.currentTimeMillis() - startTime);
        return tasks;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean markStatus(Long taskId, String status, String imageUrl) {
        HsCleaningTask task = getById(taskId);
        if (task == null) {
            return false;
        }
        task.setStatus(status);
        task.setImageUrl(imageUrl);
        boolean result = updateById(task);
        
        if (result && "1".equals(status)) {
            LambdaUpdateWrapper<HsHomestay> updateWrapper = new LambdaUpdateWrapper<>();
            updateWrapper.eq(HsHomestay::getId, task.getHomestayId());
            updateWrapper.set(HsHomestay::getCleaningStatus, "2");
            homestayMapper.update(null, updateWrapper);
        }
        
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteTask(Long id) {
        return removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void createTask(Long homestayId, String orderNo, String cleaningDate) {
        HsHomestay homestay = homestayMapper.selectById(homestayId);
        if (homestay == null) {
            throw new IllegalArgumentException("房源不存在: " + homestayId);
        }
        HsCleaningTask task = new HsCleaningTask();
        task.setHomestayId(homestayId);
        task.setHomestayName(homestay.getTitle());
        task.setOrderNo(orderNo);
        try {
            task.setCleaningDate(new java.sql.Date(java.sql.Date.valueOf(cleaningDate).getTime()));
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid date format: " + cleaningDate);
        }
        task.setStatus("0");
        save(task);
        
        LambdaUpdateWrapper<HsHomestay> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.eq(HsHomestay::getId, homestayId);
        updateWrapper.set(HsHomestay::getCleaningStatus, "0");
        homestayMapper.update(null, updateWrapper);
    }
}
