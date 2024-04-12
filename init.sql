SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `num` int(11) NOT NULL,
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for headphone
-- ----------------------------
DROP TABLE IF EXISTS `headphone`;
CREATE TABLE `headphone`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '详情',
  `popular` int(11) NOT NULL DEFAULT 0 COMMENT '热门排行',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `attrs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '耳机表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for headphone_collection
-- ----------------------------
DROP TABLE IF EXISTS `headphone_collection`;
CREATE TABLE `headphone_collection`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `headphone_id` int(11) NULL DEFAULT NULL,
  `is_deleted` tinyint(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '耳机收藏记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for headphone_comment
-- ----------------------------
DROP TABLE IF EXISTS `headphone_comment`;
CREATE TABLE `headphone_comment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `headphone_id` int(11) NULL DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `is_admin_reply` tinyint(4) NULL DEFAULT 0 COMMENT '是否管理员回复：1是，0否',
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '耳机评论记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for headphone_visit
-- ----------------------------
DROP TABLE IF EXISTS `headphone_visit`;
CREATE TABLE `headphone_visit`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `headphone_id` int(11) NULL DEFAULT NULL,
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '耳机浏览记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `amt` decimal(10, 2) NULL DEFAULT NULL,
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `item_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `num` int(11) NULL DEFAULT NULL,
  `price` decimal(10, 2) NULL DEFAULT NULL,
  `amt` decimal(10, 2) NULL DEFAULT NULL,
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `age` int(11) NOT NULL DEFAULT 0,
  `gender` int(11) NOT NULL DEFAULT 0 COMMENT '性别：1男，2女，0未知',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `prefer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '偏好',
  `is_admin` tinyint(4) NOT NULL DEFAULT 0 COMMENT '是否管理员：1是，否',
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表，包括管理员、普通用户' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'admin', '', 0, 0, '', '[]', 1, 0, '2024-03-22 22:12:44', '2024-03-22 22:12:44');


SET FOREIGN_KEY_CHECKS = 1;
