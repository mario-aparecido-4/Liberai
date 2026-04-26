CREATE DATABASE  IF NOT EXISTS `glpi` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `glpi`;
-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: glpi
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

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
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (2,'Alunos'),(1,'Supervisores');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',3,'add_permission'),(6,'Can change permission',3,'change_permission'),(7,'Can delete permission',3,'delete_permission'),(8,'Can view permission',3,'view_permission'),(9,'Can add group',2,'add_group'),(10,'Can change group',2,'change_group'),(11,'Can delete group',2,'delete_group'),(12,'Can view group',2,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add espaco',7,'add_espaco'),(26,'Can change espaco',7,'change_espaco'),(27,'Can delete espaco',7,'delete_espaco'),(28,'Can view espaco',7,'view_espaco'),(29,'Can add Solicitação',8,'add_solicitacao'),(30,'Can change Solicitação',8,'change_solicitacao'),(31,'Can delete Solicitação',8,'delete_solicitacao'),(32,'Can view Solicitação',8,'view_solicitacao');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1200000$HG9gqKTx3eOP3yI5sizkhp$kxU4HjhIAC+mOMCKQI8iCiQDhgHEu4dXx47lvskxB0c=','2026-01-06 11:01:02.337275',1,'admin','Administrador','Django','',1,1,'2025-12-31 01:03:26.000000'),(2,'pbkdf2_sha256$1200000$1GNY797zr7KH9RpfxjDF5I$u/tRpeMQ0ZDRVX1e8/GLX9QctX1pO07AHzlC9rghOd0=','2026-01-05 23:24:50.012450',0,'aluno','Aluno','Teste','',0,1,'2026-01-05 17:19:18.000000'),(3,'pbkdf2_sha256$1200000$ij6gXzeMiHPuHllRVbLWVp$QOXx6U/8MCouoWm/qHGJP1F3RoY1hFMOSXchGjOPhlk=','2026-01-05 20:14:39.506793',0,'supervisor','Supervisor','Teste','',0,1,'2026-01-05 19:18:19.000000');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
INSERT INTO `auth_user_groups` VALUES (1,2,2),(2,3,1);
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_unicode_ci,
  `object_repr` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2026-01-05 17:19:19.455958','2','aluno_teste',1,'[{\"added\": {}}]',4,1),(2,'2026-01-05 17:39:59.219853','2','aluno',2,'[{\"changed\": {\"fields\": [\"Username\", \"First name\", \"Last name\"]}}]',4,1),(3,'2026-01-05 19:16:45.170308','1','Supervisores',1,'[{\"added\": {}}]',2,1),(4,'2026-01-05 19:16:55.536655','2','Alunos',1,'[{\"added\": {}}]',2,1),(5,'2026-01-05 19:17:02.635097','2','Alunos',2,'[]',2,1),(6,'2026-01-05 19:17:42.565672','2','aluno',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',4,1),(7,'2026-01-05 19:18:20.725131','3','supervisor',1,'[{\"added\": {}}]',4,1),(8,'2026-01-05 19:18:45.981295','3','supervisor',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Groups\"]}}]',4,1),(9,'2026-01-05 19:19:33.229222','1','Quadra Poliesportiva',1,'[{\"added\": {}}]',7,1),(10,'2026-01-05 19:19:46.331941','2','Auditório',1,'[{\"added\": {}}]',7,1),(11,'2026-01-05 19:19:57.944097','3','Quadra de Areia',1,'[{\"added\": {}}]',7,1),(12,'2026-01-05 19:20:32.916720','1','admin',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\"]}}]',4,1),(13,'2026-01-05 23:23:44.774003','1','Quadra Poliesportiva - admin (Pendente)',3,'',8,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(2,'auth','group'),(3,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(7,'glpi','espaco'),(8,'glpi','solicitacao'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-12-31 01:01:28.384152'),(2,'auth','0001_initial','2025-12-31 01:01:29.262197'),(3,'admin','0001_initial','2025-12-31 01:01:29.490179'),(4,'admin','0002_logentry_remove_auto_add','2025-12-31 01:01:29.508362'),(5,'admin','0003_logentry_add_action_flag_choices','2025-12-31 01:01:29.532767'),(6,'contenttypes','0002_remove_content_type_name','2025-12-31 01:01:29.724135'),(7,'auth','0002_alter_permission_name_max_length','2025-12-31 01:01:29.824136'),(8,'auth','0003_alter_user_email_max_length','2025-12-31 01:01:29.870331'),(9,'auth','0004_alter_user_username_opts','2025-12-31 01:01:29.888418'),(10,'auth','0005_alter_user_last_login_null','2025-12-31 01:01:29.973036'),(11,'auth','0006_require_contenttypes_0002','2025-12-31 01:01:29.977579'),(12,'auth','0007_alter_validators_add_error_messages','2025-12-31 01:01:29.995681'),(13,'auth','0008_alter_user_username_max_length','2025-12-31 01:01:30.101089'),(14,'auth','0009_alter_user_last_name_max_length','2025-12-31 01:01:30.207442'),(15,'auth','0010_alter_group_name_max_length','2025-12-31 01:01:30.246769'),(16,'auth','0011_update_proxy_permissions','2025-12-31 01:01:30.268502'),(17,'auth','0012_alter_user_first_name_max_length','2025-12-31 01:01:30.378559'),(18,'glpi','0001_initial','2025-12-31 01:01:30.739264'),(19,'sessions','0001_initial','2025-12-31 01:01:30.797645'),(20,'glpi','0002_alter_espaco_options_solicitacao_updated_at_and_more','2025-12-31 01:28:52.360584'),(21,'glpi','0002_remove_solicitacao_detalhes','2026-01-05 22:52:31.101994'),(22,'glpi','0003_solicitacao_detalhes','2026-01-05 22:54:48.638828'),(23,'glpi','0004_alter_solicitacao_detalhes','2026-01-05 22:56:57.557810');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('gbl5l6e9dwl47sikvsjrbj4xg9jftmrc','.eJxVjMsOwiAQAP-FsyFlKS-P3vsNZBdYWzUlKe3J-O-GpAe9zkzmLSIe-xyPVra4ZHEVSlx-GWF6lrWL_MD1XmWq674tJHsiT9vkVHN53c72bzBjm_sWwCCiUz5QURRsBtCMAwYwPJrBkNUaQmKwiokdsxmdp6QBbbHBi88X1gg3pA:1vd4oA:XXCS3cMeAcROCdLVlBMtmzM2d2FAFTB8akMPJTLwahc','2026-01-20 11:01:02.343771');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_espaco`
--

DROP TABLE IF EXISTS `glpi_espaco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `glpi_espaco` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descricao` longtext COLLATE utf8mb4_unicode_ci,
  `capacidade` int NOT NULL,
  `ativo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_espaco`
--

LOCK TABLES `glpi_espaco` WRITE;
/*!40000 ALTER TABLE `glpi_espaco` DISABLE KEYS */;
INSERT INTO `glpi_espaco` VALUES (1,'Quadra Poliesportiva','',50,1),(2,'Auditório','',345,1),(3,'Quadra de Areia','',20,1);
/*!40000 ALTER TABLE `glpi_espaco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glpi_solicitacao`
--

DROP TABLE IF EXISTS `glpi_solicitacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `glpi_solicitacao` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `data_inicio` datetime(6) NOT NULL,
  `data_fim` datetime(6) NOT NULL,
  `motivo` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observacao_admin` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` datetime(6) NOT NULL,
  `aprovado_por_id` int DEFAULT NULL,
  `espaco_id` bigint NOT NULL,
  `solicitante_id` int NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `detalhes` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `glpi_solicitacao_aprovado_por_id_718c4f3a_fk_auth_user_id` (`aprovado_por_id`),
  KEY `glpi_solicitacao_espaco_id_00f1a013_fk_glpi_espaco_id` (`espaco_id`),
  KEY `glpi_solicitacao_solicitante_id_8a788395_fk_auth_user_id` (`solicitante_id`),
  CONSTRAINT `glpi_solicitacao_aprovado_por_id_718c4f3a_fk_auth_user_id` FOREIGN KEY (`aprovado_por_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `glpi_solicitacao_espaco_id_00f1a013_fk_glpi_espaco_id` FOREIGN KEY (`espaco_id`) REFERENCES `glpi_espaco` (`id`),
  CONSTRAINT `glpi_solicitacao_solicitante_id_8a788395_fk_auth_user_id` FOREIGN KEY (`solicitante_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_solicitacao`
--

LOCK TABLES `glpi_solicitacao` WRITE;
/*!40000 ALTER TABLE `glpi_solicitacao` DISABLE KEYS */;
INSERT INTO `glpi_solicitacao` VALUES (2,'2026-01-28 10:50:00.000000','2026-01-28 11:40:00.000000','Futsal','PENDENTE',NULL,'2026-01-05 23:18:50.844414',NULL,1,1,'2026-01-05 23:18:50.844443','Joguim pae'),(3,'2026-02-04 17:00:00.000000','2026-02-04 20:30:00.000000','Volei','PENDENTE',NULL,'2026-01-06 11:03:31.651343',NULL,3,1,'2026-01-06 11:03:31.651376','Treino de Volei'),(4,'2026-02-05 10:00:00.000000','2026-02-06 21:20:00.000000','Torneio estudantil','PENDENTE',NULL,'2026-01-06 12:22:51.265744',NULL,1,1,'2026-01-06 12:22:51.265769','Copa anonymous');
/*!40000 ALTER TABLE `glpi_solicitacao` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-26 17:13:57
