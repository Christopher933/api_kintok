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
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'activo',
  `source` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `assigned_agent_id` int DEFAULT NULL,
  `last_contact_at` datetime DEFAULT NULL,
  `next_follow_up_at` datetime DEFAULT NULL,
  `rfc` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `curp` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `business_name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `razon_social` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_persona` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `billing_email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_line` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_street` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_number` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_neighborhood` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_city` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_state` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_zip` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_country` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `preferred_currency` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `interest_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `interest_zones` text COLLATE utf8mb4_unicode_ci,
  `interest_property_types` text COLLATE utf8mb4_unicode_ci,
  `created_by` int DEFAULT NULL,
  `updated_by` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer_full_name` (`full_name`),
  KEY `idx_customer_email` (`email`),
  KEY `idx_customer_phone` (`phone`),
  KEY `fk_customer_assigned_agent` (`assigned_agent_id`),
  KEY `fk_customer_created_by` (`created_by`),
  KEY `fk_customer_updated_by` (`updated_by`),
  CONSTRAINT `chk_customer_status` CHECK ((`status` in (_utf8mb4'activo',_utf8mb4'inactivo',_utf8mb4'bloqueado'))),
  CONSTRAINT `fk_customer_assigned_agent` FOREIGN KEY (`assigned_agent_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_customer_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_customer_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Carlos Mendoza','carlos.mendoza@gmail.com','6641234567','comprador','Cliente de prueba','activo','lead_web',2,'2026-04-07 18:00:00','2026-04-12 10:00:00','MEMC900101ABC',NULL,NULL,'fisica','carlos.mendoza@gmail.com','Tijuana, Baja California',NULL,NULL,NULL,'Tijuana','Baja California',NULL,'Mexico','MXN','compra',NULL,NULL,2,2,'2026-04-07 22:52:58','2026-04-07 22:52:58');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_note`
--

DROP TABLE IF EXISTS `customer_note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_note` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer_note_customer_created` (`customer_id`,`created_at`),
  KEY `fk_customer_note_created_by` (`created_by`),
  CONSTRAINT `fk_customer_note_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_customer_note_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_note`
--

LOCK TABLES `customer_note` WRITE;
/*!40000 ALTER TABLE `customer_note` DISABLE KEYS */;
INSERT INTO `customer_note` VALUES (1,1,'Primer contacto inicial del cliente',2,'2026-04-07 23:10:00');
/*!40000 ALTER TABLE `customer_note` ENABLE KEYS */;
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
  `status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'nuevo',
  `changed_by` int DEFAULT NULL,
  `converted_by` int DEFAULT NULL,
  `converted_at` datetime DEFAULT NULL,
  `conversion_notes` text COLLATE utf8mb4_unicode_ci,
  `lead_notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `customer_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_lead_contact_status_created` (`status`,`created_at`),
  KEY `idx_lead_contact_property` (`property_id`),
  KEY `fk_lead_contact_changed_by` (`changed_by`),
  KEY `fk_lead_contact_converted_by` (`converted_by`),
  KEY `fk_lead_contact_customer` (`customer_id`),
  CONSTRAINT `chk_lead_contact_status` CHECK ((`status` in (_utf8mb4'nuevo',_utf8mb4'contactado',_utf8mb4'calificado',_utf8mb4'cerrado'))),
  CONSTRAINT `fk_lead_contact_changed_by` FOREIGN KEY (`changed_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_lead_contact_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_lead_contact_converted_by` FOREIGN KEY (`converted_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_lead_contact_property` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lead_contact`
--

LOCK TABLES `lead_contact` WRITE;
/*!40000 ALTER TABLE `lead_contact` DISABLE KEYS */;
INSERT INTO `lead_contact` VALUES (1,1,'Christopher Sandoval','christopher.sandoval93@gmail.com','6640000000','Quiero información sobre esta propiedad','nuevo',NULL,NULL,NULL,NULL,NULL,'2026-04-02 16:12:53','2026-04-02 16:12:53',NULL);
/*!40000 ALTER TABLE `lead_contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lead_contact_note`
--

DROP TABLE IF EXISTS `lead_contact_note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lead_contact_note` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lead_contact_id` int NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_lead_contact_note_lead_created` (`lead_contact_id`,`created_at`),
  KEY `fk_lead_contact_note_created_by` (`created_by`),
  CONSTRAINT `fk_lead_contact_note_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_lead_contact_note_lead` FOREIGN KEY (`lead_contact_id`) REFERENCES `lead_contact` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lead_contact_note`
--

LOCK TABLES `lead_contact_note` WRITE;
/*!40000 ALTER TABLE `lead_contact_note` DISABLE KEYS */;
INSERT INTO `lead_contact_note` VALUES (1,1,'Primer seguimiento: solicitó información de precio.',NULL,'2026-04-02 17:00:00');
/*!40000 ALTER TABLE `lead_contact_note` ENABLE KEYS */;
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
-- Table structure for table `permission_module`
--

