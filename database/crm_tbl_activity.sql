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
-- Table structure for table `tbl_activity`
--

DROP TABLE IF EXISTS `tbl_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_activity` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `startDate` char(10) DEFAULT NULL,
  `cost` varchar(255) DEFAULT NULL,
  `endDate` char(10) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_activity`
--

LOCK TABLES `tbl_activity` WRITE;
/*!40000 ALTER TABLE `tbl_activity` DISABLE KEYS */;
INSERT INTO `tbl_activity` VALUES ('21841cbf35354121bbb79e77b4495c68','40f6cdea0bd34aceb77492a1656d9fb3','Expostion','2022-04-14','5000','2022-05-25','','2022-04-12 15:27:14','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-14 16:12:36','40f6cdea0bd34aceb77492a1656d9fb3'),('467d714d3465407ba605e552e0eedbe0','06f5fc056eac41558a964f96daa7f27c','Business meeting','2022-04-20','500','2022-04-29','','2022-04-20 17:03:43','40f6cdea0bd34aceb77492a1656d9fb3',NULL,NULL),('4c33a084fe044646b631390280033c0d','06f5fc056eac41558a964f96daa7f27c','Reunion','2021-01-20','200','2021-01-29','La réunion avec bureau d\'études','2021-01-20 15:40:47','06f5fc056eac41558a964f96daa7f27c','2022-04-19 00:24:20','40f6cdea0bd34aceb77492a1656d9fb3'),('50d52668a34043a38325b024df89449d','40f6cdea0bd34aceb77492a1656d9fb3','Conference','2021-01-19','0','2021-01-19',NULL,'2022-04-16 20:28:02','40f6cdea0bd34aceb77492a1656d9fb3',NULL,NULL),('5f3a0007342346bea0ec37e53d063edd','40f6cdea0bd34aceb77492a1656d9fb3','Business meeting','2022-04-30','2000','2022-05-02','','2022-04-29 00:15:25','40f6cdea0bd34aceb77492a1656d9fb3',NULL,NULL),('d9017b984eb94150bea0212a84893b1e','40f6cdea0bd34aceb77492a1656d9fb3','Reunion','2021-01-20','20','2021-01-29',NULL,'2022-04-16 20:28:02','40f6cdea0bd34aceb77492a1656d9fb3',NULL,NULL);
/*!40000 ALTER TABLE `tbl_activity` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-04-30  2:24:10
