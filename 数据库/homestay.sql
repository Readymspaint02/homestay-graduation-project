/*
 Navicat MySQL Data Transfer

 Source Server         : ruo
 Source Server Type    : MySQL
 Source Server Version : 80040
 Source Host           : localhost:3306
 Source Schema         : homestay

 Target Server Type    : MySQL
 Target Server Version : 80040
 File Encoding         : 65001

 Date: 29/05/2026 17:07:40
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(0) NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int(0) NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for hs_ad
-- ----------------------------
DROP TABLE IF EXISTS `hs_ad`;
CREATE TABLE `hs_ad`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `image` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `link` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `sort_order` int(0) NOT NULL DEFAULT 0,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hs_ad_status_sort`(`status`, `sort_order`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'homestay banner ads' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_ad
-- ----------------------------

-- ----------------------------
-- Table structure for hs_address
-- ----------------------------
DROP TABLE IF EXISTS `hs_address`;
CREATE TABLE `hs_address`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'pk',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '000000',
  `user_id` bigint(0) NOT NULL COMMENT 'tenant user id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'receiver name',
  `mobile` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'mobile',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'detail address',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '0-no 1-yes',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hs_address_user_default`(`user_id`, `is_default`) USING BTREE,
  INDEX `idx_hs_address_user_time`(`user_id`, `update_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 972007 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'tenant address' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_address
-- ----------------------------
INSERT INTO `hs_address` VALUES (972001, '000000', 2002, '张同学', '13800138001', '浙江省杭州市西湖区文三路88号1单元602', '1', '2026-02-24 10:38:56', '2026-02-24 10:38:56');
INSERT INTO `hs_address` VALUES (972002, '000000', 2002, '张同学', '13800138001', '浙江省杭州市滨江区江南大道99号5幢1203', '0', '2026-02-24 10:38:56', '2026-02-24 10:38:56');
INSERT INTO `hs_address` VALUES (972003, '000000', 2003, '李老师', '13900139002', '上海市浦东新区张江路518号3号楼1802', '1', '2026-02-24 10:38:56', '2026-02-24 10:38:56');
INSERT INTO `hs_address` VALUES (972004, '000000', 2003, '李老师', '13900139002', '上海市黄浦区人民路258号2单元706', '0', '2026-02-24 10:38:56', '2026-02-24 10:38:56');
INSERT INTO `hs_address` VALUES (972005, '000000', 2004, '王女士', '13700137003', '四川省成都市锦江区春熙路66号2栋901', '1', '2026-02-24 10:38:56', '2026-02-24 10:38:56');
INSERT INTO `hs_address` VALUES (972006, '000000', 2004, '王女士', '13700137003', '四川省成都市高新区天府大道200号4栋1101', '0', '2026-02-24 10:38:56', '2026-02-24 10:38:56');

-- ----------------------------
-- Table structure for hs_chat_message
-- ----------------------------
DROP TABLE IF EXISTS `hs_chat_message`;
CREATE TABLE `hs_chat_message`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '000000',
  `sender_user_id` bigint(0) NOT NULL,
  `receiver_user_id` bigint(0) NOT NULL,
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_read` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `read_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hs_chat_pair`(`sender_user_id`, `receiver_user_id`, `create_time`) USING BTREE,
  INDEX `idx_hs_chat_receiver`(`receiver_user_id`, `is_read`, `create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'homestay private chat message' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_chat_message
-- ----------------------------
INSERT INTO `hs_chat_message` VALUES (1, '000000', 2007, 1, '21', '1', '2026-05-19 17:33:46', '2026-05-20 09:45:34');
INSERT INTO `hs_chat_message` VALUES (2, '000000', 2007, 1, '怎么办理入住？？？', '1', '2026-05-19 17:34:08', '2026-05-20 09:45:34');
INSERT INTO `hs_chat_message` VALUES (3, '000000', 2007, 1, 'https://www.undsky.com/profile/upload/2026/05/19/snow_wall_20260519173412A001.jpg', '1', '2026-05-19 17:34:12', '2026-05-20 09:45:34');
INSERT INTO `hs_chat_message` VALUES (4, '000000', 2009, 1, '哥', '1', '2026-05-19 21:21:36', '2026-05-20 09:45:38');
INSERT INTO `hs_chat_message` VALUES (5, '000000', 2009, 1, '你好', '1', '2026-05-19 21:27:51', '2026-05-20 09:45:38');
INSERT INTO `hs_chat_message` VALUES (6, '000000', 2009, 1, 'hello', '1', '2026-05-19 21:27:54', '2026-05-20 09:45:38');
INSERT INTO `hs_chat_message` VALUES (7, '000000', 2009, 1, 'hello', '1', '2026-05-19 21:29:23', '2026-05-20 09:45:38');
INSERT INTO `hs_chat_message` VALUES (8, '000000', 2009, 1, '2', '1', '2026-05-19 21:31:40', '2026-05-20 09:45:38');
INSERT INTO `hs_chat_message` VALUES (9, '000000', 2009, 1, 'https://www.undsky.comhttp://js.ccnccn.cn/2026/05/199b598989-ea1a-4204-88ef-c3eeee810ed0.png', '1', '2026-05-19 21:32:08', '2026-05-20 09:45:38');
INSERT INTO `hs_chat_message` VALUES (10, '000000', 2009, 1, 'https://www.undsky.comhttp://js.ccnccn.cn/2026/05/19adef326c-5079-4ff2-8c3a-f518947889f2.png', '1', '2026-05-19 21:32:08', '2026-05-20 09:45:38');
INSERT INTO `hs_chat_message` VALUES (11, '000000', 2009, 1, '哥们双十二', '1', '2026-05-19 21:39:05', '2026-05-20 09:45:38');
INSERT INTO `hs_chat_message` VALUES (12, '000000', 2009, 1, '哥们，sse', '1', '2026-05-19 21:39:08', '2026-05-20 09:45:38');
INSERT INTO `hs_chat_message` VALUES (13, '000000', 2009, 1, '我试试', '1', '2026-05-19 21:39:16', '2026-05-20 09:45:38');
INSERT INTO `hs_chat_message` VALUES (14, '000000', 2007, 1, 'HELLO', '1', '2026-05-19 22:56:53', '2026-05-20 09:45:34');
INSERT INTO `hs_chat_message` VALUES (15, '000000', 2007, 1, 'hello', '1', '2026-05-20 05:12:11', '2026-05-20 09:45:34');
INSERT INTO `hs_chat_message` VALUES (16, '000000', 2011, 2011, '21', '1', '2026-05-20 09:26:04', '2026-05-20 09:30:37');
INSERT INTO `hs_chat_message` VALUES (17, '000000', 2003, 2001, 'hello', '0', '2026-05-20 09:27:54', NULL);
INSERT INTO `hs_chat_message` VALUES (18, '000000', 2011, 2011, '21', '1', '2026-05-20 09:30:40', '2026-05-20 09:34:37');
INSERT INTO `hs_chat_message` VALUES (19, '000000', 2011, 2011, '222', '1', '2026-05-20 09:30:43', '2026-05-20 09:34:37');
INSERT INTO `hs_chat_message` VALUES (20, '000000', 2003, 2001, '31', '0', '2026-05-20 09:33:23', NULL);
INSERT INTO `hs_chat_message` VALUES (21, '000000', 2011, 2011, '21', '1', '2026-05-20 09:34:40', '2026-05-20 09:42:52');
INSERT INTO `hs_chat_message` VALUES (22, '000000', 2011, 2011, '好', '1', '2026-05-20 09:34:49', '2026-05-20 09:42:52');
INSERT INTO `hs_chat_message` VALUES (23, '000000', 1, 2009, 'OKK', '1', '2026-05-20 09:45:46', '2026-05-20 11:17:01');
INSERT INTO `hs_chat_message` VALUES (24, '000000', 1, 2007, '不是', '1', '2026-05-20 09:45:55', '2026-05-20 11:11:55');
INSERT INTO `hs_chat_message` VALUES (25, '000000', 2007, 2011, 'helloa', '1', '2026-05-20 11:12:15', '2026-05-20 11:14:40');
INSERT INTO `hs_chat_message` VALUES (26, '000000', 2007, 2011, '23', '1', '2026-05-20 11:12:27', '2026-05-20 11:14:40');
INSERT INTO `hs_chat_message` VALUES (27, '000000', 2009, 2011, '你好2011', '1', '2026-05-20 11:17:40', '2026-05-20 11:19:19');
INSERT INTO `hs_chat_message` VALUES (28, '000000', 2007, 2011, '房东，最近还有新房吗？', '1', '2026-05-20 11:21:59', '2026-05-20 11:22:02');
INSERT INTO `hs_chat_message` VALUES (29, '000000', 2007, 2012, 'hello，房东，照片是真实的吗？房子跟图片上看起来一样大吗？', '1', '2026-05-20 13:48:04', '2026-05-20 13:48:34');
INSERT INTO `hs_chat_message` VALUES (30, '000000', 2012, 2007, '是真实的', '1', '2026-05-20 14:48:32', '2026-05-20 23:09:18');

-- ----------------------------
-- Table structure for hs_classification
-- ----------------------------
DROP TABLE IF EXISTS `hs_classification`;
CREATE TABLE `hs_classification`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'pk',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '000000',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'classification title',
  `sort` int(0) NOT NULL DEFAULT 0 COMMENT 'sort asc',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '0-enable 1-disable',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_hs_classification_title`(`title`) USING BTREE,
  INDEX `idx_hs_classification_status_sort`(`status`, `sort`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'homestay classification' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_classification
-- ----------------------------
INSERT INTO `hs_classification` VALUES (1, '000000', '城市公寓', 1, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_classification` VALUES (2, '000000', '海景别墅', 2, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_classification` VALUES (3, '000000', '山景民宿', 3, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_classification` VALUES (4, '000000', '古镇客栈', 4, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_classification` VALUES (5, '000000', '田园农庄', 5, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_classification` VALUES (6, '000000', '湖畔小屋', 6, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_classification` VALUES (7, '000000', '森林木屋', 7, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_classification` VALUES (8, '000000', '温泉酒店', 8, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');

-- ----------------------------
-- Table structure for hs_cleaning_task
-- ----------------------------
DROP TABLE IF EXISTS `hs_cleaning_task`;
CREATE TABLE `hs_cleaning_task`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'pk',
  `homestay_id` bigint(0) NOT NULL COMMENT '房源 ID',
  `homestay_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '房源名称',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联订单号',
  `cleaning_date` date NOT NULL COMMENT '清洁日期',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '0-待清洁 1-已清洁',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '清洁完成照片URL',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `cleaner_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '清洁阿姨手机号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hs_cleaning_homestay_date`(`homestay_id`, `cleaning_date`) USING BTREE,
  INDEX `idx_hs_cleaning_status`(`status`) USING BTREE,
  INDEX `idx_cleaning_homestay_date`(`homestay_id`, `cleaning_date`) USING BTREE,
  INDEX `idx_cleaning_status`(`status`) USING BTREE,
  INDEX `idx_cleaning_date`(`cleaning_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '清洁任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_cleaning_task
-- ----------------------------
INSERT INTO `hs_cleaning_task` VALUES (1, 971044, '湖北工业大学', 'TEST001', '2026-05-20', '1', ' ', NULL, '2026-05-20 09:18:23', '2026-05-20 14:07:20', '17878786702');
INSERT INTO `hs_cleaning_task` VALUES (2, 971045, NULL, 'OD20260520095252356379', '2026-05-20', '1', ' ', 'https://js.ccnccn.cn/cleaning/1779246821584_us24gvb3y.png', '2026-05-20 09:53:30', '2026-05-20 14:07:20', NULL);
INSERT INTO `hs_cleaning_task` VALUES (3, 971049, NULL, 'OD2024001', '2026-05-27', '0', ' ', NULL, '2026-05-20 13:40:46', '2026-05-20 14:07:20', NULL);
INSERT INTO `hs_cleaning_task` VALUES (4, 971049, NULL, 'OD2024002', '2026-06-01', '0', ' ', NULL, '2026-05-20 13:40:46', '2026-05-20 14:07:20', NULL);
INSERT INTO `hs_cleaning_task` VALUES (5, 971050, NULL, 'OD2024003', '2026-05-26', '0', ' ', NULL, '2026-05-20 13:40:46', '2026-05-20 14:07:20', NULL);
INSERT INTO `hs_cleaning_task` VALUES (6, 971051, NULL, 'OD2024004', '2026-05-29', '0', ' ', NULL, '2026-05-20 13:40:46', '2026-05-20 14:07:20', NULL);
INSERT INTO `hs_cleaning_task` VALUES (7, 971052, NULL, 'OD2024005', '2026-06-06', '0', ' ', NULL, '2026-05-20 13:40:46', '2026-05-20 14:07:20', NULL);
INSERT INTO `hs_cleaning_task` VALUES (8, 971054, NULL, 'OD2024007', '2026-05-24', '0', ' ', NULL, '2026-05-20 13:40:46', '2026-05-20 14:07:20', NULL);
INSERT INTO `hs_cleaning_task` VALUES (9, 971056, NULL, 'OD2024009', '2026-05-28', '0', ' ', NULL, '2026-05-20 13:40:46', '2026-05-20 14:07:20', NULL);
INSERT INTO `hs_cleaning_task` VALUES (10, 971057, NULL, 'OD2024010', '2026-05-22', '0', ' ', NULL, '2026-05-20 13:40:46', '2026-05-20 14:07:20', NULL);
INSERT INTO `hs_cleaning_task` VALUES (11, 971059, NULL, 'OD2024012', '2026-06-17', '0', ' ', NULL, '2026-05-20 13:40:46', '2026-05-20 14:07:20', NULL);
INSERT INTO `hs_cleaning_task` VALUES (12, 971060, NULL, 'OD2024013', '2026-06-22', '0', ' ', NULL, '2026-05-20 13:40:46', '2026-05-20 14:07:20', NULL);
INSERT INTO `hs_cleaning_task` VALUES (13, 971050, NULL, 'OD2024014', '2026-05-13', '1', ' ', NULL, '2026-05-13 13:40:46', '2026-05-20 14:07:20', NULL);
INSERT INTO `hs_cleaning_task` VALUES (14, 971051, NULL, NULL, '2026-05-21', '0', ' ', NULL, '2026-05-20 13:40:46', '2026-05-20 14:07:20', NULL);
INSERT INTO `hs_cleaning_task` VALUES (18, 971085, NULL, 'OD20260520141825187794', '2026-05-20', '0', NULL, NULL, '2026-05-20 14:23:41', '2026-05-20 14:23:41', NULL);
INSERT INTO `hs_cleaning_task` VALUES (19, 971086, NULL, 'OD20260520145826793309', '2026-05-20', '0', NULL, NULL, '2026-05-20 14:59:21', '2026-05-20 14:59:21', NULL);

-- ----------------------------
-- Table structure for hs_faq
-- ----------------------------
DROP TABLE IF EXISTS `hs_faq`;
CREATE TABLE `hs_faq`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `keywords` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '匹配关键词，逗号分隔',
  `question` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '常见问题',
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标准答案',
  `sort_order` int(0) NOT NULL DEFAULT 0,
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hs_faq_keywords`(`keywords`(100)) USING BTREE,
  INDEX `idx_hs_faq_status_sort`(`status`, `sort_order`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'homestay offline FAQ' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_faq
-- ----------------------------
INSERT INTO `hs_faq` VALUES (1, '支付', '如何支付？', '支持在线支付（模拟微信支付）和支付宝沙箱支付。订单创建后在订单页面点击\"去支付\"即可。模拟支付立即到账，支付宝沙箱支付需在沙箱环境完成。到账后订单状态变为\"待房东处理\"。', 0, '1', '2026-05-18 20:46:29');
INSERT INTO `hs_faq` VALUES (2, '取消', '如何取消订单？', '在订单详情页点击\"取消订单\"按钮即可取消。注意：已确认入住、已完成、已拒绝的订单无法取消。', 0, '1', '2026-05-18 20:46:29');
INSERT INTO `hs_faq` VALUES (3, '退款', '如何退款？', '订单取消后系统会自动释放日历。如果已支付，取消后请联系房东处理退款。（目前系统暂未实现自动退款流程）', 0, '1', '2026-05-18 20:46:29');
INSERT INTO `hs_faq` VALUES (4, '入住', '怎么办理入住？', '订单状态变为\"已确认\"后，租客可在订单页面点击\"确认入住\"按钮办理入住。入住后可点击\"确认退房\"完成退房。', 0, '1', '2026-05-18 20:46:29');
INSERT INTO `hs_faq` VALUES (5, '评价', '如何评价？', '退房完成后（订单状态为\"已完成\"），在订单页面点击\"去评价\"即可提交评分和文字评价。也支持入住期间评价。', 0, '1', '2026-05-18 20:46:29');
INSERT INTO `hs_faq` VALUES (6, '收藏', '如何收藏房源？', '在房源详情页点击收藏按钮，房源将保存到\"我的收藏\"中。在收藏页面可以\"移出\"收藏或\"再次下单\"。', 0, '1', '2026-05-18 20:46:29');
INSERT INTO `hs_faq` VALUES (7, '预订', '如何预订房源？', '在房源详情页选择入住/退房日期和人数，点击预订按钮。系统会检查日历可用性，生成订单后进入支付流程。', 0, '1', '2026-05-18 20:46:29');
INSERT INTO `hs_faq` VALUES (8, '退房', '如何退房？', '入住后，在订单页面点击\"确认退房\"按钮即可完成退房。退房后订单变为\"已完成\"状态，可进行评价。', 0, '1', '2026-05-18 20:46:29');
INSERT INTO `hs_faq` VALUES (9, '消息', '如何查看消息？', '在\"消息中心\"可以查看系统通知和私信。系统通知包含订单状态变更等消息。私信对话支持文字和图片聊天。', 0, '1', '2026-05-18 20:46:29');
INSERT INTO `hs_faq` VALUES (10, 'AI', 'AI助手能做什么？', 'AI助手可以回答关于房源的常见问题、对比不同房源、提供预订建议。当AI服务不可用时，系统会基于FAQ给出标准回答。', 0, '1', '2026-05-18 20:46:29');
INSERT INTO `hs_faq` VALUES (11, '注册', '如何注册账号？', '在登录页面点击注册，填写用户名、密码等信息即可注册。注册后默认为租客角色。', 0, '1', '2026-05-18 20:46:29');
INSERT INTO `hs_faq` VALUES (12, '密码', '忘记密码怎么办？', '在\"编辑资料\"页面的\"账号安全\"中可以修改密码。需要输入旧密码和新密码。', 0, '1', '2026-05-18 20:46:29');
INSERT INTO `hs_faq` VALUES (13, '房源', '什么是房源？', '房源是可供出租的房间/房屋/物业。房东可以创建和管理房源，租客可以浏览和预订房源。', 0, '1', '2026-05-18 20:46:29');
INSERT INTO `hs_faq` VALUES (14, '房态', '什么是房态？', '房态表示房源在特定日期的可预订状态：可预订、已预订、锁定、停用。房东可以在\"房态日历\"中管理。', 0, '1', '2026-05-18 20:46:29');

-- ----------------------------
-- Table structure for hs_favorite
-- ----------------------------
DROP TABLE IF EXISTS `hs_favorite`;
CREATE TABLE `hs_favorite`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'pk',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '000000',
  `tenant_user_id` bigint(0) NOT NULL,
  `homestay_id` bigint(0) NOT NULL,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_hs_fav_user_homestay`(`tenant_user_id`, `homestay_id`) USING BTREE,
  INDEX `idx_hs_fav_homestay`(`homestay_id`) USING BTREE,
  INDEX `idx_favorite_homestay`(`homestay_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 973084 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'favorite table' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_favorite
-- ----------------------------
INSERT INTO `hs_favorite` VALUES (973001, '000000', 2002, 971001, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973002, '000000', 2002, 971002, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973003, '000000', 2002, 971003, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973004, '000000', 2002, 971004, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973005, '000000', 2002, 971005, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973006, '000000', 2002, 971006, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973007, '000000', 2002, 971007, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973008, '000000', 2002, 971008, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973009, '000000', 2002, 971009, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973010, '000000', 2002, 971010, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973011, '000000', 2002, 971011, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973012, '000000', 2002, 971012, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973013, '000000', 2002, 971013, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973014, '000000', 2002, 971014, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973015, '000000', 2002, 971015, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973016, '000000', 2002, 971016, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973017, '000000', 2002, 971017, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973018, '000000', 2002, 971018, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973019, '000000', 2002, 971019, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973020, '000000', 2002, 971020, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973021, '000000', 2002, 971021, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973023, '000000', 2002, 971023, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973024, '000000', 2002, 971024, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973025, '000000', 2002, 971025, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973026, '000000', 2002, 971026, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973027, '000000', 2002, 971027, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973028, '000000', 2002, 971028, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973029, '000000', 2002, 971029, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973030, '000000', 2002, 971030, '2026-02-24 12:15:29');
INSERT INTO `hs_favorite` VALUES (973031, '000000', 1, 971001, '2026-02-24 16:13:57');
INSERT INTO `hs_favorite` VALUES (973033, '000000', 2002, 971031, '2026-02-25 23:37:51');
INSERT INTO `hs_favorite` VALUES (973034, '000000', 1, 971031, '2026-02-28 15:42:39');
INSERT INTO `hs_favorite` VALUES (973035, '000000', 1, 971032, '2026-03-05 13:26:55');
INSERT INTO `hs_favorite` VALUES (973037, '000000', 1, 971030, '2026-03-05 21:29:13');
INSERT INTO `hs_favorite` VALUES (973038, '000000', 2003, 971030, '2026-03-07 11:12:56');
INSERT INTO `hs_favorite` VALUES (973039, '000000', 2003, 971009, '2026-03-07 18:49:55');
INSERT INTO `hs_favorite` VALUES (973041, '000000', 2004, 971031, '2026-05-18 17:19:17');
INSERT INTO `hs_favorite` VALUES (973042, '000000', 2006, 971005, '2026-05-18 17:29:48');
INSERT INTO `hs_favorite` VALUES (973043, '000000', 2006, 971031, '2026-05-18 17:54:07');
INSERT INTO `hs_favorite` VALUES (973044, '000000', 2007, 971032, '2026-05-18 18:00:11');
INSERT INTO `hs_favorite` VALUES (973046, '000000', 2007, 971008, '2026-05-18 18:29:52');
INSERT INTO `hs_favorite` VALUES (973048, '000000', 2007, 971035, '2026-05-18 23:05:16');
INSERT INTO `hs_favorite` VALUES (973049, '000000', 2007, 971033, '2026-05-18 23:17:24');
INSERT INTO `hs_favorite` VALUES (973050, '000000', 2007, 971003, '2026-05-18 23:17:28');
INSERT INTO `hs_favorite` VALUES (973051, '000000', 2007, 971009, '2026-05-18 23:17:34');
INSERT INTO `hs_favorite` VALUES (973054, '000000', 2009, 5, '2026-05-19 15:11:53');
INSERT INTO `hs_favorite` VALUES (973060, '000000', 2009, 12, '2026-05-19 17:32:22');
INSERT INTO `hs_favorite` VALUES (973061, '000000', 2007, 1, '2026-05-19 17:32:46');
INSERT INTO `hs_favorite` VALUES (973063, '000000', 2009, 1, '2026-05-19 21:21:30');
INSERT INTO `hs_favorite` VALUES (973067, '000000', 2011, 1, '2026-05-20 09:22:43');
INSERT INTO `hs_favorite` VALUES (973068, '000000', 2011, 971044, '2026-05-20 09:23:03');
INSERT INTO `hs_favorite` VALUES (973069, '000000', 2003, 971045, '2026-05-20 09:27:05');
INSERT INTO `hs_favorite` VALUES (973070, '000000', 2003, 5, '2026-05-20 09:35:51');
INSERT INTO `hs_favorite` VALUES (973071, '000000', 2011, 6, '2026-05-20 09:37:08');
INSERT INTO `hs_favorite` VALUES (973072, '000000', 2011, 23, '2026-05-20 09:37:21');
INSERT INTO `hs_favorite` VALUES (973073, '000000', 2011, 4, '2026-05-20 09:46:55');
INSERT INTO `hs_favorite` VALUES (973075, '000000', 2007, 971044, '2026-05-20 09:49:59');
INSERT INTO `hs_favorite` VALUES (973076, '000000', 2011, 971046, '2026-05-20 10:04:25');
INSERT INTO `hs_favorite` VALUES (973078, '000000', 2007, 971052, '2026-05-20 13:46:03');
INSERT INTO `hs_favorite` VALUES (973082, '000000', 2007, 971057, '2026-05-20 14:46:15');
INSERT INTO `hs_favorite` VALUES (973083, '000000', 2007, 971086, '2026-05-20 14:54:39');

-- ----------------------------
-- Table structure for hs_homestay
-- ----------------------------
DROP TABLE IF EXISTS `hs_homestay`;
CREATE TABLE `hs_homestay`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'pk',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '000000' COMMENT 'tenant',
  `homestay_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'biz id, HSxxxx',
  `landlord_user_id` bigint(0) NOT NULL COMMENT 'sys_user.user_id',
  `classification_id` bigint(0) NULL DEFAULT NULL,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'title',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '封面图片URL',
  `description` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'description',
  `room_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '房型：整套/独立/合租',
  `bedroom_count` int(0) NULL DEFAULT 1 COMMENT '卧室数',
  `bed_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '床型信息',
  `province` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `city` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `district` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'cover image path',
  `longitude` decimal(10, 7) NULL DEFAULT NULL,
  `latitude` decimal(10, 7) NULL DEFAULT NULL,
  `base_price` decimal(10, 2) NOT NULL COMMENT 'base nightly price',
  `weekend_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '周末价',
  `cleaning_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '清洁费',
  `deposit` decimal(10, 2) NULL DEFAULT NULL COMMENT '押金',
  `facilities_json` json NULL COMMENT '设施 JSON 数组',
  `max_guests` int(0) NOT NULL DEFAULT 1,
  `audit_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '0-pending 1-approved 2-rejected',
  `publish_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '0-draft 1-online 2-offline',
  `cleaning_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '0-dirty 1-in-progress 2-ready',
  `rating_avg` decimal(3, 2) NOT NULL DEFAULT 5.00,
  `rating_count` int(0) NOT NULL DEFAULT 0,
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '0-exist 1-deleted',
  `create_by` bigint(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_by` bigint(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_hs_homestay_no`(`homestay_no`) USING BTREE,
  INDEX `idx_hs_homestay_landlord`(`landlord_user_id`) USING BTREE,
  INDEX `idx_hs_homestay_audit`(`audit_status`) USING BTREE,
  INDEX `idx_hs_homestay_publish`(`publish_status`) USING BTREE,
  INDEX `idx_hs_homestay_city_price`(`city`, `base_price`) USING BTREE,
  INDEX `idx_hs_homestay_cleaning`(`cleaning_status`) USING BTREE,
  INDEX `idx_hs_city_price_publish`(`city`, `base_price`, `publish_status`) USING BTREE,
  INDEX `idx_hs_landlord_audit_publish`(`landlord_user_id`, `audit_status`, `publish_status`) USING BTREE,
  INDEX `idx_landlord_user`(`landlord_user_id`) USING BTREE,
  INDEX `idx_audit_publish`(`audit_status`, `publish_status`) USING BTREE,
  INDEX `idx_city_price`(`city`, `base_price`) USING BTREE,
  INDEX `idx_rating`(`rating_avg`, `rating_count`) USING BTREE,
  INDEX `idx_homestay_landlord`(`landlord_user_id`) USING BTREE,
  INDEX `idx_homestay_audit`(`audit_status`) USING BTREE,
  INDEX `idx_homestay_publish`(`publish_status`) USING BTREE,
  INDEX `idx_homestay_city`(`city`) USING BTREE,
  INDEX `idx_landlord_audit_publish`(`landlord_user_id`, `audit_status`, `publish_status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 971087 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'homestay main table' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_homestay
-- ----------------------------
INSERT INTO `hs_homestay` VALUES (2, '000000', 'BJ002', 2001, 3, '北京怀柔山景民宿', '/profile/upload/2024/01/beijing2.jpg', '坐落于怀柔山区，远离城市喧嚣。山景房，空气清新，适合度假休闲。', '独立房间', 3, '', '北京市', '北京', '怀柔区', '雁栖湖镇北台上村', NULL, 116.6914000, 40.3696000, 458.00, NULL, NULL, NULL, NULL, 6, '0', '1', '0', 3.00, 1, '0', NULL, '2026-05-18 23:33:54', 1, '2026-05-20 03:34:30', NULL);
INSERT INTO `hs_homestay` VALUES (3, '000000', 'BJ003', 2001, 4, '北京胡同客栈', '/profile/upload/2024/01/beijing3.jpg', '传统北京胡同改造，保留老北京风貌。近故宫、天安门，体验地道京味生活。', '独立房间', 1, NULL, '北京市', '北京', '东城区', '南锣鼓巷胡同', NULL, 116.4023000, 39.9388000, 388.00, NULL, NULL, NULL, NULL, 2, '1', '1', '0', 4.70, 89, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-20 03:34:30', NULL);
INSERT INTO `hs_homestay` VALUES (4, '000000', 'SH001', 2001, 1, '上海静安区精品公寓', '/profile/upload/2024/01/shanghai1.jpg', '静安寺商圈核心位置，近地铁2号线。精致装修，智能家居系统。', '整套公寓', 1, NULL, '上海市', '上海', '静安区', '南京西路1788号', NULL, 121.4685000, 31.2244000, 358.00, NULL, NULL, NULL, NULL, 2, '1', '1', '0', 4.60, 78, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-20 03:34:30', NULL);
INSERT INTO `hs_homestay` VALUES (5, '000000', 'SH002', 2001, 6, '上海淀山湖湖畔小屋', '/profile/upload/2024/01/shanghai2.jpg', '淀山湖畔度假小屋，湖景房，可垂钓、划船。周末度假首选。', '整套别墅', 4, NULL, '上海市', '上海', '青浦区', '淀山湖畔', NULL, 120.9667000, 31.0833000, 688.00, NULL, NULL, NULL, NULL, 8, '1', '1', '0', 4.80, 45, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-20 03:34:30', NULL);
INSERT INTO `hs_homestay` VALUES (6, '000000', 'HZ001', 1, 3, '杭州西湖山景民宿', '/profile/upload/2024/01/hangzhou1.jpg', '西湖景区附近，步行可达西湖。山景民宿，环境优美，茶香四溢。', '独立房间', 2, NULL, '浙江省', '杭州', '西湖区', '龙井路88号', NULL, 120.1290000, 30.2590000, 398.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.90, 156, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:26', NULL);
INSERT INTO `hs_homestay` VALUES (7, '000000', 'HZ002', 1, 4, '杭州南宋御街客栈', '/profile/upload/2024/01/hangzhou2.jpg', '南宋御街古建筑改造，体验杭州历史文化。近河坊街、西湖。', '独立房间', 1, NULL, '浙江省', '杭州', '上城区', '南宋御街156号', NULL, 120.1700000, 30.2447000, 288.00, NULL, NULL, NULL, NULL, 2, '1', '1', '0', 4.70, 67, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:26', NULL);
INSERT INTO `hs_homestay` VALUES (8, '000000', 'XM001', 1, 2, '厦门鼓浪屿海景别墅', '/profile/upload/2024/01/xiamen1.jpg', '鼓浪屿岛上海景别墅，步行可达海滩。欧式建筑风格，浪漫度假首选。', '整套别墅', 3, NULL, '福建省', '厦门', '思明区', '鼓浪屿漳州路', NULL, 118.0694000, 24.4524000, 798.00, NULL, NULL, NULL, NULL, 6, '1', '1', '0', 4.90, 203, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:26', NULL);
INSERT INTO `hs_homestay` VALUES (9, '000000', 'XM002', 1, 2, '厦门环岛路海景房', '/profile/upload/2024/01/xiamen2.jpg', '环岛路一线海景，躺在床上看日出。近曾厝垵、厦门大学。', '整套公寓', 2, NULL, '福建省', '厦门', '思明区', '环岛路海边', NULL, 118.1156000, 24.4778000, 458.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.80, 89, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (10, '000000', 'DL001', 1, 4, '大理古城客栈', '/profile/upload/2024/01/dali1.jpg', '大理古城内传统白族建筑，近洱海、苍山。体验云南民族风情。', '独立房间', 2, NULL, '云南省', '大理', '大理市', '古城南门123号', NULL, 100.1810000, 25.7065000, 268.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.80, 178, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (11, '000000', 'DL002', 1, 6, '大理洱海湖畔小屋', '/profile/upload/2024/01/dali2.jpg', '洱海边湖景小屋，可看日出日落。近双廊古镇，骑行环洱海。', '整套公寓', 2, NULL, '云南省', '大理', '大理市', '洱海边双廊镇', NULL, 100.1833000, 25.9500000, 398.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.90, 134, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (12, '000000', 'CD001', 1, 1, '成都春熙路公寓', '/profile/upload/2024/01/chengdu1.jpg', '春熙路商圈核心位置，近IFS、太古里。成都美食聚集地。', '整套公寓', 1, NULL, '四川省', '成都', '锦江区', '春熙路88号', NULL, 104.0830000, 30.6570000, 258.00, NULL, NULL, NULL, NULL, 2, '1', '1', '0', 4.60, 92, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (13, '000000', 'CD002', 1, 5, '成都青城山田园农庄', '/profile/upload/2024/01/chengdu2.jpg', '青城山下田园农庄，有机蔬菜采摘，农家美食体验。', '整套别墅', 4, NULL, '四川省', '成都', '都江堰市', '青城山镇', NULL, 103.5350000, 30.9025000, 468.00, NULL, NULL, NULL, NULL, 8, '1', '1', '0', 4.70, 56, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (14, '000000', 'XA001', 1, 4, '西安古城墙客栈', '/profile/upload/2024/01/xian1.jpg', '古城墙附近传统建筑改造，近钟楼、回民街。体验古都文化。', '独立房间', 2, NULL, '陕西省', '西安', '碑林区', '南门里顺城巷', NULL, 108.9540000, 34.2610000, 298.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.80, 145, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (15, '000000', 'XA002', 1, 7, '西安秦岭森林木屋', '/profile/upload/2024/01/xian2.jpg', '秦岭山脚下森林木屋，空气清新，避暑胜地。近野生动物园。', '独立房间', 2, NULL, '陕西省', '西安', '长安区', '秦岭山脚下', NULL, 108.8000000, 34.0500000, 358.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.60, 67, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (16, '000000', 'SZ001', 1, 4, '苏州平江路古巷客栈', '/profile/upload/2024/01/suzhou1.jpg', '平江路历史街区，传统苏式建筑。近拙政园、狮子林。', '独立房间', 1, NULL, '江苏省', '苏州', '姑苏区', '平江路256号', NULL, 120.6288000, 31.3088000, 328.00, NULL, NULL, NULL, NULL, 2, '1', '1', '0', 4.90, 112, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (17, '000000', 'SZ002', 1, 6, '苏州太湖湖畔小屋', '/profile/upload/2024/01/suzhou2.jpg', '太湖边度假小屋，湖景房，可垂钓、游船。近东山、西山景区。', '整套公寓', 2, NULL, '江苏省', '苏州', '吴中区', '太湖边', NULL, 120.1500000, 31.2000000, 428.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.70, 78, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (18, '000000', 'QD001', 1, 2, '青岛八大关海景别墅', '/profile/upload/2024/01/qingdao1.jpg', '八大关风景区海景别墅，欧式建筑风格。近海边、栈桥。', '整套别墅', 3, NULL, '山东省', '青岛', '市南区', '八大关景区', NULL, 120.3500000, 36.0567000, 688.00, NULL, NULL, NULL, NULL, 6, '1', '1', '0', 4.80, 89, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (19, '000000', 'QD002', 1, 1, '青岛崂山区公寓', '/profile/upload/2024/01/qingdao2.jpg', '崂山区现代公寓，近崂山景区、啤酒博物馆。交通便利。', '整套公寓', 2, NULL, '山东省', '青岛', '崂山区', '崂山路88号', NULL, 120.4500000, 36.1500000, 298.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.60, 56, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (20, '000000', 'GL001', 1, 3, '桂林阳朔山景民宿', '/profile/upload/2024/01/guilin1.jpg', '阳朔漓江边山景民宿，可看漓江山水。近西街、十里画廊。', '独立房间', 2, NULL, '广西省', '桂林', '阳朔县', '漓江边', NULL, 110.4950000, 24.7814000, 268.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.90, 234, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (21, '000000', 'GL002', 1, 7, '桂林龙脊梯田森林木屋', '/profile/upload/2024/01/guilin2.jpg', '龙脊梯田景区内木屋，可看梯田日出。体验壮族风情。', '独立房间', 1, NULL, '广西省', '桂林', '龙胜县', '龙脊梯田景区', NULL, 110.1333000, 25.7833000, 198.00, NULL, NULL, NULL, NULL, 2, '1', '1', '0', 4.70, 145, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (22, '000000', 'SY001', 1, 2, '三亚亚龙湾海景别墅', '/profile/upload/2024/01/sanya1.jpg', '亚龙湾一线海景别墅，私人沙滩。热带度假天堂。', '整套别墅', 4, NULL, '海南省', '三亚', '吉阳区', '亚龙湾度假区', NULL, 109.5167000, 18.2167000, 1288.00, NULL, NULL, NULL, NULL, 8, '1', '1', '0', 4.90, 167, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (23, '000000', 'SY002', 1, 8, '三亚温泉酒店公寓', '/profile/upload/2024/01/sanya2.jpg', '温泉度假区内公寓，天然温泉入户。近天涯海角景区。', '整套公寓', 2, NULL, '海南省', '三亚', '天涯区', '温泉度假区', NULL, 109.4000000, 18.3000000, 588.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.80, 89, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (24, '000000', 'NJ001', 1, 4, '南京夫子庙客栈', '/profile/upload/2024/01/nanjing1.jpg', '夫子庙秦淮河边传统建筑，近中山陵、玄武湖。', '独立房间', 1, NULL, '江苏省', '南京', '秦淮区', '夫子庙贡院街', NULL, 118.7940000, 32.0400000, 288.00, NULL, NULL, NULL, NULL, 2, '1', '1', '0', 4.70, 134, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (25, '000000', 'NJ002', 1, 6, '南京玄武湖湖畔小屋', '/profile/upload/2024/01/nanjing2.jpg', '玄武湖边度假小屋，湖景房。近南京站、新街口。', '整套公寓', 1, NULL, '江苏省', '南京', '玄武区', '玄武湖边', NULL, 118.8000000, 32.0500000, 358.00, NULL, NULL, NULL, NULL, 2, '1', '1', '0', 4.60, 67, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (26, '000000', 'CQ001', 1, 1, '重庆解放碑公寓', '/profile/upload/2024/01/chongqing1.jpg', '解放碑商圈核心位置，近洪崖洞、长江索道。火锅美食聚集地。', '整套公寓', 1, NULL, '重庆市', '重庆', '渝中区', '解放碑步行街', NULL, 106.5770000, 29.5580000, 238.00, NULL, NULL, NULL, NULL, 2, '1', '1', '0', 4.50, 89, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (27, '000000', 'CQ002', 1, 3, '重庆南山山景民宿', '/profile/upload/2024/01/chongqing2.jpg', '南山风景区民宿，可看重庆夜景。近南山植物园、一棵树观景台。', '独立房间', 2, NULL, '重庆市', '重庆', '南岸区', '南山风景区', NULL, 106.6000000, 29.5000000, 298.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.80, 56, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (28, '000000', 'KM001', 1, 5, '昆明西山田园农庄', '/profile/upload/2024/01/kunming1.jpg', '西山脚下田园农庄，有机蔬菜采摘。近滇池、民族村。', '整套别墅', 3, NULL, '云南省', '昆明', '西山区', '西山脚下', NULL, 102.6667000, 24.9667000, 368.00, NULL, NULL, NULL, NULL, 6, '1', '1', '0', 4.70, 78, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (29, '000000', 'KM002', 1, 7, '昆明翠湖森林木屋', '/profile/upload/2024/01/kunming2.jpg', '翠湖公园附近森林木屋，近云南大学、讲武堂。四季如春。', '独立房间', 1, NULL, '云南省', '昆明', '五华区', '翠湖边', NULL, 102.7083000, 25.0356000, 258.00, NULL, NULL, NULL, NULL, 2, '1', '1', '0', 4.60, 45, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 16:58:59', NULL);
INSERT INTO `hs_homestay` VALUES (30, '000000', 'CS001', 1, 1, '长沙五一广场公寓', '/profile/upload/2024/01/changsha1.jpg', '五一广场商圈核心位置，近橘子洲、岳麓山。美食之都。', '整套公寓', 1, NULL, '湖南省', '长沙', '芙蓉区', '五一广场', NULL, 112.9667000, 28.2000000, 218.00, NULL, NULL, NULL, NULL, 2, '1', '1', '0', 4.50, 67, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (31, '000000', 'CS002', 1, 3, '长沙岳麓山山景民宿', '/profile/upload/2024/01/changsha2.jpg', '岳麓山脚下民宿，近岳麓书院、橘子洲头。书香气息。', '独立房间', 2, NULL, '湖南省', '长沙', '岳麓区', '岳麓山脚下', NULL, 112.9333000, 28.1833000, 278.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.70, 89, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (32, '000000', 'GZ001', 1, 1, '广州天河区精品公寓', '/profile/upload/2024/01/guangzhou1.jpg', '天河商圈核心位置，近珠江新城、广州塔。交通便利。', '整套公寓', 2, NULL, '广东省', '广州', '天河区', '天河路385号', NULL, 113.3200000, 23.1350000, 328.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.60, 112, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (33, '000000', 'GZ002', 1, 2, '广州南沙海景房', '/profile/upload/2024/01/guangzhou2.jpg', '南沙区海景公寓，近南沙湿地公园。周末度假好去处。', '整套公寓', 2, NULL, '广东省', '广州', '南沙区', '南沙海边', NULL, 113.5000000, 22.8000000, 398.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.70, 56, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (34, '000000', 'SZ003', 1, 1, '深圳福田CBD公寓', '/profile/upload/2024/01/shenzhen1.jpg', '福田CBD核心位置，近会展中心、购物公园。商务出差首选。', '整套公寓', 1, NULL, '广东省', '深圳', '福田区', '福田中心区', NULL, 114.0500000, 22.5400000, 358.00, NULL, NULL, NULL, NULL, 2, '1', '1', '0', 4.50, 145, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (35, '000000', 'SZ004', 1, 2, '深圳大梅沙海景别墅', '/profile/upload/2024/01/shenzhen2.jpg', '大梅沙海滨别墅，近海滩、海洋公园。周末度假首选。', '整套别墅', 3, NULL, '广东省', '深圳', '盐田区', '大梅沙海滨', NULL, 114.3000000, 22.5833000, 688.00, NULL, NULL, NULL, NULL, 6, '1', '1', '0', 4.80, 89, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (36, '000000', 'WH001', 1, 6, '武汉东湖湖畔小屋', '/profile/upload/2024/01/wuhan1.jpg', '东湖风景区湖畔小屋，近磨山、樱花园。赏樱胜地。', '整套公寓', 2, NULL, '湖北省', '武汉', '武昌区', '东湖风景区', NULL, 114.4000000, 30.5500000, 298.00, NULL, NULL, NULL, NULL, 4, '1', '1', '0', 4.70, 78, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (37, '000000', 'WH002', 1, 1, '武汉江汉路公寓', '/profile/upload/2024/01/wuhan2.jpg', '江汉路商圈核心位置，近黄鹤楼、长江大桥。交通便利。', '整套公寓', 1, NULL, '湖北省', '武汉', '江汉区', '江汉路步行街', NULL, 114.2800000, 30.5800000, 238.00, NULL, NULL, NULL, NULL, 2, '1', '1', '0', 4.50, 56, '0', NULL, '2026-05-18 23:33:54', NULL, '2026-05-19 17:12:27', NULL);
INSERT INTO `hs_homestay` VALUES (971049, '000000', 'HS2024001', 2012, NULL, '温馨湖景小屋', 'https://js.ccnccn.cn/homestay/1779254855346_z1qb16f6g.jfif', '位于美丽的湖边，环境优美，空气清新，适合家庭度假', '一室一厅', 1, NULL, '湖北省', '武汉市', '洪山区', '东湖绿道旁湖景花园1栋', NULL, 114.3283790, 30.5466430, 288.00, 358.00, NULL, 500.00, NULL, 2, '1', '1', '0', 5.00, 0, '0', NULL, '2026-05-20 13:15:54', 1, '2026-05-20 13:15:54', '');
INSERT INTO `hs_homestay` VALUES (971050, '000000', 'HS2024002', 2012, NULL, '江景豪华公寓', 'https://js.ccnccn.cn/homestay/1779254870917_kjz2t6kou.jfif', '高层江景房，视野开阔，装修豪华，配套齐全', '两室一厅', 2, NULL, '湖北省', '武汉市', '江岸区', '沿江大道188号', NULL, 114.3000000, 30.5800000, 458.00, 588.00, NULL, 800.00, NULL, 4, '1', '1', '0', 5.00, 0, '0', NULL, '2026-05-20 13:15:54', 1, '2026-05-20 13:15:54', '');
INSERT INTO `hs_homestay` VALUES (971051, '000000', 'HS2024003', 2012, NULL, '复古文艺小院', 'https://js.ccnccn.cn/homestay/1779254889568_gjh1exw8q.webp', '老洋房改造，文艺气息浓厚，适合拍照打卡', '独栋', 3, NULL, '湖北省', '武汉市', '江汉区', '江汉路步行街后巷', NULL, 114.2800000, 30.5800000, 688.00, 888.00, NULL, 1000.00, NULL, 6, '1', '1', '0', 5.00, 0, '0', NULL, '2026-05-20 13:15:54', 1, '2026-05-20 13:15:54', '');
INSERT INTO `hs_homestay` VALUES (971052, '000000', 'HS2024004', 2012, NULL, '简约现代LOFT', 'https://js.ccnccn.cn/homestay/1779254913062_6njwuak9h.webp', '工业风设计，挑高空间，年轻人最爱', 'LOFT', 2, NULL, '湖北省', '武汉市', '武昌区', '光谷步行街LOFT公寓', NULL, 114.4200000, 30.5000000, 328.00, 428.00, NULL, 600.00, NULL, 4, '1', '1', '0', 5.00, 0, '0', NULL, '2026-05-20 13:15:54', 1, '2026-05-20 13:15:54', '');
INSERT INTO `hs_homestay` VALUES (971053, '000000', 'HS2024005', 2012, NULL, '花园洋房', 'https://js.ccnccn.cn/homestay/1779254975721_0w68t6ydi.webp', '带私家花园，适合烧烤聚会，亲子活动', '三室两厅', 4, NULL, '湖北省', '武汉市', '汉阳区', '墨水湖畔花园小区', NULL, 114.2200000, 30.5500000, 888.00, 1088.00, NULL, 1500.00, NULL, 8, '1', '1', '0', 5.00, 0, '0', NULL, '2026-05-20 13:15:54', 1, '2026-05-20 13:15:54', '');
INSERT INTO `hs_homestay` VALUES (971054, '000000', 'HS2024006', 2012, NULL, '湖畔木屋', 'https://js.ccnccn.cn/homestay/1779254928666_ior4mk36n.webp', '原木风格，亲近自然，静谧舒适', '木屋', 2, NULL, '湖北省', '武汉市', '东湖高新区', '落雁岛木屋区', NULL, 114.3800000, 30.5200000, 398.00, 498.00, NULL, 700.00, NULL, 4, '1', '1', '0', 5.00, 0, '0', NULL, '2026-05-20 13:15:54', 1, '2026-05-20 13:15:54', '');
INSERT INTO `hs_homestay` VALUES (971055, '000000', 'HS2024007', 2012, NULL, '城市中心公寓', 'https://js.ccnccn.cn/homestay/1779254993260_vb4offr0j.webp', '交通便利，地铁直达，购物方便', '一室一厅', 1, NULL, '湖北省', '武汉市', '洪山区', '街道口地铁站旁', NULL, 114.3500000, 30.5200000, 258.00, 328.00, NULL, 400.00, NULL, 2, '1', '1', '0', 5.00, 0, '0', NULL, '2026-05-20 13:15:54', 1, '2026-05-20 13:15:54', '');
INSERT INTO `hs_homestay` VALUES (971056, '000000', 'HS2024008', 2012, NULL, '山景别墅', 'https://js.ccnccn.cn/homestay/1779254939032_q9tykrajg.webp', '依山而建，视野开阔，空气清新', '别墅', 5, NULL, '湖北省', '武汉市', '新洲区', '道观河风景区', NULL, 114.6800000, 30.8500000, 1288.00, 1588.00, NULL, 2000.00, NULL, 10, '1', '1', '0', 5.00, 0, '0', NULL, '2026-05-20 13:15:54', 1, '2026-05-20 13:15:54', '');
INSERT INTO `hs_homestay` VALUES (971057, '000000', 'HS2024009', 2012, NULL, '文艺书店民宿', 'https://js.ccnccn.cn/homestay/1779254955576_fak7w5bt3.webp', '书香气息，适合静心阅读', '一室一厅', 1, NULL, '湖北省', '武汉市', '武昌区', '昙华林文化街', NULL, 114.3000000, 30.5500000, 298.00, 378.00, NULL, 500.00, NULL, 2, '1', '1', '0', 5.00, 0, '0', NULL, '2026-05-20 13:15:54', 1, '2026-05-20 13:15:54', '');
INSERT INTO `hs_homestay` VALUES (971058, '000000', 'HS2024010', 2012, NULL, '网红ins风民宿', 'https://js.ccnccn.cn/homestay/1779255009205_78nxyzom0.webp', '网红装修风格，拍照出片', '一室一厅', 1, NULL, '湖北省', '武汉市', '江岸区', '黎黄陂路', NULL, 114.2800000, 30.5800000, 338.00, 438.00, NULL, 600.00, NULL, 2, '0', '0', '0', 5.00, 0, '0', NULL, '2026-05-20 13:15:54', 2012, '2026-05-20 13:15:54', NULL);
INSERT INTO `hs_homestay` VALUES (971059, '000000', 'HS2024011', 2012, NULL, '亲子主题房', 'https://js.ccnccn.cn/homestay/1779254833140_lnarr8bn0.webp', '儿童主题装修，玩具齐全', '两室一厅', 2, NULL, '湖北省', '武汉市', '东西湖区', '金银潭万达旁', NULL, 114.2500000, 30.6200000, 368.00, 468.00, NULL, 600.00, NULL, 4, '0', '0', '0', 5.00, 0, '0', NULL, '2026-05-20 13:15:54', 2012, '2026-05-20 13:15:54', NULL);
INSERT INTO `hs_homestay` VALUES (971060, '000000', 'HS2024012', 2012, NULL, '商务行政套房', 'https://js.ccnccn.cn/homestay/1779254813707_y6vce9kfi.webp', '适合商务出差，办公设施齐全', '套房', 1, NULL, '湖北省', '武汉市', '江汉区', '武广商圈', NULL, 114.2800000, 30.5800000, 488.00, 588.00, NULL, 800.00, NULL, 2, '0', '0', '0', 5.00, 0, '0', NULL, '2026-05-20 13:15:54', 2012, '2026-05-20 13:15:54', NULL);
INSERT INTO `hs_homestay` VALUES (971085, '000000', 'HS20260520141622777430', 2012, NULL, '网红ins风民宿', 'https://js.ccnccn.cn/homestay/1779257778947_4yf2vcmh6.webp', '\n这是一间专为拍照打卡和放松身心设计的ins风小屋。整体采用奶油色系搭配藤编、棉麻材质，氛围温柔安静。\n\n房间亮点：\n\n配有日落氛围灯、大叶绿植、百叶窗，光影效果极佳；\n\n舒适双人床，搭配高支数纯棉床品，保证睡眠质量；\n\n提供高清投影仪，可窝在床上看电影；\n\n房间内设有全身镜、编织地毯、ins风装饰画，随手一拍都是大片；\n\n提供免费WiFi、空调、24小时热水、一次性洗漱用品。\n\n适合人群： 情侣出游、闺蜜旅行、喜欢拍照的年轻人。\n\n注意： 全屋禁烟，请勿携带宠物。', '整套公寓', 1, '1.8m大床×1', '湖北省', '武汉市', '洪山区', '黎黄陂路', NULL, 114.3074130, 30.4799860, 199.00, 259.00, 40.00, 80.00, NULL, 2, '1', '2', '0', 5.00, 0, '0', 2012, '2026-05-20 14:16:22', 2012, '2026-05-20 14:16:22', '');
INSERT INTO `hs_homestay` VALUES (971086, '000000', 'HS20260520145107060968', 2012, NULL, '网红ins风民宿', 'https://js.ccnccn.cn/homestay/1779259863102_7il6ufcb5.webp', '这是一间专为拍照打卡和放松身心设计的ins风小屋。整体采用奶油色系搭配藤编、棉麻材质，氛围温柔安静。\n\n房间亮点：\n\n配有日落氛围灯、大叶绿植、百叶窗，光影效果极佳；\n\n舒适双人床，搭配高支数纯棉床品，保证睡眠质量；\n\n提供高清投影仪，可窝在床上看电影；\n\n房间内设有全身镜、编织地毯、ins风装饰画，随手一拍都是大片；\n\n提供免费WiFi、空调、24小时热水、一次性洗漱用品。\n\n适合人群： 情侣出游、闺蜜旅行、喜欢拍照的年轻人。\n\n注意： 全屋禁烟，请勿携带宠物。\n', '整套公寓', 1, '', '湖北省', '武汉市', '洪山区', '湖北工业大学工程技术学院', NULL, 114.3074180, 30.4800110, 199.00, 259.00, 40.00, 80.00, NULL, 2, '1', '2', '0', 5.00, 1, '0', 2012, '2026-05-20 14:51:07', 2012, '2026-05-20 14:59:47', '');

-- ----------------------------
-- Table structure for hs_homestay_facility
-- ----------------------------
DROP TABLE IF EXISTS `hs_homestay_facility`;
CREATE TABLE `hs_homestay_facility`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'pk',
  `homestay_id` bigint(0) NOT NULL COMMENT '房源 ID',
  `facility_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设施编码',
  `facility_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设施名称',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_hs_facility`(`homestay_id`, `facility_code`) USING BTREE,
  INDEX `idx_hs_facility_homestay`(`homestay_id`) USING BTREE,
  INDEX `idx_facility_homestay`(`homestay_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '房源设施关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_homestay_facility
-- ----------------------------

-- ----------------------------
-- Table structure for hs_homestay_image
-- ----------------------------
DROP TABLE IF EXISTS `hs_homestay_image`;
CREATE TABLE `hs_homestay_image`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'pk',
  `homestay_id` bigint(0) NOT NULL COMMENT '房源 ID',
  `image_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '图片 URL',
  `sort_order` int(0) NOT NULL DEFAULT 0 COMMENT '排序',
  `is_cover` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '是否封面',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hs_image_homestay`(`homestay_id`) USING BTREE,
  INDEX `idx_hs_image_cover`(`homestay_id`, `is_cover`) USING BTREE,
  INDEX `idx_image_homestay`(`homestay_id`) USING BTREE,
  INDEX `idx_image_homestay_sort`(`homestay_id`, `sort_order`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '房源图片表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_homestay_image
-- ----------------------------

-- ----------------------------
-- Table structure for hs_homestay_tag
-- ----------------------------
DROP TABLE IF EXISTS `hs_homestay_tag`;
CREATE TABLE `hs_homestay_tag`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `homestay_id` bigint(0) NOT NULL,
  `tag_id` bigint(0) NOT NULL,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_homestay_tag`(`homestay_id`, `tag_id`) USING BTREE,
  INDEX `idx_tag_id`(`tag_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 108 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '房源标签关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_homestay_tag
-- ----------------------------
INSERT INTO `hs_homestay_tag` VALUES (1, 1, 1, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (2, 1, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (3, 1, 9, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (4, 1, 10, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (5, 2, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (6, 2, 3, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (7, 2, 5, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (8, 3, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (9, 3, 4, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (10, 4, 1, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (11, 4, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (12, 4, 9, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (13, 5, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (14, 5, 3, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (15, 5, 2, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (16, 6, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (17, 6, 2, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (18, 6, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (19, 7, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (20, 7, 4, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (21, 8, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (22, 8, 4, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (23, 8, 5, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (24, 9, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (25, 9, 4, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (26, 9, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (27, 10, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (28, 10, 6, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (29, 10, 2, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (30, 11, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (31, 11, 4, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (32, 11, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (33, 12, 1, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (34, 12, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (35, 12, 9, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (36, 13, 2, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (37, 13, 3, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (38, 13, 6, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (39, 14, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (40, 14, 4, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (41, 15, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (42, 15, 3, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (43, 16, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (44, 16, 4, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (45, 17, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (46, 17, 3, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (47, 17, 2, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (48, 18, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (49, 18, 4, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (50, 18, 5, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (51, 19, 1, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (52, 19, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (53, 19, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (54, 20, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (55, 20, 2, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (56, 20, 6, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (57, 21, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (58, 21, 3, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (59, 22, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (60, 22, 4, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (61, 22, 5, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (62, 22, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (63, 23, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (64, 23, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (65, 23, 9, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (66, 24, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (67, 24, 4, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (68, 25, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (69, 25, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (70, 25, 9, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (71, 26, 1, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (72, 26, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (73, 26, 9, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (74, 27, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (75, 27, 4, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (76, 27, 5, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (77, 28, 2, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (78, 28, 3, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (79, 28, 6, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (80, 29, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (81, 29, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (82, 29, 9, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (83, 30, 1, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (84, 30, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (85, 30, 9, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (86, 31, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (87, 31, 2, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (88, 31, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (89, 32, 1, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (90, 32, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (91, 32, 9, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (92, 32, 10, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (93, 33, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (94, 33, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (95, 33, 9, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (96, 34, 1, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (97, 34, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (98, 34, 9, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (99, 35, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (100, 35, 4, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (101, 35, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (102, 36, 7, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (103, 36, 2, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (104, 36, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (105, 37, 1, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (106, 37, 8, '2026-05-18 23:33:54');
INSERT INTO `hs_homestay_tag` VALUES (107, 37, 9, '2026-05-18 23:33:54');

-- ----------------------------
-- Table structure for hs_message
-- ----------------------------
DROP TABLE IF EXISTS `hs_message`;
CREATE TABLE `hs_message`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'pk',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '000000',
  `receiver_user_id` bigint(0) NOT NULL,
  `msg_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1' COMMENT '1-system 2-order 3-audit 4-supervision',
  `title` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `related_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_read` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `read_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hs_msg_receiver`(`receiver_user_id`, `is_read`, `create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 975148 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'in-app message table' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_message
-- ----------------------------
INSERT INTO `hs_message` VALUES (975019, '000000', 2002, '1', 'Welcome', 'You can create and pay orders in this demo system.', NULL, '0', '2026-02-25 14:24:36', NULL);
INSERT INTO `hs_message` VALUES (975020, '000000', 2001, '2', 'Paid order created', 'Demo paid order ODDEMO0001 is ready for confirm/reject.', 'ODDEMO0001', '0', '2026-02-25 14:24:36', NULL);
INSERT INTO `hs_message` VALUES (975021, '000000', 2002, '2', 'order confirmed', 'landlord confirmed: ODDEMO0001', 'ODDEMO0001', '0', '2026-02-25 20:17:20', NULL);
INSERT INTO `hs_message` VALUES (975022, '000000', 2002, '2', 'order confirmed', 'landlord confirmed: ODZH600008', 'ODZH600008', '0', '2026-02-25 21:28:35', NULL);
INSERT INTO `hs_message` VALUES (975023, '000000', 2001, '2', 'new booking', 'new order: OD20260225221500906933', 'OD20260225221500906933', '0', '2026-02-25 22:15:00', NULL);
INSERT INTO `hs_message` VALUES (975024, '000000', 2001, '2', 'order paid', 'order paid: OD20260225221500906933', 'OD20260225221500906933', '0', '2026-02-25 22:15:04', NULL);
INSERT INTO `hs_message` VALUES (975025, '000000', 2001, '2', 'new booking', 'new order: OD20260225233821385946', 'OD20260225233821385946', '0', '2026-02-25 23:38:21', NULL);
INSERT INTO `hs_message` VALUES (975026, '000000', 2001, '2', 'order paid', 'order paid: OD20260225233821385946', 'OD20260225233821385946', '0', '2026-02-25 23:38:28', NULL);
INSERT INTO `hs_message` VALUES (975027, '000000', 2001, '2', 'order cancelled', 'order cancelled: OD20260225233821385946', 'OD20260225233821385946', '0', '2026-02-25 23:38:50', NULL);
INSERT INTO `hs_message` VALUES (975028, '000000', 2001, '2', 'new booking', 'new order: OD20260225233916091960', 'OD20260225233916091960', '0', '2026-02-25 23:39:16', NULL);
INSERT INTO `hs_message` VALUES (975029, '000000', 2001, '2', 'order paid', 'order paid: OD20260225233916091960', 'OD20260225233916091960', '0', '2026-02-25 23:39:17', NULL);
INSERT INTO `hs_message` VALUES (975030, '000000', 2002, '2', 'order confirmed', 'landlord confirmed: OD20260225233916091960', 'OD20260225233916091960', '0', '2026-02-28 10:04:19', NULL);
INSERT INTO `hs_message` VALUES (975031, '000000', 2002, '2', 'order rejected', 'landlord rejected: OD20260225221500906933', 'OD20260225221500906933', '0', '2026-02-28 10:04:27', NULL);
INSERT INTO `hs_message` VALUES (975032, '000000', 2001, '2', 'order cancelled', 'order cancelled: ODZH600002', 'ODZH600002', '0', '2026-02-28 15:41:26', NULL);
INSERT INTO `hs_message` VALUES (975033, '000000', 2001, '2', 'new booking', 'new order: OD20260305132759367527', 'OD20260305132759367527', '0', '2026-03-05 13:27:59', NULL);
INSERT INTO `hs_message` VALUES (975034, '000000', 2001, '2', 'new booking', 'new order: OD20260305153843625911', 'OD20260305153843625911', '0', '2026-03-05 15:38:43', NULL);
INSERT INTO `hs_message` VALUES (975035, '000000', 2001, '2', 'order cancelled', 'order cancelled: OD20260305132759367527', 'OD20260305132759367527', '0', '2026-03-05 16:13:25', NULL);
INSERT INTO `hs_message` VALUES (975036, '000000', 2001, '2', 'new booking', 'new order: OD20260305181543846372', 'OD20260305181543846372', '0', '2026-03-05 18:15:43', NULL);
INSERT INTO `hs_message` VALUES (975037, '000000', 2001, '2', 'new booking', 'new order: OD20260305182329538220', 'OD20260305182329538220', '0', '2026-03-05 18:23:29', NULL);
INSERT INTO `hs_message` VALUES (975038, '000000', 2001, '2', 'order paid', 'order paid: OD20260305182329538220', 'OD20260305182329538220', '0', '2026-03-05 18:23:31', NULL);
INSERT INTO `hs_message` VALUES (975039, '000000', 1, '2', 'order confirmed', 'landlord confirmed: OD20260305182329538220', 'OD20260305182329538220', '0', '2026-03-05 18:23:56', NULL);
INSERT INTO `hs_message` VALUES (975040, '000000', 2001, '2', 'new booking', 'new order: OD20260305193601721579', 'OD20260305193601721579', '0', '2026-03-05 19:36:01', NULL);
INSERT INTO `hs_message` VALUES (975041, '000000', 2001, '2', 'order paid', 'order paid: OD20260305193601721579', 'OD20260305193601721579', '0', '2026-03-05 19:36:03', NULL);
INSERT INTO `hs_message` VALUES (975042, '000000', 1, '2', 'order confirmed', 'landlord confirmed: OD20260305193601721579', 'OD20260305193601721579', '1', '2026-03-05 19:36:18', '2026-03-05 21:27:06');
INSERT INTO `hs_message` VALUES (975043, '000000', 2001, '2', 'order cancelled', 'order cancelled: OD20260305193601721579', 'OD20260305193601721579', '0', '2026-03-05 21:21:11', NULL);
INSERT INTO `hs_message` VALUES (975044, '000000', 2001, '2', '新订单通知', '新订单：OD20260307111032900728', 'OD20260307111032900728', '0', '2026-03-07 11:10:32', NULL);
INSERT INTO `hs_message` VALUES (975045, '000000', 2001, '2', '订单已支付', '订单已支付：OD20260307111032900728', 'OD20260307111032900728', '0', '2026-03-07 11:10:37', NULL);
INSERT INTO `hs_message` VALUES (975046, '000000', 2003, '2', '订单已确认', '房东已确认：OD20260307111032900728', 'OD20260307111032900728', '1', '2026-03-07 11:11:06', '2026-03-07 11:12:09');
INSERT INTO `hs_message` VALUES (975047, '000000', 2001, '2', '租客已入住', '租客已确认入住：OD20260307111032900728', 'OD20260307111032900728', '0', '2026-03-07 11:11:29', NULL);
INSERT INTO `hs_message` VALUES (975048, '000000', 2001, '2', '新订单通知', '新订单：OD20260307195030183112', 'OD20260307195030183112', '0', '2026-03-07 19:50:30', NULL);
INSERT INTO `hs_message` VALUES (975049, '000000', 2001, '2', '订单已支付', '订单已支付：OD20260307195030183112', 'OD20260307195030183112', '0', '2026-03-07 19:50:31', NULL);
INSERT INTO `hs_message` VALUES (975050, '000000', 2003, '2', '订单已确认', '房东已确认：OD20260307195030183112', 'OD20260307195030183112', '1', '2026-03-07 19:50:43', '2026-05-19 23:56:25');
INSERT INTO `hs_message` VALUES (975051, '000000', 2001, '2', '租客已入住', '租客已确认入住：OD20260307195030183112', 'OD20260307195030183112', '0', '2026-03-07 19:51:00', NULL);
INSERT INTO `hs_message` VALUES (975052, '000000', 1, '2', '新订单通知', '新订单：OD20260518211104337366', 'OD20260518211104337366', '0', '2026-05-18 21:11:04', NULL);
INSERT INTO `hs_message` VALUES (975053, '000000', 1, '2', '新订单通知', '新订单：OD20260518222218859105', 'OD20260518222218859105', '0', '2026-05-18 22:22:18', NULL);
INSERT INTO `hs_message` VALUES (975054, '000000', 2001, '2', '新订单通知', '新订单：OD20260518222730298688', 'OD20260518222730298688', '0', '2026-05-18 22:27:30', NULL);
INSERT INTO `hs_message` VALUES (975055, '000000', 1, '2', '新订单通知', '新订单：OD20260518223646223645', 'OD20260518223646223645', '0', '2026-05-18 22:36:46', NULL);
INSERT INTO `hs_message` VALUES (975056, '000000', 1, '2', '新订单通知', '新订单：OD20260518223804167498', 'OD20260518223804167498', '0', '2026-05-18 22:38:04', NULL);
INSERT INTO `hs_message` VALUES (975057, '000000', 1, '2', '订单已支付', '订单已支付：OD20260518223804167498', 'OD20260518223804167498', '0', '2026-05-18 22:49:14', NULL);
INSERT INTO `hs_message` VALUES (975058, '000000', 2001, '2', '新订单通知', '新订单：OD20260518225310565705', 'OD20260518225310565705', '0', '2026-05-18 22:53:10', NULL);
INSERT INTO `hs_message` VALUES (975059, '000000', 2001, '2', '订单已取消', '订单已取消：ODZH600007', 'ODZH600007', '0', '2026-05-18 22:57:11', NULL);
INSERT INTO `hs_message` VALUES (975060, '000000', 2001, '2', '订单已取消', '订单已取消：ODZH600013', 'ODZH600013', '0', '2026-05-18 22:57:13', NULL);
INSERT INTO `hs_message` VALUES (975061, '000000', 2001, '2', '订单已取消', '订单已取消：ODZH600019', 'ODZH600019', '0', '2026-05-18 22:57:14', NULL);
INSERT INTO `hs_message` VALUES (975062, '000000', 2001, '2', '订单已取消', '订单已取消：ODZH600025', 'ODZH600025', '0', '2026-05-18 22:57:14', NULL);
INSERT INTO `hs_message` VALUES (975063, '000000', 2001, '2', '订单已取消', '订单已取消：ODZH600031', 'ODZH600031', '0', '2026-05-18 22:57:14', NULL);
INSERT INTO `hs_message` VALUES (975064, '000000', 2007, '2', '订单已确认', '房东已确认：OD20260518223804167498', 'OD20260518223804167498', '1', '2026-05-18 22:58:17', '2026-05-18 23:18:00');
INSERT INTO `hs_message` VALUES (975065, '000000', 2002, '2', '订单已确认', '房东已确认：ODZH600014', 'ODZH600014', '0', '2026-05-18 22:58:19', NULL);
INSERT INTO `hs_message` VALUES (975066, '000000', 2002, '2', '订单已确认', '房东已确认：ODZH600056', 'ODZH600056', '0', '2026-05-18 22:58:19', NULL);
INSERT INTO `hs_message` VALUES (975067, '000000', 2002, '2', '订单已确认', '房东已确认：ODZH600050', 'ODZH600050', '0', '2026-05-18 22:58:20', NULL);
INSERT INTO `hs_message` VALUES (975068, '000000', 2002, '2', '订单已确认', '房东已确认：ODZH600044', 'ODZH600044', '0', '2026-05-18 22:58:21', NULL);
INSERT INTO `hs_message` VALUES (975069, '000000', 2001, '2', '订单已取消', '订单已取消：ODZH600037', 'ODZH600037', '0', '2026-05-18 22:58:29', NULL);
INSERT INTO `hs_message` VALUES (975070, '000000', 2001, '2', '订单已取消', '订单已取消：ODZH600043', 'ODZH600043', '0', '2026-05-18 22:58:29', NULL);
INSERT INTO `hs_message` VALUES (975071, '000000', 2001, '2', '订单已取消', '订单已取消：ODZH600049', 'ODZH600049', '0', '2026-05-18 22:58:29', NULL);
INSERT INTO `hs_message` VALUES (975072, '000000', 2001, '2', '订单已取消', '订单已取消：ODZH600001', 'ODZH600001', '0', '2026-05-18 22:58:31', NULL);
INSERT INTO `hs_message` VALUES (975073, '000000', 1, '2', '订单已取消', '订单已取消：OD20260518211104337366', 'OD20260518211104337366', '0', '2026-05-18 22:58:37', NULL);
INSERT INTO `hs_message` VALUES (975074, '000000', 2001, '2', '订单已取消', '订单已取消：OD20260518225310565705', 'OD20260518225310565705', '0', '2026-05-19 00:00:45', NULL);
INSERT INTO `hs_message` VALUES (975075, '000000', 1, '2', '新订单通知', '新订单：OD20260519133644904949', 'OD20260519133644904949', '0', '2026-05-19 13:36:44', NULL);
INSERT INTO `hs_message` VALUES (975076, '000000', 1, '2', '新订单通知', '新订单：OD20260519134320504608', 'OD20260519134320504608', '0', '2026-05-19 13:43:20', NULL);
INSERT INTO `hs_message` VALUES (975077, '000000', 1, '2', '新订单通知', '新订单：OD20260519140105650503', 'OD20260519140105650503', '0', '2026-05-19 14:01:05', NULL);
INSERT INTO `hs_message` VALUES (975078, '000000', 1, '2', '新订单通知', '新订单：OD20260519140526503205', 'OD20260519140526503205', '0', '2026-05-19 14:05:26', NULL);
INSERT INTO `hs_message` VALUES (975079, '000000', 1, '2', '新订单通知', '新订单：OD20260519145529103886', 'OD20260519145529103886', '0', '2026-05-19 14:55:29', NULL);
INSERT INTO `hs_message` VALUES (975080, '000000', 1, '2', '新订单通知', '新订单：OD20260519150256163941', 'OD20260519150256163941', '0', '2026-05-19 15:02:56', NULL);
INSERT INTO `hs_message` VALUES (975081, '000000', 1, '2', '新订单通知', '新订单：OD20260519150844127630', 'OD20260519150844127630', '0', '2026-05-19 15:08:44', NULL);
INSERT INTO `hs_message` VALUES (975082, '000000', 1, '2', '新订单通知', '新订单：OD20260519151038954511', 'OD20260519151038954511', '0', '2026-05-19 15:10:38', NULL);
INSERT INTO `hs_message` VALUES (975083, '000000', 1, '2', '新订单通知', '新订单：OD20260519151359812869', 'OD20260519151359812869', '0', '2026-05-19 15:13:59', NULL);
INSERT INTO `hs_message` VALUES (975084, '000000', 1, '2', '新订单通知', '新订单：OD20260519151642773270', 'OD20260519151642773270', '0', '2026-05-19 15:16:42', NULL);
INSERT INTO `hs_message` VALUES (975085, '000000', 1, '2', '新订单通知', '新订单：OD20260519151827433363', 'OD20260519151827433363', '0', '2026-05-19 15:18:27', NULL);
INSERT INTO `hs_message` VALUES (975086, '000000', 1, '2', '新订单通知', '新订单：OD20260519152920672228', 'OD20260519152920672228', '0', '2026-05-19 15:29:20', NULL);
INSERT INTO `hs_message` VALUES (975087, '000000', 1, '2', '新订单通知', '新订单：OD20260519154632463977', 'OD20260519154632463977', '0', '2026-05-19 15:46:32', NULL);
INSERT INTO `hs_message` VALUES (975088, '000000', 1, '2', '新订单通知', '新订单：OD20260519160104095541', 'OD20260519160104095541', '0', '2026-05-19 16:01:04', NULL);
INSERT INTO `hs_message` VALUES (975089, '000000', 1, '2', '订单已取消', '订单已取消：OD20260519160104095541', 'OD20260519160104095541', '0', '2026-05-19 16:03:46', NULL);
INSERT INTO `hs_message` VALUES (975090, '000000', 2001, '2', '订单已取消', '订单已取消：ODZH600055', 'ODZH600055', '0', '2026-05-19 16:42:18', NULL);
INSERT INTO `hs_message` VALUES (975091, '000000', 2001, '2', '订单已取消', '订单已取消：OD20260305153843625911', 'OD20260305153843625911', '0', '2026-05-19 16:42:18', NULL);
INSERT INTO `hs_message` VALUES (975092, '000000', 2001, '2', '订单已取消', '订单已取消：OD20260305181543846372', 'OD20260305181543846372', '0', '2026-05-19 16:43:07', NULL);
INSERT INTO `hs_message` VALUES (975093, '000000', 2002, '2', '订单已确认', '房东已确认：ODZH600038', 'ODZH600038', '0', '2026-05-19 16:43:14', NULL);
INSERT INTO `hs_message` VALUES (975094, '000000', 1, '2', '订单已取消', '订单已取消：OD20260518222218859105', 'OD20260518222218859105', '0', '2026-05-19 16:43:20', NULL);
INSERT INTO `hs_message` VALUES (975095, '000000', 2001, '2', '订单已取消', '订单已取消：OD20260518222730298688', 'OD20260518222730298688', '0', '2026-05-19 16:43:20', NULL);
INSERT INTO `hs_message` VALUES (975096, '000000', 1, '2', '订单已取消', '订单已取消：OD20260518223646223645', 'OD20260518223646223645', '0', '2026-05-19 16:43:21', NULL);
INSERT INTO `hs_message` VALUES (975097, '000000', 1, '2', '订单已取消', '订单已取消：OD20260519133644904949', 'OD20260519133644904949', '0', '2026-05-19 16:43:21', NULL);
INSERT INTO `hs_message` VALUES (975098, '000000', 1, '2', '订单已取消', '订单已取消：OD20260519134320504608', 'OD20260519134320504608', '0', '2026-05-19 16:43:21', NULL);
INSERT INTO `hs_message` VALUES (975099, '000000', 1, '2', '订单已取消', '订单已取消：OD20260519140105650503', 'OD20260519140105650503', '0', '2026-05-19 16:43:22', NULL);
INSERT INTO `hs_message` VALUES (975100, '000000', 1, '2', '订单已取消', '订单已取消：OD20260519140526503205', 'OD20260519140526503205', '0', '2026-05-19 16:43:22', NULL);
INSERT INTO `hs_message` VALUES (975101, '000000', 1, '2', '订单已取消', '订单已取消：OD20260519145529103886', 'OD20260519145529103886', '0', '2026-05-19 16:43:34', NULL);
INSERT INTO `hs_message` VALUES (975102, '000000', 1, '2', '订单已取消', '订单已取消：OD20260519150256163941', 'OD20260519150256163941', '0', '2026-05-19 16:43:35', NULL);
INSERT INTO `hs_message` VALUES (975103, '000000', 1, '2', '新订单通知', '新订单：OD20260519173758068299', 'OD20260519173758068299', '0', '2026-05-19 17:37:58', NULL);
INSERT INTO `hs_message` VALUES (975104, '000000', 1, '2', '租客已入住', '租客已确认入住：OD20260519173758068299', 'OD20260519173758068299', '0', '2026-05-19 17:40:14', NULL);
INSERT INTO `hs_message` VALUES (975105, '000000', 1, '2', '租客已退房', '租客已退房：OD20260519173758068299', 'OD20260519173758068299', '0', '2026-05-19 17:40:21', NULL);
INSERT INTO `hs_message` VALUES (975106, '000000', 1, '2', '新订单通知', '新订单：OD20260519211829243254', 'OD20260519211829243254', '0', '2026-05-19 21:18:29', NULL);
INSERT INTO `hs_message` VALUES (975107, '000000', 1, '2', '新订单通知', '新订单：OD20260519233300462983', 'OD20260519233300462983', '0', '2026-05-19 23:33:00', NULL);
INSERT INTO `hs_message` VALUES (975108, '000000', 1, '2', '新订单通知', '新订单：OD20260519233858276310', 'OD20260519233858276310', '0', '2026-05-19 23:38:58', NULL);
INSERT INTO `hs_message` VALUES (975109, '000000', 1, '2', '新订单通知', '新订单：OD20260519235100453788', 'OD20260519235100453788', '0', '2026-05-19 23:51:00', NULL);
INSERT INTO `hs_message` VALUES (975110, '000000', 1, '2', '新订单通知', '新订单：OD20260519235257316648', 'OD20260519235257316648', '0', '2026-05-19 23:52:57', NULL);
INSERT INTO `hs_message` VALUES (975111, '000000', 2001, '2', '新订单通知', '新订单：OD20260520045932296940', 'OD20260520045932296940', '0', '2026-05-20 04:59:32', NULL);
INSERT INTO `hs_message` VALUES (975112, '000000', 2001, '2', '订单已支付', '订单已支付：OD20260520045932296940', 'OD20260520045932296940', '0', '2026-05-20 04:59:38', NULL);
INSERT INTO `hs_message` VALUES (975113, '000000', 2001, '2', '新订单通知', '新订单：OD20260520050157024551', 'OD20260520050157024551', '0', '2026-05-20 05:01:57', NULL);
INSERT INTO `hs_message` VALUES (975114, '000000', 2001, '2', '租客已入住', '租客已确认入住：OD20260520050157024551', 'OD20260520050157024551', '0', '2026-05-20 05:03:06', NULL);
INSERT INTO `hs_message` VALUES (975115, '000000', 1, '2', '新订单通知', '新订单：OD20260520050727629500', 'OD20260520050727629500', '0', '2026-05-20 05:07:27', NULL);
INSERT INTO `hs_message` VALUES (975116, '000000', 2011, '2', '新订单通知', '新订单：OD20260520054827864566', 'OD20260520054827864566', '0', '2026-05-20 05:48:27', NULL);
INSERT INTO `hs_message` VALUES (975117, '000000', 2011, '2', '租客已入住', '租客已确认入住：OD20260520054827864566', 'OD20260520054827864566', '0', '2026-05-20 05:52:46', NULL);
INSERT INTO `hs_message` VALUES (975118, '000000', 2011, '2', '租客已退房', '租客已退房：OD20260520054827864566', 'OD20260520054827864566', '0', '2026-05-20 06:27:08', NULL);
INSERT INTO `hs_message` VALUES (975119, '000000', 2011, '2', '新订单通知', '新订单：OD20260520071422868628', 'OD20260520071422868628', '0', '2026-05-20 07:14:22', NULL);
INSERT INTO `hs_message` VALUES (975120, '000000', 2011, '2', '订单已支付', '订单已支付：OD20260520071422868628', 'OD20260520071422868628', '0', '2026-05-20 07:14:24', NULL);
INSERT INTO `hs_message` VALUES (975121, '000000', 2011, '2', '订单已确认', '房东已确认：OD20260520071422868628', 'OD20260520071422868628', '0', '2026-05-20 07:14:39', NULL);
INSERT INTO `hs_message` VALUES (975122, '000000', 2011, '2', '租客已入住', '租客已确认入住：OD20260520071422868628', 'OD20260520071422868628', '0', '2026-05-20 07:14:51', NULL);
INSERT INTO `hs_message` VALUES (975123, '000000', 2007, '2', '订单已确认', '房东已确认：OD20260520045932296940', 'OD20260520045932296940', '0', '2026-05-20 07:15:17', NULL);
INSERT INTO `hs_message` VALUES (975124, '000000', 2002, '2', '订单已确认', '房东已确认：ODTEST003', 'ODTEST003', '0', '2026-05-20 07:15:28', NULL);
INSERT INTO `hs_message` VALUES (975125, '000000', 2011, '2', '新订单通知', '新订单：OD20260520071704898377', 'OD20260520071704898377', '0', '2026-05-20 07:17:04', NULL);
INSERT INTO `hs_message` VALUES (975126, '000000', 2011, '2', '订单已支付', '订单已支付：OD20260520071704898377', 'OD20260520071704898377', '0', '2026-05-20 07:17:08', NULL);
INSERT INTO `hs_message` VALUES (975127, '000000', 2001, '2', '新订单通知', '新订单：OD20260520071812222416', 'OD20260520071812222416', '0', '2026-05-20 07:18:12', NULL);
INSERT INTO `hs_message` VALUES (975128, '000000', 2001, '2', '新订单通知', '新订单：OD20260520094843088152', 'OD20260520094843088152', '0', '2026-05-20 09:48:43', NULL);
INSERT INTO `hs_message` VALUES (975129, '000000', 2001, '2', '订单已支付', '订单已支付：OD20260520094843088152', 'OD20260520094843088152', '0', '2026-05-20 09:48:57', NULL);
INSERT INTO `hs_message` VALUES (975130, '000000', 2011, '2', '新订单通知', '新订单：OD20260520095040306815', 'OD20260520095040306815', '0', '2026-05-20 09:50:40', NULL);
INSERT INTO `hs_message` VALUES (975131, '000000', 2011, '2', '订单已支付', '订单已支付：OD20260520095040306815', 'OD20260520095040306815', '0', '2026-05-20 09:50:42', NULL);
INSERT INTO `hs_message` VALUES (975132, '000000', 2007, '2', '订单已确认', '房东已确认：OD20260520095040306815', 'OD20260520095040306815', '0', '2026-05-20 09:51:19', NULL);
INSERT INTO `hs_message` VALUES (975133, '000000', 2011, '2', '新订单通知', '新订单：OD20260520095252356379', 'OD20260520095252356379', '0', '2026-05-20 09:52:52', NULL);
INSERT INTO `hs_message` VALUES (975134, '000000', 2011, '2', '订单已支付', '订单已支付：OD20260520095252356379', 'OD20260520095252356379', '0', '2026-05-20 09:52:55', NULL);
INSERT INTO `hs_message` VALUES (975135, '000000', 2011, '2', '订单已确认', '房东已确认：OD20260520095252356379', 'OD20260520095252356379', '0', '2026-05-20 09:53:10', NULL);
INSERT INTO `hs_message` VALUES (975136, '000000', 2011, '2', '租客已入住', '租客已确认入住：OD20260520095252356379', 'OD20260520095252356379', '0', '2026-05-20 09:53:19', NULL);
INSERT INTO `hs_message` VALUES (975137, '000000', 2011, '2', '租客已退房', '租客已退房：OD20260520095252356379，已创建清洁任务', 'OD20260520095252356379', '0', '2026-05-20 09:53:30', NULL);
INSERT INTO `hs_message` VALUES (975138, '000000', 2012, '2', '新订单通知', '新订单：OD20260520141825187794', 'OD20260520141825187794', '0', '2026-05-20 14:18:25', NULL);
INSERT INTO `hs_message` VALUES (975139, '000000', 2012, '2', '租客已入住', '租客已确认入住：OD20260520141825187794', 'OD20260520141825187794', '0', '2026-05-20 14:19:21', NULL);
INSERT INTO `hs_message` VALUES (975140, '000000', 2012, '2', '租客已退房', '租客已退房：OD20260520141825187794，已创建清洁任务', 'OD20260520141825187794', '0', '2026-05-20 14:23:41', NULL);
INSERT INTO `hs_message` VALUES (975141, '000000', 2012, '2', '新订单通知', '新订单：OD20260520145532416860', 'OD20260520145532416860', '0', '2026-05-20 14:55:32', NULL);
INSERT INTO `hs_message` VALUES (975142, '000000', 2012, '2', '新订单通知', '新订单：OD20260520145826793309', 'OD20260520145826793309', '0', '2026-05-20 14:58:26', NULL);
INSERT INTO `hs_message` VALUES (975143, '000000', 2012, '2', '订单已支付', '订单已支付：OD20260520145826793309', 'OD20260520145826793309', '0', '2026-05-20 14:58:30', NULL);
INSERT INTO `hs_message` VALUES (975144, '000000', 2007, '2', '订单已确认', '房东已确认：OD20260520145826793309', 'OD20260520145826793309', '0', '2026-05-20 14:58:52', NULL);
INSERT INTO `hs_message` VALUES (975145, '000000', 2012, '2', '租客已入住', '租客已确认入住：OD20260520145826793309', 'OD20260520145826793309', '0', '2026-05-20 14:59:13', NULL);
INSERT INTO `hs_message` VALUES (975146, '000000', 2012, '2', '租客已退房', '租客已退房：OD20260520145826793309，已创建清洁任务', 'OD20260520145826793309', '0', '2026-05-20 14:59:21', NULL);
INSERT INTO `hs_message` VALUES (975147, '000000', 2012, '2', '新订单通知', '新订单：OD20260522091511283558', 'OD20260522091511283558', '0', '2026-05-22 09:15:11', NULL);

-- ----------------------------
-- Table structure for hs_order
-- ----------------------------
DROP TABLE IF EXISTS `hs_order`;
CREATE TABLE `hs_order`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'pk',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '000000',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'biz id, ODxxxx',
  `homestay_id` bigint(0) NOT NULL,
  `tenant_user_id` bigint(0) NOT NULL COMMENT 'renter user_id',
  `landlord_user_id` bigint(0) NOT NULL COMMENT 'owner user_id',
  `checkin_date` date NOT NULL,
  `checkout_date` date NOT NULL,
  `nights` int(0) NOT NULL,
  `guest_count` int(0) NOT NULL DEFAULT 1,
  `amount_total` decimal(10, 2) NOT NULL,
  `amount_payable` decimal(10, 2) NOT NULL,
  `pay_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '0-unpaid 1-paid 2-refunded',
  `order_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '0-wait-pay 1-paid 2-confirmed 3-finished 4-cancelled 5-rejected',
  `abnormal_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '0-normal 1-abnormal',
  `abnormal_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'abnormal reason',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `pay_time` datetime(0) NULL DEFAULT NULL,
  `confirm_time` datetime(0) NULL DEFAULT NULL,
  `create_by` bigint(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_by` bigint(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_hs_order_no`(`order_no`) USING BTREE,
  INDEX `idx_hs_order_tenant`(`tenant_user_id`) USING BTREE,
  INDEX `idx_hs_order_landlord`(`landlord_user_id`) USING BTREE,
  INDEX `idx_hs_order_homestay`(`homestay_id`) USING BTREE,
  INDEX `idx_hs_order_status`(`order_status`, `pay_status`) USING BTREE,
  INDEX `idx_hs_order_stay`(`checkin_date`, `checkout_date`) USING BTREE,
  INDEX `idx_hs_order_abnormal`(`abnormal_flag`, `order_status`, `pay_status`) USING BTREE,
  INDEX `idx_order_landlord_status`(`landlord_user_id`, `order_status`) USING BTREE,
  INDEX `idx_order_tenant_status`(`tenant_user_id`, `order_status`) USING BTREE,
  INDEX `idx_landlord_status_time`(`landlord_user_id`, `order_status`, `create_time`) USING BTREE,
  INDEX `idx_landlord_pay`(`landlord_user_id`, `pay_status`) USING BTREE,
  INDEX `idx_landlord_checkin`(`landlord_user_id`, `checkin_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 972132 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'booking order table' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_order
-- ----------------------------
INSERT INTO `hs_order` VALUES (972001, '000000', 'ODZH600001', 971001, 2002, 2001, '2026-02-28', '2026-03-02', 2, 2, 570.00, 570.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单001');
INSERT INTO `hs_order` VALUES (972002, '000000', 'ODZH600002', 971002, 2002, 2001, '2026-03-02', '2026-03-05', 3, 3, 906.00, 906.00, '1', '4', '0', NULL, 'cancel-by-tenant', '2026-02-22 12:15:29', NULL, 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单002');
INSERT INTO `hs_order` VALUES (972003, '000000', 'ODZH600003', 971003, 2002, 2001, '2026-03-04', '2026-03-05', 1, 4, 319.00, 319.00, '1', '2', '0', NULL, NULL, '2026-02-21 12:15:29', '2026-02-21 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单003');
INSERT INTO `hs_order` VALUES (972004, '000000', 'ODZH600004', 971004, 2002, 2001, '2026-03-06', '2026-03-08', 2, 1, 672.00, 672.00, '1', '3', '0', NULL, NULL, '2026-02-20 12:15:29', '2026-02-20 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单004');
INSERT INTO `hs_order` VALUES (972005, '000000', 'ODZH600005', 971005, 2002, 2001, '2026-03-08', '2026-03-11', 3, 2, 1059.00, 1059.00, '0', '4', '0', NULL, '租客行程变更取消', NULL, NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单005');
INSERT INTO `hs_order` VALUES (972006, '000000', 'ODZH600006', 971006, 2002, 2001, '2026-03-10', '2026-03-11', 1, 3, 370.00, 370.00, '2', '5', '1', 'MARKED[2026-02-24 12:15:29] 房态冲突触发人工处理', '房东拒单并退款', '2026-02-18 12:15:29', NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单006');
INSERT INTO `hs_order` VALUES (972007, '000000', 'ODZH600007', 971007, 2002, 2001, '2026-03-12', '2026-03-14', 2, 4, 774.00, 774.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单007');
INSERT INTO `hs_order` VALUES (972008, '000000', 'ODZH600008', 971008, 2002, 2001, '2026-03-14', '2026-03-17', 3, 1, 1212.00, 1212.00, '1', '2', '0', NULL, NULL, '2026-02-23 12:15:29', '2026-02-25 21:28:36', 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单008');
INSERT INTO `hs_order` VALUES (972009, '000000', 'ODZH600009', 971009, 2002, 2001, '2026-03-16', '2026-03-17', 1, 2, 421.00, 421.00, '1', '2', '0', NULL, NULL, '2026-02-22 12:15:29', '2026-02-20 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单009');
INSERT INTO `hs_order` VALUES (972010, '000000', 'ODZH600010', 971010, 2002, 2001, '2026-03-18', '2026-03-20', 2, 3, 876.00, 876.00, '1', '3', '0', NULL, NULL, '2026-02-21 12:15:29', '2026-02-24 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单010');
INSERT INTO `hs_order` VALUES (972011, '000000', 'ODZH600011', 971011, 2002, 2001, '2026-03-20', '2026-03-23', 3, 4, 1365.00, 1365.00, '0', '4', '0', NULL, '租客行程变更取消', NULL, NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单011');
INSERT INTO `hs_order` VALUES (972012, '000000', 'ODZH600012', 971012, 2002, 2001, '2026-02-26', '2026-02-27', 1, 1, 472.00, 472.00, '2', '5', '1', 'MARKED[2026-02-24 12:15:29] 房态冲突触发人工处理', '房东拒单并退款', '2026-02-19 12:15:29', NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单012');
INSERT INTO `hs_order` VALUES (972013, '000000', 'ODZH600013', 971013, 2002, 2001, '2026-02-28', '2026-03-02', 2, 2, 538.00, 538.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单013');
INSERT INTO `hs_order` VALUES (972014, '000000', 'ODZH600014', 971014, 2002, 2001, '2026-03-02', '2026-03-05', 3, 3, 858.00, 858.00, '1', '2', '0', NULL, NULL, '2026-02-24 12:15:29', '2026-05-18 22:58:19', 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单014');
INSERT INTO `hs_order` VALUES (972015, '000000', 'ODZH600015', 971015, 2002, 2001, '2026-03-04', '2026-03-05', 1, 4, 303.00, 303.00, '1', '2', '0', NULL, NULL, '2026-02-23 12:15:29', '2026-02-24 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单015');
INSERT INTO `hs_order` VALUES (972016, '000000', 'ODZH600016', 971016, 2002, 2001, '2026-03-06', '2026-03-08', 2, 1, 640.00, 640.00, '1', '3', '0', NULL, NULL, '2026-02-22 12:15:29', '2026-02-23 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单016');
INSERT INTO `hs_order` VALUES (972017, '000000', 'ODZH600017', 971017, 2002, 2001, '2026-03-08', '2026-03-11', 3, 2, 1011.00, 1011.00, '0', '4', '0', NULL, '租客行程变更取消', NULL, NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单017');
INSERT INTO `hs_order` VALUES (972018, '000000', 'ODZH600018', 971018, 2002, 2001, '2026-03-10', '2026-03-11', 1, 3, 354.00, 354.00, '2', '5', '1', 'MARKED[2026-02-24 12:15:29] 房态冲突触发人工处理', '房东拒单并退款', '2026-02-20 12:15:29', NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单018');
INSERT INTO `hs_order` VALUES (972019, '000000', 'ODZH600019', 971019, 2002, 2001, '2026-03-12', '2026-03-14', 2, 4, 742.00, 742.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单019');
INSERT INTO `hs_order` VALUES (972020, '000000', 'ODZH600020', 971020, 2002, 2001, '2026-03-14', '2026-03-17', 3, 1, 1164.00, 1164.00, '1', '2', '0', NULL, NULL, '2026-02-18 12:15:29', '2026-05-19 18:00:00', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单020');
INSERT INTO `hs_order` VALUES (972021, '000000', 'ODZH600021', 971021, 2002, 2001, '2026-03-16', '2026-03-17', 1, 2, 405.00, 405.00, '1', '2', '0', NULL, NULL, '2026-02-24 12:15:29', '2026-02-23 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单021');
INSERT INTO `hs_order` VALUES (972022, '000000', 'ODZH600022', 971022, 2002, 2001, '2026-03-18', '2026-03-20', 2, 3, 844.00, 844.00, '1', '3', '0', NULL, NULL, '2026-02-23 12:15:29', '2026-02-22 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单022');
INSERT INTO `hs_order` VALUES (972023, '000000', 'ODZH600023', 971023, 2002, 2001, '2026-03-20', '2026-03-23', 3, 4, 1317.00, 1317.00, '0', '4', '0', NULL, '租客行程变更取消', NULL, NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单023');
INSERT INTO `hs_order` VALUES (972024, '000000', 'ODZH600024', 971024, 2002, 2001, '2026-02-26', '2026-02-27', 1, 1, 456.00, 456.00, '2', '5', '1', 'MARKED[2026-02-24 12:15:29] 房态冲突触发人工处理', '房东拒单并退款', '2026-02-21 12:15:29', NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单024');
INSERT INTO `hs_order` VALUES (972025, '000000', 'ODZH600025', 971025, 2002, 2001, '2026-02-28', '2026-03-02', 2, 2, 946.00, 946.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单025');
INSERT INTO `hs_order` VALUES (972026, '000000', 'ODZH600026', 971026, 2002, 2001, '2026-03-02', '2026-03-05', 3, 3, 810.00, 810.00, '1', '2', '0', NULL, NULL, '2026-02-19 12:15:29', '2026-05-19 18:00:00', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单026');
INSERT INTO `hs_order` VALUES (972027, '000000', 'ODZH600027', 971027, 2002, 2001, '2026-03-04', '2026-03-05', 1, 4, 287.00, 287.00, '1', '2', '0', NULL, NULL, '2026-02-18 12:15:29', '2026-02-22 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单027');
INSERT INTO `hs_order` VALUES (972028, '000000', 'ODZH600028', 971028, 2002, 2001, '2026-03-06', '2026-03-08', 2, 1, 608.00, 608.00, '1', '3', '0', NULL, NULL, '2026-02-24 12:15:29', '2026-02-21 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单028');
INSERT INTO `hs_order` VALUES (972029, '000000', 'ODZH600029', 971029, 2002, 2001, '2026-03-08', '2026-03-11', 3, 2, 963.00, 963.00, '0', '4', '0', NULL, '租客行程变更取消', NULL, NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单029');
INSERT INTO `hs_order` VALUES (972030, '000000', 'ODZH600030', 971030, 2002, 2001, '2026-03-10', '2026-03-11', 1, 3, 338.00, 338.00, '2', '5', '1', 'MARKED[2026-02-24 12:15:29] 房态冲突触发人工处理', '房东拒单并退款', '2026-02-22 12:15:29', NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单030');
INSERT INTO `hs_order` VALUES (972031, '000000', 'ODZH600031', 971001, 2002, 2001, '2026-03-12', '2026-03-14', 2, 4, 570.00, 570.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单031');
INSERT INTO `hs_order` VALUES (972032, '000000', 'ODZH600032', 971002, 2002, 2001, '2026-03-14', '2026-03-17', 3, 1, 906.00, 906.00, '1', '2', '0', NULL, NULL, '2026-02-20 12:15:29', '2026-05-19 18:00:00', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单032');
INSERT INTO `hs_order` VALUES (972033, '000000', 'ODZH600033', 971003, 2002, 2001, '2026-03-16', '2026-03-17', 1, 2, 319.00, 319.00, '1', '2', '0', NULL, NULL, '2026-02-19 12:15:29', '2026-02-21 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单033');
INSERT INTO `hs_order` VALUES (972034, '000000', 'ODZH600034', 971004, 2002, 2001, '2026-03-18', '2026-03-20', 2, 3, 672.00, 672.00, '1', '3', '0', NULL, NULL, '2026-02-18 12:15:29', '2026-02-20 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单034');
INSERT INTO `hs_order` VALUES (972035, '000000', 'ODZH600035', 971005, 2002, 2001, '2026-03-20', '2026-03-23', 3, 4, 1059.00, 1059.00, '0', '4', '0', NULL, '租客行程变更取消', NULL, NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单035');
INSERT INTO `hs_order` VALUES (972036, '000000', 'ODZH600036', 971006, 2002, 2001, '2026-02-26', '2026-02-27', 1, 1, 370.00, 370.00, '2', '5', '1', 'MARKED[2026-02-24 12:15:29] 房态冲突触发人工处理', '房东拒单并退款', '2026-02-23 12:15:29', NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单036');
INSERT INTO `hs_order` VALUES (972037, '000000', 'ODZH600037', 971007, 2002, 2001, '2026-02-28', '2026-03-02', 2, 2, 774.00, 774.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单037');
INSERT INTO `hs_order` VALUES (972038, '000000', 'ODZH600038', 971008, 2002, 2001, '2026-03-02', '2026-03-05', 3, 3, 1212.00, 1212.00, '1', '2', '0', NULL, NULL, '2026-02-21 12:15:29', '2026-05-19 16:43:14', 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单038');
INSERT INTO `hs_order` VALUES (972039, '000000', 'ODZH600039', 971009, 2002, 2001, '2026-03-04', '2026-03-05', 1, 4, 421.00, 421.00, '1', '2', '0', NULL, NULL, '2026-02-20 12:15:29', '2026-02-20 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单039');
INSERT INTO `hs_order` VALUES (972040, '000000', 'ODZH600040', 971010, 2002, 2001, '2026-03-06', '2026-03-08', 2, 1, 876.00, 876.00, '1', '3', '0', NULL, NULL, '2026-02-19 12:15:29', '2026-02-24 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单040');
INSERT INTO `hs_order` VALUES (972041, '000000', 'ODZH600041', 971011, 2002, 2001, '2026-03-08', '2026-03-11', 3, 2, 1365.00, 1365.00, '0', '4', '0', NULL, '租客行程变更取消', NULL, NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单041');
INSERT INTO `hs_order` VALUES (972042, '000000', 'ODZH600042', 971012, 2002, 2001, '2026-03-10', '2026-03-11', 1, 3, 472.00, 472.00, '2', '5', '1', 'MARKED[2026-02-24 12:15:29] 房态冲突触发人工处理', '房东拒单并退款', '2026-02-24 12:15:29', NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单042');
INSERT INTO `hs_order` VALUES (972043, '000000', 'ODZH600043', 971013, 2002, 2001, '2026-03-12', '2026-03-14', 2, 4, 538.00, 538.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单043');
INSERT INTO `hs_order` VALUES (972044, '000000', 'ODZH600044', 971014, 2002, 2001, '2026-03-14', '2026-03-17', 3, 1, 858.00, 858.00, '1', '2', '0', NULL, NULL, '2026-02-22 12:15:29', '2026-05-18 22:58:21', 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单044');
INSERT INTO `hs_order` VALUES (972045, '000000', 'ODZH600045', 971015, 2002, 2001, '2026-03-16', '2026-03-17', 1, 2, 303.00, 303.00, '1', '2', '0', NULL, NULL, '2026-02-21 12:15:29', '2026-02-24 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单045');
INSERT INTO `hs_order` VALUES (972046, '000000', 'ODZH600046', 971016, 2002, 2001, '2026-03-18', '2026-03-20', 2, 3, 640.00, 640.00, '1', '3', '0', NULL, NULL, '2026-02-20 12:15:29', '2026-02-23 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单046');
INSERT INTO `hs_order` VALUES (972047, '000000', 'ODZH600047', 971017, 2002, 2001, '2026-03-20', '2026-03-23', 3, 4, 1011.00, 1011.00, '0', '4', '0', NULL, '租客行程变更取消', NULL, NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单047');
INSERT INTO `hs_order` VALUES (972048, '000000', 'ODZH600048', 971018, 2002, 2001, '2026-02-26', '2026-02-27', 1, 1, 354.00, 354.00, '2', '5', '1', 'MARKED[2026-02-24 12:15:29] 房态冲突触发人工处理', '房东拒单并退款', '2026-02-18 12:15:29', NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单048');
INSERT INTO `hs_order` VALUES (972049, '000000', 'ODZH600049', 971019, 2002, 2001, '2026-02-28', '2026-03-02', 2, 2, 742.00, 742.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单049');
INSERT INTO `hs_order` VALUES (972050, '000000', 'ODZH600050', 971020, 2002, 2001, '2026-03-02', '2026-03-05', 3, 3, 1164.00, 1164.00, '1', '2', '0', NULL, NULL, '2026-02-23 12:15:29', '2026-05-18 22:58:20', 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单050');
INSERT INTO `hs_order` VALUES (972051, '000000', 'ODZH600051', 971021, 2002, 2001, '2026-03-04', '2026-03-05', 1, 4, 405.00, 405.00, '1', '2', '0', NULL, NULL, '2026-02-22 12:15:29', '2026-02-23 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单051');
INSERT INTO `hs_order` VALUES (972052, '000000', 'ODZH600052', 971022, 2002, 2001, '2026-03-06', '2026-03-08', 2, 1, 844.00, 844.00, '1', '3', '0', NULL, NULL, '2026-02-21 12:15:29', '2026-02-22 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单052');
INSERT INTO `hs_order` VALUES (972053, '000000', 'ODZH600053', 971023, 2002, 2001, '2026-03-08', '2026-03-11', 3, 2, 1317.00, 1317.00, '0', '4', '0', NULL, '租客行程变更取消', NULL, NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单053');
INSERT INTO `hs_order` VALUES (972054, '000000', 'ODZH600054', 971024, 2002, 2001, '2026-03-10', '2026-03-11', 1, 3, 456.00, 456.00, '2', '5', '1', 'MARKED[2026-02-24 12:15:29] 房态冲突触发人工处理', '房东拒单并退款', '2026-02-19 12:15:29', NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单054');
INSERT INTO `hs_order` VALUES (972055, '000000', 'ODZH600055', 971025, 2002, 2001, '2026-03-12', '2026-03-14', 2, 4, 946.00, 946.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单055');
INSERT INTO `hs_order` VALUES (972056, '000000', 'ODZH600056', 971026, 2002, 2001, '2026-03-14', '2026-03-17', 3, 1, 810.00, 810.00, '1', '2', '0', NULL, NULL, '2026-02-24 12:15:29', '2026-05-18 22:58:20', 2002, '2026-02-24 12:15:29', 1, '2026-02-24 12:15:29', '高质量中文演示订单056');
INSERT INTO `hs_order` VALUES (972057, '000000', 'ODZH600057', 971027, 2002, 2001, '2026-03-16', '2026-03-17', 1, 2, 287.00, 287.00, '1', '2', '0', NULL, NULL, '2026-02-23 12:15:29', '2026-02-22 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单057');
INSERT INTO `hs_order` VALUES (972058, '000000', 'ODZH600058', 971028, 2002, 2001, '2026-03-18', '2026-03-20', 2, 3, 608.00, 608.00, '1', '3', '0', NULL, NULL, '2026-02-22 12:15:29', '2026-02-21 12:15:29', 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单058');
INSERT INTO `hs_order` VALUES (972059, '000000', 'ODZH600059', 971029, 2002, 2001, '2026-03-20', '2026-03-23', 3, 4, 963.00, 963.00, '0', '4', '0', NULL, '租客行程变更取消', NULL, NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单059');
INSERT INTO `hs_order` VALUES (972060, '000000', 'ODZH600060', 971030, 2002, 2001, '2026-02-26', '2026-02-27', 1, 1, 338.00, 338.00, '2', '5', '1', 'MARKED[2026-02-24 12:15:29] 房态冲突触发人工处理', '房东拒单并退款', '2026-02-20 12:15:29', NULL, 2002, '2026-02-24 12:15:29', 2001, '2026-02-24 12:15:29', '高质量中文演示订单060');
INSERT INTO `hs_order` VALUES (972061, '000000', 'ODDEMO0001', 971031, 2002, 2001, '2026-02-28', '2026-03-02', 2, 2, 536.00, 536.00, '1', '2', '0', NULL, NULL, '2026-02-25 14:24:36', '2026-02-25 20:17:20', 2002, '2026-02-25 14:24:36', 1, '2026-02-25 14:24:36', 'paid order for landlord action demo');
INSERT INTO `hs_order` VALUES (972062, '000000', 'OD20260225221500906933', 971022, 2002, 2001, '2026-02-25', '2026-02-26', 1, 1, 442.00, 442.00, '2', '5', '0', NULL, '管理员拒绝演示单', '2026-02-25 22:15:05', NULL, 2002, '2026-02-25 22:15:00', 1, '2026-02-25 22:15:00', NULL);
INSERT INTO `hs_order` VALUES (972063, '000000', 'OD20260225233821385946', 971031, 2002, 2001, '2026-02-25', '2026-02-26', 1, 2, 268.00, 268.00, '1', '4', '0', NULL, 'cancel-by-tenant', '2026-02-25 23:38:29', NULL, 2002, '2026-02-25 23:38:21', 2002, '2026-02-25 23:38:21', NULL);
INSERT INTO `hs_order` VALUES (972064, '000000', 'OD20260225233916091960', 971032, 2002, 2001, '2026-02-25', '2026-02-26', 1, 2, 328.00, 328.00, '1', '2', '0', NULL, NULL, '2026-02-25 23:39:18', '2026-02-28 10:04:20', 2002, '2026-02-25 23:39:16', 1, '2026-02-25 23:39:16', NULL);
INSERT INTO `hs_order` VALUES (972065, '000000', 'OD20260305132759367527', 971032, 1, 2001, '2026-03-07', '2026-03-09', 2, 2, 656.00, 656.00, '0', '4', '0', NULL, 'cancel-by-tenant', NULL, NULL, 1, '2026-03-05 13:27:59', 1, '2026-03-05 13:27:59', NULL);
INSERT INTO `hs_order` VALUES (972066, '000000', 'OD20260305153843625911', 971031, 1, 2001, '2026-03-18', '2026-03-19', 1, 1, 268.00, 268.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 1, '2026-03-05 15:38:43', 1, '2026-03-05 15:38:43', NULL);
INSERT INTO `hs_order` VALUES (972067, '000000', 'OD20260305181543846372', 971030, 1, 2001, '2026-03-07', '2026-03-08', 1, 1, 328.00, 328.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 1, '2026-03-05 18:15:43', 1, '2026-03-05 18:15:43', NULL);
INSERT INTO `hs_order` VALUES (972068, '000000', 'OD20260305182329538220', 971032, 1, 2001, '2026-03-05', '2026-03-06', 1, 1, 328.00, 328.00, '1', '2', '0', NULL, NULL, '2026-03-05 18:23:32', '2026-03-05 18:23:56', 1, '2026-03-05 18:23:29', 1, '2026-03-05 18:23:29', NULL);
INSERT INTO `hs_order` VALUES (972069, '000000', 'OD20260305193601721579', 971030, 1, 2001, '2026-03-08', '2026-03-09', 1, 1, 338.00, 338.00, '1', '4', '0', NULL, 'cancel-by-tenant', '2026-03-05 19:36:04', '2026-03-05 19:36:19', 1, '2026-03-05 19:36:01', 1, '2026-03-05 19:36:01', NULL);
INSERT INTO `hs_order` VALUES (972070, '000000', 'OD20260307111032900728', 971032, 2003, 2001, '2026-03-07', '2026-03-08', 1, 1, 328.00, 328.00, '1', '3', '0', NULL, NULL, '2026-03-07 11:10:37', '2026-03-07 11:11:07', 2003, '2026-03-07 11:10:32', 2003, '2026-03-07 11:10:32', NULL);
INSERT INTO `hs_order` VALUES (972071, '000000', 'OD20260307195030183112', 971031, 2003, 2001, '2026-03-07', '2026-03-08', 1, 1, 268.00, 268.00, '1', '3', '0', NULL, NULL, '2026-03-07 19:50:32', '2026-03-07 19:50:43', 2003, '2026-03-07 19:50:30', 2003, '2026-03-07 19:50:30', NULL);
INSERT INTO `hs_order` VALUES (972072, '000000', 'OD20260518211104337366', 971033, 2007, 1, '2026-05-18', '2026-05-21', 3, 1, 597.00, 597.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2007, '2026-05-18 21:11:04', 1, '2026-05-18 21:11:04', NULL);
INSERT INTO `hs_order` VALUES (972073, '000000', 'OD20260518222218859105', 971033, 2007, 1, '2026-05-21', '2026-05-22', 1, 1, 199.00, 199.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2007, '2026-05-18 22:22:18', 1, '2026-05-18 22:22:18', NULL);
INSERT INTO `hs_order` VALUES (972074, '000000', 'OD20260518222730298688', 971004, 2007, 2001, '2026-05-19', '2026-05-20', 1, 1, 336.00, 336.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2007, '2026-05-18 22:27:30', 1, '2026-05-18 22:27:30', NULL);
INSERT INTO `hs_order` VALUES (972075, '000000', 'OD20260518223646223645', 971033, 2007, 1, '2026-05-22', '2026-05-23', 1, 1, 199.00, 199.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2007, '2026-05-18 22:36:46', 1, '2026-05-18 22:36:46', NULL);
INSERT INTO `hs_order` VALUES (972076, '000000', 'OD20260518223804167498', 971033, 2007, 1, '2026-05-23', '2026-05-24', 1, 1, 199.00, 199.00, '1', '2', '0', NULL, NULL, '2026-05-18 22:49:15', '2026-05-18 22:58:18', 2007, '2026-05-18 22:38:04', 1, '2026-05-18 22:38:04', NULL);
INSERT INTO `hs_order` VALUES (972077, '000000', 'OD20260518225310565705', 971003, 2007, 2001, '2026-05-18', '2026-05-20', 2, 1, 638.00, 638.00, '0', '4', '0', NULL, 'cancel-by-tenant', NULL, NULL, 2007, '2026-05-18 22:53:10', 2007, '2026-05-18 22:53:10', NULL);
INSERT INTO `hs_order` VALUES (972078, '000000', 'OD20260519133644904949', 8, 2009, 1, '2026-05-19', '2026-05-21', 2, 1, 1596.00, 1596.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2009, '2026-05-19 13:36:44', 1, '2026-05-19 13:36:44', NULL);
INSERT INTO `hs_order` VALUES (972079, '000000', 'OD20260519134320504608', 4, 2009, 1, '2026-05-19', '2026-05-22', 3, 1, 1074.00, 1074.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2009, '2026-05-19 13:43:20', 1, '2026-05-19 13:43:20', NULL);
INSERT INTO `hs_order` VALUES (972080, '000000', 'OD20260519140105650503', 9, 2009, 1, '2026-05-19', '2026-05-21', 2, 1, 916.00, 916.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2009, '2026-05-19 14:01:05', 1, '2026-05-19 14:01:05', NULL);
INSERT INTO `hs_order` VALUES (972081, '000000', 'OD20260519140526503205', 11, 2009, 1, '2026-05-19', '2026-05-21', 2, 1, 796.00, 796.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2009, '2026-05-19 14:05:26', 1, '2026-05-19 14:05:26', NULL);
INSERT INTO `hs_order` VALUES (972082, '000000', 'OD20260519145529103886', 2, 2009, 1, '2026-05-19', '2026-05-21', 2, 1, 916.00, 916.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2009, '2026-05-19 14:55:29', 1, '2026-05-19 14:55:29', NULL);
INSERT INTO `hs_order` VALUES (972083, '000000', 'OD20260519150256163941', 1, 2009, 1, '2026-05-19', '2026-05-21', 2, 1, 598.00, 598.00, '0', '4', '0', NULL, '管理员手动关闭', NULL, NULL, 2009, '2026-05-19 15:02:56', 1, '2026-05-19 15:02:56', NULL);
INSERT INTO `hs_order` VALUES (972084, '000000', 'OD20260519150844127630', 2, 2009, 1, '2026-05-21', '2026-05-23', 2, 1, 916.00, 916.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 2009, '2026-05-19 15:08:44', 2009, '2026-05-19 15:08:44', NULL);
INSERT INTO `hs_order` VALUES (972085, '000000', 'OD20260519151038954511', 1, 2009, 1, '2026-05-21', '2026-05-23', 2, 1, 598.00, 598.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 2009, '2026-05-19 15:10:38', 2009, '2026-05-19 15:10:38', NULL);
INSERT INTO `hs_order` VALUES (972086, '000000', 'OD20260519151359812869', 4, 2009, 1, '2026-05-23', '2026-05-25', 2, 1, 716.00, 716.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 2009, '2026-05-19 15:13:59', 2009, '2026-05-19 15:13:59', NULL);
INSERT INTO `hs_order` VALUES (972087, '000000', 'OD20260519151642773270', 8, 2003, 1, '2026-05-26', '2026-05-27', 1, 1, 798.00, 798.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 2003, '2026-05-19 15:16:42', 2003, '2026-05-19 15:16:42', NULL);
INSERT INTO `hs_order` VALUES (972088, '000000', 'OD20260519151827433363', 1, 2009, 1, '2026-05-26', '2026-05-27', 1, 1, 299.00, 299.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 2009, '2026-05-19 15:18:27', 2009, '2026-05-19 15:18:27', NULL);
INSERT INTO `hs_order` VALUES (972089, '000000', 'OD20260519152920672228', 1, 2009, 1, '2026-06-16', '2026-06-17', 1, 1, 299.00, 299.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 2009, '2026-05-19 15:29:20', 2009, '2026-05-19 15:29:20', NULL);
INSERT INTO `hs_order` VALUES (972090, '000000', 'OD20260519154632463977', 1, 2007, 1, '2026-05-27', '2026-05-28', 1, 1, 299.00, 299.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 2007, '2026-05-19 15:46:32', 2007, '2026-05-19 15:46:32', NULL);
INSERT INTO `hs_order` VALUES (972091, '000000', 'OD20260519160104095541', 1, 2007, 1, '2026-06-17', '2026-06-18', 1, 1, 299.00, 299.00, '0', '4', '0', NULL, 'cancel-by-tenant', NULL, NULL, 2007, '2026-05-19 16:01:04', 2007, '2026-05-19 16:01:04', NULL);
INSERT INTO `hs_order` VALUES (972092, '000000', 'OD20260519173758068299', 2, 2007, 1, '2026-05-27', '2026-05-28', 1, 1, 458.00, 458.00, '1', '3', '0', NULL, NULL, '2026-05-19 17:39:26', NULL, 2007, '2026-05-19 17:37:58', 2007, '2026-05-19 17:37:58', NULL);
INSERT INTO `hs_order` VALUES (972093, '000000', 'OD20260519211829243254', 13, 2009, 1, '2026-05-19', '2026-05-20', 1, 1, 468.00, 468.00, '1', '2', '0', NULL, NULL, '2026-05-19 21:19:36', NULL, 2009, '2026-05-19 21:18:29', 2009, '2026-05-19 21:18:29', NULL);
INSERT INTO `hs_order` VALUES (972094, '000000', 'OD20260519233300462983', 3, 2007, 1, '2026-05-19', '2026-05-20', 1, 1, 388.00, 388.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 2007, '2026-05-19 23:33:00', 2007, '2026-05-19 23:33:00', NULL);
INSERT INTO `hs_order` VALUES (972095, '000000', 'OD20260519233858276310', 3, 2007, 1, '2026-05-27', '2026-05-29', 2, 1, 776.00, 776.00, '1', '2', '0', NULL, NULL, '2026-05-19 23:39:54', NULL, 2007, '2026-05-19 23:38:58', 2007, '2026-05-19 23:38:58', NULL);
INSERT INTO `hs_order` VALUES (972096, '000000', 'OD20260519235100453788', 4, 2007, 1, '2026-05-19', '2026-05-20', 1, 1, 358.00, 358.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 2007, '2026-05-19 23:51:00', 2007, '2026-05-19 23:51:00', NULL);
INSERT INTO `hs_order` VALUES (972097, '000000', 'OD20260519235257316648', 9, 2007, 1, '2026-05-19', '2026-05-20', 1, 1, 458.00, 458.00, '1', '2', '0', NULL, NULL, '2026-05-19 23:53:35', NULL, 2007, '2026-05-19 23:52:57', 2007, '2026-05-19 23:52:57', NULL);
INSERT INTO `hs_order` VALUES (972098, '000000', 'ODTEST001', 1, 2002, 2001, '2026-05-23', '2026-05-25', 2, 2, 536.00, 536.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 2002, '2026-05-20 03:34:47', 2002, '2026-05-20 03:34:47', NULL);
INSERT INTO `hs_order` VALUES (972099, '000000', 'ODTEST002', 2, 2002, 2001, '2026-05-24', '2026-05-26', 2, 2, 480.00, 480.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 2002, '2026-05-20 03:34:47', 2002, '2026-05-20 03:34:47', NULL);
INSERT INTO `hs_order` VALUES (972100, '000000', 'ODTEST003', 1, 2002, 2001, '2026-05-25', '2026-05-27', 2, 2, 536.00, 536.00, '1', '2', '0', NULL, NULL, '2026-05-20 03:34:47', '2026-05-20 07:15:28', 2002, '2026-05-20 03:34:47', 1, '2026-05-20 03:34:47', NULL);
INSERT INTO `hs_order` VALUES (972101, '000000', 'ODTEST004', 3, 2002, 2001, '2026-05-26', '2026-05-28', 2, 2, 600.00, 600.00, '1', '2', '0', NULL, NULL, '2026-05-20 03:34:47', '2026-05-21 04:00:00', 2002, '2026-05-20 03:34:47', 2002, '2026-05-20 03:34:47', NULL);
INSERT INTO `hs_order` VALUES (972102, '000000', 'ODTEST005', 4, 2002, 2001, '2026-05-27', '2026-05-29', 2, 2, 450.00, 450.00, '1', '2', '0', NULL, NULL, '2026-05-20 03:34:47', '2026-05-21 04:00:00', 2002, '2026-05-20 03:34:47', 2002, '2026-05-20 03:34:47', NULL);
INSERT INTO `hs_order` VALUES (972103, '000000', 'OD20260520045932296940', 3, 2007, 2001, '2026-05-20', '2026-05-22', 2, 1, 776.00, 776.00, '1', '2', '0', NULL, NULL, '2026-05-20 04:59:38', '2026-05-20 07:15:18', 2007, '2026-05-20 04:59:32', 1, '2026-05-20 04:59:32', NULL);
INSERT INTO `hs_order` VALUES (972104, '000000', 'OD20260520050157024551', 1, 2007, 2001, '2026-06-22', '2026-06-23', 1, 1, 299.00, 299.00, '1', '6', '0', NULL, NULL, '2026-05-20 05:02:48', NULL, 2007, '2026-05-20 05:01:57', 2007, '2026-05-20 05:01:57', NULL);
INSERT INTO `hs_order` VALUES (972105, '000000', 'OD20260520050727629500', 10, 2007, 1, '2026-06-02', '2026-06-03', 1, 1, 268.00, 268.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 2007, '2026-05-20 05:07:27', 2007, '2026-05-20 05:40:00', NULL);
INSERT INTO `hs_order` VALUES (972106, '000000', 'OD20260520054827864566', 971044, 2011, 2011, '2026-05-20', '2026-05-21', 1, 1, 199.00, 199.00, '1', '3', '0', NULL, NULL, '2026-05-20 05:52:39', NULL, 2011, '2026-05-20 05:48:27', 2011, '2026-05-20 05:48:27', NULL);
INSERT INTO `hs_order` VALUES (972107, '000000', 'OD20260520071422868628', 971044, 2011, 2011, '2026-06-15', '2026-06-16', 1, 1, 199.00, 199.00, '1', '6', '0', NULL, NULL, '2026-05-20 07:14:25', '2026-05-20 07:14:40', 2011, '2026-05-20 07:14:22', 2011, '2026-05-20 07:14:22', NULL);
INSERT INTO `hs_order` VALUES (972108, '000000', 'OD20260520071704898377', 971045, 2011, 2011, '2026-06-23', '2026-06-25', 2, 1, 400.00, 400.00, '1', '1', '0', NULL, NULL, '2026-05-20 07:17:08', NULL, 2011, '2026-05-20 07:17:04', 2011, '2026-05-20 07:17:04', NULL);
INSERT INTO `hs_order` VALUES (972109, '000000', 'OD20260520071812222416', 4, 2011, 2001, '2026-05-20', '2026-05-21', 1, 1, 358.00, 358.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 2011, '2026-05-20 07:18:12', 2011, '2026-05-20 07:50:00', NULL);
INSERT INTO `hs_order` VALUES (972110, '000000', 'OD20260520094843088152', 4, 2007, 2001, '2026-05-20', '2026-05-21', 1, 1, 358.00, 358.00, '1', '1', '0', NULL, NULL, '2026-05-20 09:48:58', NULL, 2007, '2026-05-20 09:48:43', 2007, '2026-05-20 09:48:43', NULL);
INSERT INTO `hs_order` VALUES (972111, '000000', 'OD20260520095040306815', 971044, 2007, 2011, '2026-07-28', '2026-07-29', 1, 1, 199.00, 199.00, '1', '2', '0', NULL, NULL, '2026-05-20 09:50:42', '2026-05-20 09:51:19', 2007, '2026-05-20 09:50:40', 2011, '2026-05-20 09:50:40', NULL);
INSERT INTO `hs_order` VALUES (972112, '000000', 'OD20260520095252356379', 971045, 2011, 2011, '2026-05-20', '2026-05-21', 1, 1, 200.00, 200.00, '1', '3', '0', NULL, NULL, '2026-05-20 09:52:55', '2026-05-20 09:53:10', 2011, '2026-05-20 09:52:52', 2011, '2026-05-20 09:52:52', NULL);
INSERT INTO `hs_order` VALUES (972113, '000000', 'OD2024001', 971049, 1001, 2012, '2026-05-25', '2026-05-27', 2, 2, 776.00, 776.00, '1', '2', '0', NULL, NULL, '2026-05-20 13:40:46', '2026-05-20 13:40:46', 1001, '2026-05-20 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972114, '000000', 'OD2024002', 971049, 1002, 2012, '2026-05-30', '2026-06-01', 2, 3, 916.00, 916.00, '1', '1', '0', NULL, NULL, '2026-05-20 13:40:46', NULL, 1002, '2026-05-20 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972115, '000000', 'OD2024003', 971050, 1003, 2012, '2026-05-23', '2026-05-26', 3, 4, 2064.00, 2064.00, '1', '2', '0', NULL, NULL, '2026-05-20 13:40:46', '2026-05-20 13:40:46', 1003, '2026-05-20 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972116, '000000', 'OD2024004', 971051, 1004, 2012, '2026-05-28', '2026-05-29', 1, 1, 298.00, 298.00, '1', '3', '0', NULL, NULL, '2026-05-20 13:40:46', '2026-05-20 13:40:46', 1004, '2026-05-20 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972117, '000000', 'OD2024005', 971052, 1005, 2012, '2026-06-04', '2026-06-06', 2, 2, 916.00, 916.00, '1', '2', '0', NULL, NULL, '2026-05-20 13:40:46', '2026-05-20 13:40:46', 1005, '2026-05-20 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972118, '000000', 'OD2024006', 971053, 1006, 2012, '2026-06-09', '2026-06-11', 2, 3, 1056.00, 1056.00, '1', '1', '0', NULL, NULL, '2026-05-20 13:40:46', NULL, 1006, '2026-05-20 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972119, '000000', 'OD2024007', 971054, 1007, 2012, '2026-05-22', '2026-05-24', 2, 2, 796.00, 796.00, '1', '2', '0', NULL, NULL, '2026-05-20 13:40:46', '2026-05-20 13:40:46', 1007, '2026-05-20 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972120, '000000', 'OD2024008', 971055, 1008, 2012, '2026-06-01', '2026-06-02', 1, 1, 328.00, 328.00, '0', '4', '0', NULL, '系统自动取消：超时未支付', NULL, NULL, 1008, '2026-05-20 13:40:46', NULL, '2026-05-20 14:15:00', NULL);
INSERT INTO `hs_order` VALUES (972121, '000000', 'OD2024009', 971056, 1009, 2012, '2026-05-26', '2026-05-28', 2, 3, 1176.00, 1176.00, '1', '2', '0', NULL, NULL, '2026-05-20 13:40:46', '2026-05-20 13:40:46', 1009, '2026-05-20 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972122, '000000', 'OD2024010', 971057, 1010, 2012, '2026-05-21', '2026-05-22', 1, 1, 358.00, 358.00, '1', '3', '0', NULL, NULL, '2026-05-20 13:40:46', '2026-05-20 13:40:46', 1010, '2026-05-20 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972123, '000000', 'OD2024011', 971058, 1011, 2012, '2026-06-07', '2026-06-09', 2, 2, 856.00, 856.00, '1', '1', '0', NULL, NULL, '2026-05-20 13:40:46', NULL, 1011, '2026-05-20 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972124, '000000', 'OD2024012', 971059, 1012, 2012, '2026-06-14', '2026-06-17', 3, 4, 1464.00, 1464.00, '1', '2', '0', NULL, NULL, '2026-05-20 13:40:46', '2026-05-20 13:40:46', 1012, '2026-05-20 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972125, '000000', 'OD2024013', 971060, 1013, 2012, '2026-06-19', '2026-06-22', 3, 6, 2664.00, 2664.00, '1', '2', '0', NULL, NULL, '2026-05-20 13:40:46', '2026-05-20 13:40:46', 1013, '2026-05-20 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972126, '000000', 'OD2024014', 971050, 1014, 2012, '2026-05-10', '2026-05-13', 3, 5, 2064.00, 2064.00, '1', '3', '0', NULL, NULL, '2026-05-20 13:40:46', '2026-05-20 13:40:46', 1014, '2026-05-08 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972127, '000000', 'OD2024015', 971051, 1015, 2012, '2026-05-15', '2026-05-16', 1, 1, 298.00, 298.00, '1', '4', '0', NULL, NULL, NULL, NULL, 1015, '2026-05-14 13:40:46', NULL, '2026-05-20 13:40:46', NULL);
INSERT INTO `hs_order` VALUES (972128, '000000', 'OD20260520141825187794', 971085, 2007, 2012, '2026-05-20', '2026-05-21', 1, 1, 199.00, 199.00, '1', '3', '0', NULL, NULL, '2026-05-20 14:19:21', NULL, 2007, '2026-05-20 14:18:25', 2007, '2026-05-20 14:18:25', NULL);
INSERT INTO `hs_order` VALUES (972129, '000000', 'OD20260520145532416860', 971086, 2007, 2012, '2026-06-08', '2026-06-09', 1, 1, 199.00, 199.00, '1', '2', '0', NULL, NULL, '2026-05-20 14:56:30', NULL, 2007, '2026-05-20 14:55:32', 2007, '2026-05-20 14:55:32', NULL);
INSERT INTO `hs_order` VALUES (972130, '000000', 'OD20260520145826793309', 971086, 2007, 2012, '2026-05-20', '2026-05-21', 1, 1, 199.00, 199.00, '1', '3', '0', NULL, NULL, '2026-05-20 14:58:31', '2026-05-20 14:58:53', 2007, '2026-05-20 14:58:26', 2007, '2026-05-20 14:58:26', NULL);
INSERT INTO `hs_order` VALUES (972131, '000000', 'OD20260522091511283558', 971049, 2011, 2012, '2026-05-22', '2026-05-23', 1, 1, 288.00, 288.00, '1', '2', '0', NULL, NULL, '2026-05-22 09:16:27', NULL, 2011, '2026-05-22 09:15:11', 2011, '2026-05-22 09:15:11', NULL);

-- ----------------------------
-- Table structure for hs_review
-- ----------------------------
DROP TABLE IF EXISTS `hs_review`;
CREATE TABLE `hs_review`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'pk',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '000000',
  `order_id` bigint(0) NOT NULL,
  `homestay_id` bigint(0) NOT NULL,
  `tenant_user_id` bigint(0) NOT NULL,
  `rating` tinyint(0) NOT NULL COMMENT '1-5',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_anonymous` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_hs_review_order`(`order_id`) USING BTREE,
  INDEX `idx_hs_review_homestay`(`homestay_id`) USING BTREE,
  INDEX `idx_hs_review_user`(`tenant_user_id`) USING BTREE,
  INDEX `idx_review_homestay_time`(`homestay_id`, `create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 974037 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'review table' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_review
-- ----------------------------
INSERT INTO `hs_review` VALUES (974001, '000000', 972001, 971001, 2002, 4, '房间整洁，房东回复及时。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974002, '000000', 972002, 971002, 2002, 5, '地理位置很好，周边配套齐全。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974003, '000000', 972003, 971003, 2002, 3, '整体体验不错，性价比高。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974004, '000000', 972004, 971004, 2002, 4, '设施完善，适合短租出行。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974005, '000000', 972005, 971005, 2002, 5, '交通便利，入住顺畅，推荐。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974006, '000000', 972006, 971006, 2002, 3, '房间整洁，房东回复及时。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974007, '000000', 972007, 971007, 2002, 4, '地理位置很好，周边配套齐全。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974008, '000000', 972008, 971008, 2002, 5, '整体体验不错，性价比高。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974009, '000000', 972009, 971009, 2002, 3, '设施完善，适合短租出行。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974010, '000000', 972010, 971010, 2002, 4, '交通便利，入住顺畅，推荐。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974011, '000000', 972011, 971011, 2002, 5, '房间整洁，房东回复及时。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974012, '000000', 972012, 971012, 2002, 3, '地理位置很好，周边配套齐全。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974013, '000000', 972013, 971013, 2002, 4, '整体体验不错，性价比高。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974014, '000000', 972014, 971014, 2002, 5, '设施完善，适合短租出行。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974015, '000000', 972015, 971015, 2002, 3, '交通便利，入住顺畅，推荐。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974016, '000000', 972016, 971016, 2002, 4, '房间整洁，房东回复及时。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974017, '000000', 972017, 971017, 2002, 5, '地理位置很好，周边配套齐全。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974018, '000000', 972018, 971018, 2002, 3, '整体体验不错，性价比高。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974019, '000000', 972019, 971019, 2002, 4, '设施完善，适合短租出行。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974020, '000000', 972020, 971020, 2002, 5, '交通便利，入住顺畅，推荐。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974021, '000000', 972021, 971021, 2002, 3, '房间整洁，房东回复及时。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974022, '000000', 972022, 971022, 2002, 4, '地理位置很好，周边配套齐全。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974023, '000000', 972023, 971023, 2002, 5, '整体体验不错，性价比高。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974024, '000000', 972024, 971024, 2002, 3, '设施完善，适合短租出行。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974025, '000000', 972025, 971025, 2002, 4, '交通便利，入住顺畅，推荐。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974026, '000000', 972026, 971026, 2002, 5, '房间整洁，房东回复及时。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974027, '000000', 972027, 971027, 2002, 3, '地理位置很好，周边配套齐全。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974028, '000000', 972028, 971028, 2002, 4, '整体体验不错，性价比高。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974029, '000000', 972029, 971029, 2002, 5, '设施完善，适合短租出行。', '0', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974030, '000000', 972030, 971030, 2002, 3, '交通便利，入住顺畅，推荐。', '1', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_review` VALUES (974031, '000000', 972071, 971031, 2003, 5, '不咋行', '1', '2026-05-19 14:13:22', '2026-05-19 14:13:22');
INSERT INTO `hs_review` VALUES (974032, '000000', 972092, 2, 2007, 3, '就那样，不太行，三分', '0', '2026-05-19 17:40:43', '2026-05-19 17:40:43');
INSERT INTO `hs_review` VALUES (974033, '000000', 972070, 971032, 2003, 5, '231', '0', '2026-05-19 23:55:37', '2026-05-19 23:55:37');
INSERT INTO `hs_review` VALUES (974034, '000000', 972104, 1, 2007, 5, '还可以，但是支付后需要我点击返回，不能自己检测支付成功没....', '0', '2026-05-20 05:03:38', '2026-05-20 05:03:38');
INSERT INTO `hs_review` VALUES (974035, '000000', 972106, 971044, 2011, 5, '1.确认退房，特别慢，需要优化，2.之后状态：就改为，待清洁', '1', '2026-05-20 06:28:29', '2026-05-20 06:28:29');
INSERT INTO `hs_review` VALUES (974036, '000000', 972130, 971086, 2007, 5, '有求必应，回复消息特别快，让人感觉像在本地有个朋友一样。', '0', '2026-05-20 14:59:47', '2026-05-20 14:59:47');

-- ----------------------------
-- Table structure for hs_room_calendar
-- ----------------------------
DROP TABLE IF EXISTS `hs_room_calendar`;
CREATE TABLE `hs_room_calendar`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'pk',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '000000',
  `homestay_id` bigint(0) NOT NULL,
  `biz_date` date NOT NULL COMMENT 'date',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '0-available 1-locked 2-booked 3-blocked',
  `price` decimal(10, 2) NOT NULL,
  `lock_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `version` int(0) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'optimistic lock version',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_hs_calendar_date`(`homestay_id`, `biz_date`) USING BTREE,
  INDEX `idx_hs_calendar_status_date`(`status`, `biz_date`) USING BTREE,
  INDEX `idx_hs_calendar_homestay`(`homestay_id`) USING BTREE,
  INDEX `idx_calendar_homestay_status`(`homestay_id`, `status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2033 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'calendar and inventory' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_room_calendar
-- ----------------------------
INSERT INTO `hs_room_calendar` VALUES (1247, '000000', 8, '2026-05-19', '0', 798.00, NULL, 3, '2026-05-19 13:36:44', '2026-05-19 16:43:21');
INSERT INTO `hs_room_calendar` VALUES (1248, '000000', 8, '2026-05-20', '0', 798.00, NULL, 3, '2026-05-19 13:36:44', '2026-05-19 16:43:21');
INSERT INTO `hs_room_calendar` VALUES (1249, '000000', 4, '2026-05-19', '2', 358.00, 'OD20260519235100453788', 4, '2026-05-19 13:43:20', '2026-05-19 23:51:00');
INSERT INTO `hs_room_calendar` VALUES (1250, '000000', 4, '2026-05-20', '2', 358.00, 'OD20260520094843088152', 6, '2026-05-19 13:43:20', '2026-05-20 09:48:43');
INSERT INTO `hs_room_calendar` VALUES (1251, '000000', 4, '2026-05-21', '0', 358.00, NULL, 3, '2026-05-19 13:43:20', '2026-05-19 16:43:21');
INSERT INTO `hs_room_calendar` VALUES (1252, '000000', 9, '2026-05-19', '2', 458.00, 'OD20260519235257316648', 4, '2026-05-19 14:01:05', '2026-05-19 23:52:57');
INSERT INTO `hs_room_calendar` VALUES (1253, '000000', 9, '2026-05-20', '0', 458.00, NULL, 3, '2026-05-19 14:01:05', '2026-05-19 16:43:22');
INSERT INTO `hs_room_calendar` VALUES (1254, '000000', 11, '2026-05-19', '0', 398.00, NULL, 3, '2026-05-19 14:05:26', '2026-05-19 16:43:22');
INSERT INTO `hs_room_calendar` VALUES (1255, '000000', 11, '2026-05-20', '0', 398.00, NULL, 3, '2026-05-19 14:05:26', '2026-05-19 16:43:22');
INSERT INTO `hs_room_calendar` VALUES (1256, '000000', 2, '2026-05-19', '0', 458.00, NULL, 3, '2026-05-19 14:55:29', '2026-05-19 16:43:34');
INSERT INTO `hs_room_calendar` VALUES (1257, '000000', 2, '2026-05-20', '0', 458.00, NULL, 3, '2026-05-19 14:55:29', '2026-05-19 16:43:34');
INSERT INTO `hs_room_calendar` VALUES (1258, '000000', 1, '2026-05-19', '0', 299.00, NULL, 3, '2026-05-19 15:02:56', '2026-05-19 16:43:35');
INSERT INTO `hs_room_calendar` VALUES (1259, '000000', 1, '2026-05-20', '0', 299.00, NULL, 3, '2026-05-19 15:02:56', '2026-05-19 16:43:35');
INSERT INTO `hs_room_calendar` VALUES (1260, '000000', 2, '2026-05-21', '2', 458.00, 'OD20260519150844127630', 2, '2026-05-19 15:08:44', '2026-05-19 15:08:44');
INSERT INTO `hs_room_calendar` VALUES (1261, '000000', 2, '2026-05-22', '2', 458.00, 'OD20260519150844127630', 2, '2026-05-19 15:08:44', '2026-05-19 15:08:44');
INSERT INTO `hs_room_calendar` VALUES (1262, '000000', 1, '2026-05-21', '2', 299.00, 'OD20260519151038954511', 2, '2026-05-19 15:10:38', '2026-05-19 15:10:38');
INSERT INTO `hs_room_calendar` VALUES (1263, '000000', 1, '2026-05-22', '2', 299.00, 'OD20260519151038954511', 2, '2026-05-19 15:10:38', '2026-05-19 15:10:38');
INSERT INTO `hs_room_calendar` VALUES (1264, '000000', 4, '2026-05-23', '2', 358.00, 'OD20260519151359812869', 2, '2026-05-19 15:13:59', '2026-05-19 15:13:59');
INSERT INTO `hs_room_calendar` VALUES (1265, '000000', 4, '2026-05-24', '2', 358.00, 'OD20260519151359812869', 2, '2026-05-19 15:13:59', '2026-05-19 15:13:59');
INSERT INTO `hs_room_calendar` VALUES (1266, '000000', 8, '2026-05-26', '2', 798.00, 'OD20260519151642773270', 2, '2026-05-19 15:16:42', '2026-05-19 15:16:42');
INSERT INTO `hs_room_calendar` VALUES (1267, '000000', 1, '2026-05-26', '2', 299.00, 'OD20260519151827433363', 2, '2026-05-19 15:18:27', '2026-05-19 15:18:27');
INSERT INTO `hs_room_calendar` VALUES (1268, '000000', 1, '2026-06-16', '2', 299.00, 'OD20260519152920672228', 2, '2026-05-19 15:29:20', '2026-05-19 15:29:20');
INSERT INTO `hs_room_calendar` VALUES (1269, '000000', 1, '2026-05-27', '2', 299.00, 'OD20260519154632463977', 2, '2026-05-19 15:46:32', '2026-05-19 15:46:32');
INSERT INTO `hs_room_calendar` VALUES (1270, '000000', 1, '2026-06-17', '0', 299.00, NULL, 3, '2026-05-19 16:01:04', '2026-05-19 16:03:46');
INSERT INTO `hs_room_calendar` VALUES (1271, '000000', 971038, '2026-05-19', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1272, '000000', 971038, '2026-05-20', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1273, '000000', 971038, '2026-05-21', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1274, '000000', 971038, '2026-05-22', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1275, '000000', 971038, '2026-05-23', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1276, '000000', 971038, '2026-05-24', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1277, '000000', 971038, '2026-05-25', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1278, '000000', 971038, '2026-05-26', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1279, '000000', 971038, '2026-05-27', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1280, '000000', 971038, '2026-05-28', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1281, '000000', 971038, '2026-05-29', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1282, '000000', 971038, '2026-05-30', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1283, '000000', 971038, '2026-05-31', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1284, '000000', 971038, '2026-06-01', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1285, '000000', 971038, '2026-06-02', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1286, '000000', 971038, '2026-06-03', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1287, '000000', 971038, '2026-06-04', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1288, '000000', 971038, '2026-06-05', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1289, '000000', 971038, '2026-06-06', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1290, '000000', 971038, '2026-06-07', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1291, '000000', 971038, '2026-06-08', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1292, '000000', 971038, '2026-06-09', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1293, '000000', 971038, '2026-06-10', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1294, '000000', 971038, '2026-06-11', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1295, '000000', 971038, '2026-06-12', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1296, '000000', 971038, '2026-06-13', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1297, '000000', 971038, '2026-06-14', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1298, '000000', 971038, '2026-06-15', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1299, '000000', 971038, '2026-06-16', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1300, '000000', 971038, '2026-06-17', '0', 199.00, NULL, 1, '2026-05-19 16:20:12', '2026-05-19 16:20:12');
INSERT INTO `hs_room_calendar` VALUES (1301, '000000', 2, '2026-05-27', '2', 458.00, 'OD20260519173758068299', 2, '2026-05-19 17:37:58', '2026-05-19 17:37:58');
INSERT INTO `hs_room_calendar` VALUES (1302, '000000', 971039, '2026-05-19', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1303, '000000', 971039, '2026-05-20', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1304, '000000', 971039, '2026-05-21', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1305, '000000', 971039, '2026-05-22', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1306, '000000', 971039, '2026-05-23', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1307, '000000', 971039, '2026-05-24', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1308, '000000', 971039, '2026-05-25', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1309, '000000', 971039, '2026-05-26', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1310, '000000', 971039, '2026-05-27', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1311, '000000', 971039, '2026-05-28', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1312, '000000', 971039, '2026-05-29', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1313, '000000', 971039, '2026-05-30', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1314, '000000', 971039, '2026-05-31', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1315, '000000', 971039, '2026-06-01', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1316, '000000', 971039, '2026-06-02', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1317, '000000', 971039, '2026-06-03', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1318, '000000', 971039, '2026-06-04', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1319, '000000', 971039, '2026-06-05', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1320, '000000', 971039, '2026-06-06', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1321, '000000', 971039, '2026-06-07', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1322, '000000', 971039, '2026-06-08', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1323, '000000', 971039, '2026-06-09', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1324, '000000', 971039, '2026-06-10', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1325, '000000', 971039, '2026-06-11', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1326, '000000', 971039, '2026-06-12', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1327, '000000', 971039, '2026-06-13', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1328, '000000', 971039, '2026-06-14', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1329, '000000', 971039, '2026-06-15', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1330, '000000', 971039, '2026-06-16', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1331, '000000', 971039, '2026-06-17', '0', 199.00, NULL, 1, '2026-05-19 17:46:17', '2026-05-19 17:46:17');
INSERT INTO `hs_room_calendar` VALUES (1332, '000000', 13, '2026-05-19', '2', 468.00, 'OD20260519211829243254', 2, '2026-05-19 21:18:29', '2026-05-19 21:18:29');
INSERT INTO `hs_room_calendar` VALUES (1333, '000000', 971040, '2026-05-19', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1334, '000000', 971040, '2026-05-20', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1335, '000000', 971040, '2026-05-21', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1336, '000000', 971040, '2026-05-22', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1337, '000000', 971040, '2026-05-23', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1338, '000000', 971040, '2026-05-24', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1339, '000000', 971040, '2026-05-25', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1340, '000000', 971040, '2026-05-26', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1341, '000000', 971040, '2026-05-27', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1342, '000000', 971040, '2026-05-28', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1343, '000000', 971040, '2026-05-29', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1344, '000000', 971040, '2026-05-30', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1345, '000000', 971040, '2026-05-31', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1346, '000000', 971040, '2026-06-01', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1347, '000000', 971040, '2026-06-02', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1348, '000000', 971040, '2026-06-03', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1349, '000000', 971040, '2026-06-04', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1350, '000000', 971040, '2026-06-05', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1351, '000000', 971040, '2026-06-06', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1352, '000000', 971040, '2026-06-07', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1353, '000000', 971040, '2026-06-08', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1354, '000000', 971040, '2026-06-09', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1355, '000000', 971040, '2026-06-10', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1356, '000000', 971040, '2026-06-11', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1357, '000000', 971040, '2026-06-12', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1358, '000000', 971040, '2026-06-13', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1359, '000000', 971040, '2026-06-14', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1360, '000000', 971040, '2026-06-15', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1361, '000000', 971040, '2026-06-16', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1362, '000000', 971040, '2026-06-17', '0', 199.00, NULL, 1, '2026-05-19 23:00:35', '2026-05-19 23:00:35');
INSERT INTO `hs_room_calendar` VALUES (1363, '000000', 971041, '2026-05-19', '0', 199.00, NULL, 1, '2026-05-19 23:01:18', '2026-05-19 23:01:18');
INSERT INTO `hs_room_calendar` VALUES (1364, '000000', 971041, '2026-05-20', '0', 199.00, NULL, 1, '2026-05-19 23:01:18', '2026-05-19 23:01:18');
INSERT INTO `hs_room_calendar` VALUES (1365, '000000', 971041, '2026-05-21', '0', 199.00, NULL, 1, '2026-05-19 23:01:18', '2026-05-19 23:01:18');
INSERT INTO `hs_room_calendar` VALUES (1366, '000000', 971041, '2026-05-22', '0', 199.00, NULL, 1, '2026-05-19 23:01:18', '2026-05-19 23:01:18');
INSERT INTO `hs_room_calendar` VALUES (1367, '000000', 971041, '2026-05-23', '0', 199.00, NULL, 1, '2026-05-19 23:01:18', '2026-05-19 23:01:18');
INSERT INTO `hs_room_calendar` VALUES (1368, '000000', 971041, '2026-05-24', '0', 199.00, NULL, 1, '2026-05-19 23:01:18', '2026-05-19 23:01:18');
INSERT INTO `hs_room_calendar` VALUES (1369, '000000', 971041, '2026-05-25', '0', 199.00, NULL, 1, '2026-05-19 23:01:18', '2026-05-19 23:01:18');
INSERT INTO `hs_room_calendar` VALUES (1370, '000000', 971041, '2026-05-26', '0', 199.00, NULL, 1, '2026-05-19 23:01:18', '2026-05-19 23:01:18');
INSERT INTO `hs_room_calendar` VALUES (1371, '000000', 971041, '2026-05-27', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1372, '000000', 971041, '2026-05-28', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1373, '000000', 971041, '2026-05-29', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1374, '000000', 971041, '2026-05-30', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1375, '000000', 971041, '2026-05-31', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1376, '000000', 971041, '2026-06-01', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1377, '000000', 971041, '2026-06-02', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1378, '000000', 971041, '2026-06-03', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1379, '000000', 971041, '2026-06-04', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1380, '000000', 971041, '2026-06-05', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1381, '000000', 971041, '2026-06-06', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1382, '000000', 971041, '2026-06-07', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1383, '000000', 971041, '2026-06-08', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1384, '000000', 971041, '2026-06-09', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1385, '000000', 971041, '2026-06-10', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1386, '000000', 971041, '2026-06-11', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1387, '000000', 971041, '2026-06-12', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1388, '000000', 971041, '2026-06-13', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1389, '000000', 971041, '2026-06-14', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1390, '000000', 971041, '2026-06-15', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1391, '000000', 971041, '2026-06-16', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1392, '000000', 971041, '2026-06-17', '0', 199.00, NULL, 1, '2026-05-19 23:01:19', '2026-05-19 23:01:19');
INSERT INTO `hs_room_calendar` VALUES (1393, '000000', 3, '2026-05-19', '2', 388.00, 'OD20260519233300462983', 2, '2026-05-19 23:33:00', '2026-05-19 23:33:00');
INSERT INTO `hs_room_calendar` VALUES (1394, '000000', 3, '2026-05-27', '2', 388.00, 'OD20260519233858276310', 2, '2026-05-19 23:38:58', '2026-05-19 23:38:58');
INSERT INTO `hs_room_calendar` VALUES (1395, '000000', 3, '2026-05-28', '2', 388.00, 'OD20260519233858276310', 2, '2026-05-19 23:38:58', '2026-05-19 23:38:58');
INSERT INTO `hs_room_calendar` VALUES (1396, '000000', 971042, '2026-05-20', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1397, '000000', 971042, '2026-05-21', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1398, '000000', 971042, '2026-05-22', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1399, '000000', 971042, '2026-05-23', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1400, '000000', 971042, '2026-05-24', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1401, '000000', 971042, '2026-05-25', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1402, '000000', 971042, '2026-05-26', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1403, '000000', 971042, '2026-05-27', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1404, '000000', 971042, '2026-05-28', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1405, '000000', 971042, '2026-05-29', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1406, '000000', 971042, '2026-05-30', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1407, '000000', 971042, '2026-05-31', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1408, '000000', 971042, '2026-06-01', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1409, '000000', 971042, '2026-06-02', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1410, '000000', 971042, '2026-06-03', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1411, '000000', 971042, '2026-06-04', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1412, '000000', 971042, '2026-06-05', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1413, '000000', 971042, '2026-06-06', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1414, '000000', 971042, '2026-06-07', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1415, '000000', 971042, '2026-06-08', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1416, '000000', 971042, '2026-06-09', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1417, '000000', 971042, '2026-06-10', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1418, '000000', 971042, '2026-06-11', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1419, '000000', 971042, '2026-06-12', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1420, '000000', 971042, '2026-06-13', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1421, '000000', 971042, '2026-06-14', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1422, '000000', 971042, '2026-06-15', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1423, '000000', 971042, '2026-06-16', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1424, '000000', 971042, '2026-06-17', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1425, '000000', 971042, '2026-06-18', '0', 199.00, NULL, 1, '2026-05-20 00:39:51', '2026-05-20 00:39:51');
INSERT INTO `hs_room_calendar` VALUES (1426, '000000', 971043, '2026-05-20', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1427, '000000', 971043, '2026-05-21', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1428, '000000', 971043, '2026-05-22', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1429, '000000', 971043, '2026-05-23', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1430, '000000', 971043, '2026-05-24', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1431, '000000', 971043, '2026-05-25', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1432, '000000', 971043, '2026-05-26', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1433, '000000', 971043, '2026-05-27', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1434, '000000', 971043, '2026-05-28', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1435, '000000', 971043, '2026-05-29', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1436, '000000', 971043, '2026-05-30', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1437, '000000', 971043, '2026-05-31', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1438, '000000', 971043, '2026-06-01', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1439, '000000', 971043, '2026-06-02', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1440, '000000', 971043, '2026-06-03', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1441, '000000', 971043, '2026-06-04', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1442, '000000', 971043, '2026-06-05', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1443, '000000', 971043, '2026-06-06', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1444, '000000', 971043, '2026-06-07', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1445, '000000', 971043, '2026-06-08', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1446, '000000', 971043, '2026-06-09', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1447, '000000', 971043, '2026-06-10', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1448, '000000', 971043, '2026-06-11', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1449, '000000', 971043, '2026-06-12', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1450, '000000', 971043, '2026-06-13', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1451, '000000', 971043, '2026-06-14', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1452, '000000', 971043, '2026-06-15', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1453, '000000', 971043, '2026-06-16', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1454, '000000', 971043, '2026-06-17', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1455, '000000', 971043, '2026-06-18', '0', 199.00, NULL, 1, '2026-05-20 00:40:59', '2026-05-20 00:40:59');
INSERT INTO `hs_room_calendar` VALUES (1456, '000000', 3, '2026-05-20', '2', 388.00, 'OD20260520045932296940', 2, '2026-05-20 04:59:32', '2026-05-20 04:59:32');
INSERT INTO `hs_room_calendar` VALUES (1457, '000000', 3, '2026-05-21', '2', 388.00, 'OD20260520045932296940', 2, '2026-05-20 04:59:32', '2026-05-20 04:59:32');
INSERT INTO `hs_room_calendar` VALUES (1458, '000000', 1, '2026-06-22', '2', 299.00, 'OD20260520050157024551', 2, '2026-05-20 05:01:57', '2026-05-20 05:01:57');
INSERT INTO `hs_room_calendar` VALUES (1459, '000000', 10, '2026-06-02', '0', 268.00, NULL, 3, '2026-05-20 05:07:27', '2026-05-20 05:40:00');
INSERT INTO `hs_room_calendar` VALUES (1460, '000000', 971044, '2026-05-20', '2', 199.00, 'OD20260520054827864566', 2, '2026-05-20 05:26:11', '2026-05-20 05:48:27');
INSERT INTO `hs_room_calendar` VALUES (1461, '000000', 971044, '2026-05-21', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1462, '000000', 971044, '2026-05-22', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1463, '000000', 971044, '2026-05-23', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1464, '000000', 971044, '2026-05-24', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1465, '000000', 971044, '2026-05-25', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1466, '000000', 971044, '2026-05-26', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1467, '000000', 971044, '2026-05-27', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1468, '000000', 971044, '2026-05-28', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1469, '000000', 971044, '2026-05-29', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1470, '000000', 971044, '2026-05-30', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1471, '000000', 971044, '2026-05-31', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1472, '000000', 971044, '2026-06-01', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1473, '000000', 971044, '2026-06-02', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1474, '000000', 971044, '2026-06-03', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1475, '000000', 971044, '2026-06-04', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1476, '000000', 971044, '2026-06-05', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1477, '000000', 971044, '2026-06-06', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1478, '000000', 971044, '2026-06-07', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1479, '000000', 971044, '2026-06-08', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1480, '000000', 971044, '2026-06-09', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1481, '000000', 971044, '2026-06-10', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1482, '000000', 971044, '2026-06-11', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1483, '000000', 971044, '2026-06-12', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1484, '000000', 971044, '2026-06-13', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1485, '000000', 971044, '2026-06-14', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1486, '000000', 971044, '2026-06-15', '2', 199.00, 'OD20260520071422868628', 2, '2026-05-20 05:26:11', '2026-05-20 07:14:22');
INSERT INTO `hs_room_calendar` VALUES (1487, '000000', 971044, '2026-06-16', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1488, '000000', 971044, '2026-06-17', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1489, '000000', 971044, '2026-06-18', '0', 199.00, NULL, 1, '2026-05-20 05:26:11', '2026-05-20 05:26:11');
INSERT INTO `hs_room_calendar` VALUES (1490, '000000', 971045, '2026-05-20', '2', 200.00, 'OD20260520095252356379', 2, '2026-05-20 06:56:43', '2026-05-20 09:52:52');
INSERT INTO `hs_room_calendar` VALUES (1491, '000000', 971045, '2026-05-21', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1492, '000000', 971045, '2026-05-22', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1493, '000000', 971045, '2026-05-23', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1494, '000000', 971045, '2026-05-24', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1495, '000000', 971045, '2026-05-25', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1496, '000000', 971045, '2026-05-26', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1497, '000000', 971045, '2026-05-27', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1498, '000000', 971045, '2026-05-28', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1499, '000000', 971045, '2026-05-29', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1500, '000000', 971045, '2026-05-30', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1501, '000000', 971045, '2026-05-31', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1502, '000000', 971045, '2026-06-01', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1503, '000000', 971045, '2026-06-02', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1504, '000000', 971045, '2026-06-03', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1505, '000000', 971045, '2026-06-04', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1506, '000000', 971045, '2026-06-05', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1507, '000000', 971045, '2026-06-06', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1508, '000000', 971045, '2026-06-07', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1509, '000000', 971045, '2026-06-08', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1510, '000000', 971045, '2026-06-09', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1511, '000000', 971045, '2026-06-10', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1512, '000000', 971045, '2026-06-11', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1513, '000000', 971045, '2026-06-12', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1514, '000000', 971045, '2026-06-13', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1515, '000000', 971045, '2026-06-14', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1516, '000000', 971045, '2026-06-15', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1517, '000000', 971045, '2026-06-16', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1518, '000000', 971045, '2026-06-17', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1519, '000000', 971045, '2026-06-18', '0', 200.00, NULL, 1, '2026-05-20 06:56:43', '2026-05-20 06:56:43');
INSERT INTO `hs_room_calendar` VALUES (1520, '000000', 971045, '2026-06-23', '2', 200.00, 'OD20260520071704898377', 2, '2026-05-20 07:17:04', '2026-05-20 07:17:04');
INSERT INTO `hs_room_calendar` VALUES (1521, '000000', 971045, '2026-06-24', '2', 200.00, 'OD20260520071704898377', 2, '2026-05-20 07:17:04', '2026-05-20 07:17:04');
INSERT INTO `hs_room_calendar` VALUES (1522, '000000', 971044, '2026-07-28', '2', 199.00, 'OD20260520095040306815', 2, '2026-05-20 09:50:40', '2026-05-20 09:50:40');
INSERT INTO `hs_room_calendar` VALUES (1523, '000000', 971046, '2026-05-20', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1524, '000000', 971046, '2026-05-21', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1525, '000000', 971046, '2026-05-22', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1526, '000000', 971046, '2026-05-23', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1527, '000000', 971046, '2026-05-24', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1528, '000000', 971046, '2026-05-25', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1529, '000000', 971046, '2026-05-26', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1530, '000000', 971046, '2026-05-27', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1531, '000000', 971046, '2026-05-28', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1532, '000000', 971046, '2026-05-29', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1533, '000000', 971046, '2026-05-30', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1534, '000000', 971046, '2026-05-31', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1535, '000000', 971046, '2026-06-01', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1536, '000000', 971046, '2026-06-02', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1537, '000000', 971046, '2026-06-03', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1538, '000000', 971046, '2026-06-04', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1539, '000000', 971046, '2026-06-05', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1540, '000000', 971046, '2026-06-06', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1541, '000000', 971046, '2026-06-07', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1542, '000000', 971046, '2026-06-08', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1543, '000000', 971046, '2026-06-09', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1544, '000000', 971046, '2026-06-10', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1545, '000000', 971046, '2026-06-11', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1546, '000000', 971046, '2026-06-12', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1547, '000000', 971046, '2026-06-13', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1548, '000000', 971046, '2026-06-14', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1549, '000000', 971046, '2026-06-15', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1550, '000000', 971046, '2026-06-16', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1551, '000000', 971046, '2026-06-17', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1552, '000000', 971046, '2026-06-18', '0', 199.00, NULL, 1, '2026-05-20 10:02:55', '2026-05-20 10:02:55');
INSERT INTO `hs_room_calendar` VALUES (1553, '000000', 971047, '2026-05-20', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1554, '000000', 971047, '2026-05-21', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1555, '000000', 971047, '2026-05-22', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1556, '000000', 971047, '2026-05-23', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1557, '000000', 971047, '2026-05-24', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1558, '000000', 971047, '2026-05-25', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1559, '000000', 971047, '2026-05-26', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1560, '000000', 971047, '2026-05-27', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1561, '000000', 971047, '2026-05-28', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1562, '000000', 971047, '2026-05-29', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1563, '000000', 971047, '2026-05-30', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1564, '000000', 971047, '2026-05-31', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1565, '000000', 971047, '2026-06-01', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1566, '000000', 971047, '2026-06-02', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1567, '000000', 971047, '2026-06-03', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1568, '000000', 971047, '2026-06-04', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1569, '000000', 971047, '2026-06-05', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1570, '000000', 971047, '2026-06-06', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1571, '000000', 971047, '2026-06-07', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1572, '000000', 971047, '2026-06-08', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1573, '000000', 971047, '2026-06-09', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1574, '000000', 971047, '2026-06-10', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1575, '000000', 971047, '2026-06-11', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1576, '000000', 971047, '2026-06-12', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1577, '000000', 971047, '2026-06-13', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1578, '000000', 971047, '2026-06-14', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1579, '000000', 971047, '2026-06-15', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1580, '000000', 971047, '2026-06-16', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1581, '000000', 971047, '2026-06-17', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1582, '000000', 971047, '2026-06-18', '0', 199.00, NULL, 1, '2026-05-20 10:07:10', '2026-05-20 10:07:10');
INSERT INTO `hs_room_calendar` VALUES (1583, '000000', 971048, '2026-05-20', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1584, '000000', 971048, '2026-05-21', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1585, '000000', 971048, '2026-05-22', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1586, '000000', 971048, '2026-05-23', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1587, '000000', 971048, '2026-05-24', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1588, '000000', 971048, '2026-05-25', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1589, '000000', 971048, '2026-05-26', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1590, '000000', 971048, '2026-05-27', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1591, '000000', 971048, '2026-05-28', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1592, '000000', 971048, '2026-05-29', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1593, '000000', 971048, '2026-05-30', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1594, '000000', 971048, '2026-05-31', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1595, '000000', 971048, '2026-06-01', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1596, '000000', 971048, '2026-06-02', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1597, '000000', 971048, '2026-06-03', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1598, '000000', 971048, '2026-06-04', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1599, '000000', 971048, '2026-06-05', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1600, '000000', 971048, '2026-06-06', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1601, '000000', 971048, '2026-06-07', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1602, '000000', 971048, '2026-06-08', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1603, '000000', 971048, '2026-06-09', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1604, '000000', 971048, '2026-06-10', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1605, '000000', 971048, '2026-06-11', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1606, '000000', 971048, '2026-06-12', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1607, '000000', 971048, '2026-06-13', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1608, '000000', 971048, '2026-06-14', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1609, '000000', 971048, '2026-06-15', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1610, '000000', 971048, '2026-06-16', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1611, '000000', 971048, '2026-06-17', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1612, '000000', 971048, '2026-06-18', '0', 199.00, NULL, 1, '2026-05-20 11:16:24', '2026-05-20 11:16:24');
INSERT INTO `hs_room_calendar` VALUES (1613, '000000', 971049, '2026-05-20', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1614, '000000', 971049, '2026-05-21', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1615, '000000', 971049, '2026-05-22', '2', 288.00, 'OD20260522091511283558', 2, '2026-05-20 13:40:44', '2026-05-22 09:15:11');
INSERT INTO `hs_room_calendar` VALUES (1616, '000000', 971049, '2026-05-23', '0', 358.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1617, '000000', 971049, '2026-05-24', '0', 358.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1618, '000000', 971049, '2026-05-25', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1619, '000000', 971049, '2026-05-26', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1620, '000000', 971049, '2026-05-27', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1621, '000000', 971049, '2026-05-28', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1622, '000000', 971049, '2026-05-29', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1623, '000000', 971049, '2026-05-30', '0', 358.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1624, '000000', 971049, '2026-05-31', '0', 358.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1625, '000000', 971049, '2026-06-01', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1626, '000000', 971049, '2026-06-02', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1627, '000000', 971049, '2026-06-03', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1628, '000000', 971049, '2026-06-04', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1629, '000000', 971049, '2026-06-05', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1630, '000000', 971049, '2026-06-06', '0', 358.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1631, '000000', 971049, '2026-06-07', '0', 358.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1632, '000000', 971049, '2026-06-08', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1633, '000000', 971049, '2026-06-09', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1634, '000000', 971049, '2026-06-10', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1635, '000000', 971049, '2026-06-11', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1636, '000000', 971049, '2026-06-12', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1637, '000000', 971049, '2026-06-13', '0', 358.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1638, '000000', 971049, '2026-06-14', '0', 358.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1639, '000000', 971049, '2026-06-15', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1640, '000000', 971049, '2026-06-16', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1641, '000000', 971049, '2026-06-17', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1642, '000000', 971049, '2026-06-18', '0', 288.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1643, '000000', 971050, '2026-05-20', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1644, '000000', 971050, '2026-05-21', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1645, '000000', 971050, '2026-05-22', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1646, '000000', 971050, '2026-05-23', '0', 588.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1647, '000000', 971050, '2026-05-24', '0', 588.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1648, '000000', 971050, '2026-05-25', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1649, '000000', 971050, '2026-05-26', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1650, '000000', 971050, '2026-05-27', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1651, '000000', 971050, '2026-05-28', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1652, '000000', 971050, '2026-05-29', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1653, '000000', 971050, '2026-05-30', '0', 588.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1654, '000000', 971050, '2026-05-31', '0', 588.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1655, '000000', 971050, '2026-06-01', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1656, '000000', 971050, '2026-06-02', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1657, '000000', 971050, '2026-06-03', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1658, '000000', 971050, '2026-06-04', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1659, '000000', 971050, '2026-06-05', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1660, '000000', 971050, '2026-06-06', '0', 588.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1661, '000000', 971050, '2026-06-07', '0', 588.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1662, '000000', 971050, '2026-06-08', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1663, '000000', 971050, '2026-06-09', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1664, '000000', 971050, '2026-06-10', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1665, '000000', 971050, '2026-06-11', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1666, '000000', 971050, '2026-06-12', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1667, '000000', 971050, '2026-06-13', '0', 588.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1668, '000000', 971050, '2026-06-14', '0', 588.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1669, '000000', 971050, '2026-06-15', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1670, '000000', 971050, '2026-06-16', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1671, '000000', 971050, '2026-06-17', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1672, '000000', 971050, '2026-06-18', '0', 458.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1673, '000000', 971051, '2026-05-20', '0', 688.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1674, '000000', 971051, '2026-05-21', '0', 688.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1675, '000000', 971051, '2026-05-22', '0', 688.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1676, '000000', 971051, '2026-05-23', '0', 888.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1677, '000000', 971051, '2026-05-24', '0', 888.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1678, '000000', 971051, '2026-05-25', '0', 688.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1679, '000000', 971051, '2026-05-26', '0', 688.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1680, '000000', 971051, '2026-05-27', '0', 688.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1681, '000000', 971051, '2026-05-28', '0', 688.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1682, '000000', 971051, '2026-05-29', '0', 688.00, NULL, 1, '2026-05-20 13:40:44', '2026-05-20 13:40:44');
INSERT INTO `hs_room_calendar` VALUES (1683, '000000', 971051, '2026-05-30', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1684, '000000', 971051, '2026-05-31', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1685, '000000', 971051, '2026-06-01', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1686, '000000', 971051, '2026-06-02', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1687, '000000', 971051, '2026-06-03', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1688, '000000', 971051, '2026-06-04', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1689, '000000', 971051, '2026-06-05', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1690, '000000', 971051, '2026-06-06', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1691, '000000', 971051, '2026-06-07', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1692, '000000', 971051, '2026-06-08', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1693, '000000', 971051, '2026-06-09', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1694, '000000', 971051, '2026-06-10', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1695, '000000', 971051, '2026-06-11', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1696, '000000', 971051, '2026-06-12', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1697, '000000', 971051, '2026-06-13', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1698, '000000', 971051, '2026-06-14', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1699, '000000', 971051, '2026-06-15', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1700, '000000', 971051, '2026-06-16', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1701, '000000', 971051, '2026-06-17', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1702, '000000', 971051, '2026-06-18', '0', 688.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1703, '000000', 971052, '2026-05-20', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1704, '000000', 971052, '2026-05-21', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1705, '000000', 971052, '2026-05-22', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1706, '000000', 971052, '2026-05-23', '0', 428.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1707, '000000', 971052, '2026-05-24', '0', 428.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1708, '000000', 971052, '2026-05-25', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1709, '000000', 971052, '2026-05-26', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1710, '000000', 971052, '2026-05-27', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1711, '000000', 971052, '2026-05-28', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1712, '000000', 971052, '2026-05-29', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1713, '000000', 971052, '2026-05-30', '0', 428.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1714, '000000', 971052, '2026-05-31', '0', 428.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1715, '000000', 971052, '2026-06-01', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1716, '000000', 971052, '2026-06-02', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1717, '000000', 971052, '2026-06-03', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1718, '000000', 971052, '2026-06-04', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1719, '000000', 971052, '2026-06-05', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1720, '000000', 971052, '2026-06-06', '0', 428.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1721, '000000', 971052, '2026-06-07', '0', 428.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1722, '000000', 971052, '2026-06-08', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1723, '000000', 971052, '2026-06-09', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1724, '000000', 971052, '2026-06-10', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1725, '000000', 971052, '2026-06-11', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1726, '000000', 971052, '2026-06-12', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1727, '000000', 971052, '2026-06-13', '0', 428.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1728, '000000', 971052, '2026-06-14', '0', 428.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1729, '000000', 971052, '2026-06-15', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1730, '000000', 971052, '2026-06-16', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1731, '000000', 971052, '2026-06-17', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1732, '000000', 971052, '2026-06-18', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1733, '000000', 971053, '2026-05-20', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1734, '000000', 971053, '2026-05-21', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1735, '000000', 971053, '2026-05-22', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1736, '000000', 971053, '2026-05-23', '0', 1088.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1737, '000000', 971053, '2026-05-24', '0', 1088.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1738, '000000', 971053, '2026-05-25', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1739, '000000', 971053, '2026-05-26', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1740, '000000', 971053, '2026-05-27', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1741, '000000', 971053, '2026-05-28', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1742, '000000', 971053, '2026-05-29', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1743, '000000', 971053, '2026-05-30', '0', 1088.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1744, '000000', 971053, '2026-05-31', '0', 1088.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1745, '000000', 971053, '2026-06-01', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1746, '000000', 971053, '2026-06-02', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1747, '000000', 971053, '2026-06-03', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1748, '000000', 971053, '2026-06-04', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1749, '000000', 971053, '2026-06-05', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1750, '000000', 971053, '2026-06-06', '0', 1088.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1751, '000000', 971053, '2026-06-07', '0', 1088.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1752, '000000', 971053, '2026-06-08', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1753, '000000', 971053, '2026-06-09', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1754, '000000', 971053, '2026-06-10', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1755, '000000', 971053, '2026-06-11', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1756, '000000', 971053, '2026-06-12', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1757, '000000', 971053, '2026-06-13', '0', 1088.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1758, '000000', 971053, '2026-06-14', '0', 1088.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1759, '000000', 971053, '2026-06-15', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1760, '000000', 971053, '2026-06-16', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1761, '000000', 971053, '2026-06-17', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1762, '000000', 971053, '2026-06-18', '0', 888.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1763, '000000', 971054, '2026-05-20', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1764, '000000', 971054, '2026-05-21', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1765, '000000', 971054, '2026-05-22', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1766, '000000', 971054, '2026-05-23', '0', 498.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1767, '000000', 971054, '2026-05-24', '0', 498.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1768, '000000', 971054, '2026-05-25', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1769, '000000', 971054, '2026-05-26', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1770, '000000', 971054, '2026-05-27', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1771, '000000', 971054, '2026-05-28', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1772, '000000', 971054, '2026-05-29', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1773, '000000', 971054, '2026-05-30', '0', 498.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1774, '000000', 971054, '2026-05-31', '0', 498.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1775, '000000', 971054, '2026-06-01', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1776, '000000', 971054, '2026-06-02', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1777, '000000', 971054, '2026-06-03', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1778, '000000', 971054, '2026-06-04', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1779, '000000', 971054, '2026-06-05', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1780, '000000', 971054, '2026-06-06', '0', 498.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1781, '000000', 971054, '2026-06-07', '0', 498.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1782, '000000', 971054, '2026-06-08', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1783, '000000', 971054, '2026-06-09', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1784, '000000', 971054, '2026-06-10', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1785, '000000', 971054, '2026-06-11', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1786, '000000', 971054, '2026-06-12', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1787, '000000', 971054, '2026-06-13', '0', 498.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1788, '000000', 971054, '2026-06-14', '0', 498.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1789, '000000', 971054, '2026-06-15', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1790, '000000', 971054, '2026-06-16', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1791, '000000', 971054, '2026-06-17', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1792, '000000', 971054, '2026-06-18', '0', 398.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1793, '000000', 971055, '2026-05-20', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1794, '000000', 971055, '2026-05-21', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1795, '000000', 971055, '2026-05-22', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1796, '000000', 971055, '2026-05-23', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1797, '000000', 971055, '2026-05-24', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1798, '000000', 971055, '2026-05-25', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1799, '000000', 971055, '2026-05-26', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1800, '000000', 971055, '2026-05-27', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1801, '000000', 971055, '2026-05-28', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1802, '000000', 971055, '2026-05-29', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1803, '000000', 971055, '2026-05-30', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1804, '000000', 971055, '2026-05-31', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1805, '000000', 971055, '2026-06-01', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1806, '000000', 971055, '2026-06-02', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1807, '000000', 971055, '2026-06-03', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1808, '000000', 971055, '2026-06-04', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1809, '000000', 971055, '2026-06-05', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1810, '000000', 971055, '2026-06-06', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1811, '000000', 971055, '2026-06-07', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1812, '000000', 971055, '2026-06-08', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1813, '000000', 971055, '2026-06-09', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1814, '000000', 971055, '2026-06-10', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1815, '000000', 971055, '2026-06-11', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1816, '000000', 971055, '2026-06-12', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1817, '000000', 971055, '2026-06-13', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1818, '000000', 971055, '2026-06-14', '0', 328.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1819, '000000', 971055, '2026-06-15', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1820, '000000', 971055, '2026-06-16', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1821, '000000', 971055, '2026-06-17', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1822, '000000', 971055, '2026-06-18', '0', 258.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1823, '000000', 971056, '2026-05-20', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1824, '000000', 971056, '2026-05-21', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1825, '000000', 971056, '2026-05-22', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1826, '000000', 971056, '2026-05-23', '0', 1588.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1827, '000000', 971056, '2026-05-24', '0', 1588.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1828, '000000', 971056, '2026-05-25', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1829, '000000', 971056, '2026-05-26', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1830, '000000', 971056, '2026-05-27', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1831, '000000', 971056, '2026-05-28', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1832, '000000', 971056, '2026-05-29', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1833, '000000', 971056, '2026-05-30', '0', 1588.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1834, '000000', 971056, '2026-05-31', '0', 1588.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1835, '000000', 971056, '2026-06-01', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1836, '000000', 971056, '2026-06-02', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1837, '000000', 971056, '2026-06-03', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1838, '000000', 971056, '2026-06-04', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1839, '000000', 971056, '2026-06-05', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1840, '000000', 971056, '2026-06-06', '0', 1588.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1841, '000000', 971056, '2026-06-07', '0', 1588.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1842, '000000', 971056, '2026-06-08', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1843, '000000', 971056, '2026-06-09', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1844, '000000', 971056, '2026-06-10', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1845, '000000', 971056, '2026-06-11', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1846, '000000', 971056, '2026-06-12', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1847, '000000', 971056, '2026-06-13', '0', 1588.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1848, '000000', 971056, '2026-06-14', '0', 1588.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1849, '000000', 971056, '2026-06-15', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1850, '000000', 971056, '2026-06-16', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1851, '000000', 971056, '2026-06-17', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1852, '000000', 971056, '2026-06-18', '0', 1288.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1853, '000000', 971057, '2026-05-20', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1854, '000000', 971057, '2026-05-21', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1855, '000000', 971057, '2026-05-22', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1856, '000000', 971057, '2026-05-23', '0', 378.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1857, '000000', 971057, '2026-05-24', '0', 378.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1858, '000000', 971057, '2026-05-25', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1859, '000000', 971057, '2026-05-26', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1860, '000000', 971057, '2026-05-27', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1861, '000000', 971057, '2026-05-28', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1862, '000000', 971057, '2026-05-29', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1863, '000000', 971057, '2026-05-30', '0', 378.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1864, '000000', 971057, '2026-05-31', '0', 378.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1865, '000000', 971057, '2026-06-01', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1866, '000000', 971057, '2026-06-02', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1867, '000000', 971057, '2026-06-03', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1868, '000000', 971057, '2026-06-04', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1869, '000000', 971057, '2026-06-05', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1870, '000000', 971057, '2026-06-06', '0', 378.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1871, '000000', 971057, '2026-06-07', '0', 378.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1872, '000000', 971057, '2026-06-08', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1873, '000000', 971057, '2026-06-09', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1874, '000000', 971057, '2026-06-10', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1875, '000000', 971057, '2026-06-11', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1876, '000000', 971057, '2026-06-12', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1877, '000000', 971057, '2026-06-13', '0', 378.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1878, '000000', 971057, '2026-06-14', '0', 378.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1879, '000000', 971057, '2026-06-15', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1880, '000000', 971057, '2026-06-16', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1881, '000000', 971057, '2026-06-17', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1882, '000000', 971057, '2026-06-18', '0', 298.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1883, '000000', 971058, '2026-05-20', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1884, '000000', 971058, '2026-05-21', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1885, '000000', 971058, '2026-05-22', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1886, '000000', 971058, '2026-05-23', '0', 438.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1887, '000000', 971058, '2026-05-24', '0', 438.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1888, '000000', 971058, '2026-05-25', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1889, '000000', 971058, '2026-05-26', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1890, '000000', 971058, '2026-05-27', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1891, '000000', 971058, '2026-05-28', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1892, '000000', 971058, '2026-05-29', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1893, '000000', 971058, '2026-05-30', '0', 438.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1894, '000000', 971058, '2026-05-31', '0', 438.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1895, '000000', 971058, '2026-06-01', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1896, '000000', 971058, '2026-06-02', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1897, '000000', 971058, '2026-06-03', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1898, '000000', 971058, '2026-06-04', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1899, '000000', 971058, '2026-06-05', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1900, '000000', 971058, '2026-06-06', '0', 438.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1901, '000000', 971058, '2026-06-07', '0', 438.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1902, '000000', 971058, '2026-06-08', '0', 338.00, NULL, 1, '2026-05-20 13:40:45', '2026-05-20 13:40:45');
INSERT INTO `hs_room_calendar` VALUES (1903, '000000', 971058, '2026-06-09', '0', 338.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1904, '000000', 971058, '2026-06-10', '0', 338.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1905, '000000', 971058, '2026-06-11', '0', 338.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1906, '000000', 971058, '2026-06-12', '0', 338.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1907, '000000', 971058, '2026-06-13', '0', 438.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1908, '000000', 971058, '2026-06-14', '0', 438.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1909, '000000', 971058, '2026-06-15', '0', 338.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1910, '000000', 971058, '2026-06-16', '0', 338.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1911, '000000', 971058, '2026-06-17', '0', 338.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1912, '000000', 971058, '2026-06-18', '0', 338.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1913, '000000', 971059, '2026-05-20', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1914, '000000', 971059, '2026-05-21', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1915, '000000', 971059, '2026-05-22', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1916, '000000', 971059, '2026-05-23', '0', 468.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1917, '000000', 971059, '2026-05-24', '0', 468.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1918, '000000', 971059, '2026-05-25', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1919, '000000', 971059, '2026-05-26', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1920, '000000', 971059, '2026-05-27', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1921, '000000', 971059, '2026-05-28', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1922, '000000', 971059, '2026-05-29', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1923, '000000', 971059, '2026-05-30', '0', 468.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1924, '000000', 971059, '2026-05-31', '0', 468.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1925, '000000', 971059, '2026-06-01', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1926, '000000', 971059, '2026-06-02', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1927, '000000', 971059, '2026-06-03', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1928, '000000', 971059, '2026-06-04', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1929, '000000', 971059, '2026-06-05', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1930, '000000', 971059, '2026-06-06', '0', 468.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1931, '000000', 971059, '2026-06-07', '0', 468.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1932, '000000', 971059, '2026-06-08', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1933, '000000', 971059, '2026-06-09', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1934, '000000', 971059, '2026-06-10', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1935, '000000', 971059, '2026-06-11', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1936, '000000', 971059, '2026-06-12', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1937, '000000', 971059, '2026-06-13', '0', 468.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1938, '000000', 971059, '2026-06-14', '0', 468.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1939, '000000', 971059, '2026-06-15', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1940, '000000', 971059, '2026-06-16', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1941, '000000', 971059, '2026-06-17', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1942, '000000', 971059, '2026-06-18', '0', 368.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1943, '000000', 971060, '2026-05-20', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1944, '000000', 971060, '2026-05-21', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1945, '000000', 971060, '2026-05-22', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1946, '000000', 971060, '2026-05-23', '0', 588.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1947, '000000', 971060, '2026-05-24', '0', 588.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1948, '000000', 971060, '2026-05-25', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1949, '000000', 971060, '2026-05-26', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1950, '000000', 971060, '2026-05-27', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1951, '000000', 971060, '2026-05-28', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1952, '000000', 971060, '2026-05-29', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1953, '000000', 971060, '2026-05-30', '0', 588.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1954, '000000', 971060, '2026-05-31', '0', 588.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1955, '000000', 971060, '2026-06-01', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1956, '000000', 971060, '2026-06-02', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1957, '000000', 971060, '2026-06-03', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1958, '000000', 971060, '2026-06-04', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1959, '000000', 971060, '2026-06-05', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1960, '000000', 971060, '2026-06-06', '0', 588.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1961, '000000', 971060, '2026-06-07', '0', 588.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1962, '000000', 971060, '2026-06-08', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1963, '000000', 971060, '2026-06-09', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1964, '000000', 971060, '2026-06-10', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1965, '000000', 971060, '2026-06-11', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1966, '000000', 971060, '2026-06-12', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1967, '000000', 971060, '2026-06-13', '0', 588.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1968, '000000', 971060, '2026-06-14', '0', 588.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1969, '000000', 971060, '2026-06-15', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1970, '000000', 971060, '2026-06-16', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1971, '000000', 971060, '2026-06-17', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1972, '000000', 971060, '2026-06-18', '0', 488.00, NULL, 1, '2026-05-20 13:40:46', '2026-05-20 13:40:46');
INSERT INTO `hs_room_calendar` VALUES (1973, '000000', 971085, '2026-05-20', '2', 199.00, 'OD20260520141825187794', 2, '2026-05-20 14:16:22', '2026-05-20 14:18:25');
INSERT INTO `hs_room_calendar` VALUES (1974, '000000', 971085, '2026-05-21', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1975, '000000', 971085, '2026-05-22', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1976, '000000', 971085, '2026-05-23', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1977, '000000', 971085, '2026-05-24', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1978, '000000', 971085, '2026-05-25', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1979, '000000', 971085, '2026-05-26', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1980, '000000', 971085, '2026-05-27', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1981, '000000', 971085, '2026-05-28', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1982, '000000', 971085, '2026-05-29', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1983, '000000', 971085, '2026-05-30', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1984, '000000', 971085, '2026-05-31', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1985, '000000', 971085, '2026-06-01', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1986, '000000', 971085, '2026-06-02', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1987, '000000', 971085, '2026-06-03', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1988, '000000', 971085, '2026-06-04', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1989, '000000', 971085, '2026-06-05', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1990, '000000', 971085, '2026-06-06', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1991, '000000', 971085, '2026-06-07', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1992, '000000', 971085, '2026-06-08', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1993, '000000', 971085, '2026-06-09', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1994, '000000', 971085, '2026-06-10', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1995, '000000', 971085, '2026-06-11', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1996, '000000', 971085, '2026-06-12', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1997, '000000', 971085, '2026-06-13', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1998, '000000', 971085, '2026-06-14', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (1999, '000000', 971085, '2026-06-15', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (2000, '000000', 971085, '2026-06-16', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (2001, '000000', 971085, '2026-06-17', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (2002, '000000', 971085, '2026-06-18', '0', 199.00, NULL, 1, '2026-05-20 14:16:22', '2026-05-20 14:16:22');
INSERT INTO `hs_room_calendar` VALUES (2003, '000000', 971086, '2026-05-20', '2', 199.00, 'OD20260520145826793309', 2, '2026-05-20 14:51:07', '2026-05-20 14:58:26');
INSERT INTO `hs_room_calendar` VALUES (2004, '000000', 971086, '2026-05-21', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2005, '000000', 971086, '2026-05-22', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2006, '000000', 971086, '2026-05-23', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2007, '000000', 971086, '2026-05-24', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2008, '000000', 971086, '2026-05-25', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2009, '000000', 971086, '2026-05-26', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2010, '000000', 971086, '2026-05-27', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2011, '000000', 971086, '2026-05-28', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2012, '000000', 971086, '2026-05-29', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2013, '000000', 971086, '2026-05-30', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2014, '000000', 971086, '2026-05-31', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2015, '000000', 971086, '2026-06-01', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2016, '000000', 971086, '2026-06-02', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2017, '000000', 971086, '2026-06-03', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2018, '000000', 971086, '2026-06-04', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2019, '000000', 971086, '2026-06-05', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2020, '000000', 971086, '2026-06-06', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2021, '000000', 971086, '2026-06-07', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2022, '000000', 971086, '2026-06-08', '2', 199.00, 'OD20260520145532416860', 2, '2026-05-20 14:51:07', '2026-05-20 14:55:32');
INSERT INTO `hs_room_calendar` VALUES (2023, '000000', 971086, '2026-06-09', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2024, '000000', 971086, '2026-06-10', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2025, '000000', 971086, '2026-06-11', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2026, '000000', 971086, '2026-06-12', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2027, '000000', 971086, '2026-06-13', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2028, '000000', 971086, '2026-06-14', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2029, '000000', 971086, '2026-06-15', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2030, '000000', 971086, '2026-06-16', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2031, '000000', 971086, '2026-06-17', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');
INSERT INTO `hs_room_calendar` VALUES (2032, '000000', 971086, '2026-06-18', '0', 199.00, NULL, 1, '2026-05-20 14:51:07', '2026-05-20 14:51:07');

-- ----------------------------
-- Table structure for hs_supervision_report
-- ----------------------------
DROP TABLE IF EXISTS `hs_supervision_report`;
CREATE TABLE `hs_supervision_report`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'pk',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '000000',
  `report_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'biz id, SUPxxxx',
  `report_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '1-homestay 2-checkin 3-order-stat',
  `biz_id` bigint(0) NOT NULL COMMENT 'related business id',
  `report_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '0-pending 1-success 2-failed',
  `retry_count` int(0) NOT NULL DEFAULT 0,
  `request_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `response_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `last_report_time` datetime(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_hs_sup_no`(`report_no`) USING BTREE,
  INDEX `idx_hs_sup_type_status`(`report_type`, `report_status`) USING BTREE,
  INDEX `idx_hs_sup_biz`(`biz_id`) USING BTREE,
  INDEX `idx_hs_sup_time`(`last_report_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 976088 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'supervision report log' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_supervision_report
-- ----------------------------
INSERT INTO `hs_supervision_report` VALUES (3, '000000', 'SUP20260222221520041531', '2', 2, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":2,\"orderNo\":\"ODDEMO0001\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-02-25 00:00:00\",\"checkoutDate\":\"2026-02-27 00:00:00\",\"generatedAt\":\"2026-02-22 22:15:20.046\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-22 22:15:24', '2026-02-22 22:15:20', '2026-02-22 22:15:24');
INSERT INTO `hs_supervision_report` VALUES (4, '000000', 'SUP20260222221541584620', '1', 1, '1', 1, '{\"source\":\"admin-page\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-23 16:09:46', '2026-02-22 22:15:41', '2026-02-23 16:09:46');
INSERT INTO `hs_supervision_report` VALUES (5, '000000', 'SUP20260222221543261296', '1', 1, '1', 1, '{\"source\":\"admin-page\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-23 16:09:46', '2026-02-22 22:15:43', '2026-02-23 16:09:46');
INSERT INTO `hs_supervision_report` VALUES (6, '000000', 'SUP20260222221549573394', '2', 1, '1', 1, '{\"source\":\"admin-page\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-23 16:09:46', '2026-02-22 22:15:49', '2026-02-23 16:09:46');
INSERT INTO `hs_supervision_report` VALUES (7, '000000', 'SUP20260223160952177678', '3', 1, '2', 1, '{\"source\":\"admin-page\"}', '{\"code\":500,\"msg\":\"mock push failed\"}', '2026-02-25 19:04:29', '2026-02-23 16:09:52', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (8, '000000', 'SUP20260223160956623726', '2', 1, '1', 1, '{\"source\":\"admin-page\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-23 16:09:56', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976001, '000000', 'SUPZH200001', '1', 971001, '1', 1, '{\"业务\": \"房源上报\", \"编号\": 1}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-24 12:15:29', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976002, '000000', 'SUPZH200002', '2', 972002, '1', 1, '{\"业务\": \"入住上报\", \"编号\": 2}', '{\"msg\": \"上报成功\", \"code\": 0}', '2026-02-24 10:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976003, '000000', 'SUPZH200003', '3', 972003, '1', 1, '{\"业务\": \"经营统计\", \"编号\": 3}', '{\"msg\": \"上报成功\", \"code\": 0}', '2026-02-24 09:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976004, '000000', 'SUPZH200004', '1', 971004, '2', 2, '{\"业务\": \"房源上报\", \"编号\": 4}', '{\"msg\": \"监管端超时，待重试\", \"code\": 500}', '2026-02-24 08:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976005, '000000', 'SUPZH200005', '2', 972005, '1', 1, '{\"业务\": \"入住上报\", \"编号\": 5}', '{\"msg\": \"上报成功\", \"code\": 0}', '2026-02-24 07:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976006, '000000', 'SUPZH200006', '3', 972006, '2', 1, '{\"业务\": \"经营统计\", \"编号\": 6}', '{\"code\":500,\"msg\":\"mock push failed\"}', '2026-02-25 19:04:29', '2026-02-24 12:15:29', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976007, '000000', 'SUPZH200007', '1', 971007, '1', 1, '{\"业务\": \"房源上报\", \"编号\": 7}', '{\"msg\": \"上报成功\", \"code\": 0}', '2026-02-24 05:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976008, '000000', 'SUPZH200008', '2', 972008, '1', 1, '{\"业务\": \"入住上报\", \"编号\": 8}', '{\"msg\": \"上报成功\", \"code\": 0}', '2026-02-24 04:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976009, '000000', 'SUPZH200009', '3', 972009, '2', 2, '{\"业务\": \"经营统计\", \"编号\": 9}', '{\"msg\": \"监管端超时，待重试\", \"code\": 500}', '2026-02-24 12:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976010, '000000', 'SUPZH200010', '1', 971010, '1', 1, '{\"业务\": \"房源上报\", \"编号\": 10}', '{\"msg\": \"上报成功\", \"code\": 0}', '2026-02-24 11:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976011, '000000', 'SUPZH200011', '2', 972011, '1', 1, '{\"业务\": \"入住上报\", \"编号\": 11}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-24 12:15:29', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976012, '000000', 'SUPZH200012', '3', 972012, '1', 1, '{\"业务\": \"经营统计\", \"编号\": 12}', '{\"msg\": \"上报成功\", \"code\": 0}', '2026-02-24 09:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976013, '000000', 'SUPZH200013', '1', 971013, '1', 1, '{\"业务\": \"房源上报\", \"编号\": 13}', '{\"msg\": \"上报成功\", \"code\": 0}', '2026-02-24 08:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976014, '000000', 'SUPZH200014', '2', 972014, '2', 2, '{\"业务\": \"入住上报\", \"编号\": 14}', '{\"msg\": \"监管端超时，待重试\", \"code\": 500}', '2026-02-24 07:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976015, '000000', 'SUPZH200015', '3', 972015, '1', 1, '{\"业务\": \"经营统计\", \"编号\": 15}', '{\"msg\": \"上报成功\", \"code\": 0}', '2026-02-24 06:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976016, '000000', 'SUPZH200016', '1', 971016, '1', 1, '{\"业务\": \"房源上报\", \"编号\": 16}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-24 12:15:29', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976017, '000000', 'SUPZH200017', '2', 972017, '1', 1, '{\"业务\": \"入住上报\", \"编号\": 17}', '{\"msg\": \"上报成功\", \"code\": 0}', '2026-02-24 04:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976018, '000000', 'SUPZH200018', '3', 972018, '1', 1, '{\"业务\": \"经营统计\", \"编号\": 18}', '{\"msg\": \"上报成功\", \"code\": 0}', '2026-02-24 12:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976019, '000000', 'SUPZH200019', '1', 971019, '2', 2, '{\"业务\": \"房源上报\", \"编号\": 19}', '{\"msg\": \"监管端超时，待重试\", \"code\": 500}', '2026-02-24 11:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976020, '000000', 'SUPZH200020', '2', 972020, '1', 1, '{\"业务\": \"入住上报\", \"编号\": 20}', '{\"msg\": \"上报成功\", \"code\": 0}', '2026-02-24 10:15:29', '2026-02-24 12:15:29', '2026-02-24 12:15:29');
INSERT INTO `hs_supervision_report` VALUES (976021, '000000', 'SUPDEMO0001', '3', 1, '1', 0, '{\"scope\": \"order-stat\", \"source\": \"seed\"}', '{\"code\": 200, \"message\": \"ok\"}', '2026-02-25 14:24:36', '2026-02-25 14:24:36', '2026-02-25 14:24:36');
INSERT INTO `hs_supervision_report` VALUES (976022, '000000', 'SUP20260225190335230528', '2', 972003, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972003,\"orderNo\":\"ODZH600003\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-04 00:00:00\",\"checkoutDate\":\"2026-03-05 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.231\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976023, '000000', 'SUP20260225190335243239', '2', 972009, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972009,\"orderNo\":\"ODZH600009\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-16 00:00:00\",\"checkoutDate\":\"2026-03-17 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.243\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976024, '000000', 'SUP20260225190335247446', '2', 972015, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972015,\"orderNo\":\"ODZH600015\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-04 00:00:00\",\"checkoutDate\":\"2026-03-05 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.247\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976025, '000000', 'SUP20260225190335251532', '2', 972021, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972021,\"orderNo\":\"ODZH600021\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-16 00:00:00\",\"checkoutDate\":\"2026-03-17 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.251\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976026, '000000', 'SUP20260225190335255352', '2', 972027, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972027,\"orderNo\":\"ODZH600027\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-04 00:00:00\",\"checkoutDate\":\"2026-03-05 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.255\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976027, '000000', 'SUP20260225190335261117', '2', 972033, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972033,\"orderNo\":\"ODZH600033\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-16 00:00:00\",\"checkoutDate\":\"2026-03-17 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.261\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976028, '000000', 'SUP20260225190335265323', '2', 972039, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972039,\"orderNo\":\"ODZH600039\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-04 00:00:00\",\"checkoutDate\":\"2026-03-05 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.265\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976029, '000000', 'SUP20260225190335268391', '2', 972045, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972045,\"orderNo\":\"ODZH600045\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-16 00:00:00\",\"checkoutDate\":\"2026-03-17 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.268\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976030, '000000', 'SUP20260225190335272967', '2', 972051, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972051,\"orderNo\":\"ODZH600051\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-04 00:00:00\",\"checkoutDate\":\"2026-03-05 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.272\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976031, '000000', 'SUP20260225190335276732', '2', 972057, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972057,\"orderNo\":\"ODZH600057\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-16 00:00:00\",\"checkoutDate\":\"2026-03-17 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.276\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976032, '000000', 'SUP20260225190335279247', '2', 972004, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972004,\"orderNo\":\"ODZH600004\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-06 00:00:00\",\"checkoutDate\":\"2026-03-08 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.279\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976033, '000000', 'SUP20260225190335282223', '2', 972010, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972010,\"orderNo\":\"ODZH600010\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-18 00:00:00\",\"checkoutDate\":\"2026-03-20 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.282\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976034, '000000', 'SUP20260225190335285652', '2', 972016, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972016,\"orderNo\":\"ODZH600016\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-06 00:00:00\",\"checkoutDate\":\"2026-03-08 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.285\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976035, '000000', 'SUP20260225190335288281', '2', 972022, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972022,\"orderNo\":\"ODZH600022\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-18 00:00:00\",\"checkoutDate\":\"2026-03-20 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.288\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976036, '000000', 'SUP20260225190335292348', '2', 972028, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972028,\"orderNo\":\"ODZH600028\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-06 00:00:00\",\"checkoutDate\":\"2026-03-08 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.292\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976037, '000000', 'SUP20260225190335296516', '2', 972034, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972034,\"orderNo\":\"ODZH600034\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-18 00:00:00\",\"checkoutDate\":\"2026-03-20 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.296\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:28');
INSERT INTO `hs_supervision_report` VALUES (976038, '000000', 'SUP20260225190335300872', '2', 972040, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972040,\"orderNo\":\"ODZH600040\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-06 00:00:00\",\"checkoutDate\":\"2026-03-08 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.3\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:29');
INSERT INTO `hs_supervision_report` VALUES (976039, '000000', 'SUP20260225190335303695', '2', 972046, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972046,\"orderNo\":\"ODZH600046\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-18 00:00:00\",\"checkoutDate\":\"2026-03-20 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.303\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:29');
INSERT INTO `hs_supervision_report` VALUES (976040, '000000', 'SUP20260225190335307475', '2', 972052, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972052,\"orderNo\":\"ODZH600052\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-06 00:00:00\",\"checkoutDate\":\"2026-03-08 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.307\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:29');
INSERT INTO `hs_supervision_report` VALUES (976041, '000000', 'SUP20260225190335311549', '2', 972058, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972058,\"orderNo\":\"ODZH600058\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-18 00:00:00\",\"checkoutDate\":\"2026-03-20 00:00:00\",\"generatedAt\":\"2026-02-25 19:03:35.311\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 19:04:29', '2026-02-25 19:03:35', '2026-02-25 19:04:29');
INSERT INTO `hs_supervision_report` VALUES (976042, '000000', 'SUP20260225190453667749', '3', 1772017493622, '2', 1, '{\"source\":\"admin-ui\",\"scene\":\"manual-failure-demo\"}', '{\"code\":500,\"msg\":\"mock push failed\"}', '2026-02-25 19:04:54', '2026-02-25 19:04:53', '2026-02-25 19:04:53');
INSERT INTO `hs_supervision_report` VALUES (976043, '000000', 'SUP20260225190455359245', '3', 1772017495351, '2', 1, '{\"source\":\"admin-ui\",\"scene\":\"manual-failure-demo\"}', '{\"code\":500,\"msg\":\"mock push failed\"}', '2026-02-25 19:04:55', '2026-02-25 19:04:55', '2026-02-25 19:04:55');
INSERT INTO `hs_supervision_report` VALUES (976044, '000000', 'SUP20260225210023124882', '2', 972061, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972061,\"orderNo\":\"ODDEMO0001\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-02-28 00:00:00\",\"checkoutDate\":\"2026-03-02 00:00:00\",\"generatedAt\":\"2026-02-25 21:00:23.128\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-25 21:27:56', '2026-02-25 21:00:23', '2026-02-25 21:27:56');
INSERT INTO `hs_supervision_report` VALUES (976045, '000000', 'SUP20260226000920055714', '3', 1772035759969, '2', 1, '{\"source\":\"admin-ui\",\"scene\":\"manual-failure-demo\"}', '{\"msg\":\"mock push failed\",\"code\":500}', '2026-02-26 00:09:20', '2026-02-26 00:09:20', '2026-02-26 00:09:20');
INSERT INTO `hs_supervision_report` VALUES (976046, '000000', 'SUP20260226000922004411', '3', 1772035761992, '2', 1, '{\"source\":\"admin-ui\",\"scene\":\"manual-failure-demo\"}', '{\"msg\":\"mock push failed\",\"code\":500}', '2026-02-26 00:09:22', '2026-02-26 00:09:22', '2026-02-26 00:09:22');
INSERT INTO `hs_supervision_report` VALUES (976047, '000000', 'SUP20260227131546988854', '3', 1772169346941, '2', 1, '{\"scene\":\"ui-demo-fail\"}', '{\"code\":500,\"msg\":\"mock push failed\"}', '2026-02-27 13:15:47', '2026-02-27 13:15:46', '2026-02-27 13:15:47');
INSERT INTO `hs_supervision_report` VALUES (976048, '000000', 'SUP20260228100438058807', '2', 972064, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972064,\"orderNo\":\"OD20260225233916091960\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-02-25 00:00:00\",\"checkoutDate\":\"2026-02-26 00:00:00\",\"generatedAt\":\"2026-02-28 10:04:38.061\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-02-28 10:04:43', '2026-02-28 10:04:38', '2026-02-28 10:04:42');
INSERT INTO `hs_supervision_report` VALUES (976049, '000000', 'SUP20260228154233516510', '3', 1772264553498, '2', 1, '{\"scene\":\"ui-demo-fail\"}', '{\"code\":500,\"msg\":\"mock push failed\"}', '2026-02-28 15:42:34', '2026-02-28 15:42:33', '2026-02-28 15:42:33');
INSERT INTO `hs_supervision_report` VALUES (976050, '000000', 'SUP20260305182405754139', '2', 972068, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972068,\"orderNo\":\"OD20260305182329538220\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":1,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-05 00:00:00\",\"checkoutDate\":\"2026-03-06 00:00:00\",\"generatedAt\":\"2026-03-05 18:24:05.755\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-03-05 18:24:11', '2026-03-05 18:24:05', '2026-03-05 18:24:11');
INSERT INTO `hs_supervision_report` VALUES (976051, '000000', 'SUP20260305193624125626', '2', 972069, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972069,\"orderNo\":\"OD20260305193601721579\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":1,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-08 00:00:00\",\"checkoutDate\":\"2026-03-09 00:00:00\",\"generatedAt\":\"2026-03-05 19:36:24.125\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-03-05 19:36:26', '2026-03-05 19:36:24', '2026-03-05 19:36:25');
INSERT INTO `hs_supervision_report` VALUES (976052, '000000', 'SUP20260307111113279160', '2', 972070, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972070,\"orderNo\":\"OD20260307111032900728\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2003,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-07 00:00:00\",\"checkoutDate\":\"2026-03-08 00:00:00\",\"generatedAt\":\"2026-03-07 11:11:13.279\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-03-07 19:50:51', '2026-03-07 11:11:13', '2026-03-07 19:50:50');
INSERT INTO `hs_supervision_report` VALUES (976053, '000000', 'SUP20260307195048215415', '2', 972071, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972071,\"orderNo\":\"OD20260307195030183112\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2003,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-07 00:00:00\",\"checkoutDate\":\"2026-03-08 00:00:00\",\"generatedAt\":\"2026-03-07 19:50:48.216\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-03-07 19:50:51', '2026-03-07 19:50:48', '2026-03-07 19:50:50');
INSERT INTO `hs_supervision_report` VALUES (976054, '000000', 'SUP20260518160641763237', '3', 1779091601717, '2', 1, '{\"source\":\"admin-ui\",\"scene\":\"manual-failure-demo\"}', '{\"msg\":\"mock push failed\",\"code\":500}', '2026-05-18 16:06:42', '2026-05-18 16:06:41', '2026-05-18 16:06:41');
INSERT INTO `hs_supervision_report` VALUES (976055, '000000', 'SUP20260518225936482560', '3', 1779116376466, '2', 1, '{\"source\":\"admin-ui\",\"scene\":\"manual-failure-demo\"}', '{\"msg\":\"mock push failed\",\"code\":500}', '2026-05-18 22:59:37', '2026-05-18 22:59:36', '2026-05-18 22:59:36');
INSERT INTO `hs_supervision_report` VALUES (976056, '000000', 'SUP20260518225938079497', '3', 1779116378071, '2', 1, '{\"source\":\"admin-ui\",\"scene\":\"manual-failure-demo\"}', '{\"msg\":\"mock push failed\",\"code\":500}', '2026-05-18 22:59:38', '2026-05-18 22:59:38', '2026-05-18 22:59:38');
INSERT INTO `hs_supervision_report` VALUES (976057, '000000', 'SUP20260518225939109123', '3', 1779116379101, '2', 1, '{\"source\":\"admin-ui\",\"scene\":\"manual-failure-demo\"}', '{\"msg\":\"mock push failed\",\"code\":500}', '2026-05-18 22:59:39', '2026-05-18 22:59:39', '2026-05-18 22:59:39');
INSERT INTO `hs_supervision_report` VALUES (976058, '000000', 'SUP20260519164527377952', '2', 972076, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972076,\"orderNo\":\"OD20260518223804167498\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2007,\"landlordUserId\":1,\"checkinDate\":\"2026-05-23 00:00:00\",\"checkoutDate\":\"2026-05-24 00:00:00\",\"generatedAt\":\"2026-05-19 16:45:27.377\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-19 16:45:31', '2026-05-19 16:45:27', '2026-05-19 16:45:31');
INSERT INTO `hs_supervision_report` VALUES (976059, '000000', 'SUP20260519164527382478', '2', 972038, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972038,\"orderNo\":\"ODZH600038\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-02 00:00:00\",\"checkoutDate\":\"2026-03-05 00:00:00\",\"generatedAt\":\"2026-05-19 16:45:27.382\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-19 16:45:31', '2026-05-19 16:45:27', '2026-05-19 16:45:31');
INSERT INTO `hs_supervision_report` VALUES (976060, '000000', 'SUP20260519164527384939', '2', 972044, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972044,\"orderNo\":\"ODZH600044\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-14 00:00:00\",\"checkoutDate\":\"2026-03-17 00:00:00\",\"generatedAt\":\"2026-05-19 16:45:27.384\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-19 16:45:31', '2026-05-19 16:45:27', '2026-05-19 16:45:31');
INSERT INTO `hs_supervision_report` VALUES (976061, '000000', 'SUP20260519164527387778', '2', 972050, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972050,\"orderNo\":\"ODZH600050\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-02 00:00:00\",\"checkoutDate\":\"2026-03-05 00:00:00\",\"generatedAt\":\"2026-05-19 16:45:27.387\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-19 16:45:31', '2026-05-19 16:45:27', '2026-05-19 16:45:31');
INSERT INTO `hs_supervision_report` VALUES (976062, '000000', 'SUP20260519164527390355', '2', 972056, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972056,\"orderNo\":\"ODZH600056\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-14 00:00:00\",\"checkoutDate\":\"2026-03-17 00:00:00\",\"generatedAt\":\"2026-05-19 16:45:27.391\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-19 16:45:31', '2026-05-19 16:45:27', '2026-05-19 16:45:31');
INSERT INTO `hs_supervision_report` VALUES (976063, '000000', 'SUP20260519175938436828', '2', 972092, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972092,\"orderNo\":\"OD20260519173758068299\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2007,\"landlordUserId\":1,\"checkinDate\":\"2026-05-27 00:00:00\",\"checkoutDate\":\"2026-05-28 00:00:00\",\"generatedAt\":\"2026-05-19 17:59:38.436\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-20 07:52:12', '2026-05-19 17:59:38', '2026-05-20 07:52:11');
INSERT INTO `hs_supervision_report` VALUES (976064, '000000', 'SUP20260520075208235846', '2', 972106, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972106,\"orderNo\":\"OD20260520054827864566\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2011,\"landlordUserId\":2011,\"checkinDate\":\"2026-05-20 00:00:00\",\"checkoutDate\":\"2026-05-21 00:00:00\",\"generatedAt\":\"2026-05-20 07:52:08.235\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-20 07:52:12', '2026-05-20 07:52:08', '2026-05-20 07:52:11');
INSERT INTO `hs_supervision_report` VALUES (976065, '000000', 'SUP20260520075208246351', '2', 972103, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972103,\"orderNo\":\"OD20260520045932296940\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2007,\"landlordUserId\":2001,\"checkinDate\":\"2026-05-20 00:00:00\",\"checkoutDate\":\"2026-05-22 00:00:00\",\"generatedAt\":\"2026-05-20 07:52:08.246\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-20 07:52:12', '2026-05-20 07:52:08', '2026-05-20 07:52:11');
INSERT INTO `hs_supervision_report` VALUES (976066, '000000', 'SUP20260520075208248445', '2', 972100, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972100,\"orderNo\":\"ODTEST003\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-05-25 00:00:00\",\"checkoutDate\":\"2026-05-27 00:00:00\",\"generatedAt\":\"2026-05-20 07:52:08.249\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-20 07:52:12', '2026-05-20 07:52:08', '2026-05-20 07:52:11');
INSERT INTO `hs_supervision_report` VALUES (976067, '000000', 'SUP20260520075208252636', '2', 972097, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972097,\"orderNo\":\"OD20260519235257316648\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2007,\"landlordUserId\":1,\"checkinDate\":\"2026-05-19 00:00:00\",\"checkoutDate\":\"2026-05-20 00:00:00\",\"generatedAt\":\"2026-05-20 07:52:08.252\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-20 07:52:12', '2026-05-20 07:52:08', '2026-05-20 07:52:11');
INSERT INTO `hs_supervision_report` VALUES (976068, '000000', 'SUP20260520075208255822', '2', 972095, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972095,\"orderNo\":\"OD20260519233858276310\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2007,\"landlordUserId\":1,\"checkinDate\":\"2026-05-27 00:00:00\",\"checkoutDate\":\"2026-05-29 00:00:00\",\"generatedAt\":\"2026-05-20 07:52:08.255\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-20 07:52:12', '2026-05-20 07:52:08', '2026-05-20 07:52:11');
INSERT INTO `hs_supervision_report` VALUES (976069, '000000', 'SUP20260520075208258772', '2', 972093, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972093,\"orderNo\":\"OD20260519211829243254\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2009,\"landlordUserId\":1,\"checkinDate\":\"2026-05-19 00:00:00\",\"checkoutDate\":\"2026-05-20 00:00:00\",\"generatedAt\":\"2026-05-20 07:52:08.258\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-20 07:52:12', '2026-05-20 07:52:08', '2026-05-20 07:52:11');
INSERT INTO `hs_supervision_report` VALUES (976070, '000000', 'SUP20260520075208265712', '2', 972032, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972032,\"orderNo\":\"ODZH600032\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-14 00:00:00\",\"checkoutDate\":\"2026-03-17 00:00:00\",\"generatedAt\":\"2026-05-20 07:52:08.265\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-20 07:52:12', '2026-05-20 07:52:08', '2026-05-20 07:52:11');
INSERT INTO `hs_supervision_report` VALUES (976071, '000000', 'SUP20260520075208268910', '2', 972026, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972026,\"orderNo\":\"ODZH600026\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2002,\"landlordUserId\":2001,\"checkinDate\":\"2026-03-02 00:00:00\",\"checkoutDate\":\"2026-03-05 00:00:00\",\"generatedAt\":\"2026-05-20 07:52:08.268\"}', '{\"code\":0,\"msg\":\"mock push success\"}', '2026-05-20 07:52:12', '2026-05-20 07:52:08', '2026-05-20 07:52:11');
INSERT INTO `hs_supervision_report` VALUES (976072, '000000', 'SUP20260520142453879995', '2', 972128, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972128,\"orderNo\":\"OD20260520141825187794\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2007,\"landlordUserId\":2012,\"checkinDate\":\"2026-05-20 00:00:00\",\"checkoutDate\":\"2026-05-21 00:00:00\",\"generatedAt\":\"2026-05-20 14:24:53.881\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 14:24:53', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976073, '000000', 'SUP20260520142453889278', '2', 972122, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972122,\"orderNo\":\"OD2024010\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":1010,\"landlordUserId\":2012,\"checkinDate\":\"2026-05-21 00:00:00\",\"checkoutDate\":\"2026-05-22 00:00:00\",\"generatedAt\":\"2026-05-20 14:24:53.889\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 14:24:53', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976074, '000000', 'SUP20260520142453894561', '2', 972125, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972125,\"orderNo\":\"OD2024013\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":1013,\"landlordUserId\":2012,\"checkinDate\":\"2026-06-19 00:00:00\",\"checkoutDate\":\"2026-06-22 00:00:00\",\"generatedAt\":\"2026-05-20 14:24:53.894\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 14:24:53', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976075, '000000', 'SUP20260520142453899199', '2', 972124, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972124,\"orderNo\":\"OD2024012\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":1012,\"landlordUserId\":2012,\"checkinDate\":\"2026-06-14 00:00:00\",\"checkoutDate\":\"2026-06-17 00:00:00\",\"generatedAt\":\"2026-05-20 14:24:53.899\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 14:24:53', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976076, '000000', 'SUP20260520142453903511', '2', 972113, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972113,\"orderNo\":\"OD2024001\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":1001,\"landlordUserId\":2012,\"checkinDate\":\"2026-05-25 00:00:00\",\"checkoutDate\":\"2026-05-27 00:00:00\",\"generatedAt\":\"2026-05-20 14:24:53.903\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 14:24:53', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976077, '000000', 'SUP20260520142453907809', '2', 972115, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972115,\"orderNo\":\"OD2024003\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":1003,\"landlordUserId\":2012,\"checkinDate\":\"2026-05-23 00:00:00\",\"checkoutDate\":\"2026-05-26 00:00:00\",\"generatedAt\":\"2026-05-20 14:24:53.907\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 14:24:53', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976078, '000000', 'SUP20260520142453911698', '2', 972116, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972116,\"orderNo\":\"OD2024004\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":1004,\"landlordUserId\":2012,\"checkinDate\":\"2026-05-28 00:00:00\",\"checkoutDate\":\"2026-05-29 00:00:00\",\"generatedAt\":\"2026-05-20 14:24:53.912\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 14:24:53', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976079, '000000', 'SUP20260520142453917322', '2', 972117, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972117,\"orderNo\":\"OD2024005\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":1005,\"landlordUserId\":2012,\"checkinDate\":\"2026-06-04 00:00:00\",\"checkoutDate\":\"2026-06-06 00:00:00\",\"generatedAt\":\"2026-05-20 14:24:53.917\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 14:24:53', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976080, '000000', 'SUP20260520142453920156', '2', 972119, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972119,\"orderNo\":\"OD2024007\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":1007,\"landlordUserId\":2012,\"checkinDate\":\"2026-05-22 00:00:00\",\"checkoutDate\":\"2026-05-24 00:00:00\",\"generatedAt\":\"2026-05-20 14:24:53.92\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 14:24:53', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976081, '000000', 'SUP20260520142453923421', '2', 972121, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972121,\"orderNo\":\"OD2024009\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":1009,\"landlordUserId\":2012,\"checkinDate\":\"2026-05-26 00:00:00\",\"checkoutDate\":\"2026-05-28 00:00:00\",\"generatedAt\":\"2026-05-20 14:24:53.923\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 14:24:53', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976082, '000000', 'SUP20260520142453928489', '2', 972126, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972126,\"orderNo\":\"OD2024014\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":1014,\"landlordUserId\":2012,\"checkinDate\":\"2026-05-10 00:00:00\",\"checkoutDate\":\"2026-05-13 00:00:00\",\"generatedAt\":\"2026-05-20 14:24:53.929\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 14:24:53', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976083, '000000', 'SUP20260520142453933830', '2', 972112, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972112,\"orderNo\":\"OD20260520095252356379\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2011,\"landlordUserId\":2011,\"checkinDate\":\"2026-05-20 00:00:00\",\"checkoutDate\":\"2026-05-21 00:00:00\",\"generatedAt\":\"2026-05-20 14:24:53.933\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 14:24:53', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976084, '000000', 'SUP20260520142453937743', '2', 972111, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972111,\"orderNo\":\"OD20260520095040306815\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2007,\"landlordUserId\":2011,\"checkinDate\":\"2026-07-28 00:00:00\",\"checkoutDate\":\"2026-07-29 00:00:00\",\"generatedAt\":\"2026-05-20 14:24:53.937\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 14:24:53', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976085, '000000', 'SUP20260520150020177661', '2', 972114, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972114,\"orderNo\":\"OD2024002\",\"orderStatus\":\"1\",\"payStatus\":\"1\",\"tenantUserId\":1002,\"landlordUserId\":2012,\"checkinDate\":\"2026-05-30 00:00:00\",\"checkoutDate\":\"2026-06-01 00:00:00\",\"generatedAt\":\"2026-05-20 15:00:20.177\"}', '{\"msg\":\"上报成功\",\"code\":0}', '2026-05-20 15:00:20', '2026-05-20 15:00:20', '2026-05-20 15:00:20');
INSERT INTO `hs_supervision_report` VALUES (976086, '000000', 'SUP20260520150024222451', '2', 972130, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972130,\"orderNo\":\"OD20260520145826793309\",\"orderStatus\":\"3\",\"payStatus\":\"1\",\"tenantUserId\":2007,\"landlordUserId\":2012,\"checkinDate\":\"2026-05-20 00:00:00\",\"checkoutDate\":\"2026-05-21 00:00:00\",\"generatedAt\":\"2026-05-20 15:00:24.222\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 15:00:24', '2026-05-20 15:00:27');
INSERT INTO `hs_supervision_report` VALUES (976087, '000000', 'SUP20260520150024226723', '2', 972129, '1', 1, '{\"source\":\"order-auto-task\",\"orderId\":972129,\"orderNo\":\"OD20260520145532416860\",\"orderStatus\":\"2\",\"payStatus\":\"1\",\"tenantUserId\":2007,\"landlordUserId\":2012,\"checkinDate\":\"2026-06-08 00:00:00\",\"checkoutDate\":\"2026-06-09 00:00:00\",\"generatedAt\":\"2026-05-20 15:00:24.226\"}', '{\"msg\":\"mock push success\",\"code\":0}', '2026-05-20 15:00:28', '2026-05-20 15:00:24', '2026-05-20 15:00:27');

-- ----------------------------
-- Table structure for hs_tag
-- ----------------------------
DROP TABLE IF EXISTS `hs_tag`;
CREATE TABLE `hs_tag`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'pk',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '000000',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'tag title',
  `sort` int(0) NOT NULL DEFAULT 0 COMMENT 'sort asc',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '0-enable 1-disable',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_hs_tag_title`(`title`) USING BTREE,
  INDEX `idx_hs_tag_status_sort`(`status`, `sort`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'homestay tag' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_tag
-- ----------------------------
INSERT INTO `hs_tag` VALUES (1, '000000', '近地铁', 1, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_tag` VALUES (2, '000000', '可做饭', 2, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_tag` VALUES (3, '000000', '免费停车', 3, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_tag` VALUES (4, '000000', '有阳台', 4, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_tag` VALUES (5, '000000', '投影设备', 5, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_tag` VALUES (6, '000000', '宠物友好', 6, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_tag` VALUES (7, '000000', '近景区', 7, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_tag` VALUES (8, '000000', '有WiFi', 8, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_tag` VALUES (9, '000000', '空调暖气', 9, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');
INSERT INTO `hs_tag` VALUES (10, '000000', '洗衣机', 10, '0', '2026-05-18 23:27:35', '2026-05-18 23:27:35');

-- ----------------------------
-- Table structure for hs_user_address
-- ----------------------------
DROP TABLE IF EXISTS `hs_user_address`;
CREATE TABLE `hs_user_address`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(0) NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `mobile` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `def` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hs_user_address_user`(`user_id`, `def`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'homestay user address' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hs_user_address
-- ----------------------------
INSERT INTO `hs_user_address` VALUES (1, 2002, 'R梓涵', '15171324012', 'No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,', '1', '2026-02-25 22:14:17', '2026-02-25 22:14:17');
INSERT INTO `hs_user_address` VALUES (2, 2002, '222R梓涵2222', '13171324012', 'No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,', '0', '2026-02-25 23:38:15', '2026-02-25 23:38:15');
INSERT INTO `hs_user_address` VALUES (3, 2003, '测试', '15171324012', 'No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,', '1', '2026-03-05 19:36:00', '2026-03-05 19:36:00');
INSERT INTO `hs_user_address` VALUES (4, 2007, 'R梓涵', '15171324012', 'No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,', '1', '2026-05-18 21:10:49', '2026-05-18 21:10:49');

-- ----------------------------
-- Table structure for magic_api_file
-- ----------------------------
DROP TABLE IF EXISTS `magic_api_file`;
CREATE TABLE `magic_api_file`  (
  `file_path` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `file_content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`file_path`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of magic_api_file
-- ----------------------------
INSERT INTO `magic_api_file` VALUES ('magic-api/api/', 'this is directory');
INSERT INTO `magic_api_file` VALUES ('magic-api/datasource/', 'this is directory');
INSERT INTO `magic_api_file` VALUES ('magic-api/function/', 'this is directory');

-- ----------------------------
-- Table structure for magic_backup_record
-- ----------------------------
DROP TABLE IF EXISTS `magic_backup_record`;
CREATE TABLE `magic_backup_record`  (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '原对象ID',
  `create_date` bigint(0) NOT NULL COMMENT '备份时间',
  `tag` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '类型',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '原名称',
  `content` blob NULL COMMENT '备份内容',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人',
  PRIMARY KEY (`id`, `create_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of magic_backup_record
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint(0) NOT NULL COMMENT '触发的时间',
  `sched_time` bigint(0) NOT NULL COMMENT '定时器制定的时间',
  `priority` int(0) NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint(0) NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint(0) NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint(0) NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint(0) NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint(0) NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int(0) NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int(0) NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint(0) NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint(0) NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint(0) NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint(0) NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int(0) NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint(0) NOT NULL COMMENT '开始时间',
  `end_time` bigint(0) NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint(0) NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name`, `job_name`, `job_group`) USING BTREE,
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int(0) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2024-07-18 08:50:07', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', 'Abc_12389', 'Y', 'admin', '2024-07-18 08:50:07', '', NULL, '初始化密码 Abc_12389');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2024-07-18 08:50:07', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2024-07-18 08:50:07', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2024-07-18 08:50:07', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2024-07-18 08:50:07', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '0', 'Y', 'admin', '2026-02-25 14:23:16', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-02-25 14:23:16', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (9, '用户管理-账号密码尝试登录次数', 'sys.account.tryLoginCount', '0', 'Y', 'admin', '2026-02-25 14:23:16', '', NULL, '尝试登录次数（格式0-0（尝试次数-锁号时长（分钟）），数据初始化值为0不限制）');
INSERT INTO `sys_config` VALUES (100, 'AI API地址', 'ai.baseUrl', 'https://api.openai.com/v1', 'N', 'admin', '2026-05-19 17:16:04', '', NULL, 'AI助手API地址');
INSERT INTO `sys_config` VALUES (101, 'AI 模型名称', 'ai.model', 'gpt-4o-mini', 'N', 'admin', '2026-05-19 17:16:04', '', NULL, 'AI助手模型名称');
INSERT INTO `sys_config` VALUES (102, 'AI API密钥', 'ai.apiKey', '', 'N', 'admin', '2026-05-19 17:16:13', '', NULL, 'AI助手API密钥，请在系统配置页面设置');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(0) NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(0) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '总公司', 0, 'admin', '15553502062', 'jiangyanxi@live.com', '0', '0', 'admin', '2024-07-18 08:50:06', 'admin', '2024-07-18 08:58:54');

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(0) NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 106 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 1, 'wait_pay', '0', 'hs_order_status', '', 'default', 'N', '0', 'admin', '2026-02-25 14:24:22', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (101, 2, 'paid', '1', 'hs_order_status', '', 'primary', 'N', '0', 'admin', '2026-02-25 14:24:22', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (102, 3, 'confirmed', '2', 'hs_order_status', '', 'success', 'N', '0', 'admin', '2026-02-25 14:24:22', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (103, 4, 'finished', '3', 'hs_order_status', '', 'success', 'N', '0', 'admin', '2026-02-25 14:24:22', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (104, 5, 'cancelled', '4', 'hs_order_status', '', 'danger', 'N', '0', 'admin', '2026-02-25 14:24:22', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (105, 6, 'rejected', '5', 'hs_order_status', '', 'warning', 'N', '0', 'admin', '2026-02-25 14:24:22', '', NULL, '');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2024-07-18 08:50:07', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, 'Homestay order status', 'hs_order_status', '0', 'admin', '2026-02-25 14:24:22', '', NULL, 'MVP status dictionary');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2024-07-18 08:50:07', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2024-07-18 08:50:07', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2024-07-18 08:50:07', '', NULL, '');
INSERT INTO `sys_job` VALUES (100, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '0 */5 * * * ?', '3', '1', '0', 'admin', '2026-05-19 17:04:20', '', NULL, '每 5 分钟检查并取消超时 30 分钟未支付订单');
INSERT INTO `sys_job` VALUES (101, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '0 0 * * * ?', '3', '1', '0', 'admin', '2026-05-19 17:04:34', '', NULL, '每小时检查并自动确认超过 24 小时未处理的订单');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 331 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------
INSERT INTO `sys_job_log` VALUES (1, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：110毫秒', '0', '', '2026-05-19 17:30:00');
INSERT INTO `sys_job_log` VALUES (2, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 17:35:00');
INSERT INTO `sys_job_log` VALUES (3, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 17:40:00');
INSERT INTO `sys_job_log` VALUES (4, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 17:45:00');
INSERT INTO `sys_job_log` VALUES (5, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 17:50:00');
INSERT INTO `sys_job_log` VALUES (6, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 17:55:00');
INSERT INTO `sys_job_log` VALUES (7, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 18:00:00');
INSERT INTO `sys_job_log` VALUES (8, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：34毫秒', '0', '', '2026-05-19 18:00:00');
INSERT INTO `sys_job_log` VALUES (9, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 18:05:00');
INSERT INTO `sys_job_log` VALUES (10, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-19 18:10:00');
INSERT INTO `sys_job_log` VALUES (11, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-19 18:15:00');
INSERT INTO `sys_job_log` VALUES (12, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 18:20:00');
INSERT INTO `sys_job_log` VALUES (13, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 18:25:00');
INSERT INTO `sys_job_log` VALUES (14, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 18:30:00');
INSERT INTO `sys_job_log` VALUES (15, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 18:35:00');
INSERT INTO `sys_job_log` VALUES (16, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 18:40:00');
INSERT INTO `sys_job_log` VALUES (17, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 18:45:00');
INSERT INTO `sys_job_log` VALUES (18, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 18:50:00');
INSERT INTO `sys_job_log` VALUES (19, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：6毫秒', '0', '', '2026-05-19 19:00:00');
INSERT INTO `sys_job_log` VALUES (20, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-19 19:00:00');
INSERT INTO `sys_job_log` VALUES (21, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：20毫秒', '0', '', '2026-05-19 19:10:00');
INSERT INTO `sys_job_log` VALUES (22, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：39毫秒', '0', '', '2026-05-19 21:15:00');
INSERT INTO `sys_job_log` VALUES (23, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 21:20:00');
INSERT INTO `sys_job_log` VALUES (24, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 21:25:00');
INSERT INTO `sys_job_log` VALUES (25, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 21:30:00');
INSERT INTO `sys_job_log` VALUES (26, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-19 21:35:00');
INSERT INTO `sys_job_log` VALUES (27, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 21:40:00');
INSERT INTO `sys_job_log` VALUES (28, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 21:45:00');
INSERT INTO `sys_job_log` VALUES (29, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 21:50:00');
INSERT INTO `sys_job_log` VALUES (30, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-19 21:55:00');
INSERT INTO `sys_job_log` VALUES (31, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：3毫秒', '0', '', '2026-05-19 22:00:00');
INSERT INTO `sys_job_log` VALUES (32, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 22:00:00');
INSERT INTO `sys_job_log` VALUES (33, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 22:05:00');
INSERT INTO `sys_job_log` VALUES (34, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 22:10:00');
INSERT INTO `sys_job_log` VALUES (35, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-19 22:15:00');
INSERT INTO `sys_job_log` VALUES (36, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 22:20:00');
INSERT INTO `sys_job_log` VALUES (37, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 22:25:00');
INSERT INTO `sys_job_log` VALUES (38, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 22:30:00');
INSERT INTO `sys_job_log` VALUES (39, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-19 22:35:00');
INSERT INTO `sys_job_log` VALUES (40, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 22:40:00');
INSERT INTO `sys_job_log` VALUES (41, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 22:45:00');
INSERT INTO `sys_job_log` VALUES (42, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-19 22:55:00');
INSERT INTO `sys_job_log` VALUES (43, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 23:00:00');
INSERT INTO `sys_job_log` VALUES (44, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：3毫秒', '0', '', '2026-05-19 23:00:00');
INSERT INTO `sys_job_log` VALUES (45, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：13毫秒', '0', '', '2026-05-19 23:10:00');
INSERT INTO `sys_job_log` VALUES (46, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-19 23:15:00');
INSERT INTO `sys_job_log` VALUES (47, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：8毫秒', '0', '', '2026-05-19 23:20:00');
INSERT INTO `sys_job_log` VALUES (48, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-19 23:25:00');
INSERT INTO `sys_job_log` VALUES (49, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-19 23:30:00');
INSERT INTO `sys_job_log` VALUES (50, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 23:35:00');
INSERT INTO `sys_job_log` VALUES (51, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 23:40:00');
INSERT INTO `sys_job_log` VALUES (52, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-19 23:45:00');
INSERT INTO `sys_job_log` VALUES (53, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-19 23:50:00');
INSERT INTO `sys_job_log` VALUES (54, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-19 23:55:00');
INSERT INTO `sys_job_log` VALUES (55, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：17毫秒', '0', '', '2026-05-20 00:00:00');
INSERT INTO `sys_job_log` VALUES (56, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：17毫秒', '0', '', '2026-05-20 00:00:00');
INSERT INTO `sys_job_log` VALUES (57, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：13毫秒', '0', '', '2026-05-20 00:05:00');
INSERT INTO `sys_job_log` VALUES (58, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 00:10:00');
INSERT INTO `sys_job_log` VALUES (59, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 00:15:00');
INSERT INTO `sys_job_log` VALUES (60, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 00:20:00');
INSERT INTO `sys_job_log` VALUES (61, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：17毫秒', '0', '', '2026-05-20 00:25:00');
INSERT INTO `sys_job_log` VALUES (62, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 00:30:00');
INSERT INTO `sys_job_log` VALUES (63, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 00:35:00');
INSERT INTO `sys_job_log` VALUES (64, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 00:40:00');
INSERT INTO `sys_job_log` VALUES (65, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 00:45:00');
INSERT INTO `sys_job_log` VALUES (66, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 00:50:00');
INSERT INTO `sys_job_log` VALUES (67, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 00:55:00');
INSERT INTO `sys_job_log` VALUES (68, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 01:00:00');
INSERT INTO `sys_job_log` VALUES (69, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：6毫秒', '0', '', '2026-05-20 01:00:00');
INSERT INTO `sys_job_log` VALUES (70, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 01:05:00');
INSERT INTO `sys_job_log` VALUES (71, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 01:10:00');
INSERT INTO `sys_job_log` VALUES (72, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 01:15:00');
INSERT INTO `sys_job_log` VALUES (73, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-20 01:20:00');
INSERT INTO `sys_job_log` VALUES (74, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 01:25:00');
INSERT INTO `sys_job_log` VALUES (75, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 01:30:00');
INSERT INTO `sys_job_log` VALUES (76, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 01:35:00');
INSERT INTO `sys_job_log` VALUES (77, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 01:40:00');
INSERT INTO `sys_job_log` VALUES (78, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 01:45:00');
INSERT INTO `sys_job_log` VALUES (79, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 01:50:00');
INSERT INTO `sys_job_log` VALUES (80, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-20 01:55:00');
INSERT INTO `sys_job_log` VALUES (81, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：8毫秒', '0', '', '2026-05-20 02:00:00');
INSERT INTO `sys_job_log` VALUES (82, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：12毫秒', '0', '', '2026-05-20 02:00:00');
INSERT INTO `sys_job_log` VALUES (83, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：14毫秒', '0', '', '2026-05-20 02:05:00');
INSERT INTO `sys_job_log` VALUES (84, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 02:10:00');
INSERT INTO `sys_job_log` VALUES (85, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 02:15:00');
INSERT INTO `sys_job_log` VALUES (86, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 02:20:00');
INSERT INTO `sys_job_log` VALUES (87, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：31毫秒', '0', '', '2026-05-20 02:25:00');
INSERT INTO `sys_job_log` VALUES (88, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-20 02:30:00');
INSERT INTO `sys_job_log` VALUES (89, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-20 02:35:00');
INSERT INTO `sys_job_log` VALUES (90, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 02:40:00');
INSERT INTO `sys_job_log` VALUES (91, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-20 02:45:00');
INSERT INTO `sys_job_log` VALUES (92, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 02:50:00');
INSERT INTO `sys_job_log` VALUES (93, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 02:55:00');
INSERT INTO `sys_job_log` VALUES (94, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：18毫秒', '0', '', '2026-05-20 03:00:00');
INSERT INTO `sys_job_log` VALUES (95, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：17毫秒', '0', '', '2026-05-20 03:00:00');
INSERT INTO `sys_job_log` VALUES (96, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 03:05:00');
INSERT INTO `sys_job_log` VALUES (97, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 03:10:00');
INSERT INTO `sys_job_log` VALUES (98, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 03:15:00');
INSERT INTO `sys_job_log` VALUES (99, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 03:20:00');
INSERT INTO `sys_job_log` VALUES (100, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 03:25:00');
INSERT INTO `sys_job_log` VALUES (101, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-20 03:30:00');
INSERT INTO `sys_job_log` VALUES (102, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 03:35:00');
INSERT INTO `sys_job_log` VALUES (103, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 03:40:00');
INSERT INTO `sys_job_log` VALUES (104, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 03:45:00');
INSERT INTO `sys_job_log` VALUES (105, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：12毫秒', '0', '', '2026-05-20 03:50:00');
INSERT INTO `sys_job_log` VALUES (106, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：3毫秒', '1', 'org.springframework.beans.factory.NoSuchBeanDefinitionException: No bean named \'hsOrderTask\' available\r\n	at org.springframework.beans.factory.support.DefaultListableBeanFactory.getBeanDefinition(DefaultListableBeanFactory.java:978)\r\n	at org.springframework.beans.factory.support.AbstractBeanFactory.getMergedLocalBeanDefinition(AbstractBeanFactory.java:1381)\r\n	at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:302)\r\n	at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:202)\r\n	at com.ruoyi.common.utils.spring.SpringUtils.getBean(SpringUtils.java:50)\r\n	at com.ruoyi.quartz.util.JobInvokeUtil.invokeMethod(JobInvokeUtil.java:32)\r\n	at com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution.doExecute(QuartzDisallowConcurrentExecution.java:19)\r\n	at com.ruoyi.quartz.util.AbstractQuartzJob.execute(AbstractQuartzJob.java:43)\r\n	at org.quartz.core.JobRunShell.run(JobRunShell.java:203)\r\n	at org.quartz.simpl.SimpleThreadPool$WorkerThread.run(SimpleThreadPool.java:566)\r\n', '2026-05-20 04:00:00');
INSERT INTO `sys_job_log` VALUES (107, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '1', 'org.springframework.beans.factory.NoSuchBeanDefinitionException: No bean named \'hsOrderTask\' available\r\n	at org.springframework.beans.factory.support.DefaultListableBeanFactory.getBeanDefinition(DefaultListableBeanFactory.java:978)\r\n	at org.springframework.beans.factory.support.AbstractBeanFactory.getMergedLocalBeanDefinition(AbstractBeanFactory.java:1381)\r\n	at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:302)\r\n	at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:202)\r\n	at com.ruoyi.common.utils.spring.SpringUtils.getBean(SpringUtils.java:50)\r\n	at com.ruoyi.quartz.util.JobInvokeUtil.invokeMethod(JobInvokeUtil.java:32)\r\n	at com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution.doExecute(QuartzDisallowConcurrentExecution.java:19)\r\n	at com.ruoyi.quartz.util.AbstractQuartzJob.execute(AbstractQuartzJob.java:43)\r\n	at org.quartz.core.JobRunShell.run(JobRunShell.java:203)\r\n	at org.quartz.simpl.SimpleThreadPool$WorkerThread.run(SimpleThreadPool.java:566)\r\n', '2026-05-20 04:00:00');
INSERT INTO `sys_job_log` VALUES (108, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：1毫秒', '1', 'org.springframework.beans.factory.NoSuchBeanDefinitionException: No bean named \'hsOrderTask\' available\r\n	at org.springframework.beans.factory.support.DefaultListableBeanFactory.getBeanDefinition(DefaultListableBeanFactory.java:978)\r\n	at org.springframework.beans.factory.support.AbstractBeanFactory.getMergedLocalBeanDefinition(AbstractBeanFactory.java:1381)\r\n	at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:302)\r\n	at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:202)\r\n	at com.ruoyi.common.utils.spring.SpringUtils.getBean(SpringUtils.java:50)\r\n	at com.ruoyi.quartz.util.JobInvokeUtil.invokeMethod(JobInvokeUtil.java:32)\r\n	at com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution.doExecute(QuartzDisallowConcurrentExecution.java:19)\r\n	at com.ruoyi.quartz.util.AbstractQuartzJob.execute(AbstractQuartzJob.java:43)\r\n	at org.quartz.core.JobRunShell.run(JobRunShell.java:203)\r\n	at org.quartz.simpl.SimpleThreadPool$WorkerThread.run(SimpleThreadPool.java:566)\r\n', '2026-05-20 04:05:00');
INSERT INTO `sys_job_log` VALUES (109, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：126毫秒', '0', '', '2026-05-20 04:10:00');
INSERT INTO `sys_job_log` VALUES (110, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 04:15:00');
INSERT INTO `sys_job_log` VALUES (111, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-20 04:20:00');
INSERT INTO `sys_job_log` VALUES (112, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：8毫秒', '0', '', '2026-05-20 04:25:00');
INSERT INTO `sys_job_log` VALUES (113, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 04:30:00');
INSERT INTO `sys_job_log` VALUES (114, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：19毫秒', '0', '', '2026-05-20 04:35:00');
INSERT INTO `sys_job_log` VALUES (115, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：8毫秒', '0', '', '2026-05-20 04:40:00');
INSERT INTO `sys_job_log` VALUES (116, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：11毫秒', '0', '', '2026-05-20 04:45:00');
INSERT INTO `sys_job_log` VALUES (117, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 04:50:00');
INSERT INTO `sys_job_log` VALUES (118, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 04:55:00');
INSERT INTO `sys_job_log` VALUES (119, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 05:00:00');
INSERT INTO `sys_job_log` VALUES (120, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：4毫秒', '0', '', '2026-05-20 05:00:00');
INSERT INTO `sys_job_log` VALUES (121, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 05:05:00');
INSERT INTO `sys_job_log` VALUES (122, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 05:10:00');
INSERT INTO `sys_job_log` VALUES (123, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 05:15:00');
INSERT INTO `sys_job_log` VALUES (124, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 05:20:00');
INSERT INTO `sys_job_log` VALUES (125, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 05:25:00');
INSERT INTO `sys_job_log` VALUES (126, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 05:30:00');
INSERT INTO `sys_job_log` VALUES (127, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 05:35:00');
INSERT INTO `sys_job_log` VALUES (128, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：23毫秒', '0', '', '2026-05-20 05:40:00');
INSERT INTO `sys_job_log` VALUES (129, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 05:45:00');
INSERT INTO `sys_job_log` VALUES (130, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 05:50:00');
INSERT INTO `sys_job_log` VALUES (131, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 05:55:00');
INSERT INTO `sys_job_log` VALUES (132, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：3毫秒', '0', '', '2026-05-20 06:00:00');
INSERT INTO `sys_job_log` VALUES (133, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 06:00:00');
INSERT INTO `sys_job_log` VALUES (134, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 06:05:00');
INSERT INTO `sys_job_log` VALUES (135, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 06:10:00');
INSERT INTO `sys_job_log` VALUES (136, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 06:15:00');
INSERT INTO `sys_job_log` VALUES (137, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 06:20:00');
INSERT INTO `sys_job_log` VALUES (138, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 06:25:00');
INSERT INTO `sys_job_log` VALUES (139, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 06:30:00');
INSERT INTO `sys_job_log` VALUES (140, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 06:35:00');
INSERT INTO `sys_job_log` VALUES (141, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 06:40:00');
INSERT INTO `sys_job_log` VALUES (142, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 06:45:00');
INSERT INTO `sys_job_log` VALUES (143, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 06:50:00');
INSERT INTO `sys_job_log` VALUES (144, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 06:55:00');
INSERT INTO `sys_job_log` VALUES (145, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 07:00:00');
INSERT INTO `sys_job_log` VALUES (146, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：4毫秒', '0', '', '2026-05-20 07:00:00');
INSERT INTO `sys_job_log` VALUES (147, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 07:05:00');
INSERT INTO `sys_job_log` VALUES (148, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 07:10:00');
INSERT INTO `sys_job_log` VALUES (149, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 07:15:00');
INSERT INTO `sys_job_log` VALUES (150, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 07:20:00');
INSERT INTO `sys_job_log` VALUES (151, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 07:25:00');
INSERT INTO `sys_job_log` VALUES (152, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 07:30:00');
INSERT INTO `sys_job_log` VALUES (153, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 07:35:00');
INSERT INTO `sys_job_log` VALUES (154, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 07:40:00');
INSERT INTO `sys_job_log` VALUES (155, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 07:45:00');
INSERT INTO `sys_job_log` VALUES (156, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：25毫秒', '0', '', '2026-05-20 07:50:00');
INSERT INTO `sys_job_log` VALUES (157, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 07:55:00');
INSERT INTO `sys_job_log` VALUES (158, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 08:00:00');
INSERT INTO `sys_job_log` VALUES (159, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：3毫秒', '0', '', '2026-05-20 08:00:00');
INSERT INTO `sys_job_log` VALUES (160, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 08:05:00');
INSERT INTO `sys_job_log` VALUES (161, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 08:10:00');
INSERT INTO `sys_job_log` VALUES (162, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 08:15:00');
INSERT INTO `sys_job_log` VALUES (163, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 08:20:00');
INSERT INTO `sys_job_log` VALUES (164, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 08:25:00');
INSERT INTO `sys_job_log` VALUES (165, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 08:30:00');
INSERT INTO `sys_job_log` VALUES (166, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 08:35:00');
INSERT INTO `sys_job_log` VALUES (167, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 08:40:00');
INSERT INTO `sys_job_log` VALUES (168, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 08:45:00');
INSERT INTO `sys_job_log` VALUES (169, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 08:50:00');
INSERT INTO `sys_job_log` VALUES (170, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 08:55:00');
INSERT INTO `sys_job_log` VALUES (171, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：8毫秒', '0', '', '2026-05-20 09:00:00');
INSERT INTO `sys_job_log` VALUES (172, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：15毫秒', '0', '', '2026-05-20 09:00:00');
INSERT INTO `sys_job_log` VALUES (173, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 09:05:00');
INSERT INTO `sys_job_log` VALUES (174, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：9毫秒', '0', '', '2026-05-20 09:10:00');
INSERT INTO `sys_job_log` VALUES (175, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-20 09:15:00');
INSERT INTO `sys_job_log` VALUES (176, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 09:25:00');
INSERT INTO `sys_job_log` VALUES (177, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 09:30:00');
INSERT INTO `sys_job_log` VALUES (178, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 09:35:00');
INSERT INTO `sys_job_log` VALUES (179, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 09:40:00');
INSERT INTO `sys_job_log` VALUES (180, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 09:45:00');
INSERT INTO `sys_job_log` VALUES (181, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 09:50:00');
INSERT INTO `sys_job_log` VALUES (182, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 09:55:00');
INSERT INTO `sys_job_log` VALUES (183, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 10:05:00');
INSERT INTO `sys_job_log` VALUES (184, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 10:10:00');
INSERT INTO `sys_job_log` VALUES (185, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 10:15:00');
INSERT INTO `sys_job_log` VALUES (186, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 10:20:00');
INSERT INTO `sys_job_log` VALUES (187, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 10:25:00');
INSERT INTO `sys_job_log` VALUES (188, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：58毫秒', '0', '', '2026-05-20 10:55:00');
INSERT INTO `sys_job_log` VALUES (189, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：7毫秒', '0', '', '2026-05-20 11:00:00');
INSERT INTO `sys_job_log` VALUES (190, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-20 11:00:00');
INSERT INTO `sys_job_log` VALUES (191, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-20 11:05:00');
INSERT INTO `sys_job_log` VALUES (192, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 11:10:00');
INSERT INTO `sys_job_log` VALUES (193, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 11:15:00');
INSERT INTO `sys_job_log` VALUES (194, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 11:20:00');
INSERT INTO `sys_job_log` VALUES (195, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 11:25:00');
INSERT INTO `sys_job_log` VALUES (196, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 11:30:00');
INSERT INTO `sys_job_log` VALUES (197, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 11:35:00');
INSERT INTO `sys_job_log` VALUES (198, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 11:40:00');
INSERT INTO `sys_job_log` VALUES (199, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 11:45:00');
INSERT INTO `sys_job_log` VALUES (200, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 11:50:00');
INSERT INTO `sys_job_log` VALUES (201, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 11:55:00');
INSERT INTO `sys_job_log` VALUES (202, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：8毫秒', '0', '', '2026-05-20 12:00:00');
INSERT INTO `sys_job_log` VALUES (203, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：8毫秒', '0', '', '2026-05-20 12:00:00');
INSERT INTO `sys_job_log` VALUES (204, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 12:05:00');
INSERT INTO `sys_job_log` VALUES (205, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：13毫秒', '0', '', '2026-05-20 12:50:00');
INSERT INTO `sys_job_log` VALUES (206, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：9毫秒', '0', '', '2026-05-20 12:55:00');
INSERT INTO `sys_job_log` VALUES (207, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：9毫秒', '0', '', '2026-05-20 13:00:00');
INSERT INTO `sys_job_log` VALUES (208, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：10毫秒', '0', '', '2026-05-20 13:00:00');
INSERT INTO `sys_job_log` VALUES (209, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 13:05:00');
INSERT INTO `sys_job_log` VALUES (210, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 13:10:00');
INSERT INTO `sys_job_log` VALUES (211, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 13:15:00');
INSERT INTO `sys_job_log` VALUES (212, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 13:20:00');
INSERT INTO `sys_job_log` VALUES (213, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 13:25:00');
INSERT INTO `sys_job_log` VALUES (214, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 13:30:00');
INSERT INTO `sys_job_log` VALUES (215, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 13:35:00');
INSERT INTO `sys_job_log` VALUES (216, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 13:40:00');
INSERT INTO `sys_job_log` VALUES (217, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 13:45:00');
INSERT INTO `sys_job_log` VALUES (218, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 13:50:00');
INSERT INTO `sys_job_log` VALUES (219, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 13:55:00');
INSERT INTO `sys_job_log` VALUES (220, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：4毫秒', '0', '', '2026-05-20 14:00:00');
INSERT INTO `sys_job_log` VALUES (221, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 14:00:00');
INSERT INTO `sys_job_log` VALUES (222, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 14:05:00');
INSERT INTO `sys_job_log` VALUES (223, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 14:10:00');
INSERT INTO `sys_job_log` VALUES (224, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：27毫秒', '0', '', '2026-05-20 14:15:00');
INSERT INTO `sys_job_log` VALUES (225, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 14:20:00');
INSERT INTO `sys_job_log` VALUES (226, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 14:25:00');
INSERT INTO `sys_job_log` VALUES (227, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 14:30:00');
INSERT INTO `sys_job_log` VALUES (228, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-20 14:35:00');
INSERT INTO `sys_job_log` VALUES (229, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 14:40:00');
INSERT INTO `sys_job_log` VALUES (230, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 14:45:00');
INSERT INTO `sys_job_log` VALUES (231, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 14:50:00');
INSERT INTO `sys_job_log` VALUES (232, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 14:55:00');
INSERT INTO `sys_job_log` VALUES (233, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 15:00:00');
INSERT INTO `sys_job_log` VALUES (234, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：4毫秒', '0', '', '2026-05-20 15:00:00');
INSERT INTO `sys_job_log` VALUES (235, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：8毫秒', '0', '', '2026-05-20 15:05:00');
INSERT INTO `sys_job_log` VALUES (236, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 15:10:00');
INSERT INTO `sys_job_log` VALUES (237, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 15:15:00');
INSERT INTO `sys_job_log` VALUES (238, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 15:20:00');
INSERT INTO `sys_job_log` VALUES (239, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 15:25:00');
INSERT INTO `sys_job_log` VALUES (240, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-20 15:30:00');
INSERT INTO `sys_job_log` VALUES (241, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 15:35:00');
INSERT INTO `sys_job_log` VALUES (242, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 15:40:00');
INSERT INTO `sys_job_log` VALUES (243, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 15:45:00');
INSERT INTO `sys_job_log` VALUES (244, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 15:50:00');
INSERT INTO `sys_job_log` VALUES (245, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 15:55:00');
INSERT INTO `sys_job_log` VALUES (246, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：5毫秒', '0', '', '2026-05-20 16:00:00');
INSERT INTO `sys_job_log` VALUES (247, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：8毫秒', '0', '', '2026-05-20 16:00:00');
INSERT INTO `sys_job_log` VALUES (248, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 16:05:00');
INSERT INTO `sys_job_log` VALUES (249, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：8毫秒', '0', '', '2026-05-20 16:10:00');
INSERT INTO `sys_job_log` VALUES (250, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：8毫秒', '0', '', '2026-05-20 16:15:00');
INSERT INTO `sys_job_log` VALUES (251, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：8毫秒', '0', '', '2026-05-20 16:20:00');
INSERT INTO `sys_job_log` VALUES (252, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：10毫秒', '0', '', '2026-05-20 16:25:00');
INSERT INTO `sys_job_log` VALUES (253, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：12毫秒', '0', '', '2026-05-20 16:30:00');
INSERT INTO `sys_job_log` VALUES (254, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：13毫秒', '0', '', '2026-05-20 16:35:00');
INSERT INTO `sys_job_log` VALUES (255, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：12毫秒', '0', '', '2026-05-20 16:40:00');
INSERT INTO `sys_job_log` VALUES (256, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：9毫秒', '0', '', '2026-05-20 16:45:00');
INSERT INTO `sys_job_log` VALUES (257, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：8毫秒', '0', '', '2026-05-20 23:05:00');
INSERT INTO `sys_job_log` VALUES (258, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 23:10:00');
INSERT INTO `sys_job_log` VALUES (259, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 23:15:00');
INSERT INTO `sys_job_log` VALUES (260, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 23:20:00');
INSERT INTO `sys_job_log` VALUES (261, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 23:25:00');
INSERT INTO `sys_job_log` VALUES (262, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 23:30:00');
INSERT INTO `sys_job_log` VALUES (263, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-20 23:35:00');
INSERT INTO `sys_job_log` VALUES (264, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 23:40:00');
INSERT INTO `sys_job_log` VALUES (265, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 23:45:00');
INSERT INTO `sys_job_log` VALUES (266, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-20 23:50:00');
INSERT INTO `sys_job_log` VALUES (267, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-20 23:55:00');
INSERT INTO `sys_job_log` VALUES (268, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：8毫秒', '0', '', '2026-05-21 00:00:00');
INSERT INTO `sys_job_log` VALUES (269, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：14毫秒', '0', '', '2026-05-21 00:00:00');
INSERT INTO `sys_job_log` VALUES (270, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 00:05:00');
INSERT INTO `sys_job_log` VALUES (271, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 00:10:00');
INSERT INTO `sys_job_log` VALUES (272, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 00:15:00');
INSERT INTO `sys_job_log` VALUES (273, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 00:20:00');
INSERT INTO `sys_job_log` VALUES (274, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 00:25:00');
INSERT INTO `sys_job_log` VALUES (275, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 00:30:00');
INSERT INTO `sys_job_log` VALUES (276, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 00:35:00');
INSERT INTO `sys_job_log` VALUES (277, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-21 00:40:00');
INSERT INTO `sys_job_log` VALUES (278, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 00:45:00');
INSERT INTO `sys_job_log` VALUES (279, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 00:50:00');
INSERT INTO `sys_job_log` VALUES (280, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 00:55:00');
INSERT INTO `sys_job_log` VALUES (281, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：4毫秒', '0', '', '2026-05-21 01:00:00');
INSERT INTO `sys_job_log` VALUES (282, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-21 01:00:00');
INSERT INTO `sys_job_log` VALUES (283, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 01:05:00');
INSERT INTO `sys_job_log` VALUES (284, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 01:10:00');
INSERT INTO `sys_job_log` VALUES (285, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-21 01:15:00');
INSERT INTO `sys_job_log` VALUES (286, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-21 01:20:00');
INSERT INTO `sys_job_log` VALUES (287, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 01:25:00');
INSERT INTO `sys_job_log` VALUES (288, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-21 01:30:00');
INSERT INTO `sys_job_log` VALUES (289, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-21 01:35:00');
INSERT INTO `sys_job_log` VALUES (290, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 01:40:00');
INSERT INTO `sys_job_log` VALUES (291, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 01:45:00');
INSERT INTO `sys_job_log` VALUES (292, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-21 01:50:00');
INSERT INTO `sys_job_log` VALUES (293, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 01:55:00');
INSERT INTO `sys_job_log` VALUES (294, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：5毫秒', '0', '', '2026-05-21 02:00:00');
INSERT INTO `sys_job_log` VALUES (295, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：10毫秒', '0', '', '2026-05-21 02:00:00');
INSERT INTO `sys_job_log` VALUES (296, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 02:05:00');
INSERT INTO `sys_job_log` VALUES (297, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 02:10:00');
INSERT INTO `sys_job_log` VALUES (298, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 02:15:00');
INSERT INTO `sys_job_log` VALUES (299, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-21 02:20:00');
INSERT INTO `sys_job_log` VALUES (300, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-21 02:25:00');
INSERT INTO `sys_job_log` VALUES (301, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-21 02:30:00');
INSERT INTO `sys_job_log` VALUES (302, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-21 02:35:00');
INSERT INTO `sys_job_log` VALUES (303, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 02:40:00');
INSERT INTO `sys_job_log` VALUES (304, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 02:45:00');
INSERT INTO `sys_job_log` VALUES (305, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 02:50:00');
INSERT INTO `sys_job_log` VALUES (306, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 02:55:00');
INSERT INTO `sys_job_log` VALUES (307, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：4毫秒', '0', '', '2026-05-21 03:00:00');
INSERT INTO `sys_job_log` VALUES (308, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：7毫秒', '0', '', '2026-05-21 03:00:00');
INSERT INTO `sys_job_log` VALUES (309, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 03:05:00');
INSERT INTO `sys_job_log` VALUES (310, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 03:10:00');
INSERT INTO `sys_job_log` VALUES (311, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 03:15:00');
INSERT INTO `sys_job_log` VALUES (312, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-21 03:20:00');
INSERT INTO `sys_job_log` VALUES (313, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：8毫秒', '0', '', '2026-05-21 03:25:00');
INSERT INTO `sys_job_log` VALUES (314, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 03:30:00');
INSERT INTO `sys_job_log` VALUES (315, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 03:35:00');
INSERT INTO `sys_job_log` VALUES (316, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 03:40:00');
INSERT INTO `sys_job_log` VALUES (317, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-21 03:45:00');
INSERT INTO `sys_job_log` VALUES (318, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 03:50:00');
INSERT INTO `sys_job_log` VALUES (319, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 03:55:00');
INSERT INTO `sys_job_log` VALUES (320, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-21 04:00:00');
INSERT INTO `sys_job_log` VALUES (321, '民宿订单自动确认', 'hs', 'hsOrderTask.autoConfirmOrders()', '民宿订单自动确认 总共耗时：35毫秒', '0', '', '2026-05-21 04:00:00');
INSERT INTO `sys_job_log` VALUES (322, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 04:05:00');
INSERT INTO `sys_job_log` VALUES (323, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 04:10:00');
INSERT INTO `sys_job_log` VALUES (324, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：3毫秒', '0', '', '2026-05-21 04:15:00');
INSERT INTO `sys_job_log` VALUES (325, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 04:20:00');
INSERT INTO `sys_job_log` VALUES (326, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：6毫秒', '0', '', '2026-05-21 04:25:00');
INSERT INTO `sys_job_log` VALUES (327, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 04:30:00');
INSERT INTO `sys_job_log` VALUES (328, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：4毫秒', '0', '', '2026-05-21 04:35:00');
INSERT INTO `sys_job_log` VALUES (329, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：5毫秒', '0', '', '2026-05-21 04:40:00');
INSERT INTO `sys_job_log` VALUES (330, '民宿订单超时取消', 'hs', 'hsOrderTask.checkTimeoutOrders()', '民宿订单超时取消 总共耗时：16毫秒', '0', '', '2026-05-22 09:15:00');

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime(0) NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 306 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (1, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-25 15:41:40');
INSERT INTO `sys_logininfor` VALUES (2, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-25 19:03:16');
INSERT INTO `sys_logininfor` VALUES (3, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-25 21:31:40');
INSERT INTO `sys_logininfor` VALUES (4, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-25 22:15:50');
INSERT INTO `sys_logininfor` VALUES (5, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-25 22:16:06');
INSERT INTO `sys_logininfor` VALUES (6, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-25 22:16:27');
INSERT INTO `sys_logininfor` VALUES (7, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-02-25 22:16:27');
INSERT INTO `sys_logininfor` VALUES (8, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '用户不存在/密码错误', '2026-02-25 22:16:39');
INSERT INTO `sys_logininfor` VALUES (9, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '用户不存在/密码错误', '2026-02-25 22:17:38');
INSERT INTO `sys_logininfor` VALUES (10, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-25 22:33:57');
INSERT INTO `sys_logininfor` VALUES (11, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-02-25 22:46:47');
INSERT INTO `sys_logininfor` VALUES (12, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-25 23:37:36');
INSERT INTO `sys_logininfor` VALUES (13, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-25 23:40:32');
INSERT INTO `sys_logininfor` VALUES (14, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-02-25 23:40:32');
INSERT INTO `sys_logininfor` VALUES (15, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-25 23:49:31');
INSERT INTO `sys_logininfor` VALUES (16, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-02-25 23:49:31');
INSERT INTO `sys_logininfor` VALUES (17, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-02-26 00:05:40');
INSERT INTO `sys_logininfor` VALUES (18, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-26 00:05:40');
INSERT INTO `sys_logininfor` VALUES (19, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-26 00:05:48');
INSERT INTO `sys_logininfor` VALUES (20, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-02-26 00:05:48');
INSERT INTO `sys_logininfor` VALUES (21, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '用户不存在/密码错误', '2026-02-26 00:45:53');
INSERT INTO `sys_logininfor` VALUES (22, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-26 00:51:14');
INSERT INTO `sys_logininfor` VALUES (23, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-26 00:51:46');
INSERT INTO `sys_logininfor` VALUES (24, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-26 00:52:15');
INSERT INTO `sys_logininfor` VALUES (25, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-27 13:10:48');
INSERT INTO `sys_logininfor` VALUES (26, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-02-27 13:14:28');
INSERT INTO `sys_logininfor` VALUES (27, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-27 13:14:36');
INSERT INTO `sys_logininfor` VALUES (28, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-27 13:15:00');
INSERT INTO `sys_logininfor` VALUES (29, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码错误', '2026-02-28 10:01:40');
INSERT INTO `sys_logininfor` VALUES (30, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '* 必须填写', '2026-02-28 10:01:40');
INSERT INTO `sys_logininfor` VALUES (31, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码错误', '2026-02-28 10:01:49');
INSERT INTO `sys_logininfor` VALUES (32, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-28 10:02:12');
INSERT INTO `sys_logininfor` VALUES (33, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-28 13:31:20');
INSERT INTO `sys_logininfor` VALUES (34, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-28 15:39:32');
INSERT INTO `sys_logininfor` VALUES (35, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码错误', '2026-02-28 15:40:03');
INSERT INTO `sys_logininfor` VALUES (36, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-28 15:40:08');
INSERT INTO `sys_logininfor` VALUES (37, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-02-28 15:45:54');
INSERT INTO `sys_logininfor` VALUES (38, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-04 22:11:30');
INSERT INTO `sys_logininfor` VALUES (39, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-04 22:11:33');
INSERT INTO `sys_logininfor` VALUES (40, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-05 13:01:53');
INSERT INTO `sys_logininfor` VALUES (41, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 16:14:11');
INSERT INTO `sys_logininfor` VALUES (42, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-05 16:14:14');
INSERT INTO `sys_logininfor` VALUES (43, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 16:14:19');
INSERT INTO `sys_logininfor` VALUES (44, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-05 16:14:27');
INSERT INTO `sys_logininfor` VALUES (45, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 18:02:18');
INSERT INTO `sys_logininfor` VALUES (46, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 18:02:18');
INSERT INTO `sys_logininfor` VALUES (47, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 18:02:18');
INSERT INTO `sys_logininfor` VALUES (48, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 18:02:19');
INSERT INTO `sys_logininfor` VALUES (49, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-05 18:02:23');
INSERT INTO `sys_logininfor` VALUES (50, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-03-05 18:15:00');
INSERT INTO `sys_logininfor` VALUES (51, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-05 18:15:02');
INSERT INTO `sys_logininfor` VALUES (52, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 18:15:16');
INSERT INTO `sys_logininfor` VALUES (53, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-05 18:15:25');
INSERT INTO `sys_logininfor` VALUES (54, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 18:16:46');
INSERT INTO `sys_logininfor` VALUES (55, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码错误', '2026-03-05 18:17:48');
INSERT INTO `sys_logininfor` VALUES (56, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 18:17:49');
INSERT INTO `sys_logininfor` VALUES (57, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 18:23:16');
INSERT INTO `sys_logininfor` VALUES (58, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-05 18:23:23');
INSERT INTO `sys_logininfor` VALUES (59, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '注册成功', '2026-03-05 18:28:13');
INSERT INTO `sys_logininfor` VALUES (60, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 19:31:08');
INSERT INTO `sys_logininfor` VALUES (61, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 19:31:08');
INSERT INTO `sys_logininfor` VALUES (62, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-05 19:31:17');
INSERT INTO `sys_logininfor` VALUES (63, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 19:31:20');
INSERT INTO `sys_logininfor` VALUES (64, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 19:31:36');
INSERT INTO `sys_logininfor` VALUES (65, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 19:34:48');
INSERT INTO `sys_logininfor` VALUES (66, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码错误', '2026-03-05 19:34:54');
INSERT INTO `sys_logininfor` VALUES (67, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码错误', '2026-03-05 19:34:58');
INSERT INTO `sys_logininfor` VALUES (68, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-05 19:35:02');
INSERT INTO `sys_logininfor` VALUES (69, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-05 19:45:23');
INSERT INTO `sys_logininfor` VALUES (70, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-05 21:22:17');
INSERT INTO `sys_logininfor` VALUES (71, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-05 21:22:21');
INSERT INTO `sys_logininfor` VALUES (72, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-03-05 21:22:27');
INSERT INTO `sys_logininfor` VALUES (73, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '用户不存在/密码错误', '2026-03-05 21:23:32');
INSERT INTO `sys_logininfor` VALUES (74, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-05 21:24:17');
INSERT INTO `sys_logininfor` VALUES (75, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码错误', '2026-03-05 21:24:44');
INSERT INTO `sys_logininfor` VALUES (76, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-05 21:24:46');
INSERT INTO `sys_logininfor` VALUES (77, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-03-05 21:30:33');
INSERT INTO `sys_logininfor` VALUES (78, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-06 23:41:49');
INSERT INTO `sys_logininfor` VALUES (79, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 11:07:41');
INSERT INTO `sys_logininfor` VALUES (80, '17878786765', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 11:08:30');
INSERT INTO `sys_logininfor` VALUES (81, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 14:36:01');
INSERT INTO `sys_logininfor` VALUES (82, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-03-07 14:52:31');
INSERT INTO `sys_logininfor` VALUES (83, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码已失效', '2026-03-07 14:55:05');
INSERT INTO `sys_logininfor` VALUES (84, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 14:55:12');
INSERT INTO `sys_logininfor` VALUES (85, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-03-07 14:56:45');
INSERT INTO `sys_logininfor` VALUES (86, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 15:12:07');
INSERT INTO `sys_logininfor` VALUES (87, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-03-07 15:24:16');
INSERT INTO `sys_logininfor` VALUES (88, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 15:24:18');
INSERT INTO `sys_logininfor` VALUES (89, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-03-07 15:24:30');
INSERT INTO `sys_logininfor` VALUES (90, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 16:00:47');
INSERT INTO `sys_logininfor` VALUES (91, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-03-07 16:00:54');
INSERT INTO `sys_logininfor` VALUES (92, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 16:01:01');
INSERT INTO `sys_logininfor` VALUES (93, 'demo_tenant', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-03-07 16:01:14');
INSERT INTO `sys_logininfor` VALUES (94, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 16:01:37');
INSERT INTO `sys_logininfor` VALUES (95, 'demo_landlord', '192.168.146.254', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 16:02:30');
INSERT INTO `sys_logininfor` VALUES (96, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-03-07 16:33:34');
INSERT INTO `sys_logininfor` VALUES (97, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 16:33:37');
INSERT INTO `sys_logininfor` VALUES (98, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-03-07 18:08:12');
INSERT INTO `sys_logininfor` VALUES (99, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 18:08:31');
INSERT INTO `sys_logininfor` VALUES (100, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '退出成功', '2026-03-07 18:08:45');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 18:08:49');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码错误', '2026-03-07 18:29:48');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 18:29:49');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 18:34:52');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 18:48:10');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-07 19:58:49');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '1', '验证码错误', '2026-03-20 17:56:54');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Chrome 145', 'Windows10', '0', '登录成功', '2026-03-20 17:56:56');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 15:09:21');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '192.168.25.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-18 16:02:32');
INSERT INTO `sys_logininfor` VALUES (111, '17876453425', '192.168.25.1', '内网IP', 'Chrome 148', 'Windows10', '0', '注册成功', '2026-05-18 16:09:31');
INSERT INTO `sys_logininfor` VALUES (112, '17876453425', '192.168.25.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 16:09:39');
INSERT INTO `sys_logininfor` VALUES (113, '17876453425', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 17:16:05');
INSERT INTO `sys_logininfor` VALUES (114, '17876453425', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-18 17:16:05');
INSERT INTO `sys_logininfor` VALUES (115, '17876453425', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 17:16:05');
INSERT INTO `sys_logininfor` VALUES (116, '17876453425', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 17:16:05');
INSERT INTO `sys_logininfor` VALUES (117, '17876453425', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 17:16:05');
INSERT INTO `sys_logininfor` VALUES (118, '17876453425', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 17:16:12');
INSERT INTO `sys_logininfor` VALUES (119, '15171324012', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '注册成功', '2026-05-18 17:17:07');
INSERT INTO `sys_logininfor` VALUES (120, '15171324012', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 17:17:29');
INSERT INTO `sys_logininfor` VALUES (121, '15171324012', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 17:17:29');
INSERT INTO `sys_logininfor` VALUES (122, '15171324013', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '注册成功', '2026-05-18 17:17:42');
INSERT INTO `sys_logininfor` VALUES (123, '15171324013', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 17:17:52');
INSERT INTO `sys_logininfor` VALUES (124, '15171324013', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 17:17:52');
INSERT INTO `sys_logininfor` VALUES (125, '17876453425', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 17:19:10');
INSERT INTO `sys_logininfor` VALUES (126, '15171324013', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 17:23:03');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 17:55:40');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 17:55:47');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 17:57:52');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 17:58:04');
INSERT INTO `sys_logininfor` VALUES (131, '15171324013', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 17:58:18');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 17:58:51');
INSERT INTO `sys_logininfor` VALUES (133, 'fangdong', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-18 17:59:00');
INSERT INTO `sys_logininfor` VALUES (134, 'fangdong', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-18 17:59:23');
INSERT INTO `sys_logininfor` VALUES (135, 'fangdong', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-18 17:59:30');
INSERT INTO `sys_logininfor` VALUES (136, 'fangdong', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-18 17:59:35');
INSERT INTO `sys_logininfor` VALUES (137, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '注册成功', '2026-05-18 18:00:00');
INSERT INTO `sys_logininfor` VALUES (138, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 18:00:06');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 18:51:51');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 18:55:19');
INSERT INTO `sys_logininfor` VALUES (141, '15171324013', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-18 18:57:30');
INSERT INTO `sys_logininfor` VALUES (142, '15171324013', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 18:57:32');
INSERT INTO `sys_logininfor` VALUES (143, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '* 必须填写', '2026-05-18 19:00:42');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-18 19:00:42');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 19:00:49');
INSERT INTO `sys_logininfor` VALUES (146, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-18 19:56:00');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '* 必须填写', '2026-05-18 19:56:01');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '* 必须填写', '2026-05-18 19:56:07');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 19:56:14');
INSERT INTO `sys_logininfor` VALUES (150, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-18 20:08:44');
INSERT INTO `sys_logininfor` VALUES (151, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 20:08:50');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 20:09:13');
INSERT INTO `sys_logininfor` VALUES (153, '15171324013', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 20:10:32');
INSERT INTO `sys_logininfor` VALUES (154, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 20:12:59');
INSERT INTO `sys_logininfor` VALUES (155, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 20:14:46');
INSERT INTO `sys_logininfor` VALUES (156, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-18 20:24:37');
INSERT INTO `sys_logininfor` VALUES (157, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-18 20:24:41');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 20:24:46');
INSERT INTO `sys_logininfor` VALUES (159, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 20:25:14');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 20:33:17');
INSERT INTO `sys_logininfor` VALUES (161, '17878786765', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-18 20:33:29');
INSERT INTO `sys_logininfor` VALUES (162, '17878786765', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 20:33:33');
INSERT INTO `sys_logininfor` VALUES (163, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 20:34:51');
INSERT INTO `sys_logininfor` VALUES (164, '17878786765', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 20:35:12');
INSERT INTO `sys_logininfor` VALUES (165, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-18 20:35:28');
INSERT INTO `sys_logininfor` VALUES (166, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-18 20:35:29');
INSERT INTO `sys_logininfor` VALUES (167, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-18 20:35:32');
INSERT INTO `sys_logininfor` VALUES (168, '17878786702', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '注册成功', '2026-05-18 20:36:18');
INSERT INTO `sys_logininfor` VALUES (169, '17878786702', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 20:36:25');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-18 20:51:33');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 20:51:35');
INSERT INTO `sys_logininfor` VALUES (172, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 21:09:28');
INSERT INTO `sys_logininfor` VALUES (173, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-18 21:09:28');
INSERT INTO `sys_logininfor` VALUES (174, '17878786702', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 21:18:36');
INSERT INTO `sys_logininfor` VALUES (175, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 21:23:53');
INSERT INTO `sys_logininfor` VALUES (176, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 21:24:10');
INSERT INTO `sys_logininfor` VALUES (177, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 21:24:20');
INSERT INTO `sys_logininfor` VALUES (178, '17876453425', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 21:25:00');
INSERT INTO `sys_logininfor` VALUES (179, '15171324013', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 21:25:32');
INSERT INTO `sys_logininfor` VALUES (180, '15171324012', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 21:25:46');
INSERT INTO `sys_logininfor` VALUES (181, '17876453425', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 21:25:51');
INSERT INTO `sys_logininfor` VALUES (182, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '注册成功', '2026-05-18 21:26:25');
INSERT INTO `sys_logininfor` VALUES (183, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 21:26:31');
INSERT INTO `sys_logininfor` VALUES (184, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 22:21:46');
INSERT INTO `sys_logininfor` VALUES (185, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-18 22:21:46');
INSERT INTO `sys_logininfor` VALUES (186, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 22:42:19');
INSERT INTO `sys_logininfor` VALUES (187, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 22:42:24');
INSERT INTO `sys_logininfor` VALUES (188, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 23:03:55');
INSERT INTO `sys_logininfor` VALUES (189, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 23:05:34');
INSERT INTO `sys_logininfor` VALUES (190, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 23:06:35');
INSERT INTO `sys_logininfor` VALUES (191, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 23:06:56');
INSERT INTO `sys_logininfor` VALUES (192, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 23:08:10');
INSERT INTO `sys_logininfor` VALUES (193, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 23:08:31');
INSERT INTO `sys_logininfor` VALUES (194, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 23:08:36');
INSERT INTO `sys_logininfor` VALUES (195, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 23:08:48');
INSERT INTO `sys_logininfor` VALUES (196, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-18 23:10:18');
INSERT INTO `sys_logininfor` VALUES (197, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 23:10:31');
INSERT INTO `sys_logininfor` VALUES (198, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 23:17:19');
INSERT INTO `sys_logininfor` VALUES (199, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 23:57:01');
INSERT INTO `sys_logininfor` VALUES (200, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-18 23:58:44');
INSERT INTO `sys_logininfor` VALUES (201, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 00:00:01');
INSERT INTO `sys_logininfor` VALUES (202, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 00:01:38');
INSERT INTO `sys_logininfor` VALUES (203, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 13:29:11');
INSERT INTO `sys_logininfor` VALUES (204, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '* 必须填写', '2026-05-19 13:41:35');
INSERT INTO `sys_logininfor` VALUES (205, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 13:41:43');
INSERT INTO `sys_logininfor` VALUES (206, '17878786702', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 14:12:22');
INSERT INTO `sys_logininfor` VALUES (207, '17878786702', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-19 14:12:22');
INSERT INTO `sys_logininfor` VALUES (208, '17878786765', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 14:12:53');
INSERT INTO `sys_logininfor` VALUES (209, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 14:13:59');
INSERT INTO `sys_logininfor` VALUES (210, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 14:21:03');
INSERT INTO `sys_logininfor` VALUES (211, '17878786765', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 15:14:45');
INSERT INTO `sys_logininfor` VALUES (212, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 15:23:02');
INSERT INTO `sys_logininfor` VALUES (213, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 15:45:07');
INSERT INTO `sys_logininfor` VALUES (214, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-19 15:45:39');
INSERT INTO `sys_logininfor` VALUES (215, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-19 15:45:43');
INSERT INTO `sys_logininfor` VALUES (216, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 15:45:50');
INSERT INTO `sys_logininfor` VALUES (217, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-19 16:00:08');
INSERT INTO `sys_logininfor` VALUES (218, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 16:00:08');
INSERT INTO `sys_logininfor` VALUES (219, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 16:18:08');
INSERT INTO `sys_logininfor` VALUES (220, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-19 16:18:35');
INSERT INTO `sys_logininfor` VALUES (221, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 16:19:04');
INSERT INTO `sys_logininfor` VALUES (222, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 16:54:48');
INSERT INTO `sys_logininfor` VALUES (223, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 17:32:43');
INSERT INTO `sys_logininfor` VALUES (224, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 17:45:01');
INSERT INTO `sys_logininfor` VALUES (225, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 18:59:26');
INSERT INTO `sys_logininfor` VALUES (226, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-19 18:59:26');
INSERT INTO `sys_logininfor` VALUES (227, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 21:22:01');
INSERT INTO `sys_logininfor` VALUES (228, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-19 21:22:01');
INSERT INTO `sys_logininfor` VALUES (229, '15171324011', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '0', '登录成功', '2026-05-19 21:29:17');
INSERT INTO `sys_logininfor` VALUES (230, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-19 22:54:01');
INSERT INTO `sys_logininfor` VALUES (231, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-19 22:54:03');
INSERT INTO `sys_logininfor` VALUES (232, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 22:54:13');
INSERT INTO `sys_logininfor` VALUES (233, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 22:56:35');
INSERT INTO `sys_logininfor` VALUES (234, '15171324011', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '0', '登录成功', '2026-05-19 22:57:18');
INSERT INTO `sys_logininfor` VALUES (235, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 23:03:56');
INSERT INTO `sys_logininfor` VALUES (236, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 23:13:44');
INSERT INTO `sys_logininfor` VALUES (237, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-19 23:13:44');
INSERT INTO `sys_logininfor` VALUES (238, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-19 23:19:55');
INSERT INTO `sys_logininfor` VALUES (239, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-19 23:25:59');
INSERT INTO `sys_logininfor` VALUES (240, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 00:22:52');
INSERT INTO `sys_logininfor` VALUES (241, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '退出成功', '2026-05-20 01:21:19');
INSERT INTO `sys_logininfor` VALUES (242, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 01:21:55');
INSERT INTO `sys_logininfor` VALUES (243, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 04:48:56');
INSERT INTO `sys_logininfor` VALUES (244, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 04:49:12');
INSERT INTO `sys_logininfor` VALUES (245, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 04:49:34');
INSERT INTO `sys_logininfor` VALUES (246, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 04:49:44');
INSERT INTO `sys_logininfor` VALUES (247, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 04:50:17');
INSERT INTO `sys_logininfor` VALUES (248, '15171324011', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '0', '登录成功', '2026-05-20 05:04:12');
INSERT INTO `sys_logininfor` VALUES (249, '15171324011', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '1', '验证码已失效', '2026-05-20 05:04:16');
INSERT INTO `sys_logininfor` VALUES (250, '15171324011', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '0', '登录成功', '2026-05-20 05:16:05');
INSERT INTO `sys_logininfor` VALUES (251, '15171324011', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '1', '验证码已失效', '2026-05-20 05:16:09');
INSERT INTO `sys_logininfor` VALUES (252, '15171324011', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '0', '登录成功', '2026-05-20 05:16:28');
INSERT INTO `sys_logininfor` VALUES (253, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 05:17:13');
INSERT INTO `sys_logininfor` VALUES (254, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-20 05:17:31');
INSERT INTO `sys_logininfor` VALUES (255, '15171324011', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 05:17:53');
INSERT INTO `sys_logininfor` VALUES (256, '15171324015', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '注册成功', '2026-05-20 05:18:20');
INSERT INTO `sys_logininfor` VALUES (257, '15171324015', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 05:18:30');
INSERT INTO `sys_logininfor` VALUES (258, '15171324015', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-20 05:18:32');
INSERT INTO `sys_logininfor` VALUES (259, '15171324015', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-20 05:18:42');
INSERT INTO `sys_logininfor` VALUES (260, '15171324016', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '注册成功', '2026-05-20 05:19:11');
INSERT INTO `sys_logininfor` VALUES (261, '15171324016', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 05:19:21');
INSERT INTO `sys_logininfor` VALUES (262, '15171324016', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 05:21:29');
INSERT INTO `sys_logininfor` VALUES (263, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 06:54:47');
INSERT INTO `sys_logininfor` VALUES (264, 'demo_landlord', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 06:54:54');
INSERT INTO `sys_logininfor` VALUES (265, '15171324016', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 06:55:53');
INSERT INTO `sys_logininfor` VALUES (266, '15171324016', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 08:46:52');
INSERT INTO `sys_logininfor` VALUES (267, '15171324016', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '1', '验证码错误', '2026-05-20 09:29:02');
INSERT INTO `sys_logininfor` VALUES (268, '15171324016', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '0', '登录成功', '2026-05-20 09:29:05');
INSERT INTO `sys_logininfor` VALUES (269, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 09:31:20');
INSERT INTO `sys_logininfor` VALUES (270, '15171324016', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 09:34:15');
INSERT INTO `sys_logininfor` VALUES (271, '17878786765', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 09:35:46');
INSERT INTO `sys_logininfor` VALUES (272, '15171324016', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 09:44:00');
INSERT INTO `sys_logininfor` VALUES (273, '15171324016', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 09:44:08');
INSERT INTO `sys_logininfor` VALUES (274, '15171324016', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 09:44:32');
INSERT INTO `sys_logininfor` VALUES (275, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 09:47:59');
INSERT INTO `sys_logininfor` VALUES (276, '15171324016', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 09:51:08');
INSERT INTO `sys_logininfor` VALUES (277, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 10:03:45');
INSERT INTO `sys_logininfor` VALUES (278, '15171324016', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 10:05:16');
INSERT INTO `sys_logininfor` VALUES (279, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 10:19:26');
INSERT INTO `sys_logininfor` VALUES (280, '15171324016', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 11:13:05');
INSERT INTO `sys_logininfor` VALUES (281, '15171324011', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '0', '登录成功', '2026-05-20 11:18:22');
INSERT INTO `sys_logininfor` VALUES (282, '15171324011', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '1', '验证码已失效', '2026-05-20 11:18:35');
INSERT INTO `sys_logininfor` VALUES (283, '15171324016', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '0', '登录成功', '2026-05-20 11:18:54');
INSERT INTO `sys_logininfor` VALUES (284, '15171324016', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '1', '验证码已失效', '2026-05-20 11:18:59');
INSERT INTO `sys_logininfor` VALUES (285, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 11:21:09');
INSERT INTO `sys_logininfor` VALUES (286, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 11:51:43');
INSERT INTO `sys_logininfor` VALUES (287, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 11:51:49');
INSERT INTO `sys_logininfor` VALUES (288, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 11:52:02');
INSERT INTO `sys_logininfor` VALUES (289, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 11:52:12');
INSERT INTO `sys_logininfor` VALUES (290, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码错误', '2026-05-20 11:52:13');
INSERT INTO `sys_logininfor` VALUES (291, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 11:52:38');
INSERT INTO `sys_logininfor` VALUES (292, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 11:52:54');
INSERT INTO `sys_logininfor` VALUES (293, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 11:52:59');
INSERT INTO `sys_logininfor` VALUES (294, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 11:53:48');
INSERT INTO `sys_logininfor` VALUES (295, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '用户不存在/密码错误', '2026-05-20 11:54:19');
INSERT INTO `sys_logininfor` VALUES (296, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 11:54:36');
INSERT INTO `sys_logininfor` VALUES (297, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 13:00:19');
INSERT INTO `sys_logininfor` VALUES (298, '15171324010', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '1', '验证码已失效', '2026-05-20 13:00:19');
INSERT INTO `sys_logininfor` VALUES (299, 'admin', '127.0.0.1', '内网IP', 'Chrome 148', 'Windows10', '0', '登录成功', '2026-05-20 13:00:48');
INSERT INTO `sys_logininfor` VALUES (300, '15171324011', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '1', '验证码错误', '2026-05-20 13:04:37');
INSERT INTO `sys_logininfor` VALUES (301, '15171324011', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '0', '登录成功', '2026-05-20 13:04:43');
INSERT INTO `sys_logininfor` VALUES (302, '15171324021', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '0', '注册成功', '2026-05-20 13:06:02');
INSERT INTO `sys_logininfor` VALUES (303, '15171324021', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '0', '登录成功', '2026-05-20 13:06:11');
INSERT INTO `sys_logininfor` VALUES (304, '15171324021', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '0', '登录成功', '2026-05-20 13:07:05');
INSERT INTO `sys_logininfor` VALUES (305, '15171324021', '127.0.0.1', '内网IP', 'Edge 134', 'Windows >=10', '0', '登录成功', '2026-05-20 23:13:27');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(0) NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(0) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int(0) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(0) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE,
  INDEX `idx_menu_parent`(`parent_id`) USING BTREE,
  INDEX `idx_menu_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2020 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 10, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2024-07-18 08:50:06', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 11, 'monitor', NULL, '', '', 1, 0, 'M', '1', '1', '', 'monitor', 'admin', '2024-07-18 08:50:06', 'admin', '2026-05-19 16:41:56', '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 12, 'tool', NULL, '', '', 1, 0, 'M', '1', '1', '', 'tool', 'admin', '2024-07-18 08:50:06', 'admin', '2026-05-19 16:42:03', '系统工具目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 2, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2024-07-18 08:50:06', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2024-07-18 08:50:06', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2024-07-18 08:50:06', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '1', '0', 'system:dept:list', 'tree', 'admin', '2024-07-18 08:50:06', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '1', '0', 'system:post:list', 'post', 'admin', '2024-07-18 08:50:06', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '1', '0', 'system:dict:list', 'dict', 'admin', '2024-07-18 08:50:06', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2024-07-18 08:50:06', 'admin', '2026-05-19 18:02:48', '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '1', '0', 'system:notice:list', 'message', 'admin', '2024-07-18 08:50:06', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '1', '0', '', 'log', 'admin', '2024-07-18 08:50:06', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2024-07-18 08:50:06', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2024-07-18 08:50:06', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2024-07-18 08:50:06', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2024-07-18 08:50:06', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2024-07-18 08:50:06', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2024-07-18 08:50:06', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2026-02-25 14:23:17', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2024-07-18 08:50:06', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2024-07-18 08:50:06', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2024-07-18 08:50:06', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2024-07-18 08:50:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '民宿短租系统', 0, 1, 'homestay', NULL, '', '', 1, 0, 'M', '0', '0', '', 'shopping', 'admin', '2026-02-25 14:24:48', '', NULL, '民宿短租目录');
INSERT INTO `sys_menu` VALUES (2001, '监管上报', 2000, 9, 'supervision', 'homestay/supervision/index', '', '', 1, 0, 'C', '0', '0', 'homestay:supervision:list', 'monitor', 'admin', '2026-02-25 14:24:48', '', NULL, '监管上报菜单');
INSERT INTO `sys_menu` VALUES (2002, '运营看板', 2000, 12, 'overview', 'homestay/overview/index', '', '', 1, 0, 'C', '0', '1', 'homestay:overview:list', 'dashboard', 'admin', '2026-02-25 14:24:48', 'admin', '2026-05-19 16:50:30', '运营看板菜单');
INSERT INTO `sys_menu` VALUES (2003, '交易监管', 2000, 5, 'order', 'homestay/order/index', '', '', 1, 0, 'C', '0', '0', 'homestay:order:list', 'table', 'admin', '2026-02-25 14:24:48', '', NULL, '订单管理菜单');
INSERT INTO `sys_menu` VALUES (2005, '订单确认', 2003, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'homestay:order:confirm', '#', 'admin', '2026-02-25 14:24:48', '', NULL, '订单确认按钮');
INSERT INTO `sys_menu` VALUES (2006, '订单拒绝', 2003, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'homestay:order:reject', '#', 'admin', '2026-02-25 14:24:48', '', NULL, '订单拒绝按钮');
INSERT INTO `sys_menu` VALUES (2008, '公告管理', 2000, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '1', '0', 'homestay:notice:list', 'notification', 'admin', '2026-03-05 15:32:18', '', NULL, '公告管理菜单');
INSERT INTO `sys_menu` VALUES (2009, '轮播管理', 2000, 7, 'ad', 'homestay/ad/index', '', '', 1, 0, 'C', '1', '0', 'homestay:ad:list', 'picture', 'admin', '2026-03-05 15:32:18', '', NULL, '轮播管理菜单');
INSERT INTO `sys_menu` VALUES (2010, '轮播新增', 2009, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'homestay:ad:add', '#', 'admin', '2026-03-05 15:32:18', '', NULL, '轮播新增按钮');
INSERT INTO `sys_menu` VALUES (2011, '轮播编辑', 2009, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'homestay:ad:edit', '#', 'admin', '2026-03-05 15:32:18', '', NULL, '轮播编辑按钮');
INSERT INTO `sys_menu` VALUES (2012, '轮播删除', 2009, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'homestay:ad:remove', '#', 'admin', '2026-03-05 15:32:18', '', NULL, '轮播删除按钮');
INSERT INTO `sys_menu` VALUES (2013, '房源审核', 2000, 1, 'homestayAudit', 'homestay/audit/index', NULL, '', 1, 0, 'C', '0', '0', 'homestay:audit:list', 'tab', '1', '2026-03-07 17:50:49', 'admin', '2026-05-19 16:51:36', '房源审核管理');
INSERT INTO `sys_menu` VALUES (2016, '数据看板', 2000, 0, 'dashboard', 'homestay/dashboard/index', NULL, '', 1, 0, 'C', '0', '0', 'homestay:dashboard:view', 'chart', '1', '2026-03-07 17:56:59', '', NULL, '管理员数据看板');
INSERT INTO `sys_menu` VALUES (2017, '订单监控', 2000, 3, 'orderMonitor', 'homestay/orderMonitor/index', '', '', 1, 0, 'C', '0', '0', 'homestay:orderMonitor:list', 'monitor', 'admin', '2026-05-18 21:23:24', '', NULL, '订单监控菜单');
INSERT INTO `sys_menu` VALUES (2018, 'AI助手', 2000, 6, 'ai', 'homestay/ai/index', '', '', 1, 0, 'C', '0', '0', 'homestay:ai:list', 'people', 'admin', '2026-05-18 21:23:33', 'admin', '2026-05-19 16:51:15', 'AI助手菜单');
INSERT INTO `sys_menu` VALUES (2019, '租客沟通', 2000, 10, 'chat', 'homestay/chat/index', NULL, '', 1, 0, 'C', '0', '1', 'homestay:chat:list', 'message', 'admin', '2026-05-20 08:52:02', 'admin', '2026-05-20 10:16:29', '房东与租客实时对话');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int(0) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (10, '222通知公告-新增', '1', 0xE6B58BE8AF95E9809AE79FA5, '0', 'admin', '2026-02-28 13:52:00', '', NULL, NULL);
INSERT INTO `sys_notice` VALUES (11, '【新增-校友邦-测试】222通知公告-新增', '1', 0xE4BEA7E5BC8FE9809AE79FA5, '0', 'admin', '2026-02-28 13:52:12', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int(0) NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int(0) NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int(0) NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime(0) NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(0) NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 252 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (1, '通知公告', 1, 'com.ruoyi.web.controller.system.SysNoticeController.add()', 'POST', 1, 'admin', '总公司', '/system/notice', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"noticeContent\":\"测试通知\",\"noticeTitle\":\"222通知公告-新增\",\"noticeType\":\"1\",\"params\":{},\"remark\":\"\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-28 13:52:00', 163);
INSERT INTO `sys_oper_log` VALUES (2, '通知公告', 1, 'com.ruoyi.web.controller.system.SysNoticeController.add()', 'POST', 1, 'admin', '总公司', '/system/notice', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"noticeContent\":\"侧式通知\",\"noticeTitle\":\"【新增-校友邦-测试】222通知公告-新增\",\"noticeType\":\"1\",\"params\":{},\"remark\":\"\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-28 13:52:12', 10);
INSERT INTO `sys_oper_log` VALUES (3, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '总公司', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"ryo210856837@gmail.com\",\"nickName\":\"zmj\",\"params\":{},\"phonenumber\":\"16787365321\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-28 15:44:43', 22);
INSERT INTO `sys_oper_log` VALUES (4, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '总公司', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/03/05/1eaa99eebd55441a92a482d7ed9abde5.png\",\"code\":200}', 0, NULL, '2026-03-05 16:13:12', 262);
INSERT INTO `sys_oper_log` VALUES (5, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '总公司', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"3728@qq.com\",\"nickName\":\"ruoyi\",\"params\":{},\"phonenumber\":\"16787656536\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-05 16:13:12', 72);
INSERT INTO `sys_oper_log` VALUES (6, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '总公司', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/03/05/fceea8e6c0c348d198d63a9c0926c58d.png\",\"code\":200}', 0, NULL, '2026-03-05 19:46:28', 89);
INSERT INTO `sys_oper_log` VALUES (7, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '总公司', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"213#@aa.com\",\"nickName\":\"租客001\",\"params\":{},\"phonenumber\":\"15173829876\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-05 19:46:28', 19);
INSERT INTO `sys_oper_log` VALUES (8, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '总公司', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"12423@qq.com\",\"nickName\":\"test\",\"params\":{},\"phonenumber\":\"178\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-05 19:46:52', 15);
INSERT INTO `sys_oper_log` VALUES (9, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '总公司', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"123@qq.com\",\"nickName\":\"123\",\"params\":{},\"phonenumber\":\"123\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-05 19:50:14', 15);
INSERT INTO `sys_oper_log` VALUES (10, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '总公司', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/03/05/ca4974e8b23545a0a5a51133fc605fb6.png\",\"code\":200}', 0, NULL, '2026-03-05 21:07:24', 202);
INSERT INTO `sys_oper_log` VALUES (11, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '总公司', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"ryo210856837@gmail.com\",\"nickName\":\"re\",\"params\":{},\"phonenumber\":\"16576545432\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-05 21:07:24', 72);
INSERT INTO `sys_oper_log` VALUES (12, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, '17878786765', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/03/07/a37764cbf97d4cbda5ff6e20892b03fc.png\",\"code\":200}', 0, NULL, '2026-03-07 11:08:59', 78);
INSERT INTO `sys_oper_log` VALUES (13, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '17878786765', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"2333@qq.com\",\"nickName\":\"178测试\",\"params\":{},\"phonenumber\":\"15876532452\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-07 11:08:59', 21);
INSERT INTO `sys_oper_log` VALUES (14, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.payMock()', 'POST', 1, '17878786765', NULL, '/api/order/pay/mock', '127.0.0.1', '内网IP', '{\"orderId\":972071} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-07 19:50:31', 27);
INSERT INTO `sys_oper_log` VALUES (15, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.confirm()', 'POST', 1, 'admin', '总公司', '/api/order/confirm', '127.0.0.1', '内网IP', '{\"orderId\":972071} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-07 19:50:43', 21);
INSERT INTO `sys_oper_log` VALUES (16, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.checkin()', 'POST', 1, '17878786765', NULL, '/api/order/checkin', '127.0.0.1', '内网IP', '{\"orderId\":972071,\"reason\":\"checkin-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-07 19:51:00', 21);
INSERT INTO `sys_oper_log` VALUES (17, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, 'admin', '总公司', '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,\",\"basePrice\":199,\"bedInfo\":\"123\",\"bedroomCount\":4,\"city\":\"Wuhan\",\"cleaningFee\":123,\"coverImage\":\"/profile/homestay/9542627548fbbb46584adc09a943ad6b1277456726_20260518175456A001.jpg\",\"deposit\":123,\"description\":\"123\",\"district\":\"123\",\"maxGuests\":3,\"province\":\"Hubei Provice\",\"roomType\":\"整套\",\"title\":\"ce\",\"weekendPrice\":123} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971033}', 0, NULL, '2026-05-18 17:54:57', 216);
INSERT INTO `sys_oper_log` VALUES (18, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, 'admin', '总公司', '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,\",\"basePrice\":199,\"bedInfo\":\"\",\"bedroomCount\":1,\"city\":\"Wuhan\",\"coverImage\":\"/profile/homestay/营业执照01_20260518175512A002.png\",\"description\":\"123\",\"district\":\"123\",\"id\":971033,\"maxGuests\":3,\"province\":\"Hubei Provice\",\"roomType\":\"整套\",\"title\":\"ce\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 17:55:14', 41);
INSERT INTO `sys_oper_log` VALUES (19, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, 'admin', '总公司', '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,\",\"basePrice\":199,\"bedInfo\":\"\",\"bedroomCount\":1,\"city\":\"Wuhan\",\"coverImage\":\"/profile/homestay/213_20260518175525A003.png\",\"description\":\"123\",\"district\":\"123\",\"id\":971033,\"maxGuests\":3,\"province\":\"Hubei Provice\",\"roomType\":\"整套\",\"title\":\"ce\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 17:55:27', 22);
INSERT INTO `sys_oper_log` VALUES (20, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.resetPwd()', 'PUT', 1, 'admin', '总公司', '/system/user/resetPwd', '127.0.0.1', '内网IP', '{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":2001} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 17:56:46', 83);
INSERT INTO `sys_oper_log` VALUES (21, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.resetPwd()', 'PUT', 1, 'admin', '总公司', '/system/user/resetPwd', '127.0.0.1', '内网IP', '{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":2002} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 17:56:51', 81);
INSERT INTO `sys_oper_log` VALUES (22, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '总公司', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-02-25 14:24:36\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0\",\"children\":[],\"deptId\":100,\"deptName\":\"总公司\",\"leader\":\"admin\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"status\":\"0\"},\"deptId\":100,\"email\":\"landlord@demo.com\",\"loginDate\":\"2026-03-07 18:08:31\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"fangdong\",\"params\":{},\"phonenumber\":\"13800000001\",\"postIds\":[],\"pwdUpdateDate\":\"2026-05-18 17:56:46\",\"remark\":\"MVP demo landlord\",\"roleIds\":[100],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":100,\"roleKey\":\"hs:landlord\",\"roleName\":\"Landlord\",\"roleSort\":200,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"tryCount\":0,\"updateBy\":\"admin\",\"userId\":2001,\"userName\":\"demo_landlord\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 17:57:14', 37);
INSERT INTO `sys_oper_log` VALUES (23, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '总公司', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-02-25 14:24:36\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0\",\"children\":[],\"deptId\":100,\"deptName\":\"总公司\",\"leader\":\"admin\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"status\":\"0\"},\"deptId\":100,\"email\":\"landlord@demo.com\",\"loginDate\":\"2026-03-07 18:08:31\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"fangdong\",\"params\":{},\"phonenumber\":\"13800000001\",\"postIds\":[],\"pwdUpdateDate\":\"2026-05-18 17:56:46\",\"remark\":\"MVP demo landlord\",\"roleIds\":[100],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":100,\"roleKey\":\"hs:landlord\",\"roleName\":\"Landlord\",\"roleSort\":200,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"tryCount\":0,\"updateBy\":\"admin\",\"userId\":2001,\"userName\":\"demo_landlord\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 17:57:20', 31);
INSERT INTO `sys_oper_log` VALUES (24, '用户管理', 4, 'com.ruoyi.web.controller.system.SysUserController.insertAuthRole()', 'PUT', 1, 'admin', '总公司', '/system/user/authRole', '127.0.0.1', '内网IP', '{\"roleIds\":\"100\",\"userId\":\"2001\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 17:57:29', 17);
INSERT INTO `sys_oper_log` VALUES (25, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '总公司', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-02-25 14:24:36\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0\",\"children\":[],\"deptId\":100,\"deptName\":\"总公司\",\"leader\":\"admin\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"status\":\"0\"},\"deptId\":100,\"email\":\"tenant@demo.com\",\"loginDate\":\"2026-03-07 16:01:02\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"zuke\",\"params\":{},\"phonenumber\":\"13800000002\",\"postIds\":[],\"pwdUpdateDate\":\"2026-05-18 17:56:51\",\"remark\":\"MVP demo tenant\",\"roleIds\":[101],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":101,\"roleKey\":\"hs:tenant\",\"roleName\":\"Tenant\",\"roleSort\":201,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"tryCount\":0,\"updateBy\":\"admin\",\"userId\":2002,\"userName\":\"demo_tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 17:57:43', 30);
INSERT INTO `sys_oper_log` VALUES (26, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, '15171324010', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/05/18/f3e5479ee3f749f4b32e432ff79a4b0e.png\",\"code\":200}', 0, NULL, '2026-05-18 18:00:39', 10);
INSERT INTO `sys_oper_log` VALUES (27, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"123@qq.com\",\"nickName\":\"1231\",\"params\":{},\"phonenumber\":\"16765453652\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 18:00:39', 17);
INSERT INTO `sys_oper_log` VALUES (28, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"123@qq.com\",\"nickName\":\"1231\",\"params\":{},\"phonenumber\":\"16765453652\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 18:04:38', 17);
INSERT INTO `sys_oper_log` VALUES (29, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"123@qq.com\",\"nickName\":\"1231\",\"params\":{},\"phonenumber\":\"16765453652\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 18:04:40', 14);
INSERT INTO `sys_oper_log` VALUES (30, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, '15171324010', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/05/18/0b23e2d4b6864ebea044496dca32faef.png\",\"code\":200}', 0, NULL, '2026-05-18 18:06:39', 10);
INSERT INTO `sys_oper_log` VALUES (31, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"123@qq.com\",\"nickName\":\"1231\",\"params\":{},\"phonenumber\":\"16765453652\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 18:06:39', 12);
INSERT INTO `sys_oper_log` VALUES (32, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324013', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"31213@qq.com\",\"nickName\":\"张美娟\",\"params\":{},\"phonenumber\":\"16767487352\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 20:05:58', 27);
INSERT INTO `sys_oper_log` VALUES (33, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, '15171324013', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/05/18/a1fabd03267b457ea5728bb6742c4b7e.png\",\"code\":200}', 0, NULL, '2026-05-18 20:06:03', 74);
INSERT INTO `sys_oper_log` VALUES (34, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324013', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"31213@qq.com\",\"nickName\":\"张美娟\",\"params\":{},\"phonenumber\":\"16767487352\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 20:06:03', 13);
INSERT INTO `sys_oper_log` VALUES (35, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '17878786702', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,\",\"basePrice\":199,\"bedInfo\":\"房源【01】\",\"bedroomCount\":1,\"city\":\"Wuhan\",\"cleaningFee\":23,\"coverImage\":\"/profile/homestay/初音未来数字版画组图生成 (1)_20260518203742A002.png\",\"deposit\":23,\"description\":\"房源【01】房源【01】房源【01】\",\"district\":\"132\",\"maxGuests\":2,\"province\":\"Hubei Provice\",\"roomType\":\"整套\",\"title\":\"房源【01】\",\"weekendPrice\":123} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971034}', 0, NULL, '2026-05-18 20:37:43', 105);
INSERT INTO `sys_oper_log` VALUES (36, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971033,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 21:06:02', 43);
INSERT INTO `sys_oper_log` VALUES (37, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, 'admin', '总公司', '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,\",\"basePrice\":199,\"bedInfo\":\"1321\",\"bedroomCount\":2,\"city\":\"Wuhan\",\"cleaningFee\":123312,\"coverImage\":\"/profile/homestay//2026/05/18/213_20260518210640A001.png\",\"deposit\":123,\"description\":\"23\",\"district\":\"312\",\"maxGuests\":2,\"province\":\"Hubei Provice\",\"roomType\":\"整套\",\"title\":\"213\",\"weekendPrice\":123123} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971035}', 0, NULL, '2026-05-18 21:06:41', 118);
INSERT INTO `sys_oper_log` VALUES (38, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324011', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,\",\"basePrice\":199,\"bedInfo\":\"1.8m大床×1+1.2m单人床×1\",\"bedroomCount\":1,\"city\":\"武汉\",\"cleaningFee\":21,\"coverImage\":\"/profile/homestay//2026/05/18/毕业论文与任务书、开题报告的关系及权重_20260518212752A002.png\",\"deposit\":12,\"description\":\"1.8m大床×1+1.2m单人床×11.8m大床×1+1.2m单人床×1\",\"district\":\"蕲春\",\"maxGuests\":2,\"province\":\"湖北\",\"roomType\":\"独立单间\",\"title\":\"房源1\",\"weekendPrice\":334} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971036}', 0, NULL, '2026-05-18 21:29:19', 78);
INSERT INTO `sys_oper_log` VALUES (39, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324011', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,\",\"basePrice\":199,\"bedInfo\":\"地址信息\",\"bedroomCount\":1,\"city\":\"123\",\"cleaningFee\":21,\"coverImage\":\"/profile/homestay//2026/05/18/初音未来数字版画组图生成 (2)_20260518212941A003.png\",\"deposit\":23,\"description\":\"地址信息\",\"district\":\"312\",\"maxGuests\":2,\"province\":\"123\",\"roomType\":\"独立单间\",\"title\":\"2\",\"weekendPrice\":21} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971037}', 0, NULL, '2026-05-18 21:29:42', 76);
INSERT INTO `sys_oper_log` VALUES (40, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971035,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:43:49', 29);
INSERT INTO `sys_oper_log` VALUES (41, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.payMock()', 'POST', 1, '15171324010', NULL, '/api/order/pay/mock', '127.0.0.1', '内网IP', '{\"orderId\":972076} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:49:14', 23);
INSERT INTO `sys_oper_log` VALUES (42, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972007,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:57:11', 179);
INSERT INTO `sys_oper_log` VALUES (43, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972013,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:57:13', 27);
INSERT INTO `sys_oper_log` VALUES (44, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972019,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:57:14', 27);
INSERT INTO `sys_oper_log` VALUES (45, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972025,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:57:14', 22);
INSERT INTO `sys_oper_log` VALUES (46, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972031,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:57:15', 20);
INSERT INTO `sys_oper_log` VALUES (47, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.changeStatus()', 'PUT', 1, 'admin', '总公司', '/system/user/changeStatus', '127.0.0.1', '内网IP', '{\"admin\":false,\"params\":{},\"status\":\"1\",\"updateBy\":\"admin\",\"userId\":2006} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:57:58', 16);
INSERT INTO `sys_oper_log` VALUES (48, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.changeStatus()', 'PUT', 1, 'admin', '总公司', '/system/user/changeStatus', '127.0.0.1', '内网IP', '{\"admin\":false,\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":2006} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:58:01', 8);
INSERT INTO `sys_oper_log` VALUES (49, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.confirm()', 'POST', 1, 'admin', '总公司', '/api/order/confirm', '127.0.0.1', '内网IP', '{\"orderId\":972076} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:58:17', 18);
INSERT INTO `sys_oper_log` VALUES (50, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.confirm()', 'POST', 1, 'admin', '总公司', '/api/order/confirm', '127.0.0.1', '内网IP', '{\"orderId\":972014} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:58:19', 17);
INSERT INTO `sys_oper_log` VALUES (51, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.confirm()', 'POST', 1, 'admin', '总公司', '/api/order/confirm', '127.0.0.1', '内网IP', '{\"orderId\":972056} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:58:19', 17);
INSERT INTO `sys_oper_log` VALUES (52, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.confirm()', 'POST', 1, 'admin', '总公司', '/api/order/confirm', '127.0.0.1', '内网IP', '{\"orderId\":972050} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:58:20', 16);
INSERT INTO `sys_oper_log` VALUES (53, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.confirm()', 'POST', 1, 'admin', '总公司', '/api/order/confirm', '127.0.0.1', '内网IP', '{\"orderId\":972044} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:58:21', 17);
INSERT INTO `sys_oper_log` VALUES (54, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972037,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:58:29', 18);
INSERT INTO `sys_oper_log` VALUES (55, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972043,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:58:29', 19);
INSERT INTO `sys_oper_log` VALUES (56, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972049,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:58:29', 22);
INSERT INTO `sys_oper_log` VALUES (57, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972001,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:58:31', 19);
INSERT INTO `sys_oper_log` VALUES (58, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972072,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 22:58:37', 33);
INSERT INTO `sys_oper_log` VALUES (59, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, 'admin', '总公司', '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"建国路88号SOHO现代城\",\"basePrice\":299,\"bedInfo\":\"\",\"bedroomCount\":2,\"city\":\"北京\",\"coverImage\":\"/profile/homestay//2026/05/18/初音未来数字版画组图生成 (3)_20260518235910A001.png\",\"description\":\"位于朝阳区CBD核心地段，交通便利，近地铁站。现代简约风格，配备全套家电。\",\"district\":\"朝阳区\",\"id\":1,\"latitude\":39.897892,\"longitude\":116.372851,\"maxGuests\":4,\"province\":\"北京市\",\"roomType\":\"整套公寓\",\"title\":\"北京朝阳区现代公寓\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 23:59:12', 38);
INSERT INTO `sys_oper_log` VALUES (60, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":1,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-18 23:59:28', 23);
INSERT INTO `sys_oper_log` VALUES (61, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, '15171324010', NULL, '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972077,\"reason\":\"cancel-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 00:00:45', 29);
INSERT INTO `sys_oper_log` VALUES (62, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, '15171324011', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/05/19/86919b8d20044133b8f8e7c5f3d3f25e.jpeg\",\"code\":200}', 0, NULL, '2026-05-19 14:10:12', 92);
INSERT INTO `sys_oper_log` VALUES (63, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324011', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"17878786702@qq.com\",\"nickName\":\"苍龙\",\"params\":{},\"phonenumber\":\"17878786702\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 14:10:12', 21);
INSERT INTO `sys_oper_log` VALUES (64, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324011', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"17878786702@qq.com\",\"nickName\":\"苍龙\",\"params\":{},\"phonenumber\":\"17878786702\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 14:10:40', 16);
INSERT INTO `sys_oper_log` VALUES (65, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, '15171324011', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/05/19/b8d7f88809ef40ff888454f251ea46b9.png\",\"code\":200}', 0, NULL, '2026-05-19 14:54:46', 95);
INSERT INTO `sys_oper_log` VALUES (66, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324011', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"17878786702@qq.com\",\"nickName\":\"苍龙\",\"params\":{},\"phonenumber\":\"17878786702\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 14:54:46', 27);
INSERT INTO `sys_oper_log` VALUES (67, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, '15171324010', NULL, '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972091,\"reason\":\"cancel-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:03:46', 37);
INSERT INTO `sys_oper_log` VALUES (68, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324011', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,\",\"basePrice\":199,\"bedInfo\":\"\",\"bedroomCount\":1,\"city\":\"市辖区\",\"cleaningFee\":32,\"deposit\":12,\"description\":\"范德萨\",\"district\":\"西城区\",\"maxGuests\":2,\"province\":\"北京市\",\"roomType\":\"整套\",\"title\":\"范德萨\",\"weekendPrice\":222} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971038}', 0, NULL, '2026-05-19 16:20:12', 112);
INSERT INTO `sys_oper_log` VALUES (69, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '总公司', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-18 08:50:06\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":11,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:41:56', 17);
INSERT INTO `sys_oper_log` VALUES (70, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '总公司', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-18 08:50:06\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":12,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:42:03', 13);
INSERT INTO `sys_oper_log` VALUES (71, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972055,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:42:18', 16);
INSERT INTO `sys_oper_log` VALUES (72, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972066,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:42:18', 18);
INSERT INTO `sys_oper_log` VALUES (73, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972067,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:43:07', 17);
INSERT INTO `sys_oper_log` VALUES (74, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.confirm()', 'POST', 1, 'admin', '总公司', '/api/order/confirm', '127.0.0.1', '内网IP', '{\"orderId\":972038} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:43:14', 15);
INSERT INTO `sys_oper_log` VALUES (75, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972073,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:43:20', 15);
INSERT INTO `sys_oper_log` VALUES (76, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972074,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:43:21', 18);
INSERT INTO `sys_oper_log` VALUES (77, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972075,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:43:21', 16);
INSERT INTO `sys_oper_log` VALUES (78, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972078,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:43:21', 24);
INSERT INTO `sys_oper_log` VALUES (79, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972079,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:43:21', 27);
INSERT INTO `sys_oper_log` VALUES (80, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972080,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:43:22', 26);
INSERT INTO `sys_oper_log` VALUES (81, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972081,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:43:22', 22);
INSERT INTO `sys_oper_log` VALUES (82, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972082,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:43:34', 22);
INSERT INTO `sys_oper_log` VALUES (83, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.cancel()', 'POST', 1, 'admin', '总公司', '/api/order/cancel', '127.0.0.1', '内网IP', '{\"orderId\":972083,\"reason\":\"管理员手动关闭\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:43:35', 22);
INSERT INTO `sys_oper_log` VALUES (84, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '总公司', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"homestay/homestay/index\",\"createTime\":\"2026-02-25 14:24:48\",\"icon\":\"home-filled\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2004,\"menuName\":\"房源管理\",\"menuType\":\"C\",\"orderNum\":13,\"params\":{},\"parentId\":2000,\"path\":\"homestayList\",\"perms\":\"homestay:homestay:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:50:26', 12);
INSERT INTO `sys_oper_log` VALUES (85, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '总公司', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"homestay/overview/index\",\"createTime\":\"2026-02-25 14:24:48\",\"icon\":\"dashboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"运营看板\",\"menuType\":\"C\",\"orderNum\":12,\"params\":{},\"parentId\":2000,\"path\":\"overview\",\"perms\":\"homestay:overview:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:50:30', 13);
INSERT INTO `sys_oper_log` VALUES (86, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '总公司', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"homestay/ai/index\",\"createTime\":\"2026-05-18 21:23:33\",\"icon\":\"people\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2018,\"menuName\":\"AI助手\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":2000,\"path\":\"ai\",\"perms\":\"homestay:ai:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:51:15', 14);
INSERT INTO `sys_oper_log` VALUES (87, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '总公司', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"homestay/audit/index\",\"createTime\":\"2026-03-07 17:50:49\",\"icon\":\"tab\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2013,\"menuName\":\"房源审核\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"homestayAudit\",\"perms\":\"homestay:audit:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 16:51:36', 14);
INSERT INTO `sys_oper_log` VALUES (88, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, '15171324010', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/05/19/4a09b7f5f0d547f59b921667ad1a8c2e.png\",\"code\":200}', 0, NULL, '2026-05-19 17:34:54', 14);
INSERT INTO `sys_oper_log` VALUES (89, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"23133@qq.com\",\"nickName\":\"已核实\",\"params\":{},\"phonenumber\":\"18923809999\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 17:34:54', 20);
INSERT INTO `sys_oper_log` VALUES (90, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.checkin()', 'POST', 1, '15171324010', NULL, '/api/order/checkin', '127.0.0.1', '内网IP', '{\"orderId\":972092,\"reason\":\"checkin-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 17:40:14', 19);
INSERT INTO `sys_oper_log` VALUES (91, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.checkout()', 'POST', 1, '15171324010', NULL, '/api/order/checkout', '127.0.0.1', '内网IP', '{\"orderId\":972092,\"reason\":\"checkout-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 17:40:21', 16);
INSERT INTO `sys_oper_log` VALUES (92, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324011', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"湖北工业大学\",\"basePrice\":199,\"bedroomCount\":1,\"city\":\"武汉市\",\"description\":\"范德萨\",\"district\":\"洪山区\",\"facilities\":[],\"id\":971038,\"images\":[],\"latitude\":30.55,\"longitude\":114.35,\"maxGuests\":2,\"province\":\"湖北省\",\"title\":\"范德萨\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 17:45:42', 24);
INSERT INTO `sys_oper_log` VALUES (93, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324011', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,\",\"basePrice\":199,\"bedInfo\":\"\",\"bedroomCount\":1,\"city\":\"长治市\",\"cleaningFee\":23,\"deposit\":12,\"description\":\"23【新增-校友邦-测试】222通知公告-新增\",\"district\":\"屯留区\",\"maxGuests\":2,\"province\":\"山西省\",\"roomType\":\"独立单间\",\"title\":\"【新增-校友邦-测试】222通知公告-新增\",\"weekendPrice\":231} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971039}', 0, NULL, '2026-05-19 17:46:17', 127);
INSERT INTO `sys_oper_log` VALUES (94, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '总公司', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/config/index\",\"createTime\":\"2024-07-18 08:50:06\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":106,\"menuName\":\"参数设置\",\"menuType\":\"C\",\"orderNum\":7,\"params\":{},\"parentId\":1,\"path\":\"config\",\"perms\":\"system:config:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 18:00:50', 17);
INSERT INTO `sys_oper_log` VALUES (95, '参数管理', 9, 'com.ruoyi.web.controller.system.SysConfigController.refreshCache()', 'DELETE', 1, 'admin', '总公司', '/system/config/refreshCache', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 18:01:46', 7);
INSERT INTO `sys_oper_log` VALUES (96, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '总公司', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/config/index\",\"createTime\":\"2024-07-18 08:50:06\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":106,\"menuName\":\"参数设置\",\"menuType\":\"C\",\"orderNum\":7,\"params\":{},\"parentId\":1,\"path\":\"config\",\"perms\":\"system:config:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 18:02:48', 12);
INSERT INTO `sys_oper_log` VALUES (97, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324011', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,\",\"basePrice\":199,\"bedroomCount\":1,\"city\":\"长治市\",\"description\":\"23【新增-校友邦-测试】222通知公告-新增\",\"district\":\"屯留区\",\"facilities\":[],\"id\":971039,\"images\":[],\"maxGuests\":2,\"province\":\"山西省\",\"title\":\"【新增-校友邦-测试】222通知公告-新增\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 18:59:39', 41);
INSERT INTO `sys_oper_log` VALUES (98, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '总公司', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"homestay/homestay/index\",\"createTime\":\"2026-02-25 14:24:48\",\"icon\":\"home-filled\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2004,\"menuName\":\"房源管理\",\"menuType\":\"C\",\"orderNum\":13,\"params\":{},\"parentId\":2000,\"path\":\"homestayList\",\"perms\":\"homestay:homestay:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 19:00:32', 20);
INSERT INTO `sys_oper_log` VALUES (99, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, 'admin', '总公司', '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"雁栖湖镇北台上村\",\"basePrice\":458,\"bedInfo\":\"\",\"bedroomCount\":3,\"city\":\"北京\",\"description\":\"坐落于怀柔山区，远离城市喧嚣。山景房，空气清新，适合度假休闲。\",\"district\":\"怀柔区\",\"id\":2,\"latitude\":40.3696,\"longitude\":116.6914,\"maxGuests\":6,\"province\":\"北京市\",\"roomType\":\"独立房间\",\"title\":\"北京怀柔山景民宿\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 19:01:38', 17);
INSERT INTO `sys_oper_log` VALUES (100, '参数管理', 1, 'com.ruoyi.web.controller.system.SysConfigController.add()', 'POST', 1, 'admin', '总公司', '/system/config', '127.0.0.1', '内网IP', '{\"configKey\":\"ai.apiKey\",\"configName\":\"AI API Key\",\"configType\":\"N\",\"configValue\":\"sk-d531fde714c54c3fabf74d0684e9aff1\",\"params\":{},\"remark\":\"AI助手API密钥\"} ', '{\"msg\":\"新增参数\'AI API Key\'失败，参数键名已存在\",\"code\":500}', 0, NULL, '2026-05-19 19:12:05', 51);
INSERT INTO `sys_oper_log` VALUES (101, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324011', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"湖北武汉洪山区，湖北工业大学工程技术学院\",\"basePrice\":199,\"bedInfo\":\"\",\"bedroomCount\":1,\"city\":\"长治市\",\"cleaningFee\":60,\"deposit\":30,\"description\":\"上传失败，请重试\",\"district\":\"屯留区\",\"maxGuests\":2,\"province\":\"山西省\",\"roomType\":\"整套\",\"title\":\"湖北工业大学西区【1】栋\",\"weekendPrice\":299} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971040}', 0, NULL, '2026-05-19 23:00:35', 132);
INSERT INTO `sys_oper_log` VALUES (102, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324011', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"湖北武汉洪山区，湖北工业大学工程技术学院\",\"basePrice\":199,\"bedInfo\":\"\",\"bedroomCount\":1,\"city\":\"市辖区\",\"cleaningFee\":60,\"deposit\":30,\"description\":\"上传失败，请重试上传失败，请重试\",\"district\":\"河西区\",\"maxGuests\":2,\"province\":\"天津市\",\"roomType\":\"整套\",\"title\":\"湖北工业大学西区【2】栋\",\"weekendPrice\":299} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971041}', 0, NULL, '2026-05-19 23:01:19', 103);
INSERT INTO `sys_oper_log` VALUES (103, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, '15171324010', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"http://js.ccnccn.cn/2026/05/19282425d8-e7be-4e0b-b465-376bd5f4dc0d.png\",\"code\":200}', 0, NULL, '2026-05-19 23:20:54', 786);
INSERT INTO `sys_oper_log` VALUES (104, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"312@qq.com\",\"nickName\":\"发生\",\"params\":{},\"phonenumber\":\"15171324010\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 23:20:54', 19);
INSERT INTO `sys_oper_log` VALUES (105, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"312@qq.com\",\"nickName\":\"发生\",\"params\":{},\"phonenumber\":\"15171324010\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 23:20:55', 16);
INSERT INTO `sys_oper_log` VALUES (106, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, '15171324010', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"http://js.ccnccn.cn/2026/05/1928bc3d87-9f30-4cc7-be6a-a63038a28298.png\",\"code\":200}', 0, NULL, '2026-05-19 23:22:12', 5443);
INSERT INTO `sys_oper_log` VALUES (107, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"312@qq.com\",\"nickName\":\"发生\",\"params\":{},\"phonenumber\":\"15171324010\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 23:22:12', 12);
INSERT INTO `sys_oper_log` VALUES (108, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, '15171324010', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"http://js.ccnccn.cn/2026/05/1907179249-3b57-4791-9349-0407c6a923e7.png\",\"code\":200}', 0, NULL, '2026-05-19 23:22:12', 4314);
INSERT INTO `sys_oper_log` VALUES (109, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"312@qq.com\",\"nickName\":\"发生\",\"params\":{},\"phonenumber\":\"15171324010\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 23:22:12', 14);
INSERT INTO `sys_oper_log` VALUES (110, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, '15171324010', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"http://js.ccnccn.cn/2026/05/19250ccfd8-c0a1-4b7e-a8eb-c5a2570c00e1.png\",\"code\":200}', 0, NULL, '2026-05-19 23:22:12', 2839);
INSERT INTO `sys_oper_log` VALUES (111, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"312@qq.com\",\"nickName\":\"发生\",\"params\":{},\"phonenumber\":\"15171324010\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 23:22:12', 14);
INSERT INTO `sys_oper_log` VALUES (112, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updatePwd()', 'PUT', 1, '15171324010', NULL, '/system/user/profile/updatePwd', '127.0.0.1', '内网IP', '{} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-19 23:23:31', 227);
INSERT INTO `sys_oper_log` VALUES (113, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324011', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"No. 28 Nanli Road, Hongshan District, Wuhan, Hubei Province,\",\"basePrice\":199,\"bedInfo\":\"\",\"bedroomCount\":2,\"city\":\"秦皇岛市\",\"description\":\"\",\"district\":\"北戴河区\",\"maxGuests\":2,\"province\":\"河北省\",\"roomType\":\"整套\",\"title\":\"通知公告-新增\",\"weekendPrice\":200} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971042}', 0, NULL, '2026-05-20 00:39:51', 113);
INSERT INTO `sys_oper_log` VALUES (114, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324011', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"123\",\"basePrice\":199,\"bedInfo\":\"\",\"bedroomCount\":1,\"city\":\"邯郸市\",\"cleaningFee\":321,\"deposit\":321,\"description\":\"fsaaf\",\"district\":\"复兴区\",\"maxGuests\":2,\"province\":\"河北省\",\"roomType\":\"整套\",\"title\":\"办事指南-证件管理-测试001\",\"weekendPrice\":213} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971043}', 0, NULL, '2026-05-20 00:40:59', 160);
INSERT INTO `sys_oper_log` VALUES (115, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971039/delete', '127.0.0.1', '内网IP', '971039 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 00:43:02', 13);
INSERT INTO `sys_oper_log` VALUES (116, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971040/delete', '127.0.0.1', '内网IP', '971040 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 00:43:05', 13);
INSERT INTO `sys_oper_log` VALUES (117, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971040/delete', '127.0.0.1', '内网IP', '971040 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 00:43:10', 11);
INSERT INTO `sys_oper_log` VALUES (118, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971039/delete', '127.0.0.1', '内网IP', '971039 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 00:44:50', 13);
INSERT INTO `sys_oper_log` VALUES (119, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '总公司', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"ryo210856837@gmail.com\",\"nickName\":\"管理员\",\"params\":{},\"phonenumber\":\"16576545432\",\"sex\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 01:20:36', 35);
INSERT INTO `sys_oper_log` VALUES (120, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updatePwd()', 'PUT', 1, 'admin', '总公司', '/system/user/profile/updatePwd', '127.0.0.1', '内网IP', '{} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 01:22:26', 252);
INSERT INTO `sys_oper_log` VALUES (121, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.resetPwd()', 'PUT', 1, 'admin', '总公司', '/system/user/resetPwd', '127.0.0.1', '内网IP', '{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":2007} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 04:50:04', 89);
INSERT INTO `sys_oper_log` VALUES (122, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"231@qq.com\",\"nickName\":\"张美娟10\",\"params\":{},\"phonenumber\":\"15171324010\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 04:53:13', 18);
INSERT INTO `sys_oper_log` VALUES (123, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"231@qq.com\",\"nickName\":\"张美娟10\",\"params\":{},\"phonenumber\":\"15171324010\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 04:53:20', 16);
INSERT INTO `sys_oper_log` VALUES (124, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '17878786765', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"234244@qq.com\",\"nickName\":\"123113\",\"params\":{},\"phonenumber\":\"15876565432\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 04:54:08', 15);
INSERT INTO `sys_oper_log` VALUES (125, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"231@qq.com\",\"nickName\":\"张美娟10\",\"params\":{},\"phonenumber\":\"15171324010\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 04:56:10', 16);
INSERT INTO `sys_oper_log` VALUES (126, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.payMock()', 'POST', 1, '15171324010', NULL, '/api/order/pay/mock', '127.0.0.1', '内网IP', '{\"orderId\":972103} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 04:59:38', 21);
INSERT INTO `sys_oper_log` VALUES (127, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.checkin()', 'POST', 1, '15171324010', NULL, '/api/order/checkin', '127.0.0.1', '内网IP', '{\"orderId\":972104,\"reason\":\"checkin-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 05:03:06', 13);
INSERT INTO `sys_oper_log` VALUES (128, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324016', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"湖北工业大学\",\"basePrice\":199,\"bedInfo\":\"1.5m双人床×2\",\"bedroomCount\":1,\"city\":\"秦皇岛市\",\"cleaningFee\":40,\"coverImage\":\"http://js.ccnccn.cn/homestay/1779225967934_fyljht0mr.png\",\"deposit\":80,\"description\":\"https://10555013ubmt0.vicp.fun/landlord/homestay/createhttps://10555013ubmt0.vicp.fun/landlord/homestay/createhttps://10555013ubmt0.vicp.fun/landlord/homestay/create\",\"district\":\"北戴河区\",\"maxGuests\":2,\"province\":\"河北省\",\"roomType\":\"整套民宿\",\"title\":\"通知公告-新增\",\"weekendPrice\":259} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971044}', 0, NULL, '2026-05-20 05:26:11', 96);
INSERT INTO `sys_oper_log` VALUES (129, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971044,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 05:31:20', 14);
INSERT INTO `sys_oper_log` VALUES (130, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.offline()', 'POST', 1, '15171324016', NULL, '/api/homestay/971044/offline', '127.0.0.1', '内网IP', '971044 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 05:36:05', 15);
INSERT INTO `sys_oper_log` VALUES (131, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.publish()', 'POST', 1, '15171324016', NULL, '/api/homestay/971044/publish', '127.0.0.1', '内网IP', '971044 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 05:36:16', 14);
INSERT INTO `sys_oper_log` VALUES (132, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324016', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"湖北工业大学\",\"basePrice\":199,\"bedInfo\":\"1.5m双人床×2\",\"bedroomCount\":1,\"city\":\"秦皇岛市\",\"cleaningFee\":40,\"deposit\":80,\"description\":\"https://10555013ubmt0.vicp.fun/landlord/homestay/createhttps://10555013ubmt0.vicp.fun/landlord/homestay/createhttps://10555013ubmt0.vicp.fun/landlord/homestay/create\",\"district\":\"北戴河区\",\"facilities\":[],\"id\":971044,\"images\":[],\"maxGuests\":2,\"province\":\"河北省\",\"remark\":\"\",\"roomType\":\"整套民宿\",\"title\":\"湖北工业大学\",\"weekendPrice\":259} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 05:38:40', 21);
INSERT INTO `sys_oper_log` VALUES (133, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971044,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 05:41:21', 14);
INSERT INTO `sys_oper_log` VALUES (134, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.checkin()', 'POST', 1, '15171324016', NULL, '/api/order/checkin', '127.0.0.1', '内网IP', '{\"orderId\":972106,\"reason\":\"checkin-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 05:52:46', 16);
INSERT INTO `sys_oper_log` VALUES (135, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.checkout()', 'POST', 1, '15171324016', NULL, '/api/order/checkout', '127.0.0.1', '内网IP', '{\"orderId\":972106,\"reason\":\"checkout-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 06:27:08', 15);
INSERT INTO `sys_oper_log` VALUES (136, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324016', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"：温馨海景两居室\",\"basePrice\":200,\"bedInfo\":\"\",\"bedroomCount\":1,\"city\":\"大同市\",\"cleaningFee\":40,\"coverImage\":\"http://js.ccnccn.cn/homestay/1779231401019_rrotxq70d.png\",\"deposit\":80,\"description\":\"：温馨海景两居室：温馨海景两居室\",\"district\":\"新荣区\",\"maxGuests\":2,\"province\":\"山西省\",\"roomType\":\"整套公寓\",\"title\":\"：温馨海景两居室\",\"weekendPrice\":300} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971045}', 0, NULL, '2026-05-20 06:56:43', 114);
INSERT INTO `sys_oper_log` VALUES (137, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971045,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 06:57:47', 13);
INSERT INTO `sys_oper_log` VALUES (138, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.payMock()', 'POST', 1, '15171324016', NULL, '/api/order/pay/mock', '127.0.0.1', '内网IP', '{\"orderId\":972107} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 07:14:24', 13);
INSERT INTO `sys_oper_log` VALUES (139, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.payMock()', 'POST', 1, '15171324016', NULL, '/api/order/pay/mock', '127.0.0.1', '内网IP', '{\"orderId\":972107} ', NULL, 1, 'order is not waiting for pay', '2026-05-20 07:14:26', 11);
INSERT INTO `sys_oper_log` VALUES (140, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.confirm()', 'POST', 1, '15171324016', NULL, '/api/order/confirm', '127.0.0.1', '内网IP', '{\"orderId\":972107} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 07:14:39', 15);
INSERT INTO `sys_oper_log` VALUES (141, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.checkin()', 'POST', 1, '15171324016', NULL, '/api/order/checkin', '127.0.0.1', '内网IP', '{\"orderId\":972107,\"reason\":\"checkin-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 07:14:51', 15);
INSERT INTO `sys_oper_log` VALUES (142, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.confirm()', 'POST', 1, 'admin', '总公司', '/api/order/confirm', '127.0.0.1', '内网IP', '{\"orderId\":972103} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 07:15:17', 16);
INSERT INTO `sys_oper_log` VALUES (143, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.confirm()', 'POST', 1, 'admin', '总公司', '/api/order/confirm', '127.0.0.1', '内网IP', '{\"orderId\":972100} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 07:15:28', 20);
INSERT INTO `sys_oper_log` VALUES (144, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.payMock()', 'POST', 1, '15171324016', NULL, '/api/order/pay/mock', '127.0.0.1', '内网IP', '{\"orderId\":972108} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 07:17:08', 15);
INSERT INTO `sys_oper_log` VALUES (145, '参数管理', 1, 'com.ruoyi.web.controller.system.SysConfigController.add()', 'POST', 1, 'admin', '总公司', '/system/config', '127.0.0.1', '内网IP', '{\"configKey\":\"ai.apiKey\",\"configName\":\"AI API Key\",\"configType\":\"N\",\"configValue\":\"sk-17fde29477c84150a70fb0244dd2ffc7\",\"params\":{},\"remark\":\"AI助手API密钥\"} ', '{\"msg\":\"新增参数\'AI API Key\'失败，参数键名已存在\",\"code\":500}', 0, NULL, '2026-05-20 07:32:39', 14);
INSERT INTO `sys_oper_log` VALUES (146, '参数管理', 1, 'com.ruoyi.web.controller.system.SysConfigController.add()', 'POST', 1, 'admin', '总公司', '/system/config', '127.0.0.1', '内网IP', '{\"configKey\":\"ai.apiKey\",\"configName\":\"AI API Key\",\"configType\":\"N\",\"configValue\":\"sk-d531fde714c54c3fabf74d0684e9aff1\",\"params\":{},\"remark\":\"AI助手API密钥\"} ', '{\"msg\":\"新增参数\'AI API Key\'失败，参数键名已存在\",\"code\":500}', 0, NULL, '2026-05-20 07:35:18', 6);
INSERT INTO `sys_oper_log` VALUES (147, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324016', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"1\",\"thingId\":\"1\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 09:22:43', 196);
INSERT INTO `sys_oper_log` VALUES (148, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324016', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"971044\",\"thingId\":\"971044\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 09:23:03', 16);
INSERT INTO `sys_oper_log` VALUES (149, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324016', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 09:25:02', 27);
INSERT INTO `sys_oper_log` VALUES (150, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324016', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"ryo210856837@gmail.com\",\"nickName\":\"2`12\",\"params\":{},\"phonenumber\":\"12343212312\"} ', '{\"msg\":\"修改用户\'15171324016\'失败，邮箱账号已存在\",\"code\":500}', 0, NULL, '2026-05-20 09:25:43', 7);
INSERT INTO `sys_oper_log` VALUES (151, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '17878786765', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"234244@qq.com\",\"nickName\":\"123113\",\"params\":{},\"phonenumber\":\"15876565432\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 09:26:50', 15);
INSERT INTO `sys_oper_log` VALUES (152, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '17878786765', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"971045\",\"thingId\":\"971045\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 09:27:05', 13);
INSERT INTO `sys_oper_log` VALUES (153, '清洁任务', 2, 'com.ruoyi.biz.controller.homestay.HsCleaningTaskController.markStatus()', 'POST', 1, '15171324016', NULL, '/api/cleaning/mark', '127.0.0.1', '内网IP', '{\"taskId\":\"1\",\"status\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 09:29:59', 22);
INSERT INTO `sys_oper_log` VALUES (154, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '17878786765', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"5\",\"thingId\":\"5\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 09:35:51', 14);
INSERT INTO `sys_oper_log` VALUES (155, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324016', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"6\",\"thingId\":\"6\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 09:37:08', 14);
INSERT INTO `sys_oper_log` VALUES (156, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324016', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"23\",\"thingId\":\"23\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 09:37:21', 12);
INSERT INTO `sys_oper_log` VALUES (157, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324016', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"ryo210856837@gmail.com\",\"nickName\":\"2`12\",\"params\":{},\"phonenumber\":\"12343212312\"} ', '{\"msg\":\"修改用户\'15171324016\'失败，邮箱账号已存在\",\"code\":500}', 0, NULL, '2026-05-20 09:37:35', 7);
INSERT INTO `sys_oper_log` VALUES (158, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324016', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"\",\"nickName\":\"2`12\",\"params\":{},\"phonenumber\":\"12343212312\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 09:37:42', 11);
INSERT INTO `sys_oper_log` VALUES (159, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324016', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"4\",\"thingId\":\"4\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 09:46:55', 15);
INSERT INTO `sys_oper_log` VALUES (160, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"4\",\"thingId\":\"4\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 09:48:10', 14);
INSERT INTO `sys_oper_log` VALUES (161, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.payMock()', 'POST', 1, '15171324010', NULL, '/api/order/pay/mock', '127.0.0.1', '内网IP', '{\"orderId\":972110} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 09:48:57', 19);
INSERT INTO `sys_oper_log` VALUES (162, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"971044\",\"thingId\":\"971044\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 09:49:59', 14);
INSERT INTO `sys_oper_log` VALUES (163, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.payMock()', 'POST', 1, '15171324010', NULL, '/api/order/pay/mock', '127.0.0.1', '内网IP', '{\"orderId\":972111} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 09:50:42', 14);
INSERT INTO `sys_oper_log` VALUES (164, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.confirm()', 'POST', 1, '15171324016', NULL, '/api/order/confirm', '127.0.0.1', '内网IP', '{\"orderId\":972111} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 09:51:19', 15);
INSERT INTO `sys_oper_log` VALUES (165, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.payMock()', 'POST', 1, '15171324016', NULL, '/api/order/pay/mock', '127.0.0.1', '内网IP', '{\"orderId\":972112} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 09:52:55', 14);
INSERT INTO `sys_oper_log` VALUES (166, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.confirm()', 'POST', 1, '15171324016', NULL, '/api/order/confirm', '127.0.0.1', '内网IP', '{\"orderId\":972112} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 09:53:10', 15);
INSERT INTO `sys_oper_log` VALUES (167, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.checkin()', 'POST', 1, '15171324016', NULL, '/api/order/checkin', '127.0.0.1', '内网IP', '{\"orderId\":972112,\"reason\":\"checkin-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 09:53:19', 15);
INSERT INTO `sys_oper_log` VALUES (168, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.checkout()', 'POST', 1, '15171324016', NULL, '/api/order/checkout', '127.0.0.1', '内网IP', '{\"orderId\":972112,\"reason\":\"checkout-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 09:53:30', 26);
INSERT INTO `sys_oper_log` VALUES (169, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324016', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"重庆市重庆市长寿区重庆大学fas\",\"basePrice\":199,\"bedInfo\":\"\",\"bedroomCount\":1,\"city\":\"长治市\",\"cleaningFee\":40,\"coverImage\":\"http://js.ccnccn.cn/homestay/1779242573640_j5au41g2i.jpg\",\"deposit\":80,\"description\":\"【01】房源-图书馆-开放时间调整\",\"district\":\"潞城区\",\"latitude\":30.5927,\"longitude\":114.3052,\"maxGuests\":2,\"province\":\"山西省\",\"roomType\":\"整套公寓\",\"title\":\"【01】房源-图书馆-开放时间调整\",\"weekendPrice\":259} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971046}', 0, NULL, '2026-05-20 10:02:55', 287);
INSERT INTO `sys_oper_log` VALUES (170, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971046,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 10:03:13', 21);
INSERT INTO `sys_oper_log` VALUES (171, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324016', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"971046\",\"thingId\":\"971046\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 10:04:25', 19);
INSERT INTO `sys_oper_log` VALUES (172, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324016', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"测试地址\",\"basePrice\":199,\"bedInfo\":\"1.0m单人床×2\",\"bedroomCount\":1,\"city\":\"市辖区\",\"cleaningFee\":40,\"coverImage\":\"http://js.ccnccn.cn/homestay/1779242776337_6w3ej2i2t.png\",\"deposit\":80,\"description\":\"测试地址\",\"district\":\"河东区\",\"latitude\":30.587698,\"longitude\":114.362781,\"maxGuests\":2,\"province\":\"天津市\",\"roomType\":\"整套公寓\",\"title\":\"测试地址\",\"weekendPrice\":259} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971047}', 0, NULL, '2026-05-20 10:07:10', 87);
INSERT INTO `sys_oper_log` VALUES (173, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '总公司', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"homestay/chat/index\",\"createTime\":\"2026-05-20 08:52:02\",\"icon\":\"message\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2019,\"menuName\":\"租客沟通\",\"menuType\":\"C\",\"orderNum\":10,\"params\":{},\"parentId\":2000,\"path\":\"chat\",\"perms\":\"homestay:chat:list\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 10:16:29', 20);
INSERT INTO `sys_oper_log` VALUES (174, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"231@qq.com\",\"nickName\":\"张美娟10\",\"params\":{},\"phonenumber\":\"15171324010\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 10:19:37', 16);
INSERT INTO `sys_oper_log` VALUES (175, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"231@qq.com\",\"nickName\":\"张美娟10\",\"params\":{},\"phonenumber\":\"15171324010\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 11:09:35', 48);
INSERT INTO `sys_oper_log` VALUES (176, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"231@qq.com\",\"nickName\":\"张美娟10\",\"params\":{},\"phonenumber\":\"15171324010\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 11:10:10', 19);
INSERT INTO `sys_oper_log` VALUES (177, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324016', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"湖北工业大学\",\"basePrice\":199,\"bedInfo\":\"1.5m双人床×2\",\"bedroomCount\":1,\"city\":\"武汉市\",\"cleaningFee\":40,\"coverImage\":\"https://js.ccnccn.cn/homestay/1779246950297_jxrgd9jh0.png\",\"deposit\":80,\"description\":\"测试【房子01】推送通知\",\"district\":\"洪山区\",\"latitude\":30.47747,\"longitude\":114.307955,\"maxGuests\":2,\"province\":\"湖北省\",\"roomType\":\"整套公寓\",\"title\":\"测试【房子01】推送通知\",\"weekendPrice\":259} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971048}', 0, NULL, '2026-05-20 11:16:24', 132);
INSERT INTO `sys_oper_log` VALUES (178, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324016', NULL, '/api/homestay/971048/delete', '127.0.0.1', '内网IP', '971048 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:01:42', 32);
INSERT INTO `sys_oper_log` VALUES (179, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '总公司', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"\",\"createTime\":\"2026-05-20 05:19:11\",\"delFlag\":\"0\",\"email\":\"ryo210856837@gmail.com\",\"loginDate\":\"2026-05-20 11:18:55\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"左鑫\",\"params\":{},\"phonenumber\":\"15978362563\",\"postIds\":[],\"pwdUpdateDate\":\"2026-05-20 05:19:11\",\"roleIds\":[100],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":100,\"roleKey\":\"hs:landlord\",\"roleName\":\"Landlord\",\"roleSort\":200,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"tryCount\":1,\"userId\":2011,\"userName\":\"15171324016\"} ', '{\"msg\":\"修改用户\'15171324016\'失败，邮箱账号已存在\",\"code\":500}', 0, NULL, '2026-05-20 13:04:00', 14);
INSERT INTO `sys_oper_log` VALUES (180, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '总公司', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"\",\"createTime\":\"2026-05-20 05:19:11\",\"delFlag\":\"0\",\"email\":\"\",\"loginDate\":\"2026-05-20 11:18:55\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"左鑫\",\"params\":{},\"phonenumber\":\"15978362563\",\"postIds\":[],\"pwdUpdateDate\":\"2026-05-20 05:19:11\",\"roleIds\":[100],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":100,\"roleKey\":\"hs:landlord\",\"roleName\":\"Landlord\",\"roleSort\":200,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"tryCount\":1,\"updateBy\":\"admin\",\"userId\":2011,\"userName\":\"15171324016\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:04:05', 35);
INSERT INTO `sys_oper_log` VALUES (181, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971043/delete', '127.0.0.1', '内网IP', '971043 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:02', 12);
INSERT INTO `sys_oper_log` VALUES (182, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971043/delete', '127.0.0.1', '内网IP', '971043 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:04', 10);
INSERT INTO `sys_oper_log` VALUES (183, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971043/delete', '127.0.0.1', '内网IP', '971043 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:07', 12);
INSERT INTO `sys_oper_log` VALUES (184, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971043/delete', '127.0.0.1', '内网IP', '971043 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:08', 11);
INSERT INTO `sys_oper_log` VALUES (185, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971043/delete', '127.0.0.1', '内网IP', '971043 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:10', 14);
INSERT INTO `sys_oper_log` VALUES (186, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971043/delete', '127.0.0.1', '内网IP', '971043 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:12', 17);
INSERT INTO `sys_oper_log` VALUES (187, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971043/delete', '127.0.0.1', '内网IP', '971043 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:15', 11);
INSERT INTO `sys_oper_log` VALUES (188, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971043/delete', '127.0.0.1', '内网IP', '971043 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:21', 9);
INSERT INTO `sys_oper_log` VALUES (189, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971043/delete', '127.0.0.1', '内网IP', '971043 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:23', 11);
INSERT INTO `sys_oper_log` VALUES (190, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971043/delete', '127.0.0.1', '内网IP', '971043 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:24', 11);
INSERT INTO `sys_oper_log` VALUES (191, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971043/delete', '127.0.0.1', '内网IP', '971043 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:26', 11);
INSERT INTO `sys_oper_log` VALUES (192, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971043/delete', '127.0.0.1', '内网IP', '971043 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:29', 10);
INSERT INTO `sys_oper_log` VALUES (193, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971038/delete', '127.0.0.1', '内网IP', '971038 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:33', 10);
INSERT INTO `sys_oper_log` VALUES (194, '房源管理', 3, 'com.ruoyi.biz.controller.homestay.HsHomestayController.delete()', 'POST', 1, '15171324011', NULL, '/api/homestay/971038/delete', '127.0.0.1', '内网IP', '971038 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:05:41', 11);
INSERT INTO `sys_oper_log` VALUES (195, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '总公司', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"\",\"createTime\":\"2026-05-20 05:19:11\",\"delFlag\":\"0\",\"email\":\"\",\"loginDate\":\"2026-05-20 11:18:55\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"201\",\"params\":{},\"phonenumber\":\"15978362563\",\"postIds\":[],\"pwdUpdateDate\":\"2026-05-20 05:19:11\",\"roleIds\":[100],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":100,\"roleKey\":\"hs:landlord\",\"roleName\":\"Landlord\",\"roleSort\":200,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"tryCount\":1,\"updateBy\":\"admin\",\"userId\":2011,\"userName\":\"15171324016\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:06:27', 26);
INSERT INTO `sys_oper_log` VALUES (196, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '总公司', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"\",\"createTime\":\"2026-05-20 13:06:02\",\"delFlag\":\"0\",\"email\":\"\",\"loginDate\":\"2026-05-20 13:06:11\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"左鑫\",\"params\":{},\"phonenumber\":\"15171324021\",\"postIds\":[],\"pwdUpdateDate\":\"2026-05-20 13:06:02\",\"roleIds\":[100],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":100,\"roleKey\":\"hs:landlord\",\"roleName\":\"Landlord\",\"roleSort\":200,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"tryCount\":0,\"updateBy\":\"admin\",\"userId\":2012,\"userName\":\"15171324021\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:06:45', 25);
INSERT INTO `sys_oper_log` VALUES (197, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '15171324010', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"231@qq.com\",\"nickName\":\"张美娟\",\"params\":{},\"phonenumber\":\"15171324010\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:07:50', 16);
INSERT INTO `sys_oper_log` VALUES (198, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"武广商圈\",\"basePrice\":488,\"bedroomCount\":1,\"city\":\"武汉市\",\"coverImage\":\"https://js.ccnccn.cn/homestay/1779254813707_y6vce9kfi.webp\",\"deposit\":800,\"description\":\"适合商务出差，办公设施齐全\",\"district\":\"江汉区\",\"facilities\":[],\"id\":971060,\"images\":[],\"latitude\":30.58,\"longitude\":114.28,\"maxGuests\":2,\"province\":\"湖北省\",\"roomType\":\"套房\",\"title\":\"商务行政套房\",\"weekendPrice\":588} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:26:56', 23);
INSERT INTO `sys_oper_log` VALUES (199, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"金银潭万达旁\",\"basePrice\":368,\"bedroomCount\":2,\"city\":\"武汉市\",\"coverImage\":\"https://js.ccnccn.cn/homestay/1779254833140_lnarr8bn0.webp\",\"deposit\":600,\"description\":\"儿童主题装修，玩具齐全\",\"district\":\"东西湖区\",\"facilities\":[],\"id\":971059,\"images\":[],\"latitude\":30.62,\"longitude\":114.25,\"maxGuests\":4,\"province\":\"湖北省\",\"roomType\":\"两室一厅\",\"title\":\"亲子主题房\",\"weekendPrice\":468} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:27:15', 17);
INSERT INTO `sys_oper_log` VALUES (200, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"东湖绿道旁湖景花园1栋\",\"basePrice\":288,\"bedroomCount\":1,\"city\":\"武汉市\",\"deposit\":500,\"description\":\"位于美丽的湖边，环境优美，空气清新，适合家庭度假\",\"district\":\"洪山区\",\"facilities\":[],\"id\":971049,\"images\":[],\"latitude\":30.55,\"longitude\":114.35,\"maxGuests\":2,\"province\":\"湖北省\",\"roomType\":\"一室一厅\",\"title\":\"温馨湖景小屋\",\"weekendPrice\":358} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:27:24', 22);
INSERT INTO `sys_oper_log` VALUES (201, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"东湖绿道旁湖景花园1栋\",\"basePrice\":288,\"bedroomCount\":1,\"city\":\"武汉市\",\"coverImage\":\"https://js.ccnccn.cn/homestay/1779254855346_z1qb16f6g.jfif\",\"deposit\":500,\"description\":\"位于美丽的湖边，环境优美，空气清新，适合家庭度假\",\"district\":\"洪山区\",\"facilities\":[],\"id\":971049,\"images\":[],\"latitude\":30.546643,\"longitude\":114.328379,\"maxGuests\":2,\"province\":\"湖北省\",\"roomType\":\"一室一厅\",\"title\":\"温馨湖景小屋\",\"weekendPrice\":358} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:27:38', 20);
INSERT INTO `sys_oper_log` VALUES (202, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"沿江大道188号\",\"basePrice\":458,\"bedroomCount\":2,\"city\":\"武汉市\",\"coverImage\":\"https://js.ccnccn.cn/homestay/1779254870917_kjz2t6kou.jfif\",\"deposit\":800,\"description\":\"高层江景房，视野开阔，装修豪华，配套齐全\",\"district\":\"江岸区\",\"facilities\":[],\"id\":971050,\"images\":[],\"latitude\":30.58,\"longitude\":114.3,\"maxGuests\":4,\"province\":\"湖北省\",\"roomType\":\"两室一厅\",\"title\":\"江景豪华公寓\",\"weekendPrice\":588} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:27:54', 22);
INSERT INTO `sys_oper_log` VALUES (203, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"江汉路步行街后巷\",\"basePrice\":688,\"bedroomCount\":3,\"city\":\"武汉市\",\"coverImage\":\"https://js.ccnccn.cn/homestay/1779254889568_gjh1exw8q.webp\",\"deposit\":1000,\"description\":\"老洋房改造，文艺气息浓厚，适合拍照打卡\",\"district\":\"江汉区\",\"facilities\":[],\"id\":971051,\"images\":[],\"latitude\":30.58,\"longitude\":114.28,\"maxGuests\":6,\"province\":\"湖北省\",\"roomType\":\"独栋\",\"title\":\"复古文艺小院\",\"weekendPrice\":888} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:28:12', 20);
INSERT INTO `sys_oper_log` VALUES (204, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"光谷步行街LOFT公寓\",\"basePrice\":328,\"bedroomCount\":2,\"city\":\"武汉市\",\"coverImage\":\"https://js.ccnccn.cn/homestay/1779254913062_6njwuak9h.webp\",\"deposit\":600,\"description\":\"工业风设计，挑高空间，年轻人最爱\",\"district\":\"武昌区\",\"facilities\":[],\"id\":971052,\"images\":[],\"latitude\":30.5,\"longitude\":114.42,\"maxGuests\":4,\"province\":\"湖北省\",\"roomType\":\"LOFT\",\"title\":\"简约现代LOFT\",\"weekendPrice\":428} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:28:35', 20);
INSERT INTO `sys_oper_log` VALUES (205, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"落雁岛木屋区\",\"basePrice\":398,\"bedroomCount\":2,\"city\":\"武汉市\",\"coverImage\":\"https://js.ccnccn.cn/homestay/1779254928666_ior4mk36n.webp\",\"deposit\":700,\"description\":\"原木风格，亲近自然，静谧舒适\",\"district\":\"东湖高新区\",\"facilities\":[],\"id\":971054,\"images\":[],\"latitude\":30.52,\"longitude\":114.38,\"maxGuests\":4,\"province\":\"湖北省\",\"roomType\":\"木屋\",\"title\":\"湖畔木屋\",\"weekendPrice\":498} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:28:50', 19);
INSERT INTO `sys_oper_log` VALUES (206, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"道观河风景区\",\"basePrice\":1288,\"bedroomCount\":5,\"city\":\"武汉市\",\"coverImage\":\"https://js.ccnccn.cn/homestay/1779254939032_q9tykrajg.webp\",\"deposit\":2000,\"description\":\"依山而建，视野开阔，空气清新\",\"district\":\"新洲区\",\"facilities\":[],\"id\":971056,\"images\":[],\"latitude\":30.85,\"longitude\":114.68,\"maxGuests\":10,\"province\":\"湖北省\",\"roomType\":\"别墅\",\"title\":\"山景别墅\",\"weekendPrice\":1588} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:29:00', 18);
INSERT INTO `sys_oper_log` VALUES (207, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"昙华林文化街\",\"basePrice\":298,\"bedroomCount\":1,\"city\":\"武汉市\",\"coverImage\":\"https://js.ccnccn.cn/homestay/1779254955576_fak7w5bt3.webp\",\"deposit\":500,\"description\":\"书香气息，适合静心阅读\",\"district\":\"武昌区\",\"facilities\":[],\"id\":971057,\"images\":[],\"latitude\":30.55,\"longitude\":114.3,\"maxGuests\":2,\"province\":\"湖北省\",\"roomType\":\"一室一厅\",\"title\":\"文艺书店民宿\",\"weekendPrice\":378} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:29:17', 20);
INSERT INTO `sys_oper_log` VALUES (208, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"墨水湖畔花园小区\",\"basePrice\":888,\"bedroomCount\":4,\"city\":\"武汉市\",\"coverImage\":\"https://js.ccnccn.cn/homestay/1779254975721_0w68t6ydi.webp\",\"deposit\":1500,\"description\":\"带私家花园，适合烧烤聚会，亲子活动\",\"district\":\"汉阳区\",\"facilities\":[],\"id\":971053,\"images\":[],\"latitude\":30.55,\"longitude\":114.22,\"maxGuests\":8,\"province\":\"湖北省\",\"roomType\":\"三室两厅\",\"title\":\"花园洋房\",\"weekendPrice\":1088} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:29:38', 18);
INSERT INTO `sys_oper_log` VALUES (209, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"街道口地铁站旁\",\"basePrice\":258,\"bedroomCount\":1,\"city\":\"武汉市\",\"coverImage\":\"https://js.ccnccn.cn/homestay/1779254993260_vb4offr0j.webp\",\"deposit\":400,\"description\":\"交通便利，地铁直达，购物方便\",\"district\":\"洪山区\",\"facilities\":[],\"id\":971055,\"images\":[],\"latitude\":30.52,\"longitude\":114.35,\"maxGuests\":2,\"province\":\"湖北省\",\"roomType\":\"一室一厅\",\"title\":\"城市中心公寓\",\"weekendPrice\":328} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:29:56', 17);
INSERT INTO `sys_oper_log` VALUES (210, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"黎黄陂路\",\"basePrice\":338,\"bedroomCount\":1,\"city\":\"武汉市\",\"coverImage\":\"https://js.ccnccn.cn/homestay/1779255009205_78nxyzom0.webp\",\"deposit\":600,\"description\":\"网红装修风格，拍照出片\",\"district\":\"江岸区\",\"facilities\":[],\"id\":971058,\"images\":[],\"latitude\":30.58,\"longitude\":114.28,\"maxGuests\":2,\"province\":\"湖北省\",\"roomType\":\"一室一厅\",\"title\":\"网红ins风民宿\",\"weekendPrice\":438} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:30:12', 19);
INSERT INTO `sys_oper_log` VALUES (211, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971049,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:32:40', 17);
INSERT INTO `sys_oper_log` VALUES (212, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971050,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:32:48', 15);
INSERT INTO `sys_oper_log` VALUES (213, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971051,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:32:49', 14);
INSERT INTO `sys_oper_log` VALUES (214, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971052,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:32:52', 14);
INSERT INTO `sys_oper_log` VALUES (215, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971053,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:32:55', 15);
INSERT INTO `sys_oper_log` VALUES (216, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971054,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:32:57', 14);
INSERT INTO `sys_oper_log` VALUES (217, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971055,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:32:59', 16);
INSERT INTO `sys_oper_log` VALUES (218, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971056,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:33:01', 14);
INSERT INTO `sys_oper_log` VALUES (219, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971057,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:33:04', 17);
INSERT INTO `sys_oper_log` VALUES (220, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"20\",\"thingId\":\"20\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 13:42:32', 36);
INSERT INTO `sys_oper_log` VALUES (221, '收藏管理', 3, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.unCollect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/unCollect', '127.0.0.1', '内网IP', '{\"id\":\"20\",\"thingId\":\"20\"}', '{\"msg\":\"取消收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 13:42:33', 12);
INSERT INTO `sys_oper_log` VALUES (222, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"971052\",\"thingId\":\"971052\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 13:46:03', 12);
INSERT INTO `sys_oper_log` VALUES (223, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"12\",\"thingId\":\"12\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 13:55:48', 15);
INSERT INTO `sys_oper_log` VALUES (224, '收藏管理', 3, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.unCollect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/unCollect', '127.0.0.1', '内网IP', '{\"id\":\"12\",\"thingId\":\"12\"}', '{\"msg\":\"取消收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 13:57:32', 10);
INSERT INTO `sys_oper_log` VALUES (225, '收藏管理', 3, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.unCollect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/unCollect', '127.0.0.1', '内网IP', '{\"id\":\"3\",\"thingId\":\"3\"}', '{\"msg\":\"取消收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 13:57:35', 9);
INSERT INTO `sys_oper_log` VALUES (226, '收藏管理', 3, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.unCollect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/unCollect', '127.0.0.1', '内网IP', '{\"id\":\"4\",\"thingId\":\"4\"}', '{\"msg\":\"取消收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 13:57:38', 13);
INSERT INTO `sys_oper_log` VALUES (227, '收藏管理', 3, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.unCollect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/unCollect', '127.0.0.1', '内网IP', '{\"id\":\"29\",\"thingId\":\"29\"}', '{\"msg\":\"取消收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 13:57:41', 10);
INSERT INTO `sys_oper_log` VALUES (228, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '总公司', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-02-25 14:24:22\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2003,2005,2006,2009,2010,2011,2012,2008,2001,2019,2002],\"params\":{},\"remark\":\"Homestay landlord role\",\"roleId\":100,\"roleKey\":\"hs:landlord\",\"roleName\":\"房东\",\"roleSort\":200,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:58:34', 49);
INSERT INTO `sys_oper_log` VALUES (229, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '总公司', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-02-25 14:24:22\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2003,2009,2008,2002],\"params\":{},\"remark\":\"Homestay tenant role\",\"roleId\":101,\"roleKey\":\"hs:tenant\",\"roleName\":\"租客\",\"roleSort\":201,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 13:58:41', 31);
INSERT INTO `sys_oper_log` VALUES (230, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"13\",\"thingId\":\"13\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 14:12:33', 19);
INSERT INTO `sys_oper_log` VALUES (231, '收藏管理', 3, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.unCollect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/unCollect', '127.0.0.1', '内网IP', '{\"id\":\"13\",\"thingId\":\"13\"}', '{\"msg\":\"取消收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 14:13:01', 9);
INSERT INTO `sys_oper_log` VALUES (232, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324021', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"黎黄陂路\",\"basePrice\":199,\"bedInfo\":\"1.8m大床×1\",\"bedroomCount\":1,\"city\":\"武汉市\",\"cleaningFee\":40,\"coverImage\":\"https://js.ccnccn.cn/homestay/1779257778947_4yf2vcmh6.webp\",\"deposit\":80,\"description\":\"\\n这是一间专为拍照打卡和放松身心设计的ins风小屋。整体采用奶油色系搭配藤编、棉麻材质，氛围温柔安静。\\n\\n房间亮点：\\n\\n配有日落氛围灯、大叶绿植、百叶窗，光影效果极佳；\\n\\n舒适双人床，搭配高支数纯棉床品，保证睡眠质量；\\n\\n提供高清投影仪，可窝在床上看电影；\\n\\n房间内设有全身镜、编织地毯、ins风装饰画，随手一拍都是大片；\\n\\n提供免费WiFi、空调、24小时热水、一次性洗漱用品。\\n\\n适合人群： 情侣出游、闺蜜旅行、喜欢拍照的年轻人。\\n\\n注意： 全屋禁烟，请勿携带宠物。\",\"district\":\"洪山区\",\"latitude\":30.479986,\"longitude\":114.307413,\"maxGuests\":2,\"province\":\"湖北省\",\"roomType\":\"整套公寓\",\"title\":\"网红ins风民宿\",\"weekendPrice\":259} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971085}', 0, NULL, '2026-05-20 14:16:22', 167);
INSERT INTO `sys_oper_log` VALUES (233, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971085,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 14:17:01', 23);
INSERT INTO `sys_oper_log` VALUES (234, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"971085\",\"thingId\":\"971085\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 14:18:00', 21);
INSERT INTO `sys_oper_log` VALUES (235, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.checkin()', 'POST', 1, '15171324010', NULL, '/api/order/checkin', '127.0.0.1', '内网IP', '{\"orderId\":972128,\"reason\":\"checkin-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 14:19:21', 22);
INSERT INTO `sys_oper_log` VALUES (236, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.checkout()', 'POST', 1, '15171324010', NULL, '/api/order/checkout', '127.0.0.1', '内网IP', '{\"orderId\":972128,\"reason\":\"checkout-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 14:23:41', 35);
INSERT INTO `sys_oper_log` VALUES (237, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '总公司', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"\",\"createTime\":\"2026-05-20 13:06:02\",\"delFlag\":\"0\",\"email\":\"\",\"loginDate\":\"2026-05-20 13:07:05\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"左鑫\",\"params\":{},\"phonenumber\":\"15171324021\",\"postIds\":[],\"pwdUpdateDate\":\"2026-05-20 13:06:02\",\"roleIds\":[100],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":100,\"roleKey\":\"hs:landlord\",\"roleName\":\"房东\",\"roleSort\":200,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"tryCount\":0,\"updateBy\":\"admin\",\"userId\":2012,\"userName\":\"15171324021\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 14:28:59', 38);
INSERT INTO `sys_oper_log` VALUES (238, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"971057\",\"thingId\":\"971057\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 14:46:15', 40);
INSERT INTO `sys_oper_log` VALUES (239, '房源管理', 1, 'com.ruoyi.biz.controller.homestay.HsHomestayController.create()', 'POST', 1, '15171324021', NULL, '/api/homestay/create', '127.0.0.1', '内网IP', '{\"address\":\"黎黄陂路\",\"basePrice\":199,\"bedInfo\":\"\",\"bedroomCount\":1,\"city\":\"无锡市\",\"cleaningFee\":40,\"coverImage\":\"https://js.ccnccn.cn/homestay/1779259863102_7il6ufcb5.webp\",\"deposit\":80,\"description\":\"这是一间专为拍照打卡和放松身心设计的ins风小屋。整体采用奶油色系搭配藤编、棉麻材质，氛围温柔安静。\\n\\n房间亮点：\\n\\n配有日落氛围灯、大叶绿植、百叶窗，光影效果极佳；\\n\\n舒适双人床，搭配高支数纯棉床品，保证睡眠质量；\\n\\n提供高清投影仪，可窝在床上看电影；\\n\\n房间内设有全身镜、编织地毯、ins风装饰画，随手一拍都是大片；\\n\\n提供免费WiFi、空调、24小时热水、一次性洗漱用品。\\n\\n适合人群： 情侣出游、闺蜜旅行、喜欢拍照的年轻人。\\n\\n注意： 全屋禁烟，请勿携带宠物。\\n\",\"district\":\"锡山区\",\"latitude\":30.480676,\"longitude\":114.31021,\"maxGuests\":2,\"province\":\"江苏省\",\"roomType\":\"整套公寓\",\"title\":\"网红ins风民宿\",\"weekendPrice\":259} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":971086}', 0, NULL, '2026-05-20 14:51:07', 74);
INSERT INTO `sys_oper_log` VALUES (240, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971086,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 14:51:20', 26);
INSERT INTO `sys_oper_log` VALUES (241, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.offline()', 'POST', 1, '15171324021', NULL, '/api/homestay/971086/offline', '127.0.0.1', '内网IP', '971086 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 14:52:45', 17);
INSERT INTO `sys_oper_log` VALUES (242, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.offline()', 'POST', 1, '15171324021', NULL, '/api/homestay/971085/offline', '127.0.0.1', '内网IP', '971085 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 14:52:50', 16);
INSERT INTO `sys_oper_log` VALUES (243, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.update()', 'POST', 1, '15171324021', NULL, '/api/homestay/update', '127.0.0.1', '内网IP', '{\"address\":\"湖北工业大学工程技术学院\",\"basePrice\":199,\"bedInfo\":\"\",\"bedroomCount\":1,\"city\":\"武汉市\",\"cleaningFee\":40,\"coverImage\":\"https://js.ccnccn.cn/homestay/1779259863102_7il6ufcb5.webp\",\"deposit\":80,\"description\":\"这是一间专为拍照打卡和放松身心设计的ins风小屋。整体采用奶油色系搭配藤编、棉麻材质，氛围温柔安静。\\n\\n房间亮点：\\n\\n配有日落氛围灯、大叶绿植、百叶窗，光影效果极佳；\\n\\n舒适双人床，搭配高支数纯棉床品，保证睡眠质量；\\n\\n提供高清投影仪，可窝在床上看电影；\\n\\n房间内设有全身镜、编织地毯、ins风装饰画，随手一拍都是大片；\\n\\n提供免费WiFi、空调、24小时热水、一次性洗漱用品。\\n\\n适合人群： 情侣出游、闺蜜旅行、喜欢拍照的年轻人。\\n\\n注意： 全屋禁烟，请勿携带宠物。\\n\",\"district\":\"洪山区\",\"facilities\":[],\"id\":971086,\"images\":[],\"latitude\":30.480011,\"longitude\":114.307418,\"maxGuests\":2,\"province\":\"湖北省\",\"remark\":\"\",\"roomType\":\"整套公寓\",\"title\":\"网红ins风民宿\",\"weekendPrice\":259} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 14:53:27', 36);
INSERT INTO `sys_oper_log` VALUES (244, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.audit()', 'POST', 1, 'admin', '总公司', '/api/homestay/audit', '127.0.0.1', '内网IP', '{\"auditStatus\":\"1\",\"id\":971086,\"publishStatus\":\"1\",\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 14:53:39', 19);
INSERT INTO `sys_oper_log` VALUES (245, '收藏管理', 1, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.collect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/collect', '127.0.0.1', '内网IP', '{\"id\":\"971086\",\"thingId\":\"971086\"}', '{\"msg\":\"收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 14:54:39', 14);
INSERT INTO `sys_oper_log` VALUES (246, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.payMock()', 'POST', 1, '15171324010', NULL, '/api/order/pay/mock', '127.0.0.1', '内网IP', '{\"orderId\":972130} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 14:58:30', 20);
INSERT INTO `sys_oper_log` VALUES (247, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.confirm()', 'POST', 1, '15171324021', NULL, '/api/order/confirm', '127.0.0.1', '内网IP', '{\"orderId\":972130} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 14:58:52', 20);
INSERT INTO `sys_oper_log` VALUES (248, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.checkin()', 'POST', 1, '15171324010', NULL, '/api/order/checkin', '127.0.0.1', '内网IP', '{\"orderId\":972130,\"reason\":\"checkin-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 14:59:13', 20);
INSERT INTO `sys_oper_log` VALUES (249, '订单管理', 2, 'com.ruoyi.biz.controller.homestay.HsOrderController.checkout()', 'POST', 1, '15171324010', NULL, '/api/order/checkout', '127.0.0.1', '内网IP', '{\"orderId\":972130,\"reason\":\"checkout-by-tenant\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 14:59:21', 41);
INSERT INTO `sys_oper_log` VALUES (250, '收藏管理', 3, 'com.ruoyi.biz.controller.homestay.HsFavoriteController.unCollect()', 'POST', 1, '15171324010', NULL, '/api/thingCollect/unCollect', '127.0.0.1', '内网IP', '{\"id\":\"971085\",\"thingId\":\"971085\"}', '{\"msg\":\"取消收藏成功\",\"code\":200}', 0, NULL, '2026-05-20 23:10:09', 26);
INSERT INTO `sys_oper_log` VALUES (251, '房源管理', 2, 'com.ruoyi.biz.controller.homestay.HsHomestayController.offline()', 'POST', 1, '15171324021', NULL, '/api/homestay/971086/offline', '127.0.0.1', '内网IP', '971086 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-05-20 23:13:34', 25);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(0) NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'admin', '系统管理员', 1, '0', 'admin', '2024-07-18 08:50:06', 'admin', '2024-07-18 08:59:44', '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(0) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2024-07-18 08:50:06', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '2', 'admin', '2024-07-18 08:50:06', '', NULL, '普通角色');
INSERT INTO `sys_role` VALUES (100, '房东', 'hs:landlord', 200, '1', 1, 1, '0', '0', 'admin', '2026-02-25 14:24:22', 'admin', '2026-05-20 13:58:34', 'Homestay landlord role');
INSERT INTO `sys_role` VALUES (101, '租客', 'hs:tenant', 201, '1', 1, 1, '0', '0', 'admin', '2026-02-25 14:24:22', 'admin', '2026-05-20 13:58:41', 'Homestay tenant role');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint(0) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(0) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(0) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(0) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE,
  INDEX `idx_role_menu_role`(`role_id`) USING BTREE,
  INDEX `idx_role_menu_menu`(`menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 2000);
INSERT INTO `sys_role_menu` VALUES (1, 2001);
INSERT INTO `sys_role_menu` VALUES (1, 2002);
INSERT INTO `sys_role_menu` VALUES (1, 2003);
INSERT INTO `sys_role_menu` VALUES (1, 2004);
INSERT INTO `sys_role_menu` VALUES (1, 2005);
INSERT INTO `sys_role_menu` VALUES (1, 2006);
INSERT INTO `sys_role_menu` VALUES (1, 2007);
INSERT INTO `sys_role_menu` VALUES (1, 2008);
INSERT INTO `sys_role_menu` VALUES (1, 2009);
INSERT INTO `sys_role_menu` VALUES (1, 2010);
INSERT INTO `sys_role_menu` VALUES (1, 2011);
INSERT INTO `sys_role_menu` VALUES (1, 2012);
INSERT INTO `sys_role_menu` VALUES (1, 2013);
INSERT INTO `sys_role_menu` VALUES (1, 2016);
INSERT INTO `sys_role_menu` VALUES (1, 2017);
INSERT INTO `sys_role_menu` VALUES (1, 2018);
INSERT INTO `sys_role_menu` VALUES (100, 2000);
INSERT INTO `sys_role_menu` VALUES (100, 2001);
INSERT INTO `sys_role_menu` VALUES (100, 2002);
INSERT INTO `sys_role_menu` VALUES (100, 2003);
INSERT INTO `sys_role_menu` VALUES (100, 2005);
INSERT INTO `sys_role_menu` VALUES (100, 2006);
INSERT INTO `sys_role_menu` VALUES (100, 2008);
INSERT INTO `sys_role_menu` VALUES (100, 2009);
INSERT INTO `sys_role_menu` VALUES (100, 2010);
INSERT INTO `sys_role_menu` VALUES (100, 2011);
INSERT INTO `sys_role_menu` VALUES (100, 2012);
INSERT INTO `sys_role_menu` VALUES (100, 2019);
INSERT INTO `sys_role_menu` VALUES (101, 2000);
INSERT INTO `sys_role_menu` VALUES (101, 2002);
INSERT INTO `sys_role_menu` VALUES (101, 2003);
INSERT INTO `sys_role_menu` VALUES (101, 2008);
INSERT INTO `sys_role_menu` VALUES (101, 2009);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `tenant_id` bigint(0) NULL DEFAULT NULL COMMENT '租户ID',
  `dept_id` bigint(0) NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime(0) NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `try_count` int(0) NULL DEFAULT NULL COMMENT '尝试登录次数',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `hs_real_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'real name (homestay)',
  `hs_id_card` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'id card encrypted',
  `hs_auth_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '0-unverified 1-pending 2-approved 3-rejected',
  PRIMARY KEY (`user_id`) USING BTREE,
  INDEX `idx_user_name`(`user_name`) USING BTREE,
  INDEX `idx_phonenumber`(`phonenumber`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_user_status`(`status`) USING BTREE,
  INDEX `idx_user_dept`(`dept_id`) USING BTREE,
  INDEX `idx_user_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2013 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, NULL, 100, 'admin', '管理员', '00', 'ryo210856837@gmail.com', '16576545432', '0', '/profile/avatar/2026/03/05/ca4974e8b23545a0a5a51133fc605fb6.png', '$2a$10$qXI5oBIAKMDg/xXLWzjO9OTTMgm5S2bN7.CqpHU7EqCNgRuBLLGZm', '0', '0', '127.0.0.1', '2026-05-20 13:00:49', '2026-05-20 01:22:26', 0, 'admin', '2024-07-18 08:50:06', '', '2026-05-20 01:20:36', '管理员', NULL, NULL, '0');
INSERT INTO `sys_user` VALUES (2001, NULL, 100, 'demo_landlord', 'fangdong', '00', 'landlord@demo.com', '13800000001', '1', '', '$2a$10$WnzCQmgAdawpxVG8H8r9ie1QGxBvkB4BCfDaJgBwZjZiUrXAJhmcy', '0', '0', '127.0.0.1', '2026-03-07 18:08:31', '2026-05-18 17:56:46', 5, 'admin', '2026-02-25 14:24:36', 'admin', '2026-05-18 17:57:20', 'MVP demo landlord', NULL, NULL, '0');
INSERT INTO `sys_user` VALUES (2002, NULL, 100, 'demo_tenant', 'zuke', '00', 'tenant@demo.com', '13800000002', '0', '', '$2a$10$hs6KTr5lk8qPdUbbOdhgjejc2kxMHlMDRhxLbm/z5YGJwHYHPGj12', '0', '0', '127.0.0.1', '2026-03-07 16:01:02', '2026-05-18 17:56:51', 0, 'admin', '2026-02-25 14:24:36', 'admin', '2026-05-18 17:57:43', 'MVP demo tenant', NULL, NULL, '0');
INSERT INTO `sys_user` VALUES (2003, NULL, NULL, '17878786765', '123113', '00', '234244@qq.com', '15876565432', '0', '/profile/avatar/2026/03/07/a37764cbf97d4cbda5ff6e20892b03fc.png', '$2a$10$r0vGPrMWccKZAqmDzM1Yq.vJXjJK/i4MycA9//xR4ChT5dLZjx4D6', '0', '0', '127.0.0.1', '2026-05-20 09:35:47', '2026-03-05 18:28:11', 0, '', '2026-03-05 18:28:11', '', '2026-05-20 09:26:50', NULL, NULL, NULL, '0');
INSERT INTO `sys_user` VALUES (2004, NULL, NULL, '17876453425', '17876453425', '00', '', '', '0', '', '$2a$10$SF7jRkB4FT8Vr8JVbrJLEO.o.KJQ1mOeM2kaZ3hoSxWZ/4qZPaByC', '0', '0', '127.0.0.1', '2026-05-18 21:25:01', '2026-05-18 16:09:32', 0, '', '2026-05-18 16:09:31', '', NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_user` VALUES (2005, NULL, NULL, '15171324012', '15171324012', '00', '', '', '0', '', '$2a$10$r97zwjkK4r1No8AI744RL.jI1hP04MODMo1yiqaywIm0Hr6n0i9Hm', '0', '0', '127.0.0.1', '2026-05-18 21:25:47', '2026-05-18 17:17:07', 0, '', '2026-05-18 17:17:07', '', NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_user` VALUES (2006, NULL, NULL, '15171324013', '张美娟', '00', '31213@qq.com', '16767487352', '0', '/profile/avatar/2026/05/18/a1fabd03267b457ea5728bb6742c4b7e.png', '$2a$10$GTcliOkPr1DY.Qwsm4EqI.NEwTXeWVZ3u3tKSBdJ1.eVH6M3vc22W', '0', '0', '127.0.0.1', '2026-05-18 21:25:32', '2026-05-18 17:17:43', 0, '', '2026-05-18 17:17:42', '', '2026-05-18 22:58:01', NULL, NULL, NULL, '0');
INSERT INTO `sys_user` VALUES (2007, NULL, NULL, '15171324010', '张美娟', '00', '231@qq.com', '15171324010', '0', 'http://js.ccnccn.cn/2026/05/19250ccfd8-c0a1-4b7e-a8eb-c5a2570c00e1.png', '$2a$10$NFSPkPY.3lwM.8VFwIBBt.OUkFU.ZKMq6KyvVKuj5.VBWYEzNJalq', '0', '0', '127.0.0.1', '2026-05-20 11:21:09', '2026-05-20 04:50:04', 0, '', '2026-05-18 18:00:00', '', '2026-05-20 13:07:50', NULL, NULL, NULL, '0');
INSERT INTO `sys_user` VALUES (2008, NULL, NULL, '17878786702', '17878786702', '00', '', '', '0', '', '$2a$10$u9zOZJ.5/LipEIPJxPmtlevosrUryHcreK1B9BI.iqftW4nY9vQse', '0', '0', '127.0.0.1', '2026-05-19 14:12:20', '2026-05-18 20:36:19', 0, '', '2026-05-18 20:36:18', '', NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_user` VALUES (2009, NULL, NULL, '15171324011', '苍龙', '00', '17878786702@qq.com', '17878786702', '0', '/profile/avatar/2026/05/19/b8d7f88809ef40ff888454f251ea46b9.png', '$2a$10$Gb/do0PDfTdTiBs8R4bpHOx3c95i3wwieZRnanYsAnHWax7LzAgd2', '0', '0', '127.0.0.1', '2026-05-20 13:04:44', '2026-05-18 21:26:25', 0, '', '2026-05-18 21:26:25', '', '2026-05-19 14:54:46', NULL, NULL, NULL, '0');
INSERT INTO `sys_user` VALUES (2010, NULL, NULL, '15171324015', '15171324015', '00', '', '', '0', '', '$2a$10$auCyDAp5BobMM3eMGeC6ZeqLQ/SQC669Tpv8hfo92X9Iuy6YGww5e', '0', '0', '127.0.0.1', '2026-05-20 05:18:30', '2026-05-20 05:18:20', 2, '', '2026-05-20 05:18:20', '', NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_user` VALUES (2011, NULL, NULL, '15171324016', '201', '00', '', '15978362563', '0', '', '$2a$10$TGtun0CnB5xdg75rKFFd.epOORJMXEV475fkTTe86BiLf2Vn6h/w.', '0', '0', '127.0.0.1', '2026-05-20 11:18:55', '2026-05-20 05:19:11', 1, '', '2026-05-20 05:19:11', 'admin', '2026-05-20 13:06:27', NULL, NULL, NULL, '0');
INSERT INTO `sys_user` VALUES (2012, NULL, NULL, '15171324021', '左鑫', '00', '', '15171324021', '0', '', '$2a$10$DAZqAzT9iXrHac.txeGGE.m.ZR4B2uRKqR7LTCmdBQAMEflaQpraC', '0', '0', '127.0.0.1', '2026-05-20 23:13:26', '2026-05-20 13:06:02', 0, '', '2026-05-20 13:06:02', 'admin', '2026-05-20 14:28:59', NULL, NULL, NULL, '0');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `post_id` bigint(0) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `role_id` bigint(0) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2001, 100);
INSERT INTO `sys_user_role` VALUES (2002, 101);
INSERT INTO `sys_user_role` VALUES (2005, 100);
INSERT INTO `sys_user_role` VALUES (2006, 100);
INSERT INTO `sys_user_role` VALUES (2007, 101);
INSERT INTO `sys_user_role` VALUES (2008, 100);
INSERT INTO `sys_user_role` VALUES (2009, 100);
INSERT INTO `sys_user_role` VALUES (2010, 100);
INSERT INTO `sys_user_role` VALUES (2011, 100);
INSERT INTO `sys_user_role` VALUES (2012, 100);

SET FOREIGN_KEY_CHECKS = 1;