DROP TABLE IF EXISTS `permission_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission_module` (
  `id` int NOT NULL AUTO_INCREMENT,
  `module_key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_permission_module_key` (`module_key`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_module`
--

LOCK TABLES `permission_module` WRITE;
/*!40000 ALTER TABLE `permission_module` DISABLE KEYS */;
INSERT INTO `permission_module` VALUES
(1,'auth','Autenticación','2026-04-09 09:00:00','2026-04-09 09:00:00'),
(2,'user','Usuarios','2026-04-09 09:00:00','2026-04-09 09:00:00'),
(3,'role_permission','Roles y Permisos','2026-04-09 09:00:00','2026-04-09 09:00:00'),
(4,'property','Propiedades','2026-04-09 09:00:00','2026-04-09 09:00:00'),
(5,'lead','Leads','2026-04-09 09:00:00','2026-04-09 09:00:00'),
(6,'customer','Clientes','2026-04-09 09:00:00','2026-04-09 09:00:00'),
(7,'transaction','Transacciones','2026-04-09 09:00:00','2026-04-09 09:00:00'),
(8,'catalog','Catálogos','2026-04-09 09:00:00','2026-04-09 09:00:00'),
(9,'cms','Contenido CMS','2026-04-09 09:00:00','2026-04-09 09:00:00');
/*!40000 ALTER TABLE `permission_module` ENABLE KEYS */;
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
INSERT INTO `property` VALUES (1,11,4,1,1,NULL,NULL,NULL,'test para casa','test desc',200.00,2000.00,'MXN',0,0,'2026-04-02 14:04:46','2026-04-02 14:33:04',1,1),(2,11,4,1,1,NULL,NULL,NULL,'test para casa','este es un test',200.00,2000.00,'MXN',0,0,'2026-04-02 14:08:17','2026-04-02 14:33:04',1,1),(3,11,4,1,1,NULL,NULL,NULL,'este es una casa','test para casa',200.00,2000.00,'USD',0,0,'2026-04-02 14:11:08','2026-04-02 17:42:20',1,1),(4,11,4,1,1,NULL,NULL,NULL,'casa de test','este es un test',200.00,2000.00,'MXN',0,0,'2026-04-02 17:22:13','2026-04-02 17:22:13',1,1),(5,11,3,1,1,NULL,NULL,NULL,'test 4','este es un test',200.00,3000.00,'MXN',0,0,'2026-04-03 22:03:31','2026-04-03 22:03:31',1,1),(6,11,3,1,1,NULL,NULL,NULL,'test 4','este es un test',200.00,3000.00,'MXN',0,0,'2026-04-03 22:03:53','2026-04-03 22:03:53',1,1),(7,11,3,1,1,'Avenida de los Olivos 3401, 22045 Tijuana, Baja California, Mexico',32.51196057,-117.01500313,'test 4','este es un test',200.00,3000.00,'MXN',30,0,'2026-04-03 22:09:08','2026-04-03 22:44:40',2,4);
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
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'activa',
  `final_price` decimal(14,2) DEFAULT NULL,
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_by` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cancelled_at` datetime DEFAULT NULL,
  `cancelled_by` int DEFAULT NULL,
  `cancel_reason` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `fk_property_transaction_user` (`created_by`),
  KEY `fk_property_transaction_cancelled_by_user` (`cancelled_by`),
  KEY `idx_property_transaction_property` (`property_id`),
  KEY `idx_property_transaction_customer` (`customer_id`),
  KEY `idx_property_transaction_type` (`transaction_type`,`status`),
  KEY `idx_property_transaction_date` (`transaction_date`),
  CONSTRAINT `fk_property_transaction_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_property_transaction_property` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_property_transaction_cancelled_by_user` FOREIGN KEY (`cancelled_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_property_transaction_user` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_property_transaction_currency` CHECK ((`currency` in (_utf8mb4'USD',_utf8mb4'MXN'))),
  CONSTRAINT `chk_property_transaction_status` CHECK ((`status` in (_utf8mb4'activa',_utf8mb4'cancelada',_utf8mb4'cerrada'))),
  CONSTRAINT `chk_property_transaction_type` CHECK ((`transaction_type` in (_utf8mb4'apartado',_utf8mb4'venta',_utf8mb4'renta')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_transaction`
--

LOCK TABLES `property_transaction` WRITE;
/*!40000 ALTER TABLE `property_transaction` DISABLE KEYS */;
INSERT INTO `property_transaction` VALUES
(1,7,1,'apartado','cancelada',3000.00,'MXN','2026-04-04 10:00:00','Apartado de prueba',2,'2026-04-04 10:00:00','2026-04-05 09:45:00',2,'El cliente decidió no continuar'),
(2,7,1,'renta','activa',2000.00,'MXN','2026-04-06 11:30:00','Renta vigente de prueba',2,'2026-04-06 11:30:00',NULL,NULL,NULL);
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
-- Table structure for table `role_module_permission`
--

DROP TABLE IF EXISTS `role_module_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_module_permission` (
  `role_id` int NOT NULL,
  `module_id` int NOT NULL,
  `can_view` tinyint(1) NOT NULL DEFAULT '0',
  `can_create` tinyint(1) NOT NULL DEFAULT '0',
  `can_update` tinyint(1) NOT NULL DEFAULT '0',
  `can_delete` tinyint(1) NOT NULL DEFAULT '0',
  `updated_by` int DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`role_id`,`module_id`),
  KEY `fk_role_module_permission_module` (`module_id`),
  KEY `fk_role_module_permission_updated_by` (`updated_by`),
  CONSTRAINT `fk_role_module_permission_module` FOREIGN KEY (`module_id`) REFERENCES `permission_module` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_role_module_permission_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_role_module_permission_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_module_permission`
--

LOCK TABLES `role_module_permission` WRITE;
/*!40000 ALTER TABLE `role_module_permission` DISABLE KEYS */;
INSERT INTO `role_module_permission` VALUES
(1,1,1,1,1,1,1,'2026-04-09 09:05:00'),
(1,2,1,1,1,1,1,'2026-04-09 09:05:00'),
(1,3,1,1,1,1,1,'2026-04-09 09:05:00'),
(1,4,1,1,1,1,1,'2026-04-09 09:05:00'),
(1,5,1,1,1,1,1,'2026-04-09 09:05:00'),
(1,6,1,1,1,1,1,'2026-04-09 09:05:00'),
(1,7,1,1,1,1,1,'2026-04-09 09:05:00'),
(1,8,1,1,1,1,1,'2026-04-09 09:05:00'),
(1,9,1,1,1,1,1,'2026-04-09 09:05:00'),
(2,1,1,1,1,0,1,'2026-04-09 09:05:00'),
(2,2,1,1,1,0,1,'2026-04-09 09:05:00'),
(2,3,1,0,1,0,1,'2026-04-09 09:05:00'),
(2,4,1,1,1,1,1,'2026-04-09 09:05:00'),
(2,5,1,1,1,1,1,'2026-04-09 09:05:00'),
(2,6,1,1,1,1,1,'2026-04-09 09:05:00'),
(2,7,1,1,1,1,1,'2026-04-09 09:05:00'),
(2,8,1,1,1,0,1,'2026-04-09 09:05:00'),
(2,9,1,1,1,0,1,'2026-04-09 09:05:00'),
(3,1,1,0,1,0,1,'2026-04-09 09:05:00'),
(3,2,0,0,0,0,1,'2026-04-09 09:05:00'),
(3,3,0,0,0,0,1,'2026-04-09 09:05:00'),
(3,4,1,1,1,0,1,'2026-04-09 09:05:00'),
(3,5,1,1,1,0,1,'2026-04-09 09:05:00'),
(3,6,1,1,1,0,1,'2026-04-09 09:05:00'),
(3,7,1,1,1,0,1,'2026-04-09 09:05:00'),
(3,8,1,0,0,0,1,'2026-04-09 09:05:00'),
(3,9,1,0,0,0,1,'2026-04-09 09:05:00');
/*!40000 ALTER TABLE `role_module_permission` ENABLE KEYS */;
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
-- Table structure for table `document_type`
--

DROP TABLE IF EXISTS `document_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applicable_to` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'todos',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_document_type_name` (`name`),
  CONSTRAINT `chk_document_type_applicable` CHECK ((`applicable_to` in (_utf8mb4'apartado',_utf8mb4'venta',_utf8mb4'renta',_utf8mb4'todos')))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_type`
--

LOCK TABLES `document_type` WRITE;
/*!40000 ALTER TABLE `document_type` DISABLE KEYS */;
INSERT INTO `document_type` VALUES (1,'Identificación oficial','todos'),(2,'Comprobante de domicilio','todos'),(3,'Carta de intención','apartado'),(4,'Contrato de compraventa','venta'),(5,'Contrato de arrendamiento','renta'),(6,'Aval','renta'),(7,'Estado de cuenta','todos'),(8,'Escritura','venta');
/*!40000 ALTER TABLE `document_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_document`
--

DROP TABLE IF EXISTS `transaction_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_document` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transaction_id` int NOT NULL,
  `document_type_id` int NOT NULL,
  `file_url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `uploaded_by` int DEFAULT NULL,
  `uploaded_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_transaction_document_transaction` (`transaction_id`),
  KEY `fk_transaction_document_type` (`document_type_id`),
  KEY `fk_transaction_document_user` (`uploaded_by`),
  CONSTRAINT `fk_transaction_document_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `property_transaction` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_transaction_document_type` FOREIGN KEY (`document_type_id`) REFERENCES `document_type` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_transaction_document_user` FOREIGN KEY (`uploaded_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_document`
--

LOCK TABLES `transaction_document` WRITE;
/*!40000 ALTER TABLE `transaction_document` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_reservation`
--

DROP TABLE IF EXISTS `transaction_reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_reservation` (
  `transaction_id` int NOT NULL,
  `deposit_amount` decimal(14,2) DEFAULT NULL,
  `deposit_currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MXN',
  `expires_at` datetime DEFAULT NULL,
  `applied_to_sale` tinyint(1) NOT NULL DEFAULT '0',
  `cancellation_policy` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`transaction_id`),
  CONSTRAINT `fk_transaction_reservation_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `property_transaction` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_transaction_reservation_currency` CHECK ((`deposit_currency` in (_utf8mb4'USD',_utf8mb4'MXN')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_reservation`
--

LOCK TABLES `transaction_reservation` WRITE;
/*!40000 ALTER TABLE `transaction_reservation` DISABLE KEYS */;
INSERT INTO `transaction_reservation` VALUES (1,3000.00,'MXN','2026-04-20 00:00:00',1,'Si el cliente cancela, el apartado no es reembolsable');
/*!40000 ALTER TABLE `transaction_reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_rental`
--

DROP TABLE IF EXISTS `transaction_rental`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_rental` (
  `transaction_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `monthly_rent` decimal(14,2) NOT NULL,
  `deposit_amount` decimal(14,2) DEFAULT NULL,
  `deposit_currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MXN',
  `payment_day` tinyint NOT NULL DEFAULT '1',
  `auto_renew` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`transaction_id`),
  CONSTRAINT `fk_transaction_rental_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `property_transaction` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_transaction_rental_currency` CHECK ((`deposit_currency` in (_utf8mb4'USD',_utf8mb4'MXN'))),
  CONSTRAINT `chk_transaction_rental_payment_day` CHECK ((`payment_day` between 1 and 28))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_rental`
--

LOCK TABLES `transaction_rental` WRITE;
/*!40000 ALTER TABLE `transaction_rental` DISABLE KEYS */;
INSERT INTO `transaction_rental` VALUES (2,'2026-04-01','2027-03-31',2000.00,2000.00,'MXN',5,0);
/*!40000 ALTER TABLE `transaction_rental` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rent_payment`
--

DROP TABLE IF EXISTS `rent_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rent_payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transaction_id` int NOT NULL,
  `period_year` smallint NOT NULL,
  `period_month` tinyint NOT NULL,
  `due_date` date NOT NULL,
  `amount_due` decimal(14,2) NOT NULL,
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount_paid` decimal(14,2) NOT NULL DEFAULT '0.00',
  `paid_at` datetime DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pendiente',
  `late_fee` decimal(14,2) DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `recorded_by` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_rent_payment_period` (`transaction_id`,`period_year`,`period_month`),
  KEY `idx_rent_payment_status_due` (`status`,`due_date`),
  KEY `fk_rent_payment_user` (`recorded_by`),
  CONSTRAINT `fk_rent_payment_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `property_transaction` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rent_payment_user` FOREIGN KEY (`recorded_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_rent_payment_currency` CHECK ((`currency` in (_utf8mb4'USD',_utf8mb4'MXN'))),
  CONSTRAINT `chk_rent_payment_status` CHECK ((`status` in (_utf8mb4'pendiente',_utf8mb4'pagado',_utf8mb4'parcial',_utf8mb4'atrasado',_utf8mb4'cancelado'))),
  CONSTRAINT `chk_rent_payment_month` CHECK ((`period_month` between 1 and 12))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rent_payment`
--

LOCK TABLES `rent_payment` WRITE;
/*!40000 ALTER TABLE `rent_payment` DISABLE KEYS */;
INSERT INTO `rent_payment` VALUES
(1,2,2026,4,'2026-04-05',2000.00,'MXN',2000.00,'2026-04-05 12:00:00','pagado',NULL,'Pago completo de abril',2,'2026-04-06 11:35:00','2026-04-06 11:35:00'),
(2,2,2026,5,'2026-05-05',2000.00,'MXN',0.00,NULL,'pendiente',NULL,'Pago pendiente de mayo',NULL,'2026-04-06 11:35:00','2026-04-06 11:35:00'),
(3,2,2026,6,'2026-06-05',2000.00,'MXN',500.00,'2026-06-06 18:00:00','parcial',100.00,'Pago parcial de junio',2,'2026-04-06 11:35:00','2026-06-06 18:00:00'),
(4,2,2026,3,'2026-03-05',2000.00,'MXN',0.00,NULL,'atrasado',150.00,'Renta vencida de marzo',NULL,'2026-04-06 11:35:00','2026-04-06 11:35:00');
/*!40000 ALTER TABLE `rent_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rent_payment_partiality`
--

DROP TABLE IF EXISTS `rent_payment_partiality`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rent_payment_partiality` (
  `id` int NOT NULL AUTO_INCREMENT,
  `payment_id` int NOT NULL,
  `amount` decimal(14,2) NOT NULL,
  `paid_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `recorded_by` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_rent_payment_partiality_payment` (`payment_id`),
  KEY `fk_rent_payment_partiality_user` (`recorded_by`),
  CONSTRAINT `fk_rent_payment_partiality_payment` FOREIGN KEY (`payment_id`) REFERENCES `rent_payment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rent_payment_partiality_user` FOREIGN KEY (`recorded_by`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_rent_payment_partiality_amount` CHECK ((`amount` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rent_payment_partiality`
--

LOCK TABLES `rent_payment_partiality` WRITE;
/*!40000 ALTER TABLE `rent_payment_partiality` DISABLE KEYS */;
INSERT INTO `rent_payment_partiality` VALUES
(1,3,300.00,'2026-06-03 12:20:00','Primer abono junio',2,'2026-06-03 12:20:00'),
(2,3,200.00,'2026-06-06 18:00:00','Segundo abono junio',2,'2026-06-06 18:00:00');
/*!40000 ALTER TABLE `rent_payment_partiality` ENABLE KEYS */;
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
/*!50003 DROP PROCEDURE IF EXISTS `property_transaction_close` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_transaction_close`(
    IN p_transaction_id INT,
    IN p_close_reason TEXT,
    IN p_closed_by INT
)
BEGIN
    DECLARE v_property_id INT;
    DECLARE v_transaction_type VARCHAR(20);
    DECLARE v_current_status VARCHAR(20);
    DECLARE v_business_status_id INT;
    DECLARE v_publication_status_id INT;
    DECLARE v_reason TEXT;
    DECLARE v_open_balances INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SELECT
        pt.property_id,
        pt.transaction_type,
        pt.status
      INTO v_property_id, v_transaction_type, v_current_status
      FROM property_transaction pt
     WHERE pt.id = p_transaction_id
     LIMIT 1;

    IF v_property_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transacción no encontrada';
    END IF;

    IF v_current_status = 'cerrada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La transacción ya está cerrada';
    END IF;

    IF v_current_status = 'cancelada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede cerrar una transacción cancelada';
    END IF;

    IF v_transaction_type = 'venta' THEN
        SELECT id INTO v_business_status_id
          FROM property_business_status
         WHERE name = 'vendido'
         LIMIT 1;

        SELECT id INTO v_publication_status_id
          FROM property_publication_status
         WHERE name = 'inactivo'
         LIMIT 1;
    ELSE
        SELECT id INTO v_business_status_id
          FROM property_business_status
         WHERE name = 'disponible'
         LIMIT 1;

        SELECT id INTO v_publication_status_id
          FROM property_publication_status
         WHERE name = 'activo'
         LIMIT 1;
    END IF;

    IF v_business_status_id IS NULL OR v_publication_status_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontraron los catálogos de estado de propiedad requeridos';
    END IF;

    IF v_transaction_type = 'renta' THEN
        SELECT COUNT(*)
          INTO v_open_balances
          FROM rent_payment rp
         WHERE rp.transaction_id = p_transaction_id
           AND (rp.amount_due - rp.amount_paid + IFNULL(rp.late_fee, 0)) > 0;

        IF v_open_balances > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se puede cerrar la renta con adeudos pendientes';
        END IF;
    END IF;

    SET v_reason = COALESCE(NULLIF(TRIM(p_close_reason), ''), 'Cierre de transacción');

    START TRANSACTION;

    UPDATE property_transaction
       SET status = 'cerrada',
           notes = CASE
                     WHEN notes IS NULL OR notes = '' THEN CONCAT(v_reason, ' (cerrada)')
                     ELSE CONCAT(notes, ' | ', v_reason, ' (cerrada)')
                   END
     WHERE id = p_transaction_id;

    UPDATE property
       SET business_status_id = v_business_status_id,
           publication_status_id = v_publication_status_id
     WHERE id = v_property_id;

    INSERT INTO property_status_history (
        property_id,
        publication_status_id,
        business_status_id,
        changed_by,
        change_notes
    ) VALUES (
        v_property_id,
        v_publication_status_id,
        v_business_status_id,
        p_closed_by,
        CONCAT('Cierre de transacción #', p_transaction_id, ': ', v_reason)
    );

    COMMIT;

    SELECT
        p_transaction_id AS property_transaction_id,
        'cerrada' AS status,
        v_transaction_type AS transaction_type,
        v_property_id AS property_id;
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
    IN p_status VARCHAR(20),
    IN p_customer_type VARCHAR(50),
    IN p_assigned_agent_id INT,
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

    IF p_status IS NOT NULL AND p_status <> '' AND p_status NOT IN ('activo','inactivo','bloqueado') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'status inválido. Usa: activo, inactivo, bloqueado';
    END IF;

    SET v_offset = (p_page_number - 1) * p_page_size;

    SELECT COUNT(*)
      INTO v_total_records
    FROM customer c
    WHERE (
        p_search_text IS NULL
        OR p_search_text = ''
        OR c.full_name LIKE CONCAT('%', p_search_text, '%')
        OR c.email LIKE CONCAT('%', p_search_text, '%')
        OR c.phone LIKE CONCAT('%', p_search_text, '%')
    )
      AND (p_status IS NULL OR p_status = '' OR c.status = p_status)
      AND (p_customer_type IS NULL OR p_customer_type = '' OR c.customer_type = p_customer_type)
      AND (p_assigned_agent_id IS NULL OR c.assigned_agent_id = p_assigned_agent_id);

    SET v_total_pages = CEIL(v_total_records / p_page_size);

    SELECT
        v_total_records AS total_records,
        p_page_number AS page_number,
        p_page_size AS page_size,
        v_total_pages AS total_pages;

    SELECT
        c.id,
        c.full_name,
        c.email,
        c.phone,
        c.customer_type,
        c.status,
        c.source,
        c.assigned_agent_id,
        ua.full_name AS assigned_agent_name,
        c.last_contact_at,
        c.next_follow_up_at,
        c.notes,
        (
            SELECT COUNT(*)
            FROM customer_note cn
            WHERE cn.customer_id = c.id
        ) AS notes_count,
        (
            SELECT cn.note
            FROM customer_note cn
            WHERE cn.customer_id = c.id
            ORDER BY cn.created_at DESC, cn.id DESC
            LIMIT 1
        ) AS last_note,
        (
            SELECT cn.created_at
            FROM customer_note cn
            WHERE cn.customer_id = c.id
            ORDER BY cn.created_at DESC, cn.id DESC
            LIMIT 1
        ) AS last_note_at,
        (
            SELECT COUNT(*)
            FROM lead_contact lc
            WHERE lc.customer_id = c.id
              AND lc.status <> 'cerrado'
        ) AS open_leads_count,
        (
            SELECT COUNT(*)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
              AND pt.status = 'activa'
        ) AS active_transactions_count,
        (
            SELECT COUNT(*)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
        ) AS total_transactions_count,
        (
            SELECT COALESCE(SUM(fn_convert_to_base(COALESCE(pt.final_price, 0), pt.currency, 'MXN')), 0)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
        ) AS total_spent_or_rented_mxn,
        (
            SELECT COUNT(*)
            FROM rent_payment rp
            INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
            WHERE pt.customer_id = c.id
              AND rp.status = 'atrasado'
        ) AS overdue_payments_count,
        (
            SELECT MIN(rp.due_date)
            FROM rent_payment rp
            INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
            WHERE pt.customer_id = c.id
              AND rp.status IN ('pendiente','parcial','atrasado')
        ) AS next_due_date,
        c.created_at,
        c.updated_at
    FROM customer c
    LEFT JOIN `user` ua ON ua.id = c.assigned_agent_id
    WHERE (
        p_search_text IS NULL
        OR p_search_text = ''
        OR c.full_name LIKE CONCAT('%', p_search_text, '%')
        OR c.email LIKE CONCAT('%', p_search_text, '%')
        OR c.phone LIKE CONCAT('%', p_search_text, '%')
    )
      AND (p_status IS NULL OR p_status = '' OR c.status = p_status)
      AND (p_customer_type IS NULL OR p_customer_type = '' OR c.customer_type = p_customer_type)
      AND (p_assigned_agent_id IS NULL OR c.assigned_agent_id = p_assigned_agent_id)
    ORDER BY c.created_at DESC, c.id DESC
    LIMIT p_page_size OFFSET v_offset;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_detail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_detail`(
    IN p_customer_id INT
)
BEGIN
    DECLARE v_exists INT;

    SELECT id INTO v_exists
    FROM customer
    WHERE id = p_customer_id
    LIMIT 1;

    IF v_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente no encontrado';
    END IF;

    SELECT
        c.id,
        c.full_name,
        c.email,
        c.phone,
        c.customer_type,
        c.status,
        c.source,
        c.assigned_agent_id,
        ua.full_name AS assigned_agent_name,
        c.last_contact_at,
        c.next_follow_up_at,
        c.rfc,
        c.business_name,
        c.billing_email,
        c.address_line,
        c.notes,
        (
            SELECT COUNT(*)
            FROM customer_note cn
            WHERE cn.customer_id = c.id
        ) AS notes_count,
        (
            SELECT cn.note
            FROM customer_note cn
            WHERE cn.customer_id = c.id
            ORDER BY cn.created_at DESC, cn.id DESC
            LIMIT 1
        ) AS last_note,
        (
            SELECT cn.created_at
            FROM customer_note cn
            WHERE cn.customer_id = c.id
            ORDER BY cn.created_at DESC, cn.id DESC
            LIMIT 1
        ) AS last_note_at,
        c.created_by,
        ucb.full_name AS created_by_name,
        c.updated_by,
        uub.full_name AS updated_by_name,
        (
            SELECT COUNT(*)
            FROM lead_contact lc
            WHERE lc.customer_id = c.id
              AND lc.status <> 'cerrado'
        ) AS open_leads_count,
        (
            SELECT COUNT(*)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
              AND pt.status = 'activa'
        ) AS active_transactions_count,
        (
            SELECT COUNT(*)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
        ) AS total_transactions_count,
        (
            SELECT COALESCE(SUM(fn_convert_to_base(COALESCE(pt.final_price, 0), pt.currency, 'MXN')), 0)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
        ) AS total_spent_or_rented_mxn,
        (
            SELECT COUNT(*)
            FROM rent_payment rp
            INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
            WHERE pt.customer_id = c.id
              AND rp.status = 'atrasado'
        ) AS overdue_payments_count,
        (
            SELECT COALESCE(SUM(GREATEST((rp.amount_due + COALESCE(rp.late_fee, 0)) - rp.amount_paid, 0)), 0)
            FROM rent_payment rp
            INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
            WHERE pt.customer_id = c.id
              AND rp.status IN ('pendiente','parcial','atrasado')
        ) AS outstanding_balance_mxn,
        c.created_at,
        c.updated_at
    FROM customer c
    LEFT JOIN `user` ua ON ua.id = c.assigned_agent_id
    LEFT JOIN `user` ucb ON ucb.id = c.created_by
    LEFT JOIN `user` uub ON uub.id = c.updated_by
    WHERE c.id = p_customer_id
    LIMIT 1;

    SELECT
        lc.id AS lead_contact_id,
        lc.property_id,
        p.title AS property_title,
        lc.name,
        lc.email,
        lc.phone,
        lc.status,
        lc.comments,
        lc.created_at,
        lc.updated_at
    FROM lead_contact lc
    LEFT JOIN property p ON p.id = lc.property_id
    WHERE lc.customer_id = p_customer_id
    ORDER BY lc.created_at DESC, lc.id DESC;

    SELECT
        pt.id AS transaction_id,
        pt.property_id,
        p.title AS property_title,
        pt.transaction_type,
        pt.status,
        pt.final_price,
        pt.currency,
        pt.transaction_date,
        pt.notes,
        pt.cancelled_at,
        pt.cancel_reason,
        pt.created_at
    FROM property_transaction pt
    LEFT JOIN property p ON p.id = pt.property_id
    WHERE pt.customer_id = p_customer_id
    ORDER BY pt.transaction_date DESC, pt.id DESC;

    SELECT
        rp.id AS payment_id,
        rp.transaction_id,
        rp.period_year,
        rp.period_month,
        rp.due_date,
        rp.amount_due,
        rp.amount_paid,
        GREATEST((rp.amount_due + COALESCE(rp.late_fee, 0)) - rp.amount_paid, 0) AS amount_pending,
        rp.currency,
        rp.status,
        rp.late_fee,
        rp.paid_at,
        rp.notes,
        rp.updated_at
    FROM rent_payment rp
    INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
    WHERE pt.customer_id = p_customer_id
    ORDER BY rp.due_date DESC, rp.id DESC;

    SELECT
        cn.id AS note_id,
        cn.customer_id,
        cn.note,
        cn.created_by,
        u.full_name AS created_by_name,
        cn.created_at
    FROM customer_note cn
    LEFT JOIN `user` u ON u.id = cn.created_by
    WHERE cn.customer_id = p_customer_id
    ORDER BY cn.created_at DESC, cn.id DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_note_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_note_add`(
    IN p_customer_id INT,
    IN p_note TEXT,
    IN p_created_by INT
)
BEGIN
    DECLARE v_customer_exists INT;
    DECLARE v_note_id INT;
    DECLARE v_note_trimmed TEXT;

    IF p_customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'customer_id es requerido';
    END IF;

    SET v_note_trimmed = TRIM(COALESCE(p_note, ''));
    IF v_note_trimmed = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'note es requerida';
    END IF;

    SELECT id INTO v_customer_exists
    FROM customer
    WHERE id = p_customer_id
    LIMIT 1;

    IF v_customer_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente no encontrado';
    END IF;

    INSERT INTO customer_note (
        customer_id,
        note,
        created_by
    ) VALUES (
        p_customer_id,
        v_note_trimmed,
        p_created_by
    );

    SET v_note_id = LAST_INSERT_ID();

    UPDATE customer
       SET notes = v_note_trimmed,
           updated_by = p_created_by,
           updated_at = NOW()
    WHERE id = p_customer_id;

    SELECT
        cn.id AS note_id,
        cn.customer_id,
        cn.note,
        cn.created_by,
        u.full_name AS created_by_name,
        cn.created_at
    FROM customer_note cn
    LEFT JOIN `user` u ON u.id = cn.created_by
    WHERE cn.id = v_note_id
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_note_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_note_list`(
    IN p_customer_id INT
)
BEGIN
    DECLARE v_customer_exists INT;

    IF p_customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'customer_id es requerido';
    END IF;

    SELECT id INTO v_customer_exists
    FROM customer
    WHERE id = p_customer_id
    LIMIT 1;

    IF v_customer_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente no encontrado';
    END IF;

    SELECT
        cn.id AS note_id,
        cn.customer_id,
        cn.note,
        cn.created_by,
        u.full_name AS created_by_name,
        cn.created_at
    FROM customer_note cn
    LEFT JOIN `user` u ON u.id = cn.created_by
    WHERE cn.customer_id = p_customer_id
    ORDER BY cn.created_at DESC, cn.id DESC;
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
    IN p_notes TEXT,
    IN p_status VARCHAR(20),
    IN p_source VARCHAR(50),
    IN p_assigned_agent_id INT,
    IN p_last_contact_at DATETIME,
    IN p_next_follow_up_at DATETIME,
    IN p_rfc VARCHAR(20),
    IN p_business_name VARCHAR(150),
    IN p_billing_email VARCHAR(150),
    IN p_address_line VARCHAR(255),
    IN p_actor_user_id INT
)
BEGIN
    DECLARE v_customer_id INT;
    DECLARE v_status VARCHAR(20);

    IF p_full_name IS NULL OR TRIM(p_full_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'full_name es requerido';
    END IF;

    SET v_status = COALESCE(NULLIF(TRIM(p_status), ''), 'activo');
    IF v_status NOT IN ('activo','inactivo','bloqueado') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'status inválido. Usa: activo, inactivo, bloqueado';
    END IF;

    IF p_id IS NULL OR p_id = 0 THEN
        INSERT INTO customer (
            full_name,
            email,
            phone,
            customer_type,
            notes,
            status,
            source,
            assigned_agent_id,
            last_contact_at,
            next_follow_up_at,
            rfc,
            business_name,
            billing_email,
            address_line,
            created_by,
            updated_by
        )
        VALUES (
            TRIM(p_full_name),
            p_email,
            p_phone,
            p_customer_type,
            p_notes,
            v_status,
            p_source,
            p_assigned_agent_id,
            p_last_contact_at,
            p_next_follow_up_at,
            p_rfc,
            p_business_name,
            p_billing_email,
            p_address_line,
            p_actor_user_id,
            p_actor_user_id
        );

        SET v_customer_id = LAST_INSERT_ID();
    ELSE
        UPDATE customer
           SET full_name = TRIM(p_full_name),
               email = p_email,
               phone = p_phone,
               customer_type = p_customer_type,
               notes = p_notes,
               status = v_status,
               source = p_source,
               assigned_agent_id = p_assigned_agent_id,
               last_contact_at = p_last_contact_at,
               next_follow_up_at = p_next_follow_up_at,
               rfc = p_rfc,
               business_name = p_business_name,
               billing_email = p_billing_email,
               address_line = p_address_line,
               updated_by = p_actor_user_id
         WHERE id = p_id;

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente no encontrado';
        END IF;

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

    IF p_status IS NOT NULL AND p_status <> '' THEN
        SET p_status = LOWER(p_status);
        IF p_status NOT IN ('nuevo','contactado','calificado','cerrado') THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'status inválido. Usa: nuevo, contactado, calificado, cerrado';
        END IF;
    END IF;

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
        l.changed_by,
        l.converted_by,
        l.converted_at,
        l.conversion_notes,
        l.lead_notes,
        (
            SELECT COUNT(*)
            FROM lead_contact_note ln
            WHERE ln.lead_contact_id = l.id
        ) AS notes_count,
        (
            SELECT ln.note
            FROM lead_contact_note ln
            WHERE ln.lead_contact_id = l.id
            ORDER BY ln.created_at DESC, ln.id DESC
            LIMIT 1
        ) AS last_note,
        (
            SELECT ln.created_at
            FROM lead_contact_note ln
            WHERE ln.lead_contact_id = l.id
            ORDER BY ln.created_at DESC, ln.id DESC
            LIMIT 1
        ) AS last_note_at,
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
    DECLARE v_property_exists INT;
    DECLARE v_recent_duplicate_id INT;

    IF p_property_id IS NULL OR p_name IS NULL OR p_email IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'property_id, name y email son requeridos';
    END IF;

    IF p_email NOT REGEXP '^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Formato de email inválido';
    END IF;

    IF p_phone IS NOT NULL AND p_phone <> '' AND p_phone NOT REGEXP '^[0-9+()\\-[:space:]]{7,20}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Formato de teléfono inválido';
    END IF;

    SELECT id
      INTO v_property_exists
      FROM property
     WHERE id = p_property_id
     LIMIT 1;

    IF v_property_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Propiedad no encontrada';
    END IF;

    SET p_email = LOWER(TRIM(p_email));

    SELECT id
      INTO v_recent_duplicate_id
      FROM lead_contact
     WHERE property_id = p_property_id
       AND LOWER(email) = p_email
       AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
     ORDER BY id DESC
     LIMIT 1;

    IF v_recent_duplicate_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un lead reciente con ese email para esta propiedad (últimas 24h)';
    END IF;

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
        'nuevo',
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
    IN p_status VARCHAR(50),
    IN p_changed_by INT
)
BEGIN
    DECLARE v_lead_exists INT;

    IF p_lead_contact_id IS NULL OR p_status IS NULL OR p_status = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'lead_contact_id y status son requeridos';
    END IF;

    SET p_status = LOWER(TRIM(p_status));
    IF p_status NOT IN ('nuevo','contactado','calificado','cerrado') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'status inválido. Usa: nuevo, contactado, calificado, cerrado';
    END IF;

    SELECT id INTO v_lead_exists
      FROM lead_contact
     WHERE id = p_lead_contact_id
     LIMIT 1;

    IF v_lead_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lead no encontrado';
    END IF;

    UPDATE lead_contact
       SET status = p_status,
           changed_by = p_changed_by,
           updated_at = NOW()
     WHERE id = p_lead_contact_id;

    SELECT ROW_COUNT() AS affected_rows;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lead_contact_notes_update` */;
/*!50003 DROP PROCEDURE IF EXISTS `lead_contact_notes_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lead_contact_notes_update`(
    IN p_lead_contact_id INT,
    IN p_note TEXT,
    IN p_created_by INT
)
BEGIN
    DECLARE v_lead_exists INT;
    DECLARE v_note_id INT;
    DECLARE v_note_trimmed TEXT;

    IF p_lead_contact_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'lead_contact_id es requerido';
    END IF;

    SET v_note_trimmed = TRIM(COALESCE(p_note, ''));
    IF v_note_trimmed = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'note es requerida';
    END IF;

    SELECT id INTO v_lead_exists
      FROM lead_contact
     WHERE id = p_lead_contact_id
     LIMIT 1;

    IF v_lead_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lead no encontrado';
    END IF;

    INSERT INTO lead_contact_note (
        lead_contact_id,
        note,
        created_by
    ) VALUES (
        p_lead_contact_id,
        v_note_trimmed,
        p_created_by
    );

    SET v_note_id = LAST_INSERT_ID();

    UPDATE lead_contact
       SET lead_notes = v_note_trimmed,
           changed_by = p_created_by,
           updated_at = NOW()
     WHERE id = p_lead_contact_id;

    SELECT
        n.id AS note_id,
        n.lead_contact_id,
        n.note,
        n.created_by,
        u.full_name AS created_by_name,
        n.created_at
    FROM lead_contact_note n
    LEFT JOIN user u ON u.id = n.created_by
    WHERE n.id = v_note_id
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lead_contact_notes_list`(
    IN p_lead_contact_id INT
)
BEGIN
    DECLARE v_lead_exists INT;

    IF p_lead_contact_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'lead_contact_id es requerido';
    END IF;

    SELECT id INTO v_lead_exists
      FROM lead_contact
     WHERE id = p_lead_contact_id
     LIMIT 1;

    IF v_lead_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lead no encontrado';
    END IF;

    SELECT
        n.id AS note_id,
        n.lead_contact_id,
        n.note,
        n.created_by,
        u.full_name AS created_by_name,
        n.created_at
    FROM lead_contact_note n
    LEFT JOIN user u ON u.id = n.created_by
    WHERE n.lead_contact_id = p_lead_contact_id
    ORDER BY n.created_at DESC, n.id DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lead_contact_convert_to_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lead_contact_convert_to_customer`(
    IN p_lead_contact_id INT,
    IN p_customer_type VARCHAR(50),
    IN p_notes TEXT,
    IN p_converted_by INT
)
BEGIN
    DECLARE v_name VARCHAR(150);
    DECLARE v_email VARCHAR(150);
    DECLARE v_phone VARCHAR(50);
    DECLARE v_comments TEXT;
    DECLARE v_status VARCHAR(50);
    DECLARE v_customer_id INT;

    IF p_lead_contact_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'lead_contact_id es requerido';
    END IF;

    SELECT name, LOWER(email), phone, comments, status
      INTO v_name, v_email, v_phone, v_comments, v_status
      FROM lead_contact
     WHERE id = p_lead_contact_id
     LIMIT 1;

    IF v_name IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lead no encontrado';
    END IF;

    IF v_status = 'cerrado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El lead ya está cerrado';
    END IF;

    SELECT id
      INTO v_customer_id
      FROM customer
     WHERE LOWER(email) = v_email
     ORDER BY id DESC
     LIMIT 1;

    IF v_customer_id IS NULL THEN
        INSERT INTO customer (
            full_name, email, phone, customer_type, notes
        ) VALUES (
            v_name,
            v_email,
            v_phone,
            COALESCE(NULLIF(TRIM(p_customer_type), ''), 'comprador'),
            COALESCE(NULLIF(TRIM(p_notes), ''), v_comments)
        );
        SET v_customer_id = LAST_INSERT_ID();
    ELSE
        UPDATE customer
           SET full_name = COALESCE(NULLIF(TRIM(v_name), ''), full_name),
               phone = COALESCE(NULLIF(TRIM(v_phone), ''), phone),
               customer_type = COALESCE(NULLIF(TRIM(p_customer_type), ''), customer_type),
               notes = COALESCE(NULLIF(TRIM(p_notes), ''), notes)
         WHERE id = v_customer_id;
    END IF;

    UPDATE lead_contact
       SET customer_id = v_customer_id,
           status = 'cerrado',
           changed_by = p_converted_by,
           converted_by = p_converted_by,
           converted_at = NOW(),
           conversion_notes = p_notes,
           updated_at = NOW()
     WHERE id = p_lead_contact_id;

    SELECT
        p_lead_contact_id AS lead_contact_id,
        v_customer_id AS customer_id,
        'cerrado' AS status,
        1 AS is_converted;
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
    -- result[0]: propiedad base
    SELECT
        p.*,
        pt.name  AS property_type,
        o.name   AS operation,
        c.name   AS city,
        z.name   AS zone,
        pps.name AS publication_status,
        pbs.name AS business_status,
        fn_format_price(p.price_value, p.currency) AS formatted_price
    FROM property p
    INNER JOIN property_type               pt  ON pt.id  = p.property_type_id
    INNER JOIN operation                   o   ON o.id   = p.operation_id
    INNER JOIN city                        c   ON c.id   = p.city_id
    INNER JOIN zone                        z   ON z.id   = p.zone_id
    INNER JOIN property_publication_status pps ON pps.id = p.publication_status_id
    INNER JOIN property_business_status    pbs ON pbs.id = p.business_status_id
    WHERE p.id = p_property_id;

    -- result[1]: industrial
    SELECT * FROM property_industrial WHERE property_id = p_property_id;

    -- result[2]: residential
    SELECT * FROM property_residential WHERE property_id = p_property_id;

    -- result[3]: land
    SELECT * FROM property_land WHERE property_id = p_property_id;

    -- result[4]: amenities
    SELECT a.id, a.name
      FROM property_amenity pa
      INNER JOIN amenity a ON a.id = pa.amenity_id
     WHERE pa.property_id = p_property_id
     ORDER BY a.name;

    -- result[5]: images
    SELECT id, property_id, image_url, sort_order
      FROM property_image
     WHERE property_id = p_property_id
     ORDER BY sort_order, id;

    -- result[6]: agents
    SELECT ag.id, ag.full_name, ag.email, ag.phone, ag.bio, ag.image_url
      FROM property_agent pag
      INNER JOIN agent ag ON ag.id = pag.agent_id
     WHERE pag.property_id = p_property_id
       AND ag.is_active = b'1'
     ORDER BY ag.full_name;

    -- result[7]: transacción activa más reciente (con detalle de apartado o renta)
    SELECT
        pt.id              AS transaction_id,
        pt.transaction_type,
        pt.status          AS transaction_status,
        pt.final_price,
        pt.currency,
        pt.transaction_date,
        pt.notes,
        pt.created_at,
        pt.cancelled_at,
        pt.cancelled_by,
        pt.cancel_reason,
        c.id               AS customer_id,
        c.full_name        AS customer_name,
        c.email            AS customer_email,
        c.phone            AS customer_phone,
        c.customer_type,
        tr_res.deposit_amount      AS reservation_deposit,
        tr_res.deposit_currency    AS reservation_currency,
        tr_res.expires_at          AS reservation_expires_at,
        tr_res.applied_to_sale     AS reservation_applied_to_sale,
        tr_ren.start_date          AS rental_start_date,
        tr_ren.end_date            AS rental_end_date,
        tr_ren.monthly_rent        AS rental_monthly_rent,
        tr_ren.deposit_amount      AS rental_deposit,
        tr_ren.deposit_currency    AS rental_deposit_currency,
        tr_ren.payment_day         AS rental_payment_day,
        tr_ren.auto_renew          AS rental_auto_renew
    FROM property_transaction pt
    INNER JOIN customer c ON c.id = pt.customer_id
    LEFT JOIN transaction_reservation tr_res ON tr_res.transaction_id = pt.id
    LEFT JOIN transaction_rental      tr_ren ON tr_ren.transaction_id = pt.id
    WHERE pt.property_id = p_property_id
      AND pt.status = 'activa'
    ORDER BY pt.transaction_date DESC, pt.id DESC
    LIMIT 1;

    -- result[8]: estado de pago del mes actual (solo si está rentada)
    SELECT
        rp.id,
        rp.period_year,
        rp.period_month,
        rp.due_date,
        rp.amount_due,
        rp.amount_paid,
        rp.currency,
        rp.status,
        rp.late_fee,
        (rp.amount_due - rp.amount_paid + IFNULL(rp.late_fee, 0)) AS balance_due,
        (
            SELECT COUNT(*)
              FROM rent_payment rp2
             WHERE rp2.transaction_id = rp.transaction_id
               AND rp2.status IN ('atrasado', 'parcial')
        ) AS overdue_count,
        (
            SELECT IFNULL(SUM(rp3.amount_due - rp3.amount_paid + IFNULL(rp3.late_fee, 0)), 0)
              FROM rent_payment rp3
             WHERE rp3.transaction_id = rp.transaction_id
               AND rp3.status IN ('atrasado', 'parcial')
        ) AS total_overdue_amount
    FROM rent_payment rp
    INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
    WHERE pt.property_id    = p_property_id
      AND pt.transaction_type = 'renta'
      AND pt.status = 'activa'
      AND rp.period_year    = YEAR(CURDATE())
      AND rp.period_month   = MONTH(CURDATE())
    LIMIT 1;
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
    IN p_min_bathrooms      DECIMAL(5,2),
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
    IN p_amenities          TEXT,
    -- Pagination
    IN p_page_number        INT,
    IN p_page_size          INT,
    -- NULL = sin filtro | 'activo' | 'inactivo'
    IN p_publication_status VARCHAR(20),
    -- NULL = sin filtro | 'disponible' | 'apartado' | 'vendido' | 'rentado'
    IN p_business_status    VARCHAR(50)
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
    JOIN property_business_status pbs    ON pbs.id = p.business_status_id
    LEFT JOIN property_residential pr   ON pr.property_id = p.id
    LEFT JOIN property_industrial  pi   ON pi.property_id = p.id
    LEFT JOIN property_land        pl   ON pl.property_id = p.id
    WHERE
        (p_publication_status IS NULL OR pps.name = p_publication_status)
        AND (p_business_status IS NULL OR pbs.name = p_business_status)
        AND (p_property_type_id IS NULL OR p.property_type_id = p_property_type_id)
        AND (p_operation_id     IS NULL OR p.operation_id     = p_operation_id)
        AND (p_city_id          IS NULL OR p.city_id          = p_city_id)
        AND (p_zone_id          IS NULL OR p.zone_id          = p_zone_id)
        AND (p_min_area         IS NULL OR p.area_value      >= p_min_area)
        AND (p_max_area         IS NULL OR p.area_value      <= p_max_area)
        AND (p_min_price        IS NULL OR IFNULL(fn_convert_to_base(p.price_value, p.currency, v_target_curr), p.price_value) >= p_min_price)
        AND (p_max_price        IS NULL OR IFNULL(fn_convert_to_base(p.price_value, p.currency, v_target_curr), p.price_value) <= p_max_price)
        AND (p_featured_only    IS NULL OR p_featured_only = 0 OR p.is_featured = 1)
        AND (p_search_text      IS NULL OR p_search_text = ''
             OR p.title       LIKE CONCAT('%', p_search_text, '%')
             OR p.description LIKE CONCAT('%', p_search_text, '%'))
        AND (p_min_bedrooms     IS NULL OR pr.bedrooms     >= p_min_bedrooms)
        AND (p_min_bathrooms    IS NULL OR pr.bathrooms    >= p_min_bathrooms)
        AND (p_min_parking      IS NULL OR pr.parking      >= p_min_parking)
        AND (p_pets_allowed     IS NULL OR p_pets_allowed = 0 OR pr.pets_allowed = 1)
        AND (p_min_clear_height IS NULL OR pi.clear_height >= p_min_clear_height)
        AND (p_min_docks        IS NULL OR pi.docks        >= p_min_docks)
        AND (p_min_power_kva    IS NULL OR pi.power_kva    >= p_min_power_kva)
        AND (p_industrial_park  IS NULL OR p_industrial_park = 0 OR (pi.industrial_park IS NOT NULL AND pi.industrial_park != ''))
        AND (p_land_use         IS NULL OR p_land_use = '' OR pl.land_use = p_land_use)
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
        IFNULL(fn_convert_to_base(p.price_value, p.currency, v_target_curr), p.price_value) AS normalized_price,
        CONCAT('$', FORMAT(
            IFNULL(fn_convert_to_base(p.price_value, p.currency, v_target_curr), p.price_value), 2), ' ', v_target_curr) AS formatted_normalized_price,
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
        atx.transaction_id        AS active_transaction_id,
        atx.transaction_type      AS active_transaction_type,
        atx.transaction_status    AS active_transaction_status,
        atx.customer_id           AS active_transaction_customer_id,
        rp_cur.id                 AS current_payment_id,
        rp_cur.status             AS current_payment_status,
        (rp_cur.amount_due - rp_cur.amount_paid + IFNULL(rp_cur.late_fee, 0)) AS current_payment_balance_due,
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
    LEFT JOIN (
        SELECT
            pt1.id AS transaction_id,
            pt1.property_id,
            pt1.transaction_type,
            pt1.status AS transaction_status,
            pt1.customer_id
        FROM property_transaction pt1
        INNER JOIN (
            SELECT property_id, MAX(id) AS latest_transaction_id
            FROM property_transaction
            WHERE status = 'activa'
            GROUP BY property_id
        ) tmax ON tmax.latest_transaction_id = pt1.id
    ) atx ON atx.property_id = p.id
    LEFT JOIN rent_payment rp_cur
      ON rp_cur.transaction_id = atx.transaction_id
     AND rp_cur.period_year = YEAR(CURDATE())
     AND rp_cur.period_month = MONTH(CURDATE())
    WHERE
        (p_publication_status IS NULL OR pps.name = p_publication_status)
        AND (p_business_status IS NULL OR pbs.name = p_business_status)
        AND (p_property_type_id IS NULL OR p.property_type_id = p_property_type_id)
        AND (p_operation_id     IS NULL OR p.operation_id     = p_operation_id)
        AND (p_city_id          IS NULL OR p.city_id          = p_city_id)
        AND (p_zone_id          IS NULL OR p.zone_id          = p_zone_id)
        AND (p_min_area         IS NULL OR p.area_value      >= p_min_area)
        AND (p_max_area         IS NULL OR p.area_value      <= p_max_area)
        AND (p_min_price        IS NULL OR IFNULL(fn_convert_to_base(p.price_value, p.currency, v_target_curr), p.price_value) >= p_min_price)
        AND (p_max_price        IS NULL OR IFNULL(fn_convert_to_base(p.price_value, p.currency, v_target_curr), p.price_value) <= p_max_price)
        AND (p_featured_only    IS NULL OR p_featured_only = 0 OR p.is_featured = 1)
        AND (p_search_text      IS NULL OR p_search_text = ''
             OR p.title       LIKE CONCAT('%', p_search_text, '%')
             OR p.description LIKE CONCAT('%', p_search_text, '%'))
        AND (p_min_bedrooms     IS NULL OR pr.bedrooms     >= p_min_bedrooms)
        AND (p_min_bathrooms    IS NULL OR pr.bathrooms    >= p_min_bathrooms)
        AND (p_min_parking      IS NULL OR pr.parking      >= p_min_parking)
        AND (p_pets_allowed     IS NULL OR p_pets_allowed = 0 OR pr.pets_allowed = 1)
        AND (p_min_clear_height IS NULL OR pi.clear_height >= p_min_clear_height)
        AND (p_min_docks        IS NULL OR pi.docks        >= p_min_docks)
        AND (p_min_power_kva    IS NULL OR pi.power_kva    >= p_min_power_kva)
        AND (p_industrial_park  IS NULL OR p_industrial_park = 0 OR (pi.industrial_park IS NOT NULL AND pi.industrial_park != ''))
        AND (p_land_use         IS NULL OR p_land_use = '' OR pl.land_use = p_land_use)
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
    DECLARE v_current_publication_status_id INT;
    DECLARE v_current_business_status_id INT;
    DECLARE v_new_publication_status_id INT;
    DECLARE v_new_business_status_id INT;

    SELECT publication_status_id, business_status_id
      INTO v_current_publication_status_id, v_current_business_status_id
      FROM property
     WHERE id = p_property_id
     LIMIT 1;

    IF v_current_publication_status_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Propiedad no encontrada';
    END IF;

    SET v_new_publication_status_id = COALESCE(p_publication_status_id, v_current_publication_status_id);
    SET v_new_business_status_id = COALESCE(p_business_status_id, v_current_business_status_id);

    UPDATE property
       SET publication_status_id = v_new_publication_status_id,
           business_status_id = v_new_business_status_id
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
        v_new_publication_status_id,
        v_new_business_status_id,
        p_changed_by,
        COALESCE(NULLIF(TRIM(p_change_notes), ''), 'Actualización manual de estatus')
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
        pt.status,
        pt.final_price,
        pt.currency,
        pt.transaction_date,
        pt.notes,
        pt.cancelled_at,
        pt.cancel_reason,
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
        pt.status,
        pt.final_price,
        pt.currency,
        pt.transaction_date,
        pt.notes,
        pt.cancelled_at,
        pt.cancel_reason,
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
    DECLARE v_active_transaction_id INT;
    DECLARE v_property_exists INT;
    DECLARE v_property_transaction_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Lock de propiedad para evitar doble transacción activa por requests concurrentes
    SELECT id
      INTO v_property_exists
      FROM property
     WHERE id = p_property_id
     FOR UPDATE;

    IF v_property_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Propiedad no encontrada';
    END IF;

    -- Evitar registrar otra transacción activa para la misma propiedad
    SELECT id
      INTO v_active_transaction_id
      FROM property_transaction
     WHERE property_id = p_property_id
       AND status = 'activa'
     ORDER BY transaction_date DESC, id DESC
     LIMIT 1;

    IF v_active_transaction_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La propiedad ya tiene una transacción activa. Cancélala o ciérrala antes de registrar otra.';
    END IF;

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
        status,
        final_price,
        currency,
        notes,
        created_by
    )
    VALUES (
        p_property_id,
        p_customer_id,
        p_transaction_type,
        'activa',
        p_final_price,
        p_currency,
        p_notes,
        p_created_by
    );
    SET v_property_transaction_id = LAST_INSERT_ID();

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

    COMMIT;

    SELECT v_property_transaction_id AS property_transaction_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `property_transaction_cancel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_transaction_cancel`(
    IN p_transaction_id INT,
    IN p_cancel_reason TEXT,
    IN p_cancelled_by INT
)
BEGIN
    DECLARE v_property_id INT;
    DECLARE v_transaction_type VARCHAR(20);
    DECLARE v_current_status VARCHAR(20);
    DECLARE v_business_status_id INT;
    DECLARE v_publication_status_id INT;
    DECLARE v_reason TEXT;
    DECLARE v_payments_cancelled INT DEFAULT 0;

    SELECT
        pt.property_id,
        pt.transaction_type,
        pt.status
      INTO v_property_id, v_transaction_type, v_current_status
      FROM property_transaction pt
     WHERE pt.id = p_transaction_id
     LIMIT 1;

    IF v_property_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transacción no encontrada';
    END IF;

    IF v_current_status = 'cancelada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La transacción ya está cancelada';
    END IF;

    IF v_current_status = 'cerrada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede cancelar una transacción cerrada';
    END IF;

    SELECT id
      INTO v_business_status_id
      FROM property_business_status
     WHERE name = 'disponible'
     LIMIT 1;

    SELECT id
      INTO v_publication_status_id
      FROM property_publication_status
     WHERE name = 'activo'
     LIMIT 1;

    IF v_business_status_id IS NULL OR v_publication_status_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontraron los catálogos de estado de propiedad requeridos';
    END IF;

    SET v_reason = COALESCE(NULLIF(TRIM(p_cancel_reason), ''), 'Cancelada por usuario');

    START TRANSACTION;

    UPDATE property_transaction
       SET status = 'cancelada',
           cancelled_at = NOW(),
           cancelled_by = p_cancelled_by,
           cancel_reason = v_reason
     WHERE id = p_transaction_id;

    IF v_transaction_type = 'renta' THEN
        UPDATE rent_payment
           SET status = 'cancelado',
               notes = CASE
                           WHEN notes IS NULL OR notes = '' THEN CONCAT('Pago cancelado por cancelación de la transacción #', p_transaction_id)
                           ELSE CONCAT(notes, ' | Pago cancelado por cancelación de la transacción #', p_transaction_id)
                       END
         WHERE transaction_id = p_transaction_id
           AND status IN ('pendiente', 'atrasado');

        SET v_payments_cancelled = ROW_COUNT();
    END IF;

    UPDATE property
       SET business_status_id = v_business_status_id,
           publication_status_id = v_publication_status_id
     WHERE id = v_property_id;

    INSERT INTO property_status_history (
        property_id,
        publication_status_id,
        business_status_id,
        changed_by,
        change_notes
    ) VALUES (
        v_property_id,
        v_publication_status_id,
        v_business_status_id,
        p_cancelled_by,
        CONCAT('Cancelación de transacción #', p_transaction_id, ': ', v_reason)
    );

    COMMIT;

    SELECT
        p_transaction_id AS property_transaction_id,
        'cancelada' AS status,
        v_transaction_type AS transaction_type,
        v_property_id AS property_id,
        v_payments_cancelled AS payments_cancelled;
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

--
-- Stored procedures: transaction operations & rent payments
--

/*!50003 DROP PROCEDURE IF EXISTS `transaction_reservation_save` */;
DELIMITER ;;
CREATE PROCEDURE `transaction_reservation_save`(
    IN p_transaction_id      INT,
    IN p_deposit_amount      DECIMAL(14,2),
    IN p_deposit_currency    CHAR(3),
    IN p_expires_at          DATETIME,
    IN p_applied_to_sale     TINYINT(1),
    IN p_cancellation_policy TEXT
)
BEGIN
    DECLARE v_transaction_type VARCHAR(20);
    DECLARE v_status VARCHAR(20);

    SELECT transaction_type, status
      INTO v_transaction_type, v_status
      FROM property_transaction
     WHERE id = p_transaction_id
     LIMIT 1;

    IF v_transaction_type IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transacción no encontrada';
    END IF;

    IF v_transaction_type <> 'apartado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La transacción no es de tipo apartado';
    END IF;

    IF v_status <> 'activa' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo se puede actualizar apartado en transacciones activas';
    END IF;

    INSERT INTO transaction_reservation (
        transaction_id, deposit_amount, deposit_currency,
        expires_at, applied_to_sale, cancellation_policy
    ) VALUES (
        p_transaction_id, p_deposit_amount, p_deposit_currency,
        p_expires_at, IFNULL(p_applied_to_sale, 0), p_cancellation_policy
    )
    ON DUPLICATE KEY UPDATE
        deposit_amount       = VALUES(deposit_amount),
        deposit_currency     = VALUES(deposit_currency),
        expires_at           = VALUES(expires_at),
        applied_to_sale      = VALUES(applied_to_sale),
        cancellation_policy  = VALUES(cancellation_policy);

    SELECT * FROM transaction_reservation WHERE transaction_id = p_transaction_id;
END ;;
DELIMITER ;

/*!50003 DROP PROCEDURE IF EXISTS `transaction_rental_save` */;
DELIMITER ;;
CREATE PROCEDURE `transaction_rental_save`(
    IN p_transaction_id   INT,
    IN p_start_date       DATE,
    IN p_end_date         DATE,
    IN p_monthly_rent     DECIMAL(14,2),
    IN p_deposit_amount   DECIMAL(14,2),
    IN p_deposit_currency CHAR(3),
    IN p_payment_day      TINYINT,
    IN p_auto_renew       TINYINT(1)
)
BEGIN
    DECLARE v_transaction_type VARCHAR(20);
    DECLARE v_status VARCHAR(20);

    SELECT transaction_type, status
      INTO v_transaction_type, v_status
      FROM property_transaction
     WHERE id = p_transaction_id
     LIMIT 1;

    IF v_transaction_type IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transacción no encontrada';
    END IF;

    IF v_transaction_type <> 'renta' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La transacción no es de tipo renta';
    END IF;

    IF v_status <> 'activa' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo se puede actualizar renta en transacciones activas';
    END IF;

    INSERT INTO transaction_rental (
        transaction_id, start_date, end_date, monthly_rent,
        deposit_amount, deposit_currency, payment_day, auto_renew
    ) VALUES (
        p_transaction_id, p_start_date, p_end_date, p_monthly_rent,
        p_deposit_amount, p_deposit_currency, IFNULL(p_payment_day, 1), IFNULL(p_auto_renew, 0)
    )
    ON DUPLICATE KEY UPDATE
        start_date       = VALUES(start_date),
        end_date         = VALUES(end_date),
        monthly_rent     = VALUES(monthly_rent),
        deposit_amount   = VALUES(deposit_amount),
        deposit_currency = VALUES(deposit_currency),
        payment_day      = VALUES(payment_day),
        auto_renew       = VALUES(auto_renew);

    SELECT * FROM transaction_rental WHERE transaction_id = p_transaction_id;
END ;;
DELIMITER ;

/*!50003 DROP PROCEDURE IF EXISTS `rent_payment_generate` */;
DELIMITER ;;
CREATE PROCEDURE `rent_payment_generate`(
    IN p_transaction_id INT
)
BEGIN
    DECLARE v_start_date   DATE;
    DECLARE v_end_date     DATE;
    DECLARE v_monthly_rent DECIMAL(14,2);
    DECLARE v_currency     CHAR(3);
    DECLARE v_payment_day  TINYINT;
    DECLARE v_current      DATE;
    DECLARE v_due_date     DATE;
    DECLARE v_period_year  SMALLINT;
    DECLARE v_period_month TINYINT;
    DECLARE v_months_total INT DEFAULT 12;
    DECLARE v_counter      INT DEFAULT 0;
    DECLARE v_last_day     INT;

    SELECT tr.start_date, tr.end_date, tr.monthly_rent, tr.payment_day, pt.currency
      INTO v_start_date, v_end_date, v_monthly_rent, v_payment_day, v_currency
      FROM transaction_rental tr
      JOIN property_transaction pt ON pt.id = tr.transaction_id
     WHERE tr.transaction_id = p_transaction_id;

    IF v_end_date IS NOT NULL THEN
        SET v_months_total = PERIOD_DIFF(
            DATE_FORMAT(v_end_date, '%Y%m'),
            DATE_FORMAT(v_start_date, '%Y%m')
        ) + 1;
    END IF;

    SET v_current = v_start_date;

    WHILE v_counter < v_months_total DO
        SET v_period_year  = YEAR(v_current);
        SET v_period_month = MONTH(v_current);
        SET v_last_day     = DAY(LAST_DAY(v_current));

        IF v_payment_day > v_last_day THEN
            SET v_due_date = LAST_DAY(v_current);
        ELSE
            SET v_due_date = DATE(CONCAT(
                v_period_year, '-',
                LPAD(v_period_month, 2, '0'), '-',
                LPAD(v_payment_day, 2, '0')
            ));
        END IF;

        INSERT IGNORE INTO rent_payment (
            transaction_id, period_year, period_month,
            due_date, amount_due, currency, status
        ) VALUES (
            p_transaction_id, v_period_year, v_period_month,
            v_due_date, v_monthly_rent, v_currency, 'pendiente'
        );

        SET v_current = DATE_ADD(v_current, INTERVAL 1 MONTH);
        SET v_counter = v_counter + 1;
    END WHILE;

    SELECT COUNT(*) AS payments_generated
      FROM rent_payment
     WHERE transaction_id = p_transaction_id;
END ;;
DELIMITER ;

/*!50003 DROP PROCEDURE IF EXISTS `rent_payment_list` */;
DELIMITER ;;
CREATE PROCEDURE `rent_payment_list`(
    IN p_transaction_id INT
)
BEGIN
    UPDATE rent_payment
       SET status = 'atrasado'
     WHERE transaction_id = p_transaction_id
       AND due_date < CURDATE()
       AND status IN ('pendiente');

    SELECT
        rp.*,
        (rp.amount_due - rp.amount_paid + IFNULL(rp.late_fee, 0)) AS balance_due,
        (
            SELECT COUNT(*)
              FROM rent_payment_partiality rpp
             WHERE rpp.payment_id = rp.id
        ) AS partialities_count,
        (
            SELECT IFNULL(SUM(rpp2.amount), 0)
              FROM rent_payment_partiality rpp2
             WHERE rpp2.payment_id = rp.id
        ) AS partialities_total
      FROM rent_payment rp
     WHERE rp.transaction_id = p_transaction_id
     ORDER BY rp.period_year ASC, rp.period_month ASC;
END ;;
DELIMITER ;

/*!50003 DROP PROCEDURE IF EXISTS `rent_payment_update` */;
/*!50003 DROP PROCEDURE IF EXISTS `rent_payment_partial_list` */;
/*!50003 DROP PROCEDURE IF EXISTS `rent_payment_partial_add` */;
DELIMITER ;;
CREATE PROCEDURE `rent_payment_update`(
    IN p_payment_id  INT,
    IN p_amount_paid DECIMAL(14,2),
    IN p_paid_at     DATETIME,
    IN p_late_fee    DECIMAL(14,2),
    IN p_notes       TEXT,
    IN p_recorded_by INT
)
BEGIN
    DECLARE v_amount_due DECIMAL(14,2);
    DECLARE v_due_date   DATE;
    DECLARE v_late_fee   DECIMAL(14,2);
    DECLARE v_total_due  DECIMAL(14,2);
    DECLARE v_current_status VARCHAR(20);
    DECLARE v_status     VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT amount_due, due_date, IFNULL(late_fee, 0), status
      INTO v_amount_due, v_due_date, v_late_fee, v_current_status
      FROM rent_payment
     WHERE id = p_payment_id
     FOR UPDATE;

    IF v_amount_due IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pago no encontrado';
    END IF;

    IF v_current_status = 'cancelado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede actualizar un pago cancelado';
    END IF;

    SET v_total_due = v_amount_due + IFNULL(p_late_fee, v_late_fee);

    IF p_amount_paid < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'amount_paid no puede ser negativo';
    END IF;

    IF p_amount_paid > v_total_due THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pago excede el adeudo del mes. Registra la penalización en late_fee antes de cobrar más.';
    END IF;

    IF p_amount_paid >= v_total_due THEN
        SET v_status = 'pagado';
    ELSEIF p_amount_paid > 0 THEN
        SET v_status = 'parcial';
    ELSEIF v_due_date < CURDATE() THEN
        SET v_status = 'atrasado';
    ELSE
        SET v_status = 'pendiente';
    END IF;

    UPDATE rent_payment
       SET amount_paid = p_amount_paid,
           paid_at     = IFNULL(p_paid_at, NOW()),
           late_fee    = IFNULL(p_late_fee, late_fee),
           notes       = p_notes,
           status      = v_status,
           recorded_by = p_recorded_by
     WHERE id = p_payment_id;

    COMMIT;

    SELECT
        rp.*,
        (rp.amount_due - rp.amount_paid + IFNULL(rp.late_fee, 0)) AS balance_due
      FROM rent_payment rp
     WHERE rp.id = p_payment_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `rent_payment_partial_list`(
    IN p_payment_id INT
)
BEGIN
    SELECT
        rpp.id,
        rpp.payment_id,
        rpp.amount,
        rpp.paid_at,
        rpp.notes,
        rpp.recorded_by,
        u.full_name AS recorded_by_name,
        rpp.created_at
    FROM rent_payment_partiality rpp
    LEFT JOIN `user` u ON u.id = rpp.recorded_by
    WHERE rpp.payment_id = p_payment_id
    ORDER BY rpp.paid_at ASC, rpp.id ASC;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `rent_payment_partial_add`(
    IN p_payment_id  INT,
    IN p_amount      DECIMAL(14,2),
    IN p_paid_at     DATETIME,
    IN p_late_fee    DECIMAL(14,2),
    IN p_notes       TEXT,
    IN p_recorded_by INT
)
BEGIN
    DECLARE v_amount_due DECIMAL(14,2);
    DECLARE v_amount_paid DECIMAL(14,2);
    DECLARE v_due_date DATE;
    DECLARE v_late_fee DECIMAL(14,2);
    DECLARE v_new_late_fee DECIMAL(14,2);
    DECLARE v_total_due DECIMAL(14,2);
    DECLARE v_new_amount_paid DECIMAL(14,2);
    DECLARE v_new_status VARCHAR(20);
    DECLARE v_current_status VARCHAR(20);
    DECLARE v_partial_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_amount IS NULL OR p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto de la parcialidad debe ser mayor a 0';
    END IF;

    START TRANSACTION;

    SELECT amount_due, amount_paid, due_date, IFNULL(late_fee, 0), status
      INTO v_amount_due, v_amount_paid, v_due_date, v_late_fee, v_current_status
      FROM rent_payment
     WHERE id = p_payment_id
     FOR UPDATE;

    IF v_amount_due IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pago no encontrado';
    END IF;

    IF v_current_status = 'cancelado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede registrar parcialidad en un pago cancelado';
    END IF;

    SET v_new_late_fee = IFNULL(p_late_fee, v_late_fee);
    SET v_total_due = v_amount_due - v_amount_paid + v_new_late_fee;

    IF p_amount > v_total_due THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La parcialidad excede el saldo pendiente del mes';
    END IF;

    SET v_new_amount_paid = v_amount_paid + p_amount;

    IF v_new_amount_paid >= (v_amount_due + v_new_late_fee) THEN
        SET v_new_status = 'pagado';
    ELSEIF v_new_amount_paid > 0 THEN
        SET v_new_status = 'parcial';
    ELSEIF v_due_date < CURDATE() THEN
        SET v_new_status = 'atrasado';
    ELSE
        SET v_new_status = 'pendiente';
    END IF;

    INSERT INTO rent_payment_partiality (
        payment_id,
        amount,
        paid_at,
        notes,
        recorded_by
    ) VALUES (
        p_payment_id,
        p_amount,
        IFNULL(p_paid_at, NOW()),
        p_notes,
        p_recorded_by
    );

    SET v_partial_id = LAST_INSERT_ID();

    UPDATE rent_payment
       SET amount_paid = v_new_amount_paid,
           paid_at = IFNULL(p_paid_at, NOW()),
           late_fee = v_new_late_fee,
           notes = CASE
                     WHEN p_notes IS NULL OR p_notes = '' THEN notes
                     WHEN notes IS NULL OR notes = '' THEN p_notes
                     ELSE CONCAT(notes, ' | ', p_notes)
                   END,
           status = v_new_status,
           recorded_by = p_recorded_by
     WHERE id = p_payment_id;

    COMMIT;

    SELECT
        rp.*,
        v_partial_id AS partiality_id,
        p_amount AS partial_amount,
        (rp.amount_due - rp.amount_paid + IFNULL(rp.late_fee, 0)) AS balance_due
      FROM rent_payment rp
     WHERE rp.id = p_payment_id;
END ;;
DELIMITER ;

/*!50003 DROP PROCEDURE IF EXISTS `transaction_document_add` */;
DELIMITER ;;
CREATE PROCEDURE `transaction_document_add`(
    IN p_transaction_id   INT,
    IN p_document_type_id INT,
    IN p_file_url         VARCHAR(500),
    IN p_file_name        VARCHAR(255),
    IN p_notes            TEXT,
    IN p_uploaded_by      INT
)
BEGIN
    DECLARE v_transaction_type VARCHAR(20);
    DECLARE v_applicable_to VARCHAR(20);

    SELECT pt.transaction_type
      INTO v_transaction_type
      FROM property_transaction pt
     WHERE pt.id = p_transaction_id
     LIMIT 1;

    IF v_transaction_type IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transacción no encontrada';
    END IF;

    SELECT dt.applicable_to
      INTO v_applicable_to
      FROM document_type dt
     WHERE dt.id = p_document_type_id
     LIMIT 1;

    IF v_applicable_to IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de documento no encontrado';
    END IF;

    IF v_applicable_to <> 'todos' AND v_applicable_to <> v_transaction_type THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El tipo de documento no aplica al tipo de transacción';
    END IF;

    INSERT INTO transaction_document (
        transaction_id, document_type_id, file_url, file_name, notes, uploaded_by
    ) VALUES (
        p_transaction_id, p_document_type_id, p_file_url,
        p_file_name, p_notes, p_uploaded_by
    );

    SELECT LAST_INSERT_ID() AS transaction_document_id;
END ;;
DELIMITER ;

/*!50003 DROP PROCEDURE IF EXISTS `transaction_document_list` */;
DELIMITER ;;
CREATE PROCEDURE `transaction_document_list`(
    IN p_transaction_id INT
)
BEGIN
    SELECT
        td.id,
        td.transaction_id,
        td.document_type_id,
        dt.name       AS document_type_name,
        dt.applicable_to,
        td.file_url,
        td.file_name,
        td.notes,
        td.uploaded_by,
        u.full_name   AS uploaded_by_name,
        td.uploaded_at
      FROM transaction_document td
      LEFT JOIN document_type dt ON dt.id = td.document_type_id
      LEFT JOIN `user` u         ON u.id  = td.uploaded_by
     WHERE td.transaction_id = p_transaction_id
     ORDER BY td.uploaded_at DESC;
END ;;
DELIMITER ;

/*!50003 DROP PROCEDURE IF EXISTS `transaction_document_delete` */;
DELIMITER ;;
CREATE PROCEDURE `transaction_document_delete`(
    IN p_document_id INT
)
BEGIN
    DECLARE v_file_url VARCHAR(500);

    SELECT file_url INTO v_file_url
      FROM transaction_document
     WHERE id = p_document_id;

    DELETE FROM transaction_document WHERE id = p_document_id;

    SELECT ROW_COUNT() AS deleted, v_file_url AS file_url;
END ;;
DELIMITER ;

-- Dump completed on 2026-04-07 17:53:02
/*!50003 DROP PROCEDURE IF EXISTS `property_overdue_list` */;
DELIMITER ;;
CREATE PROCEDURE `property_overdue_list`(
    IN p_search_text VARCHAR(150),
    IN p_city_id INT,
    IN p_zone_id INT,
    IN p_status VARCHAR(20),
    IN p_page_number INT,
    IN p_page_size INT
)
BEGIN
    DECLARE v_page_number INT DEFAULT 1;
    DECLARE v_page_size INT DEFAULT 15;
    DECLARE v_offset INT DEFAULT 0;
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_total_records INT DEFAULT 0;
    DECLARE v_total_pages INT DEFAULT 0;
    DECLARE v_search_text VARCHAR(150) DEFAULT NULL;

    SET v_page_number = IFNULL(p_page_number, 1);
    IF v_page_number < 1 THEN SET v_page_number = 1; END IF;

    SET v_page_size = IFNULL(p_page_size, 15);
    IF v_page_size < 1 THEN SET v_page_size = 15; END IF;
    IF v_page_size > 100 THEN SET v_page_size = 100; END IF;

    SET v_offset = (v_page_number - 1) * v_page_size;

    IF p_status IS NOT NULL AND TRIM(p_status) <> '' THEN
        SET v_status = LOWER(TRIM(p_status));
    END IF;

    IF p_search_text IS NOT NULL AND TRIM(p_search_text) <> '' THEN
        SET v_search_text = TRIM(p_search_text);
    END IF;

    SELECT COUNT(*)
      INTO v_total_records
      FROM (
            SELECT
                p.id AS property_id,
                SUM(CASE WHEN (rp.status = 'atrasado' OR (rp.status = 'pendiente' AND rp.due_date < CURDATE())) THEN 1 ELSE 0 END) AS overdue_atrasado_count,
                SUM(CASE WHEN rp.status = 'parcial' THEN 1 ELSE 0 END) AS overdue_parcial_count
            FROM property p
            INNER JOIN city c ON c.id = p.city_id
            LEFT JOIN zone z ON z.id = p.zone_id
            INNER JOIN (
                SELECT pt1.property_id, pt1.id AS transaction_id, pt1.customer_id
                FROM property_transaction pt1
                INNER JOIN (
                    SELECT property_id, MAX(id) AS latest_transaction_id
                    FROM property_transaction
                    WHERE status = 'activa' AND transaction_type = 'renta'
                    GROUP BY property_id
                ) tx ON tx.latest_transaction_id = pt1.id
            ) atx ON atx.property_id = p.id
            INNER JOIN customer cu ON cu.id = atx.customer_id
            INNER JOIN rent_payment rp ON rp.transaction_id = atx.transaction_id
            WHERE
                (rp.status IN ('atrasado', 'parcial') OR (rp.status = 'pendiente' AND rp.due_date < CURDATE()))
                AND (p_city_id IS NULL OR p.city_id = p_city_id)
                AND (p_zone_id IS NULL OR p.zone_id = p_zone_id)
                AND (
                    v_search_text IS NULL
                    OR p.title LIKE CONCAT('%', v_search_text, '%')
                    OR cu.full_name LIKE CONCAT('%', v_search_text, '%')
                    OR cu.email LIKE CONCAT('%', v_search_text, '%')
                )
            GROUP BY p.id
            HAVING
                v_status IS NULL
                OR v_status = 'todos'
                OR (v_status = 'atrasado' AND overdue_atrasado_count > 0)
                OR (v_status = 'parcial' AND overdue_parcial_count > 0)
      ) q;

    SET v_total_pages = IF(v_total_records = 0, 0, CEIL(v_total_records / v_page_size));

    SELECT
        v_total_records AS total_records,
        v_page_number AS page_number,
        v_page_size AS page_size,
        v_total_pages AS total_pages;

    SELECT
        q.property_id,
        q.title,
        q.city_id,
        q.city_name,
        q.zone_id,
        q.zone_name,
        q.active_transaction_id,
        q.customer_id,
        q.customer_name,
        q.customer_email,
        q.customer_phone,
        q.overdue_payments_count,
        q.overdue_atrasado_count,
        q.overdue_parcial_count,
        q.total_overdue_amount,
        q.oldest_due_date,
        q.max_days_overdue,
        CASE
            WHEN q.overdue_atrasado_count > 0 THEN 'atrasado'
            WHEN q.overdue_parcial_count > 0 THEN 'parcial'
            ELSE 'pendiente'
        END AS overdue_status,
        q.current_payment_id,
        q.current_payment_status,
        q.current_payment_balance_due,
        q.main_image_url
    FROM (
            SELECT
                p.id AS property_id,
                p.title,
                p.city_id,
                c.name AS city_name,
                p.zone_id,
                z.name AS zone_name,
                atx.transaction_id AS active_transaction_id,
                cu.id AS customer_id,
                cu.full_name AS customer_name,
                cu.email AS customer_email,
                cu.phone AS customer_phone,
                SUM(CASE WHEN (rp.status IN ('atrasado', 'parcial') OR (rp.status = 'pendiente' AND rp.due_date < CURDATE())) THEN 1 ELSE 0 END) AS overdue_payments_count,
                SUM(CASE WHEN (rp.status = 'atrasado' OR (rp.status = 'pendiente' AND rp.due_date < CURDATE())) THEN 1 ELSE 0 END) AS overdue_atrasado_count,
                SUM(CASE WHEN rp.status = 'parcial' THEN 1 ELSE 0 END) AS overdue_parcial_count,
                ROUND(SUM(
                    CASE
                        WHEN (rp.status IN ('atrasado', 'parcial') OR (rp.status = 'pendiente' AND rp.due_date < CURDATE()))
                        THEN GREATEST((rp.amount_due + IFNULL(rp.late_fee, 0)) - rp.amount_paid, 0)
                        ELSE 0
                    END
                ), 2) AS total_overdue_amount,
                MIN(CASE WHEN (rp.status IN ('atrasado', 'parcial') OR (rp.status = 'pendiente' AND rp.due_date < CURDATE())) THEN rp.due_date END) AS oldest_due_date,
                MAX(CASE WHEN (rp.status IN ('atrasado', 'parcial') OR (rp.status = 'pendiente' AND rp.due_date < CURDATE())) THEN DATEDIFF(CURDATE(), rp.due_date) ELSE 0 END) AS max_days_overdue,
                rp_cur.id AS current_payment_id,
                rp_cur.status AS current_payment_status,
                GREATEST((rp_cur.amount_due + IFNULL(rp_cur.late_fee, 0)) - rp_cur.amount_paid, 0) AS current_payment_balance_due,
                (
                    SELECT pi2.image_url
                    FROM property_image pi2
                    WHERE pi2.property_id = p.id
                    ORDER BY pi2.sort_order ASC
                    LIMIT 1
                ) AS main_image_url
            FROM property p
            INNER JOIN city c ON c.id = p.city_id
            LEFT JOIN zone z ON z.id = p.zone_id
            INNER JOIN (
                SELECT pt1.property_id, pt1.id AS transaction_id, pt1.customer_id
                FROM property_transaction pt1
                INNER JOIN (
                    SELECT property_id, MAX(id) AS latest_transaction_id
                    FROM property_transaction
                    WHERE status = 'activa' AND transaction_type = 'renta'
                    GROUP BY property_id
                ) tx ON tx.latest_transaction_id = pt1.id
            ) atx ON atx.property_id = p.id
            INNER JOIN customer cu ON cu.id = atx.customer_id
            INNER JOIN rent_payment rp ON rp.transaction_id = atx.transaction_id
            LEFT JOIN rent_payment rp_cur
                   ON rp_cur.transaction_id = atx.transaction_id
                  AND rp_cur.period_year = YEAR(CURDATE())
                  AND rp_cur.period_month = MONTH(CURDATE())
            WHERE
                (rp.status IN ('atrasado', 'parcial') OR (rp.status = 'pendiente' AND rp.due_date < CURDATE()))
                AND (p_city_id IS NULL OR p.city_id = p_city_id)
                AND (p_zone_id IS NULL OR p.zone_id = p_zone_id)
                AND (
                    v_search_text IS NULL
                    OR p.title LIKE CONCAT('%', v_search_text, '%')
                    OR cu.full_name LIKE CONCAT('%', v_search_text, '%')
                    OR cu.email LIKE CONCAT('%', v_search_text, '%')
                )
            GROUP BY
                p.id,
                p.title,
                p.city_id,
                c.name,
                p.zone_id,
                z.name,
                atx.transaction_id,
                cu.id,
                cu.full_name,
                cu.email,
                cu.phone,
                rp_cur.id,
                rp_cur.status,
                rp_cur.amount_due,
                rp_cur.amount_paid,
                rp_cur.late_fee
            HAVING
                v_status IS NULL
                OR v_status = 'todos'
                OR (v_status = 'atrasado' AND overdue_atrasado_count > 0)
                OR (v_status = 'parcial' AND overdue_parcial_count > 0)
    ) q
    ORDER BY q.max_days_overdue DESC, q.total_overdue_amount DESC, q.property_id DESC
    LIMIT v_offset, v_page_size;
END ;;
DELIMITER ;

SELECT 'property_overdue_list_applied' AS result;
SET @db_name = DATABASE();

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'curp');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN curp VARCHAR(25) NULL AFTER rfc', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'razon_social');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN razon_social VARCHAR(180) NULL AFTER business_name', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'tipo_persona');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN tipo_persona VARCHAR(20) NULL AFTER razon_social', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_street');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_street VARCHAR(150) NULL AFTER address_line', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_number');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_number VARCHAR(30) NULL AFTER address_street', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_neighborhood');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_neighborhood VARCHAR(120) NULL AFTER address_number', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_city');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_city VARCHAR(120) NULL AFTER address_neighborhood', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_state');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_state VARCHAR(120) NULL AFTER address_city', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_zip');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_zip VARCHAR(20) NULL AFTER address_state', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_country');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_country VARCHAR(120) NULL AFTER address_zip', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'preferred_currency');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN preferred_currency VARCHAR(10) NULL AFTER address_country', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'interest_type');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN interest_type VARCHAR(20) NULL AFTER preferred_currency', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'interest_zones');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN interest_zones TEXT NULL AFTER interest_type', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'interest_property_types');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN interest_property_types TEXT NULL AFTER interest_zones', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

