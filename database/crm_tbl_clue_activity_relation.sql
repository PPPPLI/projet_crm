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
-- Table structure for table `tbl_clue_activity_relation`
--

DROP TABLE IF EXISTS `tbl_clue_activity_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_clue_activity_relation` (
  `id` char(32) NOT NULL,
  `clueId` char(32) DEFAULT NULL,
  `activityId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_clue_activity_relation`
--

LOCK TABLES `tbl_clue_activity_relation` WRITE;
/*!40000 ALTER TABLE `tbl_clue_activity_relation` DISABLE KEYS */;
INSERT INTO `tbl_clue_activity_relation` VALUES ('01d0c15799ac4bc4aa745854c337adce','50a6034c942e4304bdf3ed933d8f3966','21841cbf35354121bbb79e77b4495c68'),('08efc63dce7b4f7dac1d49cc8e3e885b','78a3f1d27a9d427b9475c5869d5bb13a','21841cbf35354121bbb79e77b4495c68'),('6bf6369c4d0144ec9b2c99fe638f5677','c9508e5133904299822ce127503d5026','467d714d3465407ba605e552e0eedbe0'),('8c90ca14d40147b4a08b0417d5c963eb','50a6034c942e4304bdf3ed933d8f3966','467d714d3465407ba605e552e0eedbe0');
/*!40000 ALTER TABLE `tbl_clue_activity_relation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-04-30  2:24:11
