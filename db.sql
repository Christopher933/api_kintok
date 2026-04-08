Warning: A partial dump from a server that has GTIDs will by default include the GTIDs of all transactions, even those that changed suppressed parts of the database. If you don't want to restore GTIDs, pass --set-gtid-purged=OFF. To make a complete dump, pass --all-databases --triggers --routines --events. 
Warning: A dump from a server that has GTIDs enabled will by default include the GTIDs of all transactions, even those that were executed during its extraction and might not be represented in the dumped data. This might result in an inconsistent data dump. 
In order to ensure a consistent backup of the database, pass --single-transaction or --lock-all-tables or --source-data. 
-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: localhost    Database: kintok
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '19bee2ac-2e0e-11f1-8201-4d178f86f125:1-366';

--
-- Table structure for table `agent`
--

DROP TABLE IF EXISTS `agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_agent_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent`
--

LOCK TABLES `agent` WRITE;
/*!40000 ALTER TABLE `agent` DISABLE KEYS */;
/*!40000 ALTER TABLE `agent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amenity`
--

DROP TABLE IF EXISTS `amenity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `amenity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_amenity_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amenity`
--

LOCK TABLES `amenity` WRITE;
/*!40000 ALTER TABLE `amenity` DISABLE KEYS */;
INSERT INTO `amenity` VALUES (1,'Alberca'),(3,'Elevador'),(2,'Gimnasio'),(5,'Roof garden'),(4,'Seguridad');
/*!40000 ALTER TABLE `amenity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `city`
--

DROP TABLE IF EXISTS `city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `city` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_city_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `city`
--

LOCK TABLES `city` WRITE;
/*!40000 ALTER TABLE `city` DISABLE KEYS */;
INSERT INTO `city` VALUES (1,'Tijuana');
/*!40000 ALTER TABLE `city` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer_full_name` (`full_name`),
  KEY `idx_customer_email` (`email`),
  KEY `idx_customer_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exchange_rate`
--

DROP TABLE IF EXISTS `exchange_rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exchange_rate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `base_currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rate` decimal(18,6) NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_exchange_rate_pair_date` (`base_currency`,`target_currency`,`updated_at`),
  CONSTRAINT `chk_exchange_rate_currency` CHECK (((`base_currency` in (_utf8mb4'USD',_utf8mb4'MXN')) and (`target_currency` in (_utf8mb4'USD',_utf8mb4'MXN')))),
  CONSTRAINT `chk_exchange_rate_positive` CHECK ((`rate` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exchange_rate`
--

LOCK TABLES `exchange_rate` WRITE;
/*!40000 ALTER TABLE `exchange_rate` DISABLE KEYS */;
INSERT INTO `exchange_rate` VALUES (1,'USD','MXN',17.100000,'2026-04-01 15:34:39'),(2,'MXN','USD',0.058480,'2026-04-01 15:34:39');
/*!40000 ALTER TABLE `exchange_rate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lead_contact`
--

DROP TABLE IF EXISTS `lead_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lead_contact` (
  `id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comments` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'new',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `customer_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_lead_contact_status_created` (`status`,`created_at`),
  KEY `idx_lead_contact_property` (`property_id`),
  KEY `fk_lead_contact_customer` (`customer_id`),
  CONSTRAINT `fk_lead_contact_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_lead_contact_property` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lead_contact`
--

LOCK TABLES `lead_contact` WRITE;
/*!40000 ALTER TABLE `lead_contact` DISABLE KEYS */;
INSERT INTO `lead_contact` VALUES (1,1,'Christopher Sandoval','christopher.sandoval93@gmail.com','6640000000','Quiero información sobre esta propiedad','nuevo','2026-04-02 16:12:53','2026-04-02 16:12:53',NULL);
/*!40000 ALTER TABLE `lead_contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operation`
--

DROP TABLE IF EXISTS `operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_operation_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operation`
--

LOCK TABLES `operation` WRITE;
/*!40000 ALTER TABLE `operation` DISABLE KEYS */;
INSERT INTO `operation` VALUES (4,'Renta'),(3,'Venta');
/*!40000 ALTER TABLE `operation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property`
--

DROP TABLE IF EXISTS `property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property` (
  `id` int NOT NULL AUTO_INCREMENT,
  `property_type_id` int NOT NULL,
  `operation_id` int NOT NULL,
  `city_id` int NOT NULL,
  `zone_id` int NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `area_value` decimal(14,2) DEFAULT NULL,
  `price_value` decimal(14,2) DEFAULT NULL,
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `views_count` int NOT NULL DEFAULT '0',
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `publication_status_id` int NOT NULL,
  `business_status_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_property_operation` (`operation_id`),
  KEY `fk_property_city` (`city_id`),
  KEY `fk_property_zone` (`zone_id`),
  KEY `idx_property_main_filters` (`property_type_id`,`operation_id`,`city_id`,`zone_id`,`is_featured`),
  KEY `idx_property_price` (`price_value`,`currency`),
  KEY `idx_property_title` (`title`),
  KEY `idx_property_active_created` (`created_at`),
  KEY `idx_property_publication_status` (`publication_status_id`),
  KEY `idx_property_business_status` (`business_status_id`),
  KEY `idx_property_status_filters` (`publication_status_id`,`business_status_id`,`property_type_id`,`operation_id`,`city_id`,`zone_id`),
  CONSTRAINT `fk_property_business_status` FOREIGN KEY (`business_status_id`) REFERENCES `property_business_status` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_property_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_property_operation` FOREIGN KEY (`operation_id`) REFERENCES `operation` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_property_property_type` FOREIGN KEY (`property_type_id`) REFERENCES `property_type` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_property_publication_status` FOREIGN KEY (`publication_status_id`) REFERENCES `property_publication_status` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_property_zone` FOREIGN KEY (`zone_id`) REFERENCES `zone` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_property_currency` CHECK ((`currency` in (_utf8mb4'USD',_utf8mb4'MXN')))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property`
--

LOCK TABLES `property` WRITE;
/*!40000 ALTER TABLE `property` DISABLE KEYS */;
INSERT INTO `property` VALUES (1,11,4,1,1,NULL,NULL,NULL,'test para casa','test desc',200.00,2000.00,'MXN',0,0,'2026-04-02 14:04:46','2026-04-02 14:33:04',1,1),(2,11,4,1,1,NULL,NULL,NULL,'test para casa','este es un test',200.00,2000.00,'MXN',0,0,'2026-04-02 14:08:17','2026-04-02 14:33:04',1,1),(3,11,4,1,1,NULL,NULL,NULL,'este es una casa','test para casa',200.00,2000.00,'USD',0,0,'2026-04-02 14:11:08','2026-04-02 17:42:20',1,1),(4,11,4,1,1,NULL,NULL,NULL,'casa de test','este es un test',200.00,2000.00,'MXN',0,0,'2026-04-02 17:22:13','2026-04-02 17:22:13',1,1),(5,11,3,1,1,NULL,NULL,NULL,'test 4','este es un test',200.00,3000.00,'MXN',0,0,'2026-04-03 22:03:31','2026-04-03 22:03:31',1,1),(6,11,3,1,1,NULL,NULL,NULL,'test 4','este es un test',200.00,3000.00,'MXN',0,0,'2026-04-03 22:03:53','2026-04-03 22:03:53',1,1),(7,11,3,1,1,'Avenida de los Olivos 3401, 22045 Tijuana, Baja California, Mexico',32.51196057,-117.01500313,'test 4','este es un test',200.00,3000.00,'MXN',30,0,'2026-04-03 22:09:08','2026-04-03 22:44:40',1,1);
/*!40000 ALTER TABLE `property` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_agent`
--

DROP TABLE IF EXISTS `property_agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_agent` (
  `property_id` int NOT NULL,
  `agent_id` int NOT NULL,
  PRIMARY KEY (`property_id`,`agent_id`),
  KEY `fk_property_agent_agent` (`agent_id`),
  CONSTRAINT `fk_property_agent_agent` FOREIGN KEY (`agent_id`) REFERENCES `agent` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_property_agent_property` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_agent`
--

LOCK TABLES `property_agent` WRITE;
/*!40000 ALTER TABLE `property_agent` DISABLE KEYS */;
/*!40000 ALTER TABLE `property_agent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_amenity`
--

DROP TABLE IF EXISTS `property_amenity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_amenity` (
  `property_id` int NOT NULL,
  `amenity_id` int NOT NULL,
  PRIMARY KEY (`property_id`,`amenity_id`),
  KEY `fk_property_amenity_amenity` (`amenity_id`),
  CONSTRAINT `fk_property_amenity_amenity` FOREIGN KEY (`amenity_id`) REFERENCES `amenity` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_property_amenity_property` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_amenity`
--

LOCK TABLES `property_amenity` WRITE;
/*!40000 ALTER TABLE `property_amenity` DISABLE KEYS */;
INSERT INTO `property_amenity` VALUES (7,1),(7,2);
/*!40000 ALTER TABLE `property_amenity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_business_status`
--

DROP TABLE IF EXISTS `property_business_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_business_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_property_business_status_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_business_status`
--

LOCK TABLES `property_business_status` WRITE;
/*!40000 ALTER TABLE `property_business_status` DISABLE KEYS */;
INSERT INTO `property_business_status` VALUES (2,'apartado'),(1,'disponible'),(4,'rentado'),(3,'vendido');
/*!40000 ALTER TABLE `property_business_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_image`
--

DROP TABLE IF EXISTS `property_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_image` (
  `id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_property_image_property_sort` (`property_id`,`sort_order`),
  CONSTRAINT `fk_property_image_property` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_image`
--

LOCK TABLES `property_image` WRITE;
/*!40000 ALTER TABLE `property_image` DISABLE KEYS */;
INSERT INTO `property_image` VALUES (1,3,'/api/public/uploads/1775164268078-740978865-1775164268080.webp',2,'2026-04-02 14:11:08'),(2,3,'/api/public/uploads/1775164268078-597809976-1775164268138.webp',1,'2026-04-02 14:11:08'),(3,4,'/api/public/uploads/1775175733267-97163079-1775175733275.webp',1,'2026-04-02 17:22:13'),(4,4,'/api/public/uploads/1775175733271-79753870-1775175733312.webp',2,'2026-04-02 17:22:13'),(5,1,'http://localhost:3005/api/public/uploads/1775176647114-824560350-1775176647243.webp',1,'2026-04-02 17:37:27'),(6,1,'http://localhost:3005/api/public/uploads/1775176647184-744123344-1775176647426.webp',3,'2026-04-02 17:37:27'),(7,1,'http://localhost:3005/api/public/uploads/1775177815793-846920464-1775177815798.webp',2,'2026-04-02 17:56:55'),(8,7,'http://localhost:3005/api/public/uploads/1775279348820-340342709-1775279348838.webp',1,'2026-04-03 22:09:08');
/*!40000 ALTER TABLE `property_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_industrial`
--

DROP TABLE IF EXISTS `property_industrial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_industrial` (
  `property_id` int NOT NULL,
  `clear_height` decimal(10,2) DEFAULT NULL,
  `docks` int DEFAULT NULL,
  `power_kva` decimal(12,2) DEFAULT NULL,
  `industrial_park` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `floor_resistance` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`property_id`),
  CONSTRAINT `fk_property_industrial_property` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_industrial`
--

LOCK TABLES `property_industrial` WRITE;
/*!40000 ALTER TABLE `property_industrial` DISABLE KEYS */;
/*!40000 ALTER TABLE `property_industrial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_land`
--

DROP TABLE IF EXISTS `property_land`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_land` (
  `property_id` int NOT NULL,
  `land_use` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `frontage` decimal(10,2) DEFAULT NULL,
  `depth` decimal(10,2) DEFAULT NULL,
  `topography` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`property_id`),
  CONSTRAINT `fk_property_land_property` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_land`
--

LOCK TABLES `property_land` WRITE;
/*!40000 ALTER TABLE `property_land` DISABLE KEYS */;
/*!40000 ALTER TABLE `property_land` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_publication_status`
--

DROP TABLE IF EXISTS `property_publication_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_publication_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_property_publication_status_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_publication_status`
--

LOCK TABLES `property_publication_status` WRITE;
/*!40000 ALTER TABLE `property_publication_status` DISABLE KEYS */;
INSERT INTO `property_publication_status` VALUES (1,'activo'),(2,'inactivo');
/*!40000 ALTER TABLE `property_publication_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_residential`
--

DROP TABLE IF EXISTS `property_residential`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_residential` (
  `property_id` int NOT NULL,
  `bedrooms` int DEFAULT NULL,
  `bathrooms` decimal(5,2) DEFAULT NULL,
  `parking` int DEFAULT NULL,
  `pets_allowed` tinyint(1) NOT NULL DEFAULT '0',
  `is_furnished` tinyint(1) NOT NULL DEFAULT '0',
  `age` int DEFAULT NULL,
  PRIMARY KEY (`property_id`),
  CONSTRAINT `fk_property_residential_property` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_residential`
--

LOCK TABLES `property_residential` WRITE;
/*!40000 ALTER TABLE `property_residential` DISABLE KEYS */;
INSERT INTO `property_residential` VALUES (1,NULL,NULL,NULL,0,0,NULL),(2,NULL,NULL,NULL,0,0,NULL),(3,NULL,NULL,NULL,0,0,NULL),(4,NULL,NULL,NULL,0,0,NULL),(7,3,4.00,5,1,1,10);
/*!40000 ALTER TABLE `property_residential` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_status_history`
--

DROP TABLE IF EXISTS `property_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_status_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `publication_status_id` int DEFAULT NULL,
  `business_status_id` int DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `change_notes` text COLLATE utf8mb4_unicode_ci,
  `changed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_property_status_history_publication_status` (`publication_status_id`),
  KEY `fk_property_status_history_business_status` (`business_status_id`),
  KEY `fk_property_status_history_user` (`changed_by`),
  KEY `idx_property_status_history_property` (`property_id`),
  KEY `idx_property_status_history_changed_at` (`changed_at`),
  CONSTRAINT `fk_property_status_history_business_status` FOREIGN KEY (`business_status_id`) REFERENCES `property_business_status` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_property_status_history_property` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_property_status_history_publication_status` FOREIGN KEY (`publication_status_id`) REFERENCES `property_publication_status` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_property_status_history_user` FOREIGN KEY (`changed_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_status_history`
--

LOCK TABLES `property_status_history` WRITE;
/*!40000 ALTER TABLE `property_status_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `property_status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_transaction`
--

DROP TABLE IF EXISTS `property_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_transaction` (
  `id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `customer_id` int NOT NULL,
  `transaction_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `final_price` decimal(14,2) DEFAULT NULL,
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_by` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_property_transaction_user` (`created_by`),
  KEY `idx_property_transaction_property` (`property_id`),
  KEY `idx_property_transaction_customer` (`customer_id`),
  KEY `idx_property_transaction_type` (`transaction_type`),
  KEY `idx_property_transaction_date` (`transaction_date`),
  CONSTRAINT `fk_property_transaction_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_property_transaction_property` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_property_transaction_user` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_property_transaction_currency` CHECK ((`currency` in (_utf8mb4'USD',_utf8mb4'MXN'))),
  CONSTRAINT `chk_property_transaction_type` CHECK ((`transaction_type` in (_utf8mb4'apartado',_utf8mb4'venta',_utf8mb4'renta')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_transaction`
--

LOCK TABLES `property_transaction` WRITE;
/*!40000 ALTER TABLE `property_transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `property_transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_type`
--

DROP TABLE IF EXISTS `property_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_property_type_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_type`
--

LOCK TABLES `property_type` WRITE;
/*!40000 ALTER TABLE `property_type` DISABLE KEYS */;
INSERT INTO `property_type` VALUES (11,'Casa'),(12,'Departamento'),(9,'Nave Industrial'),(10,'Terreno');
/*!40000 ALTER TABLE `property_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_visit_log`
--

DROP TABLE IF EXISTS `property_visit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_visit_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visited_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_property_visit_log_property_date` (`property_id`,`visited_at`),
  CONSTRAINT `fk_property_visit_log_property` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_visit_log`
--

LOCK TABLES `property_visit_log` WRITE;
/*!40000 ALTER TABLE `property_visit_log` DISABLE KEYS */;
INSERT INTO `property_visit_log` VALUES (1,7,NULL,NULL,'2026-04-03 22:16:33'),(2,7,NULL,NULL,'2026-04-03 22:16:33'),(3,7,NULL,NULL,'2026-04-03 22:34:21'),(4,7,NULL,NULL,'2026-04-03 22:34:21'),(5,7,NULL,NULL,'2026-04-03 22:34:38'),(6,7,NULL,NULL,'2026-04-03 22:34:39'),(7,7,NULL,NULL,'2026-04-03 22:34:57'),(8,7,NULL,NULL,'2026-04-03 22:34:57'),(9,7,NULL,NULL,'2026-04-03 22:35:07'),(10,7,NULL,NULL,'2026-04-03 22:35:07'),(11,7,NULL,NULL,'2026-04-03 22:35:25'),(12,7,NULL,NULL,'2026-04-03 22:35:25'),(13,7,NULL,NULL,'2026-04-03 22:35:32'),(14,7,NULL,NULL,'2026-04-03 22:35:32'),(15,7,NULL,NULL,'2026-04-03 22:36:14'),(16,7,NULL,NULL,'2026-04-03 22:36:14'),(17,7,NULL,NULL,'2026-04-03 22:36:23'),(18,7,NULL,NULL,'2026-04-03 22:36:23'),(19,7,NULL,NULL,'2026-04-03 22:36:34'),(20,7,NULL,NULL,'2026-04-03 22:36:34'),(21,7,NULL,NULL,'2026-04-03 22:36:58'),(22,7,NULL,NULL,'2026-04-03 22:36:58'),(23,7,NULL,NULL,'2026-04-03 22:37:13'),(24,7,NULL,NULL,'2026-04-03 22:37:13'),(25,7,NULL,NULL,'2026-04-03 22:37:41'),(26,7,NULL,NULL,'2026-04-03 22:37:41'),(27,7,NULL,NULL,'2026-04-03 22:37:45'),(28,7,NULL,NULL,'2026-04-03 22:37:45'),(29,7,NULL,NULL,'2026-04-03 22:44:39'),(30,7,NULL,NULL,'2026-04-03 22:44:40');
/*!40000 ALTER TABLE `property_visit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (2,'admin'),(4,'marketing'),(3,'sales_agent'),(1,'super_admin'),(5,'viewer');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service` (
  `id` int NOT NULL AUTO_INCREMENT,
  `service_title` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `service_description` text COLLATE utf8mb4_unicode_ci,
  `icon_tag` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statistic`
--

DROP TABLE IF EXISTS `statistic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `statistic` (
  `id` int NOT NULL AUTO_INCREMENT,
  `stat_value` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stat_description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic`
--

LOCK TABLES `statistic` WRITE;
/*!40000 ALTER TABLE `statistic` DISABLE KEYS */;
/*!40000 ALTER TABLE `statistic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testimonial`
--

DROP TABLE IF EXISTS `testimonial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `testimonial` (
  `id` int NOT NULL AUTO_INCREMENT,
  `author_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `author_role` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quote_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testimonial`
--

LOCK TABLES `testimonial` WRITE;
/*!40000 ALTER TABLE `testimonial` DISABLE KEYS */;
/*!40000 ALTER TABLE `testimonial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role_id` int NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `last_login_at` datetime DEFAULT NULL,
  `failed_login_attempts` int NOT NULL DEFAULT '0',
  `locked_until` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_username` (`username`),
  UNIQUE KEY `uk_user_email` (`email`),
  KEY `idx_user_login_lookup` (`username`,`email`),
  KEY `idx_user_role` (`role_id`),
  CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','$2b$10$replace_this_with_real_bcrypt_hash','System Administrator','admin@kintok.com',1,1,NULL,0,NULL,'2026-04-01 15:34:39','2026-04-01 15:34:39'),(2,'christopher','$2b$10$JZKNMtSWDjFNopbHIV1BDOptVw0OfSyzjDyO1jviW6rCOputm9Cta\n','Christopher Sandoval','christopher.sandoval93@gmail.com',1,1,'2026-04-07 17:46:32',0,NULL,'2026-04-01 16:40:31','2026-04-07 17:46:32');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zone`
--

DROP TABLE IF EXISTS `zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zone` (
  `id` int NOT NULL AUTO_INCREMENT,
  `city_id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_zone_city_name` (`city_id`,`name`),
  CONSTRAINT `fk_zone_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zone`
--

LOCK TABLES `zone` WRITE;
/*!40000 ALTER TABLE `zone` DISABLE KEYS */;
INSERT INTO `zone` VALUES (1,1,'Otay');
/*!40000 ALTER TABLE `zone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'kintok'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_convert_to_base` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_convert_to_base`(
    p_amount DECIMAL(14,2),
    p_from_currency CHAR(3),
    p_to_currency CHAR(3)
) RETURNS decimal(18,6)
    READS SQL DATA
BEGIN
    DECLARE v_rate DECIMAL(18,6);

    IF p_amount IS NULL THEN
        RETURN NULL;
    END IF;

    IF p_from_currency = p_to_currency THEN
        RETURN p_amount;
    END IF;

    SELECT er.rate
      INTO v_rate
      FROM exchange_rate er
     WHERE er.base_currency = p_from_currency
       AND er.target_currency = p_to_currency
     ORDER BY er.updated_at DESC, er.id DESC
     LIMIT 1;

    IF v_rate IS NOT NULL THEN
        RETURN p_amount * v_rate;
    END IF;

    SELECT er.rate
      INTO v_rate
      FROM exchange_rate er
     WHERE er.base_currency = p_to_currency
       AND er.target_currency = p_from_currency
     ORDER BY er.updated_at DESC, er.id DESC
     LIMIT 1;

    IF v_rate IS NOT NULL AND v_rate <> 0 THEN
        RETURN p_amount / v_rate;
    END IF;

    RETURN NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_format_price` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_format_price`(
    p_amount DECIMAL(14,2),
    p_currency CHAR(3)
) RETURNS varchar(50) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci
    DETERMINISTIC
BEGIN
    DECLARE v_symbol VARCHAR(5);

    SET v_symbol = CASE
        WHEN p_currency = 'USD' THEN '$'
        WHEN p_currency = 'MXN' THEN '$'
        ELSE ''
    END;

    RETURN CONCAT(v_symbol, FORMAT(IFNULL(p_amount, 0), 2), ' ', p_currency);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `agent_list_team` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `agent_list_team`(
    IN p_page_number INT,
    IN p_page_size INT
)
BEGIN
    DECLARE v_offset INT DEFAULT 0;
    DECLARE v_total_records INT DEFAULT 0;
    DECLARE v_total_pages INT DEFAULT 0;

    IF p_page_number IS NULL OR p_page_number < 1 THEN
        SET p_page_number = 1;
    END IF;

    IF p_page_size IS NULL OR p_page_size < 1 THEN
        SET p_page_size = 10;
    END IF;

    SET v_offset = (p_page_number - 1) * p_page_size;

    SELECT COUNT(*)
      INTO v_total_records
    FROM agent
    WHERE is_active = b'1';

    SET v_total_pages = CEIL(v_total_records / p_page_size);

    SELECT
        v_total_records AS total_records,
        p_page_number AS page_number,
        p_page_size AS page_size,
        v_total_pages AS total_pages;

    SELECT
        id,
        full_name,
        email,
        phone,
        bio,
        image_url
    FROM agent
    WHERE is_active = b'1'
    ORDER BY full_name
    LIMIT p_page_size OFFSET v_offset;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `amenity_upsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `amenity_upsert`(
    IN p_id INT,
    IN p_name VARCHAR(100)
)
BEGIN
    IF p_id IS NULL OR p_id = 0 THEN
        INSERT INTO amenity (name)
        VALUES (p_name);

        SELECT LAST_INSERT_ID() AS amenity_id;
    ELSE
        UPDATE amenity
           SET name = p_name
         WHERE id = p_id;

        SELECT p_id AS amenity_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `city_upsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `city_upsert`(
    IN p_id INT,
    IN p_name VARCHAR(100)
)
BEGIN
    IF p_id IS NULL OR p_id = 0 THEN
        INSERT INTO city (name)
        VALUES (p_name);

        SELECT LAST_INSERT_ID() AS city_id;
    ELSE
        UPDATE city
           SET name = p_name
         WHERE id = p_id;

        SELECT p_id AS city_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_list`(
    IN p_search_text VARCHAR(150),
    IN p_page_number INT,
    IN p_page_size INT
)
BEGIN
    DECLARE v_offset INT DEFAULT 0;
    DECLARE v_total_records INT DEFAULT 0;
    DECLARE v_total_pages INT DEFAULT 0;

    -- Validaciones
    IF p_page_number IS NULL OR p_page_number < 1 THEN
        SET p_page_number = 1;
    END IF;

    IF p_page_size IS NULL OR p_page_size < 1 THEN
        SET p_page_size = 10;
    END IF;

    SET v_offset = (p_page_number - 1) * p_page_size;

    -- TOTAL
    SELECT COUNT(*)
      INTO v_total_records
    FROM customer c
    WHERE (
        p_search_text IS NULL
        OR p_search_text = ''
        OR c.full_name LIKE CONCAT('%', p_search_text, '%')
        OR c.email LIKE CONCAT('%', p_search_text, '%')
        OR c.phone LIKE CONCAT('%', p_search_text, '%')
    );

    SET v_total_pages = CEIL(v_total_records / p_page_size);

    -- METADATA
    SELECT
        v_total_records AS total_records,
        p_page_number AS page_number,
        p_page_size AS page_size,
        v_total_pages AS total_pages;

    -- DATA
    SELECT
        c.id,
        c.full_name,
        c.email,
        c.phone,
        c.customer_type,
        c.notes,
        c.created_at,
        c.updated_at
    FROM customer c
    WHERE (
        p_search_text IS NULL
        OR p_search_text = ''
        OR c.full_name LIKE CONCAT('%', p_search_text, '%')
        OR c.email LIKE CONCAT('%', p_search_text, '%')
        OR c.phone LIKE CONCAT('%', p_search_text, '%')
    )
    ORDER BY c.created_at DESC, c.id DESC
    LIMIT p_page_size OFFSET v_offset;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_upsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_upsert`(
    IN p_id INT,
    IN p_full_name VARCHAR(150),
    IN p_email VARCHAR(150),
    IN p_phone VARCHAR(50),
    IN p_customer_type VARCHAR(50),
    IN p_notes TEXT
)
BEGIN
    DECLARE v_customer_id INT;

    IF p_id IS NULL OR p_id = 0 THEN
        INSERT INTO customer (
            full_name,
            email,
            phone,
            customer_type,
            notes
        )
        VALUES (
            p_full_name,
            p_email,
            p_phone,
            p_customer_type,
            p_notes
        );

        SET v_customer_id = LAST_INSERT_ID();
    ELSE
        UPDATE customer
           SET full_name = p_full_name,
               email = p_email,
               phone = p_phone,
               customer_type = p_customer_type,
               notes = p_notes
         WHERE id = p_id;

        SET v_customer_id = p_id;
    END IF;

    SELECT v_customer_id AS customer_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `home_content_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `home_content_get`()
BEGIN
    SELECT id, stat_value, stat_description, sort_order
    FROM statistic
    ORDER BY sort_order, id;

    SELECT id, author_name, author_role, quote_text, avatar_url, is_active, sort_order
    FROM testimonial
    WHERE is_active = b'1'
    ORDER BY sort_order, id;

    SELECT id, service_title, service_description, icon_tag, sort_order
    FROM service
    ORDER BY sort_order, id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lead_contact_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lead_contact_list`(
    IN p_status VARCHAR(50),
    IN p_page_number INT,
    IN p_page_size INT
)
BEGIN
    DECLARE v_offset INT DEFAULT 0;
    DECLARE v_total_records INT DEFAULT 0;
    DECLARE v_total_pages INT DEFAULT 0;

    IF p_page_number IS NULL OR p_page_number < 1 THEN
        SET p_page_number = 1;
    END IF;

    IF p_page_size IS NULL OR p_page_size < 1 THEN
        SET p_page_size = 10;
    END IF;

    SET v_offset = (p_page_number - 1) * p_page_size;

    SELECT COUNT(*)
      INTO v_total_records
    FROM lead_contact l
    WHERE (p_status IS NULL OR p_status = '' OR l.status = p_status);

    SET v_total_pages = CEIL(v_total_records / p_page_size);

    SELECT
        v_total_records AS total_records,
        p_page_number AS page_number,
        p_page_size AS page_size,
        v_total_pages AS total_pages;

    SELECT
        l.id,
        l.property_id,
        p.title AS property_title,
        l.name,
        l.email,
        l.phone,
        l.comments,
        l.status,
        l.created_at,
        l.updated_at
    FROM lead_contact l
    INNER JOIN property p ON p.id = l.property_id
    WHERE (p_status IS NULL OR p_status = '' OR l.status = p_status)
    ORDER BY l.created_at DESC, l.id DESC
    LIMIT p_page_size OFFSET v_offset;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lead_contact_list_with_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lead_contact_list_with_customer`(
    IN p_status VARCHAR(50),
    IN p_page_number INT,
    IN p_page_size INT
)
BEGIN
    DECLARE v_offset INT DEFAULT 0;
    DECLARE v_total_records INT DEFAULT 0;
    DECLARE v_total_pages INT DEFAULT 0;

    IF p_page_number IS NULL OR p_page_number < 1 THEN
        SET p_page_number = 1;
    END IF;

    IF p_page_size IS NULL OR p_page_size < 1 THEN
        SET p_page_size = 10;
    END IF;

    SET v_offset = (p_page_number - 1) * p_page_size;

    SELECT COUNT(*)
      INTO v_total_records
    FROM lead_contact l
    WHERE (
        p_status IS NULL
        OR p_status = ''
        OR l.status = p_status
    );

    SET v_total_pages = CEIL(v_total_records / p_page_size);

    SELECT
        v_total_records AS total_records,
        p_page_number AS page_number,
        p_page_size AS page_size,
        v_total_pages AS total_pages;

    SELECT
        l.id,
        l.property_id,
        p.title AS property_title,
        l.name,
        l.email,
        l.phone,
        l.comments,
        l.status,
        l.customer_id,
        c.full_name AS customer_name,
        c.email AS customer_email,
        c.phone AS customer_phone,
        CASE
            WHEN l.customer_id IS NULL THEN 0
            ELSE 1
        END AS is_converted,
        l.created_at,
        l.updated_at
    FROM lead_contact l
    INNER JOIN property p ON p.id = l.property_id
    LEFT JOIN customer c ON c.id = l.customer_id
    WHERE (
        p_status IS NULL
        OR p_status = ''
        OR l.status = p_status
    )
    ORDER BY l.created_at DESC, l.id DESC
    LIMIT p_page_size OFFSET v_offset;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lead_contact_register` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lead_contact_register`(
    IN p_property_id INT,
    IN p_name VARCHAR(150),
    IN p_email VARCHAR(150),
    IN p_phone VARCHAR(50),
    IN p_comments TEXT
)
BEGIN
    INSERT INTO lead_contact (
        property_id,
        name,
        email,
        phone,
        comments,
        status,
        created_at,
        updated_at
    )
    VALUES (
        p_property_id,
        p_name,
        p_email,
        p_phone,
        p_comments,
        'new',
        NOW(),
        NOW()
    );

    SELECT LAST_INSERT_ID() AS lead_contact_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lead_contact_status_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lead_contact_status_update`(
    IN p_lead_contact_id INT,
    IN p_status VARCHAR(50)
)
BEGIN
    UPDATE lead_contact
       SET status = p_status,
           updated_at = NOW()
     WHERE id = p_lead_contact_id;

    SELECT ROW_COUNT() AS affected_rows;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_get_detail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_get_detail`(IN p_property_id INT)
BEGIN
    SELECT
        p.*,
        pt.name AS property_type,
        o.name AS operation,
        c.name AS city,
        z.name AS zone,
        pps.name AS publication_status,
        pbs.name AS business_status,
        fn_format_price(p.price_value, p.currency) AS formatted_price
    FROM property p
    INNER JOIN property_type pt ON pt.id = p.property_type_id
    INNER JOIN operation o ON o.id = p.operation_id
    INNER JOIN city c ON c.id = p.city_id
    INNER JOIN zone z ON z.id = p.zone_id
    INNER JOIN property_publication_status pps ON pps.id = p.publication_status_id
    INNER JOIN property_business_status pbs ON pbs.id = p.business_status_id
    WHERE p.id = p_property_id;

    SELECT * FROM property_industrial WHERE property_id = p_property_id;
    SELECT * FROM property_residential WHERE property_id = p_property_id;
    SELECT * FROM property_land WHERE property_id = p_property_id;

    SELECT
        a.id,
        a.name
    FROM property_amenity pa
    INNER JOIN amenity a ON a.id = pa.amenity_id
    WHERE pa.property_id = p_property_id
    ORDER BY a.name;

    SELECT
        id,
        property_id,
        image_url,
        sort_order
    FROM property_image
    WHERE property_id = p_property_id
    ORDER BY sort_order, id;

    SELECT
        ag.id,
        ag.full_name,
        ag.email,
        ag.phone,
        ag.bio,
        ag.image_url
    FROM property_agent pag
    INNER JOIN agent ag ON ag.id = pag.agent_id
    WHERE pag.property_id = p_property_id
      AND ag.is_active = b'1'
    ORDER BY ag.full_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_image_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_image_add`(
    IN p_property_id INT,
    IN p_image_url VARCHAR(500),
    IN p_sort_order INT
)
BEGIN
    DECLARE v_next_sort_order INT;

    IF p_sort_order IS NULL OR p_sort_order <= 0 THEN
        SELECT COALESCE(MAX(sort_order), 0) + 1
        INTO v_next_sort_order
        FROM property_image
        WHERE property_id = p_property_id;

        SET p_sort_order = v_next_sort_order;
    ELSE
        UPDATE property_image
        SET sort_order = sort_order + 1
        WHERE property_id = p_property_id
          AND sort_order >= p_sort_order;
    END IF;

    INSERT INTO property_image (
        property_id,
        image_url,
        sort_order
    )
    VALUES (
        p_property_id,
        p_image_url,
        p_sort_order
    );

    SELECT LAST_INSERT_ID() AS property_image_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_image_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_image_delete`(
    IN p_image_id INT
)
BEGIN
    DECLARE v_property_id INT;
    DECLARE v_sort_order INT;

    SELECT property_id, sort_order
    INTO v_property_id, v_sort_order
    FROM property_image
    WHERE id = p_image_id;

    DELETE FROM property_image
    WHERE id = p_image_id;

    UPDATE property_image
    SET sort_order = sort_order - 1
    WHERE property_id = v_property_id
      AND sort_order > v_sort_order;

    SELECT ROW_COUNT() AS reordered_rows;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_image_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_image_list`(
    IN p_property_id INT
)
BEGIN
    SELECT
        id,
        property_id,
        image_url,
        sort_order,
        created_at
    FROM property_image
    WHERE property_id = p_property_id
    ORDER BY sort_order ASC, id ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_image_reorder_all` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_image_reorder_all`(
    IN p_property_id INT,
    IN p_json_orders JSON
)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE v_length INT;

    SET v_length = JSON_LENGTH(p_json_orders);

    WHILE i < v_length DO

        UPDATE property_image
        SET sort_order = JSON_UNQUOTE(
            JSON_EXTRACT(p_json_orders, CONCAT('$[', i, '].order'))
        )
        WHERE id = JSON_UNQUOTE(
            JSON_EXTRACT(p_json_orders, CONCAT('$[', i, '].id'))
        )
        AND property_id = p_property_id;

        SET i = i + 1;

    END WHILE;

    SELECT *
    FROM property_image
    WHERE property_id = p_property_id
    ORDER BY sort_order, id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_image_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_image_update`(
    IN p_image_id INT,
    IN p_image_url VARCHAR(500)
)
BEGIN
    UPDATE property_image
    SET image_url = p_image_url
    WHERE id = p_image_id;

    SELECT ROW_COUNT() AS affected_rows;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_image_update_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_image_update_order`(
    IN p_image_id INT,
    IN p_new_sort_order INT
)
BEGIN
    DECLARE v_property_id INT;
    DECLARE v_current_order INT;
    DECLARE v_max_order INT;

    SELECT property_id, sort_order
    INTO v_property_id, v_current_order
    FROM property_image
    WHERE id = p_image_id;

    SELECT MAX(sort_order)
    INTO v_max_order
    FROM property_image
    WHERE property_id = v_property_id;

    IF p_new_sort_order < 1 THEN
        SET p_new_sort_order = 1;
    END IF;

    IF p_new_sort_order > v_max_order THEN
        SET p_new_sort_order = v_max_order;
    END IF;

    IF v_current_order <> p_new_sort_order THEN

        IF p_new_sort_order < v_current_order THEN
            UPDATE property_image
            SET sort_order = sort_order + 1
            WHERE property_id = v_property_id
              AND sort_order >= p_new_sort_order
              AND sort_order < v_current_order;
        ELSE
            UPDATE property_image
            SET sort_order = sort_order - 1
            WHERE property_id = v_property_id
              AND sort_order <= p_new_sort_order
              AND sort_order > v_current_order;
        END IF;

        UPDATE property_image
        SET sort_order = p_new_sort_order
        WHERE id = p_image_id;

    END IF;

    SELECT *
    FROM property_image
    WHERE property_id = v_property_id
    ORDER BY sort_order, id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_list_featured` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_list_featured`(
    IN p_page_number INT,
    IN p_page_size INT
)
BEGIN
    DECLARE v_offset INT DEFAULT 0;
    DECLARE v_total_records INT DEFAULT 0;
    DECLARE v_total_pages INT DEFAULT 0;
    DECLARE v_active_publication_status_id INT;

    SELECT id
      INTO v_active_publication_status_id
    FROM property_publication_status
    WHERE name = 'activo'
    LIMIT 1;

    IF p_page_number IS NULL OR p_page_number < 1 THEN
        SET p_page_number = 1;
    END IF;

    IF p_page_size IS NULL OR p_page_size < 1 THEN
        SET p_page_size = 10;
    END IF;

    SET v_offset = (p_page_number - 1) * p_page_size;

    SELECT COUNT(*)
      INTO v_total_records
    FROM property p
    WHERE p.is_featured = b'1'
      AND p.publication_status_id = v_active_publication_status_id;

    SET v_total_pages = CEIL(v_total_records / p_page_size);

    SELECT
        v_total_records AS total_records,
        p_page_number AS page_number,
        p_page_size AS page_size,
        v_total_pages AS total_pages;

    SELECT
        p.id,
        p.title,
        p.description,
        p.area_value,
        p.price_value,
        p.currency,
        fn_format_price(p.price_value, p.currency) AS formatted_price,
        p.views_count,
        p.is_featured,
        pbs.name AS business_status,
        pps.name AS publication_status,
        pt.name AS property_type,
        o.name AS operation,
        c.name AS city,
        z.name AS zone,
        (
            SELECT pi.image_url
            FROM property_image pi
            WHERE pi.property_id = p.id
            ORDER BY pi.sort_order, pi.id
            LIMIT 1
        ) AS main_image_url
    FROM property p
    INNER JOIN property_type pt ON pt.id = p.property_type_id
    INNER JOIN operation o ON o.id = p.operation_id
    INNER JOIN city c ON c.id = p.city_id
    INNER JOIN zone z ON z.id = p.zone_id
    INNER JOIN property_publication_status pps ON pps.id = p.publication_status_id
    INNER JOIN property_business_status pbs ON pbs.id = p.business_status_id
    WHERE p.is_featured = b'1'
      AND p.publication_status_id = v_active_publication_status_id
    ORDER BY p.created_at DESC, p.id DESC
    LIMIT p_page_size OFFSET v_offset;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_search` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_search`(
    IN p_property_type_id   INT,
    IN p_operation_id       INT,
    IN p_city_id            INT,
    IN p_zone_id            INT,
    IN p_min_area           DECIMAL(14,2),
    IN p_max_area           DECIMAL(14,2),
    IN p_min_price          DECIMAL(14,2),
    IN p_max_price          DECIMAL(14,2),
    IN p_target_currency    CHAR(3),
    IN p_featured_only      TINYINT,
    IN p_search_text        VARCHAR(255),
    -- Advanced: Residential
    IN p_min_bedrooms       INT,
    IN p_min_bathrooms      INT,
    IN p_min_parking        INT,
    IN p_pets_allowed       TINYINT,
    -- Advanced: Industrial
    IN p_min_clear_height   DECIMAL(10,2),
    IN p_min_docks          INT,
    IN p_min_power_kva      DECIMAL(12,2),
    IN p_industrial_park    TINYINT,
    -- Advanced: Land
    IN p_land_use           VARCHAR(150),
    -- Amenities (comma-separated names, e.g. 'Alberca,Gimnasio')
    IN p_amenities          VARCHAR(500),
    -- Pagination
    IN p_page_number        INT,
    IN p_page_size          INT
)
BEGIN
    DECLARE v_offset        INT DEFAULT 0;
    DECLARE v_total_records INT DEFAULT 0;
    DECLARE v_total_pages   INT DEFAULT 0;
    DECLARE v_target_curr   CHAR(3);
    DECLARE v_amenity_count INT DEFAULT 0;

    -- Defaults
    IF p_page_number IS NULL OR p_page_number < 1 THEN SET p_page_number = 1; END IF;
    IF p_page_size   IS NULL OR p_page_size   < 1 THEN SET p_page_size   = 10; END IF;
    SET v_offset = (p_page_number - 1) * p_page_size;
    SET v_target_curr = COALESCE(p_target_currency, 'MXN');

    -- Count how many amenities are requested
    IF p_amenities IS NOT NULL AND p_amenities != '' THEN
        SET v_amenity_count = LENGTH(p_amenities) - LENGTH(REPLACE(p_amenities, ',', '')) + 1;
    END IF;

    -- ── COUNT ──
    SELECT COUNT(DISTINCT p.id)
      INTO v_total_records
    FROM property p
    JOIN property_publication_status pps ON pps.id = p.publication_status_id
    LEFT JOIN property_residential pr   ON pr.property_id = p.id
    LEFT JOIN property_industrial  pi   ON pi.property_id = p.id
    LEFT JOIN property_land        pl   ON pl.property_id = p.id
    WHERE pps.name = 'activo'
      AND (p_property_type_id IS NULL OR p.property_type_id = p_property_type_id)
      AND (p_operation_id     IS NULL OR p.operation_id     = p_operation_id)
      AND (p_city_id          IS NULL OR p.city_id          = p_city_id)
      AND (p_zone_id          IS NULL OR p.zone_id          = p_zone_id)
      AND (p_min_area         IS NULL OR p.area_value      >= p_min_area)
      AND (p_max_area         IS NULL OR p.area_value      <= p_max_area)
      AND (p_min_price        IS NULL OR p.price_value     >= p_min_price)
      AND (p_max_price        IS NULL OR p.price_value     <= p_max_price)
      AND (p_featured_only    IS NULL OR p_featured_only = 0 OR p.is_featured = 1)
      AND (p_search_text      IS NULL OR p_search_text = ''
           OR p.title       LIKE CONCAT('%', p_search_text, '%')
           OR p.description LIKE CONCAT('%', p_search_text, '%'))
      -- Residential filters
      AND (p_min_bedrooms     IS NULL OR pr.bedrooms     >= p_min_bedrooms)
      AND (p_min_bathrooms    IS NULL OR pr.bathrooms    >= p_min_bathrooms)
      AND (p_min_parking      IS NULL OR pr.parking      >= p_min_parking)
      AND (p_pets_allowed     IS NULL OR p_pets_allowed = 0 OR pr.pets_allowed = 1)
      -- Industrial filters
      AND (p_min_clear_height IS NULL OR pi.clear_height >= p_min_clear_height)
      AND (p_min_docks        IS NULL OR pi.docks        >= p_min_docks)
      AND (p_min_power_kva    IS NULL OR pi.power_kva    >= p_min_power_kva)
      AND (p_industrial_park  IS NULL OR p_industrial_park = 0 OR (pi.industrial_park IS NOT NULL AND pi.industrial_park != ''))
      -- Land filters
      AND (p_land_use         IS NULL OR p_land_use = '' OR pl.land_use = p_land_use)
      -- Amenity filter: property must have ALL requested amenities
      AND (v_amenity_count = 0 OR (
          SELECT COUNT(DISTINCT a.name)
          FROM property_amenity pa
          JOIN amenity a ON a.id = pa.amenity_id
          WHERE pa.property_id = p.id
            AND FIND_IN_SET(a.name, p_amenities) > 0
      ) >= v_amenity_count);

    SET v_total_pages = CEIL(v_total_records / p_page_size);

    -- ── META ──
    SELECT
        v_total_records  AS total_records,
        p_page_number    AS page_number,
        p_page_size      AS page_size,
        v_total_pages    AS total_pages,
        v_target_curr    AS target_currency;

    -- ── DATA ──
    SELECT
        p.id,
        p.property_type_id,
        p.operation_id,
        p.city_id,
        p.zone_id,
        p.title,
        p.description,
        p.area_value,
        p.price_value   AS original_price,
        p.currency      AS original_currency,
        CONCAT('$', FORMAT(p.price_value, 2), ' ', p.currency) AS formatted_original_price,
        CASE
            WHEN p.currency = v_target_curr THEN p.price_value
            WHEN p.currency = 'USD' AND v_target_curr = 'MXN' THEN p.price_value * 17.5
            WHEN p.currency = 'MXN' AND v_target_curr = 'USD' THEN p.price_value / 17.5
            ELSE p.price_value
        END AS normalized_price,
        CONCAT('$', FORMAT(
            CASE
                WHEN p.currency = v_target_curr THEN p.price_value
                WHEN p.currency = 'USD' AND v_target_curr = 'MXN' THEN p.price_value * 17.5
                WHEN p.currency = 'MXN' AND v_target_curr = 'USD' THEN p.price_value / 17.5
                ELSE p.price_value
            END, 2), ' ', v_target_curr) AS formatted_normalized_price,
        p.views_count,
        p.is_featured,
        p.created_at,
        p.updated_at,
        pt.name         AS property_type_name,
        o.name          AS operation_name,
        c.name          AS city_name,
        z.name          AS zone_name,
        pps.name        AS publication_status,
        pbs.name        AS business_status,
        (SELECT pi2.image_url FROM property_image pi2
         WHERE pi2.property_id = p.id ORDER BY pi2.sort_order ASC LIMIT 1) AS main_image_url
    FROM property p
    JOIN property_type               pt  ON pt.id  = p.property_type_id
    JOIN operation                   o   ON o.id   = p.operation_id
    JOIN city                        c   ON c.id   = p.city_id
    LEFT JOIN zone                   z   ON z.id   = p.zone_id
    JOIN property_publication_status pps ON pps.id = p.publication_status_id
    JOIN property_business_status    pbs ON pbs.id = p.business_status_id
    LEFT JOIN property_residential   pr  ON pr.property_id = p.id
    LEFT JOIN property_industrial    pi  ON pi.property_id = p.id
    LEFT JOIN property_land          pl  ON pl.property_id = p.id
    WHERE pps.name = 'activo'
      AND (p_property_type_id IS NULL OR p.property_type_id = p_property_type_id)
      AND (p_operation_id     IS NULL OR p.operation_id     = p_operation_id)
      AND (p_city_id          IS NULL OR p.city_id          = p_city_id)
      AND (p_zone_id          IS NULL OR p.zone_id          = p_zone_id)
      AND (p_min_area         IS NULL OR p.area_value      >= p_min_area)
      AND (p_max_area         IS NULL OR p.area_value      <= p_max_area)
      AND (p_min_price        IS NULL OR p.price_value     >= p_min_price)
      AND (p_max_price        IS NULL OR p.price_value     <= p_max_price)
      AND (p_featured_only    IS NULL OR p_featured_only = 0 OR p.is_featured = 1)
      AND (p_search_text      IS NULL OR p_search_text = ''
           OR p.title       LIKE CONCAT('%', p_search_text, '%')
           OR p.description LIKE CONCAT('%', p_search_text, '%'))
      -- Residential
      AND (p_min_bedrooms     IS NULL OR pr.bedrooms     >= p_min_bedrooms)
      AND (p_min_bathrooms    IS NULL OR pr.bathrooms    >= p_min_bathrooms)
      AND (p_min_parking      IS NULL OR pr.parking      >= p_min_parking)
      AND (p_pets_allowed     IS NULL OR p_pets_allowed = 0 OR pr.pets_allowed = 1)
      -- Industrial
      AND (p_min_clear_height IS NULL OR pi.clear_height >= p_min_clear_height)
      AND (p_min_docks        IS NULL OR pi.docks        >= p_min_docks)
      AND (p_min_power_kva    IS NULL OR pi.power_kva    >= p_min_power_kva)
      AND (p_industrial_park  IS NULL OR p_industrial_park = 0 OR (pi.industrial_park IS NOT NULL AND pi.industrial_park != ''))
      -- Land
      AND (p_land_use         IS NULL OR p_land_use = '' OR pl.land_use = p_land_use)
      -- Amenities
      AND (v_amenity_count = 0 OR (
          SELECT COUNT(DISTINCT a.name)
          FROM property_amenity pa
          JOIN amenity a ON a.id = pa.amenity_id
          WHERE pa.property_id = p.id
            AND FIND_IN_SET(a.name, p_amenities) > 0
      ) >= v_amenity_count)
    ORDER BY p.created_at DESC
    LIMIT p_page_size OFFSET v_offset;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_status_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_status_update`(
    IN p_property_id INT,
    IN p_publication_status_id INT,
    IN p_business_status_id INT,
    IN p_changed_by INT,
    IN p_change_notes TEXT
)
BEGIN
    UPDATE property
       SET publication_status_id = COALESCE(p_publication_status_id, publication_status_id),
           business_status_id = COALESCE(p_business_status_id, business_status_id)
     WHERE id = p_property_id;

    INSERT INTO property_status_history (
        property_id,
        publication_status_id,
        business_status_id,
        changed_by,
        change_notes
    )
    VALUES (
        p_property_id,
        p_publication_status_id,
        p_business_status_id,
        p_changed_by,
        p_change_notes
    );

    SELECT ROW_COUNT() AS affected_rows;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_transaction_list_by_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_transaction_list_by_customer`(
    IN p_customer_id INT
)
BEGIN
    SELECT
        pt.id,
        pt.property_id,
        p.title AS property_title,
        c.id AS customer_id,
        c.full_name AS customer_name,
        pt.transaction_type,
        pt.final_price,
        pt.currency,
        pt.transaction_date,
        pt.notes,
        u.full_name AS registered_by
    FROM property_transaction pt
    INNER JOIN property p ON p.id = pt.property_id
    INNER JOIN customer c ON c.id = pt.customer_id
    LEFT JOIN `user` u ON u.id = pt.created_by
    WHERE pt.customer_id = p_customer_id
    ORDER BY pt.transaction_date DESC, pt.id DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_transaction_list_by_property` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_transaction_list_by_property`(
    IN p_property_id INT
)
BEGIN
    SELECT
        pt.id,
        pt.property_id,
        p.title AS property_title,
        c.id AS customer_id,
        c.full_name AS customer_name,
        c.email AS customer_email,
        c.phone AS customer_phone,
        c.customer_type,
        pt.transaction_type,
        pt.final_price,
        pt.currency,
        pt.transaction_date,
        pt.notes,
        u.full_name AS registered_by,
        pt.created_at
    FROM property_transaction pt
    INNER JOIN property p ON p.id = pt.property_id
    INNER JOIN customer c ON c.id = pt.customer_id
    LEFT JOIN `user` u ON u.id = pt.created_by
    WHERE pt.property_id = p_property_id
    ORDER BY pt.transaction_date DESC, pt.id DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_transaction_register` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_transaction_register`(
    IN p_property_id INT,
    IN p_customer_id INT,
    IN p_transaction_type VARCHAR(20), -- apartado, venta, renta
    IN p_final_price DECIMAL(14,2),
    IN p_currency CHAR(3),
    IN p_notes TEXT,
    IN p_created_by INT
)
BEGIN
    DECLARE v_business_status_id INT;
    DECLARE v_publication_status_id INT;

    -- Resolver business status según tipo de transacción
    IF p_transaction_type = 'apartado' THEN
        SELECT id
          INTO v_business_status_id
        FROM property_business_status
        WHERE name = 'apartado'
        LIMIT 1;

        SELECT id
          INTO v_publication_status_id
        FROM property_publication_status
        WHERE name = 'activo'
        LIMIT 1;

    ELSEIF p_transaction_type = 'venta' THEN
        SELECT id
          INTO v_business_status_id
        FROM property_business_status
        WHERE name = 'vendido'
        LIMIT 1;

        SELECT id
          INTO v_publication_status_id
        FROM property_publication_status
        WHERE name = 'inactivo'
        LIMIT 1;

    ELSEIF p_transaction_type = 'renta' THEN
        SELECT id
          INTO v_business_status_id
        FROM property_business_status
        WHERE name = 'rentado'
        LIMIT 1;

        SELECT id
          INTO v_publication_status_id
        FROM property_publication_status
        WHERE name = 'inactivo'
        LIMIT 1;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'transaction_type inválido. Usa: apartado, venta o renta';
    END IF;

    -- Registrar transacción
    INSERT INTO property_transaction (
        property_id,
        customer_id,
        transaction_type,
        final_price,
        currency,
        notes,
        created_by
    )
    VALUES (
        p_property_id,
        p_customer_id,
        p_transaction_type,
        p_final_price,
        p_currency,
        p_notes,
        p_created_by
    );

    -- Actualizar propiedad
    UPDATE property
       SET business_status_id = v_business_status_id,
           publication_status_id = v_publication_status_id
     WHERE id = p_property_id;

    -- Guardar historial
    INSERT INTO property_status_history (
        property_id,
        publication_status_id,
        business_status_id,
        changed_by,
        change_notes
    )
    VALUES (
        p_property_id,
        v_publication_status_id,
        v_business_status_id,
        p_created_by,
        CONCAT('Cambio automático por transacción: ', p_transaction_type, '. ', IFNULL(p_notes, ''))
    );

    SELECT LAST_INSERT_ID() AS property_transaction_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_type_upsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_type_upsert`(
    IN p_id INT,
    IN p_name VARCHAR(100)
)
BEGIN
    IF p_id IS NULL OR p_id = 0 THEN
        INSERT INTO property_type (name)
        VALUES (p_name);

        SELECT LAST_INSERT_ID() AS property_type_id;
    ELSE
        UPDATE property_type
           SET name = p_name
         WHERE id = p_id;

        SELECT p_id AS property_type_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_upsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_upsert`(
    IN p_id INT,
    IN p_property_type_id INT,
    IN p_operation_id INT,
    IN p_city_id INT,
    IN p_zone_id INT,
    IN p_address VARCHAR(255),
    IN p_latitude DECIMAL(10,8),
    IN p_longitude DECIMAL(11,8),
    IN p_title VARCHAR(255),
    IN p_description TEXT,
    IN p_area_value DECIMAL(14,2),
    IN p_price_value DECIMAL(14,2),
    IN p_currency CHAR(3),
    IN p_is_featured TINYINT,
    IN p_publication_status_id INT,
    IN p_business_status_id INT,
    -- Industrial
    IN p_clear_height DECIMAL(10,2),
    IN p_docks INT,
    IN p_power_kva DECIMAL(12,2),
    IN p_industrial_park VARCHAR(150),
    IN p_floor_resistance DECIMAL(10,2),
    -- Residential
    IN p_bedrooms INT,
    IN p_bathrooms DECIMAL(5,2),
    IN p_parking INT,
    IN p_pets_allowed TINYINT,
    IN p_is_furnished TINYINT,
    IN p_age INT,
    -- Land
    IN p_land_use VARCHAR(150),
    IN p_frontage DECIMAL(10,2),
    IN p_depth DECIMAL(10,2),
    IN p_topography VARCHAR(100),
    -- Amenities
    IN p_amenities JSON
)
BEGIN
    DECLARE v_property_id INT;
    DECLARE v_default_publication_status_id INT;
    DECLARE v_default_business_status_id INT;
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_len INT DEFAULT 0;
    DECLARE v_amenity_name VARCHAR(100);

    SELECT id INTO v_default_publication_status_id
    FROM property_publication_status WHERE name = 'activo' LIMIT 1;

    SELECT id INTO v_default_business_status_id
    FROM property_business_status WHERE name = 'disponible' LIMIT 1;

    IF p_publication_status_id IS NULL THEN
        SET p_publication_status_id = v_default_publication_status_id;
    END IF;
    IF p_business_status_id IS NULL THEN
        SET p_business_status_id = v_default_business_status_id;
    END IF;

    IF p_id IS NULL OR p_id = 0 THEN
        INSERT INTO property (
            property_type_id, operation_id, city_id, zone_id,
            address, latitude, longitude, title, description, area_value, price_value, currency,
            is_featured, publication_status_id, business_status_id
        ) VALUES (
            p_property_type_id, p_operation_id, p_city_id, p_zone_id,
            p_address, p_latitude, p_longitude, p_title, p_description, p_area_value, p_price_value, p_currency,
            p_is_featured, p_publication_status_id, p_business_status_id
        );
        SET v_property_id = LAST_INSERT_ID();
    ELSE
        UPDATE property SET
            property_type_id = p_property_type_id, operation_id = p_operation_id,
            city_id = p_city_id, zone_id = p_zone_id,
            address = p_address, latitude = p_latitude, longitude = p_longitude,
            title = p_title, description = p_description,
            area_value = p_area_value, price_value = p_price_value,
            currency = p_currency, is_featured = p_is_featured,
            publication_status_id = p_publication_status_id,
            business_status_id = p_business_status_id
        WHERE id = p_id;
        SET v_property_id = p_id;
    END IF;

    -- Industrial
    IF p_clear_height IS NOT NULL OR p_docks IS NOT NULL OR p_power_kva IS NOT NULL
       OR p_industrial_park IS NOT NULL OR p_floor_resistance IS NOT NULL THEN
        INSERT INTO property_industrial (property_id, clear_height, docks, power_kva, industrial_park, floor_resistance)
        VALUES (v_property_id, p_clear_height, p_docks, p_power_kva, p_industrial_park, p_floor_resistance)
        ON DUPLICATE KEY UPDATE
            clear_height = VALUES(clear_height), docks = VALUES(docks),
            power_kva = VALUES(power_kva), industrial_park = VALUES(industrial_park),
            floor_resistance = VALUES(floor_resistance);
    END IF;

    -- Residential
    IF p_bedrooms IS NOT NULL OR p_bathrooms IS NOT NULL OR p_parking IS NOT NULL
       OR p_age IS NOT NULL OR p_pets_allowed IS NOT NULL OR p_is_furnished IS NOT NULL THEN
        INSERT INTO property_residential (property_id, bedrooms, bathrooms, parking, pets_allowed, is_furnished, age)
        VALUES (v_property_id, p_bedrooms, p_bathrooms, p_parking, IFNULL(p_pets_allowed, 0), IFNULL(p_is_furnished, 0), p_age)
        ON DUPLICATE KEY UPDATE
            bedrooms = VALUES(bedrooms), bathrooms = VALUES(bathrooms),
            parking = VALUES(parking), pets_allowed = VALUES(pets_allowed),
            is_furnished = VALUES(is_furnished), age = VALUES(age);
    END IF;

    -- Land
    IF p_land_use IS NOT NULL OR p_frontage IS NOT NULL OR p_depth IS NOT NULL OR p_topography IS NOT NULL THEN
        INSERT INTO property_land (property_id, land_use, frontage, depth, topography)
        VALUES (v_property_id, p_land_use, p_frontage, p_depth, p_topography)
        ON DUPLICATE KEY UPDATE
            land_use = VALUES(land_use), frontage = VALUES(frontage),
            depth = VALUES(depth), topography = VALUES(topography);
    END IF;

    -- Amenities
    IF p_amenities IS NOT NULL AND JSON_LENGTH(p_amenities) >= 0 THEN
        DELETE FROM property_amenity WHERE property_id = v_property_id;

        SET v_len = JSON_LENGTH(p_amenities);
        SET v_i = 0;
        WHILE v_i < v_len DO
            SET v_amenity_name = JSON_UNQUOTE(JSON_EXTRACT(p_amenities, CONCAT('$[', v_i, ']')));
            INSERT INTO property_amenity (property_id, amenity_id)
            SELECT v_property_id, id FROM amenity WHERE name = v_amenity_name;
            SET v_i = v_i + 1;
        END WHILE;
    END IF;

    SELECT v_property_id AS property_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_visit_increment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_visit_increment`(
    IN p_property_id INT,
    IN p_ip_address VARCHAR(45),
    IN p_user_agent VARCHAR(500)
)
BEGIN
    UPDATE property
       SET views_count = views_count + 1
     WHERE id = p_property_id;

    INSERT INTO property_visit_log (
        property_id,
        ip_address,
        user_agent,
        visited_at
    )
    VALUES (
        p_property_id,
        p_ip_address,
        p_user_agent,
        NOW()
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_login_failed` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_login_failed`(
    IN p_user_id INT
)
BEGIN
    UPDATE `user`
    SET
        failed_login_attempts = failed_login_attempts + 1,
        locked_until = CASE
            WHEN failed_login_attempts + 1 >= 20 THEN DATE_ADD(NOW(), INTERVAL 15 MINUTE)
            ELSE locked_until
        END
    WHERE id = p_user_id;

    SELECT
        failed_login_attempts,
        locked_until
    FROM `user`
    WHERE id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_login_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_login_get`(
    IN p_username_or_email VARCHAR(150)
)
BEGIN
    SELECT
        u.id,
        u.username,
        u.password_hash,
        u.full_name,
        u.email,
        u.role_id,
        r.name AS role_name,
        u.is_active,
        u.last_login_at,
        u.failed_login_attempts,
        u.locked_until
    FROM `user` u
    INNER JOIN role r ON r.id = u.role_id
    WHERE (
        u.username = p_username_or_email
        OR u.email = p_username_or_email
    )
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_login_success` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_login_success`(
    IN p_user_id INT
)
BEGIN
    UPDATE `user`
       SET last_login_at = NOW(),
           failed_login_attempts = 0,
           locked_until = NULL
     WHERE id = p_user_id;

    SELECT ROW_COUNT() AS affected_rows;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `zone_upsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `zone_upsert`(
    IN p_id INT,
    IN p_city_id INT,
    IN p_name VARCHAR(100)
)
BEGIN
    IF p_id IS NULL OR p_id = 0 THEN
        INSERT INTO zone (city_id, name)
        VALUES (p_city_id, p_name);

        SELECT LAST_INSERT_ID() AS zone_id;
    ELSE
        UPDATE zone
           SET city_id = p_city_id,
               name = p_name
         WHERE id = p_id;

        SELECT p_id AS zone_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-07 17:53:02
