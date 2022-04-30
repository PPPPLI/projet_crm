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
-- Table structure for table `tbl_dic_value`
--

DROP TABLE IF EXISTS `tbl_dic_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_dic_value` (
  `id` char(32) NOT NULL COMMENT '涓婚敭锛岄噰鐢║UID',
  `value` varchar(255) DEFAULT NULL COMMENT '涓嶈兘涓虹┖锛屽苟涓旇姹傚悓涓�涓瓧鍏哥被鍨嬩笅瀛楀吀鍊间笉鑳介噸澶嶏紝鍏锋湁鍞竴鎬с��',
  `text` varchar(255) DEFAULT NULL COMMENT '鍙互涓虹┖',
  `orderNo` varchar(255) DEFAULT NULL COMMENT '鍙互涓虹┖锛屼絾涓嶄负绌虹殑鏃跺�欙紝瑕佹眰蹇呴』鏄鏁存暟',
  `typeCode` varchar(255) DEFAULT NULL COMMENT '澶栭敭',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_dic_value`
--

LOCK TABLES `tbl_dic_value` WRITE;
/*!40000 ALTER TABLE `tbl_dic_value` DISABLE KEYS */;
INSERT INTO `tbl_dic_value` VALUES ('06e3cbdf10a44eca8511dddfc6896c55','Fake clue','Fake clue','4','clueState'),('0fe33840c6d84bf78df55d49b169a894','Client mail','Client mail','8','source'),('12302fd42bd349c1bb768b19600e6b20','Trade fair','Trade fair','11','source'),('1615f0bb3e604552a86cde9a2ad45bea','Top','Top','2','returnPriority'),('1e0bd307e6ee425599327447f8387285','Future contact','Future contact','2','clueState'),('2173663b40b949ce928db92607b5fe57','Clue lost','Clue lost','5','clueState'),('2876690b7e744333b7f1867102f91153','Pending','Pending','1','returnState'),('29805c804dd94974b568cfc9017b2e4c','Deal','Deal','8','stage'),('310e6a49bd8a4962b3f95a1d92eb76f4','Try to contact','Try to contact','1','clueState'),('37ef211719134b009e10b7108194cf46','File check','File check','2','stage'),('3a39605d67da48f2a3ef52e19d243953','By contact','By contact','14','source'),('474ab93e2e114816abf3ffc596b19131','Low','Low','3','returnPriority'),('48512bfed26145d4a38d3616e2d2cf79','Advertisement','Advertisement','1','source'),('4d03a42898684135809d380597ed3268','Partner workshop','Partner workshop','9','source'),('59795c49896947e1ab61b7312bd0597c','Mr','Mr','1','appellation'),('5c6e9e10ca414bd499c07b886f86202a','High','High','1','returnPriority'),('67165c27076e4c8599f42de57850e39c','Ms','Ms','2','appellation'),('6b86f215e69f4dbd8a2daa22efccf0cf','Web research','Web research','13','source'),('72f13af8f5d34134b5b3f42c5d477510','Partner','Partner','6','source'),('7c07db3146794c60bf975749952176df','Not contacted','Not contacted','6','clueState'),('86c56aca9eef49058145ec20d5466c17','Internal seminar','Internal seminar','10','source'),('9095bda1f9c34f098d5b92fb870eba17','In process','In process','3','returnState'),('954b410341e7433faa468d3c4f7cf0d2','Regular customer','Regular customer','1','transactionType'),('966170ead6fa481284b7d21f90364984','Contacted','Contacted','3','clueState'),('96b03f65dec748caa3f0b6284b19ef2f','Delay','Delay','2','returnState'),('97d1128f70294f0aac49e996ced28c8a','New customer','New customer','2','transactionType'),('9ca96290352c40688de6596596565c12','Completed','Completed','4','returnState'),('9e6d6e15232549af853e22e703f3e015','Conditional','Conditional','7','clueState'),('9ff57750fac04f15b10ce1bbb5bb8bab','Analyse need','Analyse need','3','stage'),('a70dc4b4523040c696f4421462be8b2f','Wait for','Wait for','5','returnState'),('a83e75ced129421dbf11fab1f05cf8b4','Sales call','Sales call','2','source'),('ab8472aab5de4ae9b388b2f1409441c1','Normal','Normal','5','returnPriority'),('ab8c2a3dc05f4e3dbc7a0405f721b040','Proposal','Proposal','5','stage'),('b924d911426f4bc5ae3876038bc7e0ad','Web download','Web download','12','source'),('c13ad8f9e2f74d5aa84697bb243be3bb','Value advice','Value advice','4','stage'),('c83c0be184bc40708fd7b361b6f36345','Lowest','Lowest','4','returnPriority'),('db867ea866bc44678ac20c8a4a8bfefb','Staff introduction','Staff introduction','3','source'),('e44be1d99158476e8e44778ed36f4355','Final decision','Final decision','7','stage'),('e5f383d2622b4fc0959f4fe131dafc80','Miss','Miss','3','appellation'),('e81577d9458f4e4192a44650a3a3692b','Negotiation','Negotiation','6','stage'),('fb65d7fdb9c6483db02713e6bc05dd19','Online market','Online market','5','source'),('fd677cc3b5d047d994e16f6ece4d3d45','Public media','Public media','7','source'),('ff802a03ccea4ded8731427055681d48','External introduction','External introduction','4','source');
/*!40000 ALTER TABLE `tbl_dic_value` ENABLE KEYS */;
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
