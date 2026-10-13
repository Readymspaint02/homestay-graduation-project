package com.ruoyi.biz.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ruoyi.biz.domain.hs.HsCleaningTask;

import java.util.List;

/**
 * 清洁任务 Service 接口
 */
public interface IHsCleaningTaskService extends IService<HsCleaningTask> {

    /**
     * 查询清洁任务列表
     *
     * @param userId      房东用户 ID
     * @param homestayId  房源 ID
     * @param startDate   开始日期
     * @param endDate     结束日期
     * @param status      状态
     * @return 清洁任务列表
     */
    List<HsCleaningTask> listByCondition(Long userId, Long homestayId, String startDate, String endDate, String status);

    /**
     * 标记清洁状态
     *
     * @param taskId 任务 ID
     * @param status 状态
     * @param imageUrl 清洁完成照片 URL
     * @return 是否成功
     */
    boolean markStatus(Long taskId, String status, String imageUrl);

    /**
     * 删除清洁任务
     *
     * @param id 任务 ID
     * @return 是否成功
     */
    boolean deleteTask(Long id);

    /**
     * 创建清洁任务
     *
     * @param homestayId  房源 ID
     * @param orderNo     订单号
     * @param cleaningDate 清洁日期
     */
    void createTask(Long homestayId, String orderNo, String cleaningDate);
}
