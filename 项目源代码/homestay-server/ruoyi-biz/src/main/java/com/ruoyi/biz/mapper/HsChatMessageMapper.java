package com.ruoyi.biz.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.biz.domain.hs.HsChatMessage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;
import java.util.Map;

@Mapper
public interface HsChatMessageMapper extends BaseMapper<HsChatMessage> {

    @Select("SELECT u.user_id AS userId, u.nick_name AS nickName, u.user_name AS userName, " +
            "(SELECT COUNT(*) FROM hs_chat_message WHERE receiver_user_id = #{currentUserId} AND sender_user_id = u.user_id AND is_read = '0') AS unread " +
            "FROM sys_user u " +
            "WHERE u.user_id IN (" +
            "  SELECT DISTINCT sender_user_id FROM hs_chat_message WHERE receiver_user_id = #{currentUserId} " +
            "  UNION " +
            "  SELECT DISTINCT receiver_user_id FROM hs_chat_message WHERE sender_user_id = #{currentUserId} " +
            ") AND u.del_flag = '0'")
    List<Map<String, Object>> selectContacts(@Param("currentUserId") Long currentUserId);

    @Select("SELECT * FROM hs_chat_message " +
            "WHERE (sender_user_id = #{currentUserId} AND receiver_user_id = #{peerUserId}) " +
            "OR (sender_user_id = #{peerUserId} AND receiver_user_id = #{currentUserId}) " +
            "ORDER BY create_time ASC")
    List<HsChatMessage> selectHistory(@Param("currentUserId") Long currentUserId, @Param("peerUserId") Long peerUserId);

    @Update("UPDATE hs_chat_message SET is_read = '1', read_time = NOW() " +
            "WHERE sender_user_id = #{peerUserId} AND receiver_user_id = #{currentUserId} AND is_read = '0'")
    int markAsRead(@Param("currentUserId") Long currentUserId, @Param("peerUserId") Long peerUserId);
}
