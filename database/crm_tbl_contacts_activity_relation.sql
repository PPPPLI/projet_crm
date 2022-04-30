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
-- Table structure for table `tbl_contacts_activity_relation`
--

DROP TABLE IF EXISTS `tbl_contacts_activity_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_contacts_activity_relation` (
  `id` char(32) NOT NULL,
  `contactsId` char(32) DEFAULT NULL,
  `activityId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_contacts_activity_relation`
--

LOCK TABLES `tbl_contacts_activity_relation` WRITE;
/*!40000 ALTER TABLE `tbl_contacts_activity_relation` DISABLE KEYS */;
INSERT INTO `tbl_contacts_activity_relation` VALUES ('255b2af19b2044b5937f5377d7a738b0','159e0fd60f0c4b909112900f7d4970ba','467d714d3465407ba605e552e0eedbe0'),('3e2c8997d73342588413512122fc043e','e6d2666820054e66bb303c21bf0eaee5','467d714d3465407ba605e552e0eedbe0'),('3f2a21ce134141e98b7eacafdca8bc9d','cf931a4c0842479a93619170fb15a297','21841cbf35354121bbb79e77b4495c68'),('afae1fe573814011a58cb98bde556538','cf931a4c0842479a93619170fb15a297','467d714d3465407ba605e552e0eedbe0');
/*!40000 ALTER TABLE `tbl_contacts_activity_relation` ENABLE KEYS */;
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