DROP PROCEDURE IF EXISTS customer_list;
DELIMITER ;;
CREATE PROCEDURE customer_list(
    IN p_search_text VARCHAR(150),
    IN p_status VARCHAR(20),
    IN p_customer_type VARCHAR(50),
    IN p_assigned_agent_id INT,
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

    IF p_status IS NOT NULL AND p_status <> '' AND p_status NOT IN ('activo','inactivo','bloqueado') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'status inválido. Usa: activo, inactivo, bloqueado';
    END IF;

    SET v_offset = (p_page_number - 1) * p_page_size;

    SELECT COUNT(*)
      INTO v_total_records
    FROM customer c
    WHERE (
        p_search_text IS NULL
        OR p_search_text = ''
        OR c.full_name LIKE CONCAT('%', p_search_text, '%')
        OR c.email LIKE CONCAT('%', p_search_text, '%')
        OR c.phone LIKE CONCAT('%', p_search_text, '%')
        OR c.rfc LIKE CONCAT('%', p_search_text, '%')
        OR c.curp LIKE CONCAT('%', p_search_text, '%')
    )
      AND (p_status IS NULL OR p_status = '' OR c.status = p_status)
      AND (p_customer_type IS NULL OR p_customer_type = '' OR c.customer_type = p_customer_type)
      AND (p_assigned_agent_id IS NULL OR c.assigned_agent_id = p_assigned_agent_id);

    SET v_total_pages = CEIL(v_total_records / p_page_size);

    SELECT
        v_total_records AS total_records,
        p_page_number AS page_number,
        p_page_size AS page_size,
        v_total_pages AS total_pages;

    SELECT
        c.id,
        c.full_name,
        c.email,
        c.phone,
        c.customer_type,
        c.status,
        c.source,
        c.assigned_agent_id,
        ua.full_name AS assigned_agent_name,
        c.last_contact_at,
        c.next_follow_up_at,
        c.rfc,
        c.curp,
        c.business_name,
        c.razon_social,
        c.tipo_persona,
        c.billing_email,
        c.address_line,
        c.address_city,
        c.address_state,
        c.address_country,
        c.preferred_currency,
        c.interest_type,
        c.interest_zones,
        c.interest_property_types,
        c.notes,
        (
            SELECT COUNT(*)
            FROM customer_note cn
            WHERE cn.customer_id = c.id
        ) AS notes_count,
        (
            SELECT cn.note
            FROM customer_note cn
            WHERE cn.customer_id = c.id
            ORDER BY cn.created_at DESC, cn.id DESC
            LIMIT 1
        ) AS last_note,
        (
            SELECT cn.created_at
            FROM customer_note cn
            WHERE cn.customer_id = c.id
            ORDER BY cn.created_at DESC, cn.id DESC
            LIMIT 1
        ) AS last_note_at,
        (
            SELECT COUNT(*)
            FROM lead_contact lc
            WHERE lc.customer_id = c.id
              AND lc.status <> 'cerrado'
        ) AS open_leads_count,
        (
            SELECT COUNT(*)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
              AND pt.status = 'activa'
        ) AS active_transactions_count,
        (
            SELECT COUNT(*)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
        ) AS total_transactions_count,
        (
            SELECT COALESCE(SUM(fn_convert_to_base(COALESCE(pt.final_price, 0), pt.currency, 'MXN')), 0)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
        ) AS total_spent_or_rented_mxn,
        (
            SELECT COUNT(*)
            FROM rent_payment rp
            INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
            WHERE pt.customer_id = c.id
              AND rp.status = 'atrasado'
        ) AS overdue_payments_count,
        (
            SELECT MIN(rp.due_date)
            FROM rent_payment rp
            INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
            WHERE pt.customer_id = c.id
              AND rp.status IN ('pendiente','parcial','atrasado')
        ) AS next_due_date,
        c.created_at,
        c.updated_at
    FROM customer c
    LEFT JOIN `user` ua ON ua.id = c.assigned_agent_id
    WHERE (
        p_search_text IS NULL
        OR p_search_text = ''
        OR c.full_name LIKE CONCAT('%', p_search_text, '%')
        OR c.email LIKE CONCAT('%', p_search_text, '%')
        OR c.phone LIKE CONCAT('%', p_search_text, '%')
        OR c.rfc LIKE CONCAT('%', p_search_text, '%')
        OR c.curp LIKE CONCAT('%', p_search_text, '%')
    )
      AND (p_status IS NULL OR p_status = '' OR c.status = p_status)
      AND (p_customer_type IS NULL OR p_customer_type = '' OR c.customer_type = p_customer_type)
      AND (p_assigned_agent_id IS NULL OR c.assigned_agent_id = p_assigned_agent_id)
    ORDER BY c.created_at DESC, c.id DESC
    LIMIT p_page_size OFFSET v_offset;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS customer_detail;
DELIMITER ;;
CREATE PROCEDURE customer_detail(
    IN p_customer_id INT
)
BEGIN
    DECLARE v_exists INT;

    SELECT id INTO v_exists
    FROM customer
    WHERE id = p_customer_id
    LIMIT 1;

    IF v_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente no encontrado';
    END IF;

    SELECT
        c.id,
        c.full_name,
        c.email,
        c.phone,
        c.customer_type,
        c.status,
        c.source,
        c.assigned_agent_id,
        ua.full_name AS assigned_agent_name,
        c.last_contact_at,
        c.next_follow_up_at,
        c.rfc,
        c.curp,
        c.business_name,
        c.razon_social,
        c.tipo_persona,
        c.billing_email,
        c.address_line,
        c.address_street,
        c.address_number,
        c.address_neighborhood,
        c.address_city,
        c.address_state,
        c.address_zip,
        c.address_country,
        c.preferred_currency,
        c.interest_type,
        c.interest_zones,
        c.interest_property_types,
        c.notes,
        (
            SELECT COUNT(*)
            FROM customer_note cn
            WHERE cn.customer_id = c.id
        ) AS notes_count,
        (
            SELECT cn.note
            FROM customer_note cn
            WHERE cn.customer_id = c.id
            ORDER BY cn.created_at DESC, cn.id DESC
            LIMIT 1
        ) AS last_note,
        (
            SELECT cn.created_at
            FROM customer_note cn
            WHERE cn.customer_id = c.id
            ORDER BY cn.created_at DESC, cn.id DESC
            LIMIT 1
        ) AS last_note_at,
        c.created_by,
        ucb.full_name AS created_by_name,
        c.updated_by,
        uub.full_name AS updated_by_name,
        (
            SELECT COUNT(*)
            FROM lead_contact lc
            WHERE lc.customer_id = c.id
              AND lc.status <> 'cerrado'
        ) AS open_leads_count,
        (
            SELECT COUNT(*)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
              AND pt.status = 'activa'
        ) AS active_transactions_count,
        (
            SELECT COUNT(*)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
        ) AS total_transactions_count,
        (
            SELECT COALESCE(SUM(fn_convert_to_base(COALESCE(pt.final_price, 0), pt.currency, 'MXN')), 0)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
        ) AS total_spent_or_rented_mxn,
        (
            SELECT COUNT(*)
            FROM rent_payment rp
            INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
            WHERE pt.customer_id = c.id
              AND rp.status = 'atrasado'
        ) AS overdue_payments_count,
        (
            SELECT COALESCE(SUM(GREATEST((rp.amount_due + COALESCE(rp.late_fee, 0)) - rp.amount_paid, 0)), 0)
            FROM rent_payment rp
            INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
            WHERE pt.customer_id = c.id
              AND rp.status IN ('pendiente','parcial','atrasado')
        ) AS outstanding_balance_mxn,
        c.created_at,
        c.updated_at
    FROM customer c
    LEFT JOIN `user` ua ON ua.id = c.assigned_agent_id
    LEFT JOIN `user` ucb ON ucb.id = c.created_by
    LEFT JOIN `user` uub ON uub.id = c.updated_by
    WHERE c.id = p_customer_id
    LIMIT 1;

    SELECT
        lc.id AS lead_contact_id,
        lc.property_id,
        p.title AS property_title,
        lc.name,
        lc.email,
        lc.phone,
        lc.status,
        lc.comments,
        lc.created_at,
        lc.updated_at
    FROM lead_contact lc
    LEFT JOIN property p ON p.id = lc.property_id
    WHERE lc.customer_id = p_customer_id
    ORDER BY lc.created_at DESC, lc.id DESC;

    SELECT
        pt.id AS transaction_id,
        pt.property_id,
        p.title AS property_title,
        pt.transaction_type,
        pt.status,
        pt.final_price,
        pt.currency,
        pt.transaction_date,
        pt.notes,
        pt.cancelled_at,
        pt.cancel_reason,
        pt.created_at
    FROM property_transaction pt
    LEFT JOIN property p ON p.id = pt.property_id
    WHERE pt.customer_id = p_customer_id
    ORDER BY pt.transaction_date DESC, pt.id DESC;

    SELECT
        rp.id AS payment_id,
        rp.transaction_id,
        rp.period_year,
        rp.period_month,
        rp.due_date,
        rp.amount_due,
        rp.amount_paid,
        GREATEST((rp.amount_due + COALESCE(rp.late_fee, 0)) - rp.amount_paid, 0) AS amount_pending,
        rp.currency,
        rp.status,
        rp.late_fee,
        rp.paid_at,
        rp.notes,
        rp.updated_at
    FROM rent_payment rp
    INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
    WHERE pt.customer_id = p_customer_id
    ORDER BY rp.due_date DESC, rp.id DESC;

    SELECT
        cn.id AS note_id,
        cn.customer_id,
        cn.note,
        cn.created_by,
        u.full_name AS created_by_name,
        cn.created_at
    FROM customer_note cn
    LEFT JOIN `user` u ON u.id = cn.created_by
    WHERE cn.customer_id = p_customer_id
    ORDER BY cn.created_at DESC, cn.id DESC;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS customer_upsert;
DELIMITER ;;
CREATE PROCEDURE customer_upsert(
    IN p_id INT,
    IN p_full_name VARCHAR(150),
    IN p_email VARCHAR(150),
    IN p_phone VARCHAR(50),
    IN p_customer_type VARCHAR(50),
    IN p_notes TEXT,
    IN p_status VARCHAR(20),
    IN p_source VARCHAR(50),
    IN p_assigned_agent_id INT,
    IN p_last_contact_at DATETIME,
    IN p_next_follow_up_at DATETIME,
    IN p_rfc VARCHAR(20),
    IN p_curp VARCHAR(25),
    IN p_business_name VARCHAR(150),
    IN p_razon_social VARCHAR(180),
    IN p_tipo_persona VARCHAR(20),
    IN p_billing_email VARCHAR(150),
    IN p_address_line VARCHAR(255),
    IN p_address_street VARCHAR(150),
    IN p_address_number VARCHAR(30),
    IN p_address_neighborhood VARCHAR(120),
    IN p_address_city VARCHAR(120),
    IN p_address_state VARCHAR(120),
    IN p_address_zip VARCHAR(20),
    IN p_address_country VARCHAR(120),
    IN p_preferred_currency VARCHAR(10),
    IN p_interest_type VARCHAR(20),
    IN p_interest_zones TEXT,
    IN p_interest_property_types TEXT,
    IN p_actor_user_id INT
)
BEGIN
    DECLARE v_customer_id INT;
    DECLARE v_status VARCHAR(20);
    DECLARE v_tipo_persona VARCHAR(20);
    DECLARE v_interest_type VARCHAR(20);
    DECLARE v_preferred_currency VARCHAR(10);

    IF p_full_name IS NULL OR TRIM(p_full_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'full_name es requerido';
    END IF;

    SET v_status = COALESCE(NULLIF(TRIM(p_status), ''), 'activo');
    IF v_status NOT IN ('activo','inactivo','bloqueado') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'status inválido. Usa: activo, inactivo, bloqueado';
    END IF;

    SET v_tipo_persona = LOWER(NULLIF(TRIM(COALESCE(p_tipo_persona, '')), ''));
    IF v_tipo_persona IS NOT NULL AND v_tipo_persona NOT IN ('fisica', 'moral') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'tipo_persona inválido. Usa: fisica o moral';
    END IF;

    SET v_interest_type = LOWER(NULLIF(TRIM(COALESCE(p_interest_type, '')), ''));
    IF v_interest_type IS NOT NULL AND v_interest_type NOT IN ('compra', 'renta', 'venta') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'interest_type inválido. Usa: compra, renta o venta';
    END IF;

    SET v_preferred_currency = UPPER(NULLIF(TRIM(COALESCE(p_preferred_currency, '')), ''));
    IF v_preferred_currency IS NOT NULL AND v_preferred_currency NOT IN ('MXN', 'USD') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'preferred_currency inválido. Usa: MXN o USD';
    END IF;

    IF p_id IS NULL OR p_id = 0 THEN
        INSERT INTO customer (
            full_name,
            email,
            phone,
            customer_type,
            notes,
            status,
            source,
            assigned_agent_id,
            last_contact_at,
            next_follow_up_at,
            rfc,
            curp,
            business_name,
            razon_social,
            tipo_persona,
            billing_email,
            address_line,
            address_street,
            address_number,
            address_neighborhood,
            address_city,
            address_state,
            address_zip,
            address_country,
            preferred_currency,
            interest_type,
            interest_zones,
            interest_property_types,
            created_by,
            updated_by
        )
        VALUES (
            TRIM(p_full_name),
            p_email,
            p_phone,
            p_customer_type,
            p_notes,
            v_status,
            p_source,
            p_assigned_agent_id,
            p_last_contact_at,
            p_next_follow_up_at,
            p_rfc,
            p_curp,
            p_business_name,
            p_razon_social,
            v_tipo_persona,
            p_billing_email,
            p_address_line,
            p_address_street,
            p_address_number,
            p_address_neighborhood,
            p_address_city,
            p_address_state,
            p_address_zip,
            p_address_country,
            v_preferred_currency,
            v_interest_type,
            p_interest_zones,
            p_interest_property_types,
            p_actor_user_id,
            p_actor_user_id
        );

        SET v_customer_id = LAST_INSERT_ID();
    ELSE
        UPDATE customer
           SET full_name = TRIM(p_full_name),
               email = p_email,
               phone = p_phone,
               customer_type = p_customer_type,
               notes = p_notes,
               status = v_status,
               source = p_source,
               assigned_agent_id = p_assigned_agent_id,
               last_contact_at = p_last_contact_at,
               next_follow_up_at = p_next_follow_up_at,
               rfc = p_rfc,
               curp = p_curp,
               business_name = p_business_name,
               razon_social = p_razon_social,
               tipo_persona = v_tipo_persona,
               billing_email = p_billing_email,
               address_line = p_address_line,
               address_street = p_address_street,
               address_number = p_address_number,
               address_neighborhood = p_address_neighborhood,
               address_city = p_address_city,
               address_state = p_address_state,
               address_zip = p_address_zip,
               address_country = p_address_country,
               preferred_currency = v_preferred_currency,
               interest_type = v_interest_type,
               interest_zones = p_interest_zones,
               interest_property_types = p_interest_property_types,
               updated_by = p_actor_user_id
         WHERE id = p_id;

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente no encontrado';
        END IF;

        SET v_customer_id = p_id;
    END IF;

    SELECT v_customer_id AS customer_id;
END ;;
DELIMITER ;

SELECT 'customer_extended_profile_applied' AS result;
