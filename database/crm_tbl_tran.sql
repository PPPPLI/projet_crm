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
-- Table structure for table `tbl_tran`
--

DROP TABLE IF EXISTS `tbl_tran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_tran` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `expectedDate` char(10) DEFAULT NULL,
  `customerId` char(32) DEFAULT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `activityId` char(32) DEFAULT NULL,
  `contactsId` char(32) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  `possibility` char(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_tran`
--

LOCK TABLES `tbl_tran` WRITE;
/*!40000 ALTER TABLE `tbl_tran` DISABLE KEYS */;
INSERT INTO `tbl_tran` VALUES ('01a0f78e62c44ee09f5cf77e8690594e','06f5fc056eac41558a964f96daa7f27c','79000','Transaction03','2022-10-21','36e5c9707d644af3906b2c03a161aa25','9ff57750fac04f15b10ce1bbb5bb8bab','954b410341e7433faa468d3c4f7cf0d2','86c56aca9eef49058145ec20d5466c17','21841cbf35354121bbb79e77b4495c68','4870210fa1894c10a9b4da84de3b971c','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-28 17:59:23','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-28 18:40:23','','','2022-09-03','30%'),('79ad7c74f9c74266b10999feb37e3520','40f6cdea0bd34aceb77492a1656d9fb3','50000','Transaction04','2023-02-16','6cf7330ba1ee4ff38ea6c895c9f6a5f9','9ff57750fac04f15b10ce1bbb5bb8bab','97d1128f70294f0aac49e996ced28c8a','6b86f215e69f4dbd8a2daa22efccf0cf','467d714d3465407ba605e552e0eedbe0','e6d2666820054e66bb303c21bf0eaee5','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-29 00:40:57','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-29 00:51:23','','','2022-05-04','30%'),('a66af97503bb46ef9a83e96300f32a0c','40f6cdea0bd34aceb77492a1656d9fb3','8000','Transaction02','2022-05-13','9b1b2899fd4e4f0abdd359b95db28f32','e81577d9458f4e4192a44650a3a3692b','954b410341e7433faa468d3c4f7cf0d2','86c56aca9eef49058145ec20d5466c17','50d52668a34043a38325b024df89449d','1965684282e642c29ece549cb09c75a3','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-28 17:11:33','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-28 17:11:33','','','2022-04-30','60%'),('d53b6f94008c46bfb9155833ff43f991','40f6cdea0bd34aceb77492a1656d9fb3','5000','Transaction01','2023-01-19','36e5c9707d644af3906b2c03a161aa25','29805c804dd94974b568cfc9017b2e4c','954b410341e7433faa468d3c4f7cf0d2','3a39605d67da48f2a3ef52e19d243953','4c33a084fe044646b631390280033c0d','9d1ddf4c8afe48cc8a894f93ec531e85','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-27 14:11:06','40f6cdea0bd34aceb77492a1656d9fb3','2022-04-28 13:24:07','Finally go to deal','','2023-01-13','100%');
/*!40000 ALTER TABLE `tbl_tran` ENABLE KEYS */;
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