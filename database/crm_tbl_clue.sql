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
-- Table structure for table `tbl_clue`
--

DROP TABLE IF EXISTS `tbl_clue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_clue` (
  `id` char(32) NOT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `appellation` varchar(255) DEFAULT NULL,
  `owner` char(32) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `mphone` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_clue`
--

LOCK TABLES `tbl_clue` WRITE;
/*!40000 ALTER TABLE `tbl_clue` DISABLE KEYS */;
INSERT INTO `tbl_clue` VALUES ('50a6034c942e4304bdf3ed933d8f3966','Jeanne','67165c27076e4c8599f42de57850e39c','40f6cdea0bd34aceb77492a1656d9fb3','Apple','Sale','test02@outlook.com','0111587496','www.apple.fr','0617558671','9e6d6e15232549af853e22e703f3e015','4d03a42898684135809d380597ed3268','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-20 16:26:48','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 23:28:08','Plan to contact tomorrow','','2022-04-21','65 boulevard Brune 75014 Paris'),('78a3f1d27a9d427b9475c5869d5bb13a','Joe','59795c49896947e1ab61b7312bd0597c','06f5fc056eac41558a964f96daa7f27c','Google','HR','test@gmail.com','0168991685','www.google.fr','0668991826','966170ead6fa481284b7d21f90364984','72f13af8f5d34134b5b3f42c5d477510','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-21 17:58:26','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 23:28:34','','','2022-04-27','75 rue du thêatre 75003 Paris'),('c9508e5133904299822ce127503d5026','Macron','59795c49896947e1ab61b7312bd0597c','40f6cdea0bd34aceb77492a1656d9fb3','Coca-cola','HR','macron@orange.fr','0165857159','www.coca-cola.com','0667458965','9e6d6e15232549af853e22e703f3e015','6b86f215e69f4dbd8a2daa22efccf0cf','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-29 00:19:41','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-29 00:19:41','It\'s a potential opportunity to make a deal','','2022-05-04','85 Av.renne 75005 Paris');
/*!40000 ALTER TABLE `tbl_clue` ENABLE KEYS */;
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
