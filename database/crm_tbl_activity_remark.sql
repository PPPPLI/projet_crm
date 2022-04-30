-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: crm
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tbl_activity_remark`
--

DROP TABLE IF EXISTS `tbl_activity_remark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_activity_remark` (
  `id` char(32) CHARACTER SET utf8 NOT NULL,
  `noteContent` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `createTime` char(19) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `createBy` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `editTime` char(19) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `editBy` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `editFlag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '0琛ㄧず鏈慨鏀癸紝1琛ㄧず宸蹭慨鏀�',
  `activityId` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_activity_remark`
--

LOCK TABLES `tbl_activity_remark` WRITE;
/*!40000 ALTER TABLE `tbl_activity_remark` DISABLE KEYS */;
INSERT INTO `tbl_activity_remark` VALUES ('5dd18723ed2f4eab9efbcabe3a57f833','Test2','2022-04-29 17:18:01','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-29 17:18:01','40f6cdea0bd34aceb77492a1656d9fb3','0','21841cbf35354121bbb79e77b4495c68'),('614f5e44b6fc4ca89792f4f8894faab8','Test02','2022-04-18 17:59:33','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-18 21:59:03','40f6cdea0bd34aceb77492a1656d9fb3','1','4c33a084fe044646b631390280033c0d'),('6430a2a1c38c487ba5f323c344ffdd11','Check the date with thge client','2021-01-20 15:40:47','06f5fc056eac41558a964f96daa7f27c','2021-01-20 15:40:47','06f5fc056eac41558a964f96daa7f27c','0','4c33a084fe044646b631390280033c0d'),('6430a2a1c38c487ba5f323c344ffdd12','Good','2021-01-20 16:40:47','40f6cdea0bd34aceb77492a1656d9fb3','2021-01-20 16:40:47','40f6cdea0bd34aceb77492a1656d9fb3','0','50d52668a34043a38325b024df89449d'),('ab559852b7394e6a92c4e8ae6bdfec61','Test','2022-04-18 18:03:43','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-18 18:03:43','40f6cdea0bd34aceb77492a1656d9fb3','0','4c33a084fe044646b631390280033c0d'),('b1cf01134ad24418a0c64d160696289c','03','2022-04-21 11:41:06','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-21 11:41:06','40f6cdea0bd34aceb77492a1656d9fb3','0','4c33a084fe044646b631390280033c0d'),('dac7a38a4b4b41e2bfc123c8fee5fe76','New Test','2022-04-18 18:32:30','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-18 21:52:51','40f6cdea0bd34aceb77492a1656d9fb3','1','4c33a084fe044646b631390280033c0d'),('fb4d05e6131d4b3691f191dee54818a4','test1','2022-04-21 14:09:49','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-21 14:09:53','40f6cdea0bd34aceb77492a1656d9fb3','1','21841cbf35354121bbb79e77b4495c68');
/*!40000 ALTER TABLE `tbl_activity_remark` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-04-30  2:24:12