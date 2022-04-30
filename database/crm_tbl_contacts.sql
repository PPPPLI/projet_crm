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
-- Table structure for table `tbl_contacts`
--

DROP TABLE IF EXISTS `tbl_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_contacts` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `customerId` char(32) DEFAULT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `appellation` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mphone` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `birth` char(10) DEFAULT NULL,
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
-- Dumping data for table `tbl_contacts`
--

LOCK TABLES `tbl_contacts` WRITE;
/*!40000 ALTER TABLE `tbl_contacts` DISABLE KEYS */;
INSERT INTO `tbl_contacts` VALUES ('1965684282e642c29ece549cb09c75a3','40f6cdea0bd34aceb77492a1656d9fb3','48512bfed26145d4a38d3616e2d2cf79','9b1b2899fd4e4f0abdd359b95db28f32','Fred','59795c49896947e1ab61b7312bd0597c','test02@outlook.com','0658994726','Sale','1991-01-31','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 17:57:35','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 22:30:57','wait for the second meeting','','2022-04-29','75 rue du père Corentin 75014 Paris'),('4870210fa1894c10a9b4da84de3b971c','40f6cdea0bd34aceb77492a1656d9fb3','48512bfed26145d4a38d3616e2d2cf79','36e5c9707d644af3906b2c03a161aa25','Ketty','67165c27076e4c8599f42de57850e39c','test@gmail.com','0668991826','GM','1979-05-16','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 14:58:15','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 17:24:02','Keep in touch','','2022-04-30','75 rue du thêatre 75003 Paris'),('9d1ddf4c8afe48cc8a894f93ec531e85','40f6cdea0bd34aceb77492a1656d9fb3','ff802a03ccea4ded8731427055681d48','36e5c9707d644af3906b2c03a161aa25','Alex','59795c49896947e1ab61b7312bd0597c','test@gmail.com','0668991685','Sale','1989-03-21','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 00:58:58','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 00:58:58','Keep in touch','','2022-04-29','85 rue d\'alésia 75014 Paris'),('c01ca7c8443e4fbda290accc19b6ed40','40f6cdea0bd34aceb77492a1656d9fb3','4d03a42898684135809d380597ed3268','9b1b2899fd4e4f0abdd359b95db28f32','Daniel','59795c49896947e1ab61b7312bd0597c','test03@outlook.com','0668991245','Sale','1990-02-14','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-25 02:08:18','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-27 14:51:06','have to meet in their office','','2022-04-29','94 boulevard Monparnasse 75015 Paris'),('e6d2666820054e66bb303c21bf0eaee5','40f6cdea0bd34aceb77492a1656d9fb3','6b86f215e69f4dbd8a2daa22efccf0cf','6cf7330ba1ee4ff38ea6c895c9f6a5f9','Macron','59795c49896947e1ab61b7312bd0597c','macron@orange.fr','0667458965','HR','1965-11-18','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-29 00:40:57','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-29 00:41:53','','','2022-05-04','85 Av.renne 75005 Paris');
/*!40000 ALTER TABLE `tbl_contacts` ENABLE KEYS */;
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
