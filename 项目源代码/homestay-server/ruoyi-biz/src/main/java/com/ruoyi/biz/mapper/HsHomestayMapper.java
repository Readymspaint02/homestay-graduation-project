package com.ruoyi.biz.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.biz.domain.hs.HsHomestay;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * Homestay mapper.
 */
public interface HsHomestayMapper extends BaseMapper<HsHomestay> {

    @Select("SELECT h.*, u.nick_name as landlordName FROM hs_homestay h " +
            "LEFT JOIN sys_user u ON h.landlord_user_id = u.user_id " +
            "WHERE h.del_flag = '0' " +
            "ORDER BY h.create_time DESC")
    List<HsHomestay> selectAdminListWithLandlordName();

    @Select("SELECT h.*, u.nick_name as landlordName FROM hs_homestay h " +
            "LEFT JOIN sys_user u ON h.landlord_user_id = u.user_id " +
            "WHERE h.del_flag = '0' AND h.landlord_user_id = #{userId} " +
            "ORDER BY h.create_time DESC")
    List<HsHomestay> selectLandlordListWithLandlordName(@Param("userId") Long userId);
}
