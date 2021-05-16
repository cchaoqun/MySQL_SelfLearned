/*
 Navicat MySQL Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50145
 Source Host           : localhost:3306
 Source Schema         : test

 Target Server Type    : MySQL
 Target Server Version : 50145
 File Encoding         : 65001

 Date: 03/07/2020 11:09:05
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_ua
-- ----------------------------
DROP TABLE IF EXISTS `t_ua`;
CREATE TABLE `t_ua`  (
  `t_id` int(11) NOT NULL,
  `tName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tGender` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`t_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of t_ua
-- ----------------------------
INSERT INTO `t_ua` VALUES (1, 'john', 'male');
INSERT INTO `t_ua` VALUES (2, 'lucy', 'female');
INSERT INTO `t_ua` VALUES (3, 'lily', 'female');
INSERT INTO `t_ua` VALUES (4, 'jack', 'male');
INSERT INTO `t_ua` VALUES (5, 'rose', 'female');

SET FOREIGN_KEY_CHECKS = 1;
