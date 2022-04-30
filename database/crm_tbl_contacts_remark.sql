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
-- Table structure for table `tbl_contacts_remark`
--

DROP TABLE IF EXISTS `tbl_contacts_remark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_contacts_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL,
  `contactsId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_contacts_remark`
--

LOCK TABLES `tbl_contacts_remark` WRITE;
/*!40000 ALTER TABLE `tbl_contacts_remark` DISABLE KEYS */;
INSERT INTO `tbl_contacts_remark` VALUES ('7b19177790ed48da8c5b39041bfb9309','Good job','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-29 00:40:57',NULL,NULL,'0','e6d2666820054e66bb303c21bf0eaee5'),('83719cda24f5440bae6b37f29ebfdcf8','Just go on....','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-29 00:21:29',NULL,NULL,'1','159e0fd60f0c4b909112900f7d4970ba'),('ae304c065de9467996e037397218d213','Good job','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-29 00:21:29',NULL,NULL,'0','159e0fd60f0c4b909112900f7d4970ba'),('bb80d22d99284e35ba2d766cf9fbb770','Test03','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 20:13:52','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 20:59:26','1','4870210fa1894c10a9b4da84de3b971c'),('f7a9f104389448b49a08be04bb28fb90','Just go on....','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-29 00:40:57',NULL,NULL,'1','e6d2666820054e66bb303c21bf0eaee5'),('f856a17488fc4891b9235aa5df7abbcb','TEST01','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 21:02:12','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 21:02:12','0','1965684282e642c29ece549cb09c75a3');
/*!40000 ALTER TABLE `tbl_contacts_remark` ENABLE KEYS */;
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
