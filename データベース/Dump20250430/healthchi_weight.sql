-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 192.168.0.159    Database: healthchi
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `weight`
--

DROP TABLE IF EXISTS `weight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `weight` (
  `W_USER_ID` varchar(8) NOT NULL,
  `W_WEIGHT` decimal(4,1) DEFAULT NULL,
  `W_DATE` datetime DEFAULT CURRENT_TIMESTAMP,
  KEY `W_USER_ID_idx` (`W_USER_ID`),
  CONSTRAINT `W_USER_ID` FOREIGN KEY (`W_USER_ID`) REFERENCES `user` (`U_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weight`
--

LOCK TABLES `weight` WRITE;
/*!40000 ALTER TABLE `weight` DISABLE KEYS */;
INSERT INTO `weight` VALUES ('health',55.2,'2025-04-15 00:00:00'),('health',56.5,'2025-04-16 00:00:00'),('health',55.0,'2025-04-17 00:00:00'),('health',55.7,'2025-04-18 00:00:00'),('health',56.8,'2025-04-19 00:00:00'),('health',56.4,'2025-04-20 00:00:00'),('health',51.5,'2025-04-21 00:00:00'),('health',51.5,'2025-04-22 00:00:00'),('health',50.0,'2025-04-22 00:00:00'),('health',54.0,'2025-04-25 00:00:00'),('7777',55.4,'2025-04-25 00:00:00'),('7777',57.0,'2025-04-24 00:00:00'),('7777',55.0,'2025-04-23 00:00:00'),('7777',56.0,'2025-04-22 00:00:00'),('7777',56.0,'2025-04-20 00:00:00'),('7777',59.0,'2025-04-20 00:00:00'),('1234',82.0,NULL),('1234',85.0,'2025-04-28 10:16:12'),('7777',53.0,'2025-04-28 12:27:08'),('health',55.0,'2025-04-28 12:47:29'),('1234',55.0,'2025-04-28 12:58:08'),('bannom',65.0,'2025-04-28 14:27:44'),('bannom',50.8,'2025-04-28 14:43:41'),('bannom',54.0,'2025-04-27 00:00:00'),('1234',56.0,'2025-04-30 09:56:07'),('health',56.0,'2025-04-01 00:00:00'),('health',55.5,'2025-04-02 00:00:00'),('health',55.2,'2025-04-03 00:00:00'),('health',55.0,'2025-04-04 00:00:00'),('health',55.4,'2025-04-05 00:00:00'),('health',55.8,'2025-04-06 00:00:00'),('health',56.0,'2025-04-07 00:00:00'),('health',56.5,'2025-04-08 00:00:00'),('health',56.3,'2025-04-09 00:00:00'),('health',55.7,'2025-04-10 00:00:00'),('health',55.4,'2025-04-11 00:00:00'),('health',55.0,'2025-04-12 00:00:00'),('health',54.6,'2025-04-13 00:00:00'),('health',55.1,'2025-04-14 00:00:00'),('health',55.0,'2025-04-15 00:00:00'),('health',54.8,'2025-04-16 00:00:00'),('health',54.5,'2025-04-17 00:00:00'),('health',54.3,'2025-04-18 00:00:00'),('health',54.2,'2025-04-19 00:00:00'),('health',54.2,'2025-04-20 00:00:00'),('health',54.1,'2025-04-21 00:00:00'),('health',54.0,'2025-04-22 00:00:00'),('health',54.1,'2025-04-23 00:00:00'),('health',55.2,'2025-04-24 00:00:00'),('health',55.0,'2025-04-25 00:00:00'),('health',54.8,'2025-04-26 00:00:00'),('health',54.7,'2025-04-27 00:00:00'),('health',54.8,'2025-04-28 00:00:00'),('health',55.0,'2025-04-29 00:00:00');
/*!40000 ALTER TABLE `weight` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-30 11:36:18
