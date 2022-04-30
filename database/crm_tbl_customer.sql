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
-- Table structure for table `tbl_customer`
--

DROP TABLE IF EXISTS `tbl_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_customer` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_customer`
--

LOCK TABLES `tbl_customer` WRITE;
/*!40000 ALTER TABLE `tbl_customer` DISABLE KEYS */;
INSERT INTO `tbl_customer` VALUES ('36e5c9707d644af3906b2c03a161aa25','06f5fc056eac41558a964f96daa7f27c','Google','www.google.fr','0168991685','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-24 13:06:43','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-24 13:06:43',NULL,'2022-04-27',NULL,'75 rue du thêatre 75003 Paris'),('6cf7330ba1ee4ff38ea6c895c9f6a5f9','40f6cdea0bd34aceb77492a1656d9fb3','Coca-cola','www.coca-cola.com','0165857159','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-29 00:40:57','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-29 00:40:57',NULL,'2022-05-04',NULL,'85 Av.renne 75005 Paris'),('9b1b2899fd4e4f0abdd359b95db28f32','40f6cdea0bd34aceb77492a1656d9fb3','Apple','www.apple.fr','0111587496','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-24 13:57:32','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 02:06:13','','2022-06-04','Wait for the response','65 boulevard Brune 75014 Paris');
/*!40000 ALTER TABLE `tbl_customer` ENABLE KEYS */;
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
