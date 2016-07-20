-- MySQL dump 10.16  Distrib 10.1.14-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: project
-- ------------------------------------------------------
-- Server version	10.1.14-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `events`
--

USE project;

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events` (
  `eid` int(11) NOT NULL AUTO_INCREMENT,
  `scope` tinyint(4) NOT NULL DEFAULT '1',
  `aid` int(11) NOT NULL DEFAULT '0',
  `name` varchar(100) NOT NULL,
  `desc` text NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date` varchar(10) NOT NULL,
  `location` varchar(100) NOT NULL,
  `latitude` double NOT NULL DEFAULT '0',
  `longitude` double NOT NULL DEFAULT '0',
  `contactname` varchar(100) DEFAULT NULL,
  `contactphone` varchar(16) DEFAULT NULL,
  `contactemail` varchar(100) DEFAULT NULL,
  `tags` text,
  `startTime` varchar(8) NOT NULL,
  `endTime` varchar(8) NOT NULL,
  PRIMARY KEY (`eid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `likes` (
  `sid` int(11) NOT NULL,
  `eid` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `likes_student_sid_fk` (`sid`),
  KEY `likes_events_eid_fk` (`eid`),
  CONSTRAINT `likes_events_eid_fk` FOREIGN KEY (`eid`) REFERENCES `events` (`eid`) ON DELETE CASCADE,
  CONSTRAINT `likes_student_sid_fk` FOREIGN KEY (`sid`) REFERENCES `student` (`sid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `message`
--

DROP TABLE IF EXISTS `message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `message` (
  `mid` int(11) NOT NULL AUTO_INCREMENT,
  `eid` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `message` text NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`mid`),
  KEY `message_events_eid_fk` (`eid`),
  KEY `message_student_sid_fk` (`sid`),
  CONSTRAINT `message_events_eid_fk` FOREIGN KEY (`eid`) REFERENCES `events` (`eid`) ON DELETE CASCADE,
  CONSTRAINT `message_student_sid_fk` FOREIGN KEY (`sid`) REFERENCES `student` (`sid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rso_data`
--

DROP TABLE IF EXISTS `rso_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rso_data` (
  `rid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `desc` text,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sid` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `approved` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`rid`),
  KEY `rso_data_student_sid_fk` (`sid`),
  KEY `rso_data_university_uid_fk` (`uid`),
  CONSTRAINT `rso_data_student_sid_fk` FOREIGN KEY (`sid`) REFERENCES `student` (`sid`) ON DELETE CASCADE,
  CONSTRAINT `rso_data_university_uid_fk` FOREIGN KEY (`uid`) REFERENCES `university` (`uid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `rso_created` AFTER INSERT ON `rso_data` FOR EACH ROW INSERT INTO `rso_membership` (`rid`, `sid`)
VALUES (NEW.rid, NEW.sid) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `rso_membership`
--

DROP TABLE IF EXISTS `rso_membership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rso_membership` (
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sid` int(11) NOT NULL,
  `rid` int(11) NOT NULL,
  KEY `rid` (`rid`),
  KEY `sid` (`sid`),
  CONSTRAINT `rso_membership_rso_data_rid_fk` FOREIGN KEY (`rid`) REFERENCES `rso_data` (`rid`) ON DELETE CASCADE,
  CONSTRAINT `rso_membership_student_sid_fk` FOREIGN KEY (`sid`) REFERENCES `student` (`sid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session` (
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sid` int(11) NOT NULL,
  `ip` int(11) NOT NULL,
  `token` varchar(36) NOT NULL,
  KEY `sid` (`sid`),
  KEY `ip` (`ip`),
  CONSTRAINT `session_student_sid_fk` FOREIGN KEY (`sid`) REFERENCES `student` (`sid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student` (
  `sid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(36) NOT NULL,
  `salt` varchar(12) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`sid`),
  UNIQUE KEY `student_username_uindex` (`username`),
  UNIQUE KEY `student_email_uindex` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `university`
--

DROP TABLE IF EXISTS `university`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `university` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `domain` varchar(100) NOT NULL,
  `sid` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `latitude` double NOT NULL DEFAULT '0',
  `longitude` double NOT NULL DEFAULT '0',
  `motto` varchar(100) DEFAULT NULL,
  `desc` text,
  `image` text,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-07-20  4:04:14

INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'matt', 'matt@knights.ucf.edu', 'eee094451368cab2362fb41bf0e96655b130', '0aa6dfef9be2', '2016-07-20 04:38:49');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (2, 'jon', 'jon@mit.edu', 'a5e6e718f0320688596ad21384d6d7fb26e4', 'b5d675751da4', '2016-07-20 05:02:17');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cayson', 'cayson@knights.ucf.edu', '5fc9cd898c2c6b4f2a170e8f046855bfd318', '0befcf69854e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'malaya', 'malaya@knights.ucf.edu', '0e72ec23e1a16a527c9744ecdf9d7522a0a9', 'e8b60069c7e4', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'remy', 'remy@knights.ucf.edu', 'aeb5a465db75ddda48e80401fbe86bdfcf4c', '396ac8cb4c9f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brentley', 'brentley@knights.ucf.edu', 'b5ed44b73283fb591a146f1c0aeb7dfb1419', '071e6f633e9d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kieran', 'kieran@knights.ucf.edu', '7dc2456c9807c87547583983ef9aab096191', '135a0eb19aa7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'langston', 'langston@knights.ucf.edu', 'ff91cf7a5f62852c5f3f153fd3c6a4cef94d', '161687b1ad9f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'evie', 'evie@knights.ucf.edu', '0da8d245be94ce2b5a6a01a84139aa051c3c', 'ce9b565e286c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'yusuf', 'yusuf@knights.ucf.edu', '784a99580d8d2a306894e4b4ee3e51ece98e', '7f981b9dfa43', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alexzander', 'alexzander@knights.ucf.edu', '74a92caf128adadc2adf9b041f019bd6a120', '18719c6bb865', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ulises', 'ulises@knights.ucf.edu', 'a086d58896c447dd559fb84536866b95aa33', '79e5e361acf6', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'raphael', 'raphael@knights.ucf.edu', '1455a5c5441f169aed5bcee67862b404936e', 'b94f3d45cfe5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'clark', 'clark@knights.ucf.edu', 'f21bf0a2bb9867254c10ab21653764f78e89', 'ce56acf224d5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ayleen', 'ayleen@knights.ucf.edu', '79456dc73196bb993fd6b485de85aefc0e42', '68ffd8bf1dfb', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aubrianna', 'aubrianna@knights.ucf.edu', '0280665d2ad17120eb5f52c7caa09cf85763', '42137461682b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alex', 'alex@knights.ucf.edu', 'a857c6433635a87f79db41a87b1d69183f55', '05905e9acbd5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jasiah', 'jasiah@knights.ucf.edu', 'b4b51155cfebf977dcafc180e7c9c3b02a24', 'b2e290337c9e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dante', 'dante@knights.ucf.edu', 'c93c7f27cd04cbc3eac578b8d09b5e400d87', 'f2b9f7fe3a30', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ada', 'ada@knights.ucf.edu', '945e10590a0aa64af95ca1376d68c34fdcef', '230dc4c16cbd', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sydney', 'sydney@knights.ucf.edu', 'd046d870405ec94a12a5581c655857f0528f', 'e4a781c6fd3e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brock', 'brock@knights.ucf.edu', 'cdb7b4b4347d56f49bef2a75de64119ae5bb', 'ac0af3992738', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ford', 'ford@knights.ucf.edu', '60fe16731e78f137e4ba2bf59256da7b39dd', 'fa345a2e1ca0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'talia', 'talia@knights.ucf.edu', 'd4d6e6378a231c5caed800f3f62af4bbd8ce', 'ba2e6d382003', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'joy', 'joy@knights.ucf.edu', '2ec6a58a9e9126e2151a6e31a045b043c77a', '41b08052c9cf', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'anson', 'anson@knights.ucf.edu', '8f7fc26a620b19f1f08ec610999aa812af94', '954e7adc2d57', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'azalea', 'azalea@knights.ucf.edu', 'ceeaf52d6527983c8067f18441a6263637db', 'eb067bf54093', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cain', 'cain@knights.ucf.edu', '37d940f7c656ec98e303fe7766e14528682c', '367ed58c655b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'harley', 'harley@knights.ucf.edu', '5d77be2e2ed9cea6ac8788b7a3d7d7051c14', '45a65ed8c48b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cedric', 'cedric@knights.ucf.edu', 'b466e47ad6484e10af45892d9257c3290117', '50e2583d1257', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'adilynn', 'adilynn@knights.ucf.edu', 'b925b01fc240319ea916107204e5a74baf27', 'dd6ee5ecf053', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'darian', 'darian@knights.ucf.edu', 'c925e417bbd8d98f69528577a6609e6b9409', '1279fe39394d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ty', 'ty@knights.ucf.edu', '7f0de078d13144aec4740e3b628e3a2d2f4b', '879619ef161d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'byron', 'byron@knights.ucf.edu', '921060798d76238a6c7e24be530acb1af407', '604d1ffa562c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bowen', 'bowen@knights.ucf.edu', '713034ad36c6e9d0b9c3d1d7cb643958b703', 'ee22d62927ef', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'helen', 'helen@knights.ucf.edu', '5b39aea6f351b4c240d813b346ce6f2ceb09', 'ef3642b69691', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'chase', 'chase@knights.ucf.edu', 'aa67774ac8a0b874b46a84f9da313f54b806', 'a5ffd90a5e64', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'colt', 'colt@knights.ucf.edu', '950525afdab213fde124d8001f6901297587', '38985c63f591', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'emiliano', 'emiliano@knights.ucf.edu', 'e9f397a71e4a0f13f36517edc47331fd165a', '608cd12f394d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sonny', 'sonny@knights.ucf.edu', 'b3f27363943e621b5d659f00012ba1efc9ae', 'e477c248ac9d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ivanna', 'ivanna@knights.ucf.edu', '17dc246d4a50ddab142273ce7449c82947cb', '75f53fe30d0e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'claudia', 'claudia@knights.ucf.edu', '2b9ff0b63a48cffaceb5c156826418116501', 'f3ec2e1c3357', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bryan', 'bryan@knights.ucf.edu', 'fd039882b729d2523d90674caf1cf471c391', 'af5f783ea56d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'marc', 'marc@knights.ucf.edu', '2e80b19f8a094dc57490b2a05afe6f32aabb', '19fcc05d2634', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cohen', 'cohen@knights.ucf.edu', '3543e06dd48f34c2b953c8159b688415418c', '496399411a47', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'elian', 'elian@knights.ucf.edu', '2fed28cc001236eec32b325e8bc787543fc9', 'd8a45e77dc09', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jacoby', 'jacoby@knights.ucf.edu', '85372d387f72da87ee4bc9c7ac7f78204163', 'd984939781e5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'randy', 'randy@knights.ucf.edu', '22feea52c2f4a249dc725637ad22cc59d4fa', '7e5f3b25934c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'anderson', 'anderson@knights.ucf.edu', 'fdde20260e138bb2a9c69792e5758a74040c', '5ca5dd36e9ea', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'leslie', 'leslie@knights.ucf.edu', '99b4d3216d0a1f0114cb213e318d0587cfaf', '5db88609ea94', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'salma', 'salma@knights.ucf.edu', 'bd0ad627ad6c0b4e00f8c98f3d7d76998a03', '32e60c3f52b9', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dorothy', 'dorothy@knights.ucf.edu', 'ca2320a727443c99992844e67a5bb397b18c', 'b3631874478f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'yaritza', 'yaritza@knights.ucf.edu', '7e8cc5693b2e5db114f42f8e94cd938b5aab', '14fb5cf029cf', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'adaline', 'adaline@knights.ucf.edu', '32daf26805d04aede5b3a6aceb81f3acc7c3', '9dbed240c927', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'eric', 'eric@knights.ucf.edu', '21a1a6fe7cd3a13f1a801993121e70f69c2e', '7b9f913c6a0f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jaydon', 'jaydon@knights.ucf.edu', '88668d727465ebcba1854db2bcbc724ab64e', 'dd8c4b515c34', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'roman', 'roman@knights.ucf.edu', 'cac076afc3e29b31200b63721b2cd0b83df7', '5ebd157917e5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'elisabeth', 'elisabeth@knights.ucf.edu', 'b21c0bc8a4c871b33756460ff525000b511b', 'c1ef18f73e4b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dayton', 'dayton@knights.ucf.edu', 'c1ef6d7d1638a1c740ddaef816f486a8e510', '7223290f0303', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'gracelyn', 'gracelyn@knights.ucf.edu', 'bb7724641ff2f40a55185e7c79485011bb9f', 'b2550dcb6b2d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kameron', 'kameron@knights.ucf.edu', 'd8c88183771c165c96f79f05472d92bf375c', 'dd243fe6871e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lillian', 'lillian@knights.ucf.edu', '98fc8d198bd642900e462376fac4cf8a56f0', '5c3e68c02ba8', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'abdiel', 'abdiel@knights.ucf.edu', '4e3959edd8b753f065ef912501614e22a649', '7d940d51ee36', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jaliyah', 'jaliyah@knights.ucf.edu', 'a2b7237efe33bae38853343fc5f0b538e31d', '69e0d0cfc3a4', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'arjun', 'arjun@knights.ucf.edu', '336fc9a82719e4f270a605a92084fa50f9a3', '9e1c0e643218', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'maya', 'maya@knights.ucf.edu', 'b8b4fe0b28027e4b63670284f12067ed79ec', 'b42aea84794c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jagger', 'jagger@knights.ucf.edu', 'd768ac3e12569da00ca546349919c646f0a9', '198426c10759', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'shayla', 'shayla@knights.ucf.edu', '6e305fefd842b2cf705c709b614e5347ca7a', '353c38ce9942', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brenden', 'brenden@knights.ucf.edu', '0d32f2a2feb8b4f76dbf27e2667290bc8827', '6f30ee7e7afe', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ephraim', 'ephraim@knights.ucf.edu', '7b21c4edfbeab9ee02b2f852f0d7089d9ccf', '145fbbf0f60d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'braylee', 'braylee@knights.ucf.edu', '48e038ecdb7a475bf6fc6f7713a10ff698ae', '71a55dd67da5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'camron', 'camron@knights.ucf.edu', 'b0bedba42e785779f99d30d4677843574b52', 'be496310ce07', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jennifer', 'jennifer@knights.ucf.edu', '9ff98a143357ad8a76036e5229d03f8417c1', '1849828f2533', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'skyla', 'skyla@knights.ucf.edu', 'e489ef2c492c15962b808342b8d4bd4b8f4b', 'ceedd29d76d2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'phoenix', 'phoenix@knights.ucf.edu', 'e864151a9fca92e837c1e072bc52cb74b2a8', 'bb5933dce3aa', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'christine', 'christine@knights.ucf.edu', '72cb0a177151749ddca2cd39c6c47a6bae6b', '1acb06b029b7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'fisher', 'fisher@knights.ucf.edu', '1eafffe7bea032c693ed0c6255a692b11a34', 'b3816cc539b9', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'pearl', 'pearl@knights.ucf.edu', '4621fcba900873e0bc8651502e4b07c4cd45', 'c7b7d96b333b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rosie', 'rosie@knights.ucf.edu', '6e553e8a5c4b26e868fd32123c5bbf945e68', 'd69054286749', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zaylee', 'zaylee@knights.ucf.edu', 'ba3bdbe5af94c6afb4dd5e49d783fa45d1eb', '9bf861b4ae34', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cole', 'cole@knights.ucf.edu', '7a20b5c36d2cc41286c1929778877d2dd262', '6f0ec17197c9', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'anders', 'anders@knights.ucf.edu', '1beacfd037cc5d293e70a35b1dc6e07f32ec', 'c6cbf261fddf', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'otis', 'otis@knights.ucf.edu', 'd7d3c907c31793c23430d698e1e93dcf316d', '44237e6a367b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'terrence', 'terrence@knights.ucf.edu', '5c77971c698d1c7fc1e383b7c4677528a53a', '78e75dcdcbe7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'catalina', 'catalina@knights.ucf.edu', '35b70bf018499eb665c1a2200e917b951c4f', '9497ad36b8e7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'marissa', 'marissa@knights.ucf.edu', '7ac5201027feeac0dfde6fab25ac705f00ed', 'd10ad5de14a3', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'gary', 'gary@knights.ucf.edu', '8d479849c878d682f9692aaf0beb881f9a86', '8799b43bdc3d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'katalina', 'katalina@knights.ucf.edu', '39e724b6cb9ded84a55903a85ce14b4a996f', '6992c3edeacb', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'karter', 'karter@knights.ucf.edu', '0c3a897d2756732b6efa70b988010bd3dbd5', '6a8af76dddcb', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rose', 'rose@knights.ucf.edu', '1216120ddf4ac4226e78d21eb4ce13b9e08f', 'f54cc2b4187d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'isla', 'isla@knights.ucf.edu', '8da0dd1d6b91af0767024ba498154429eac3', '46708ec6b8bd', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aubrey', 'aubrey@knights.ucf.edu', '3c7e3b7319b347c6d7fc32f1f3755e1c5ca4', '87b3c0d265d2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kimberly', 'kimberly@knights.ucf.edu', '228a865bd3bded3f296deca3b458657a8aaf', '9f86dfdca8bd', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'azaria', 'azaria@knights.ucf.edu', 'a70833a0b198631cb8c1dc2b8ce0e6e102ea', 'eea3f31c6f83', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'franco', 'franco@knights.ucf.edu', 'b2e834dab035ef37c02f2a42301c9b5cd688', '53f3f91162e7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'arely', 'arely@knights.ucf.edu', '4541d4a3e655fd3e7ba9416ed75d0a55479d', 'f57d66a0a8f3', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'livia', 'livia@knights.ucf.edu', '9c5ea53ecdcd16b03f937793825406dcd3bc', '181ce3d0b31e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dilan', 'dilan@knights.ucf.edu', '7af04da023bbe299187524f0789a1b16de6d', 'ad41e9b92a36', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'benson', 'benson@knights.ucf.edu', 'ad6f1e43e38d05b4151a31481b7be36229ea', 'f468cb67833c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'linda', 'linda@knights.ucf.edu', '16a1cfd818827759369608642f548f87e7dd', '6170d7b0662e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'naya', 'naya@knights.ucf.edu', 'd7071611574f56f2b158bde206146f0f2a7b', '2fbfa578c1c8', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kenya', 'kenya@knights.ucf.edu', '8f2a77b1c972bceb99679b3f18652090709f', '4bbae41245b7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jazmine', 'jazmine@knights.ucf.edu', '44074647b3b21d05b06ca9339868f32522df', '62c0990e24dc', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'damien', 'damien@knights.ucf.edu', '1678285811aa15990b383b06242049a519ce', '5b4eeb75f474', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alexandria', 'alexandria@knights.ucf.edu', '3ade8650cb6fc995fb0af581f0bda8a42e85', '94d034a081dd', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'gabriella', 'gabriella@knights.ucf.edu', '334030f9768f1a87113e34770dfd4f97c74e', '2ebd88b5352c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'charlee', 'charlee@knights.ucf.edu', '4a4eeffc46e4070486225e7c8cfe4e6ad0bd', '6fa1d7f8a7c8', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kiara', 'kiara@knights.ucf.edu', '88fb5edb2710d8c39571c88fab5e6c43d488', '6ba9d17ea893', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'josiah', 'josiah@knights.ucf.edu', 'd2dbf4dbd10d1a32c469f0a156426097183c', '001c4c04e273', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'davis', 'davis@knights.ucf.edu', '93ee6efcff6b0afe60f36b32e563c04b0d8e', '96eaa220a633', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kaelyn', 'kaelyn@knights.ucf.edu', '7e04e425e347b0a2c1e250f38110dbdcb386', '378420d749a4', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'fletcher', 'fletcher@knights.ucf.edu', 'f195b2b8325a45bed584c74fbcd99d12e83d', '605f16afd5ba', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'annie', 'annie@knights.ucf.edu', '69079b887540759a243dcaf393ffe05bb7d5', '16278c5897ed', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ace', 'ace@knights.ucf.edu', 'dfa378d8ae9045eee93947cf1bd0408a6262', 'bd8d0cb910be', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jaylah', 'jaylah@knights.ucf.edu', '1226d5ae513613c74b66bc44f099f0e2a9f7', 'a3f16ecfbe60', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rory', 'rory@knights.ucf.edu', '54fb2da670534aeaf88b03020be24e0ac7c0', '553c1017547a', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cecilia', 'cecilia@knights.ucf.edu', 'c756230d7f3746260717bc3de8e6abebe004', '6936d83b32c4', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'emmalyn', 'emmalyn@knights.ucf.edu', '497f92d6c30c28a2c62a6c7c0e21457f8133', 'd7cfab66de85', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brody', 'brody@knights.ucf.edu', 'fb4956c697a8e2fd47198b9dcd80a6807c51', 'f3dae46dd1fa', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'willa', 'willa@knights.ucf.edu', 'd52fc3c57c9ebd1205c74d9560fd88763cf3', '01c6bde7e0fd', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nala', 'nala@knights.ucf.edu', 'a97972efd7983ea36c7bf9badfc5397bab7d', '0f1ba42f84bc', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'anton', 'anton@knights.ucf.edu', '7112c9d2ab5d93c1a95c5bc989f7f64f62f8', 'b65c5217c36d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'emory', 'emory@knights.ucf.edu', '0e97bb07f3959e1d17300157ffa4d5d1e44e', '54a37d514132', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kinslee', 'kinslee@knights.ucf.edu', '37f21c63366f4e5815545ad3ca18f052682f', '544f8d38c2da', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kiera', 'kiera@knights.ucf.edu', '8236b01a7aa1e4b1039eb300f09363c7dc55', 'ff828ee0aab5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'titus', 'titus@knights.ucf.edu', '4813f85c79a86bbf475c1087d4f0eb2373f8', '6302984f753e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'neil', 'neil@knights.ucf.edu', '0811d0d6656bf2406818240a39191daececd', 'b676e5682258', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nikolas', 'nikolas@knights.ucf.edu', 'b4dc09de6e8796443ee10906eb3d96b3964e', '8ce39022293d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'toby', 'toby@knights.ucf.edu', '6dab0443038f964c115a21151d53290ff46c', 'aba9962f651c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'gwendolyn', 'gwendolyn@knights.ucf.edu', '5e7c85f87f1cca1c7208dc671725c57e0566', '7d4df60a61b5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nikolai', 'nikolai@knights.ucf.edu', '4dba9665ef5e7e70974a57645fdb3156c83b', '23494bd2799f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'callie', 'callie@knights.ucf.edu', 'ccc209c12324fa9d91c01ddcd2ce0deb4765', '9dbae7f06c16', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'caitlin', 'caitlin@knights.ucf.edu', 'c64fae56ded72748c03e329d1ed31dd1b8d4', 'c26843998d9f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'pablo', 'pablo@knights.ucf.edu', 'e0589a8b84faf6ccadde0454885144e0690b', '5d761cbb6bb4', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jaylene', 'jaylene@knights.ucf.edu', '65453f561561c490d8807663a81b25749378', '293c556f696b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sara', 'sara@knights.ucf.edu', '0568c8a957e8cc3449b8db11f19ca2220435', 'f86636971619', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'evelyn', 'evelyn@knights.ucf.edu', 'd0729b65bcb34aafadd06bbfabbf30ad479a', '6f32de725783', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cristian', 'cristian@knights.ucf.edu', '1cb0f3b286a8abacd7de593b87096a903943', 'cb51c2d6bce0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kate', 'kate@knights.ucf.edu', '9a60ec11122129a5dd13c065230f30199695', 'dc6ba6bc9d74', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'charlize', 'charlize@knights.ucf.edu', 'a1e26f31ff036f799c1a3ecf8282210fcb78', '175916eda3ae', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aliana', 'aliana@knights.ucf.edu', '0babceb0c27ee948548ea3a6cb9f2d592bf8', '8058ef3b6a21', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lucian', 'lucian@knights.ucf.edu', '1be62dd77a414da0661653fabefe950b0828', 'bbbc647e724d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'travis', 'travis@knights.ucf.edu', '629e14774767d2ab4745202e4c0231eeba38', '53a5ee2fa62d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'coen', 'coen@knights.ucf.edu', 'f05a4a4665ead0bc186cab1e7ac673e411c8', '59e1964a1dbc', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'camdyn', 'camdyn@knights.ucf.edu', '123558aab7a1998abc3e89ea212eb13e6252', '67766821a255', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'riley', 'riley@knights.ucf.edu', 'd97f29433efd991e200412cbc1f3a6d983d1', 'e489f1a79678', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'maximiliano', 'maximiliano@knights.ucf.edu', '7ed9455666c79214e9cf711941252209557b', '105de1caac27', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rashad', 'rashad@knights.ucf.edu', '5a26abc25f63ac78003009b70b2290ba3dcf', '7225f64624e4', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'myles', 'myles@knights.ucf.edu', 'ba00a3c61673a36d0649514cf06dd40a8844', 'ba4f4fd52e58', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'tate', 'tate@knights.ucf.edu', '1c483658db764fdf66c9253f9f14f0551933', 'f9644c9b5449', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'marquis', 'marquis@knights.ucf.edu', '477b7955816b69558f015eceda6818a933fc', '09a994aba46a', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'griffin', 'griffin@knights.ucf.edu', 'ed500c1e12777e28c1ba04855ac82e3e8806', 'e33f14ae12e1', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'saul', 'saul@knights.ucf.edu', '8ccf921638118d38447bc5b2005dd2fe996c', 'd8493205b549', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brecken', 'brecken@knights.ucf.edu', '08439d1beeef91f21f6653d7bd040b09a0ea', '239ca5f8e5b6', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'julianna', 'julianna@knights.ucf.edu', '1ffe193d14cf71c98f37804fac24284374cb', '64dd433454ef', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'miracle', 'miracle@knights.ucf.edu', '9a98e6be0e1ca202561da26d5878cb97aef5', '514be7930a2b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aileen', 'aileen@knights.ucf.edu', 'a7b55ac343175797bcb03905870e6d6a928a', '08ad1100e26b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'hope', 'hope@knights.ucf.edu', 'f8b4dba4d9ee58753d2460a1b33ec6235699', '8ae86fa54af2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'wilson', 'wilson@knights.ucf.edu', '8a3bcaa4a642e8f333ec2c3447ce458fa1b6', 'd80dc3ff570a', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'boston', 'boston@knights.ucf.edu', 'dee7005a9354af3cfcbfc3dd558e386053a2', '8446d21854ea', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dane', 'dane@knights.ucf.edu', 'f1c8c0fadc24bff93518547fd265a919ff19', '7c7e47f1439e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alanna', 'alanna@knights.ucf.edu', '93c924070e015c7591af5daba93ed0c62baa', '4612e23c36bb', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cataleya', 'cataleya@knights.ucf.edu', 'fd28db11f6e6ae0c26bdd79a56800533d31b', 'e15a431dd78d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'henrik', 'henrik@knights.ucf.edu', '65219799469685c9f0b5c9fc3b2d86f9ea00', '70aff7d1a3fe', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jasper', 'jasper@knights.ucf.edu', '0b87f07d959d0bcfaec9b534392bd7f13be9', '551657c9c6f0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cesar', 'cesar@knights.ucf.edu', 'bdfac99fa7a646548e8f031abc69a28e6037', 'a641dc0eaf7e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'serena', 'serena@knights.ucf.edu', '4c49997aa9a82ee6865d5e503170d18d5c8f', 'f5bcec4b6d08', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ricky', 'ricky@knights.ucf.edu', 'c0980c2a94cd7f9f720ae99de06cbbdee9cc', '9a29493bab1d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kolten', 'kolten@knights.ucf.edu', '209313b885ef6731dfcffa6a53888b50e470', '520411c996a7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'isaiah', 'isaiah@knights.ucf.edu', '17da8dcd5abdbf7f29049e30604d5248085a', '5705637c2589', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rhett', 'rhett@knights.ucf.edu', '64bf47f86878c316b7b14bfbdfab040f6a40', '459fa67439c0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cullen', 'cullen@knights.ucf.edu', 'a81f843fded9ef3693ef6cb036cf680a1ed2', 'ca9412727785', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rachel', 'rachel@knights.ucf.edu', '97ba52705e0b0caba1a83cec0371cb090cb1', '8d0f02f55349', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'serenity', 'serenity@knights.ucf.edu', '014e660402e6bda9d2731579ecd16a30fc00', '67376cd307bd', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'leonard', 'leonard@knights.ucf.edu', '4608e25e69cfcd87326ac93d01128a41af74', '902ff254fe65', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'walker', 'walker@knights.ucf.edu', '1c8511c68d5199385414a42880be8e961565', '75cdb88932fe', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'julio', 'julio@knights.ucf.edu', 'c8cf51ffb25d8e7f46c11c2688486903cead', '223909cc018b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mina', 'mina@knights.ucf.edu', '1583d8f9e8a13248325f7ca0996ac92b1cde', '03ae729be096', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ember', 'ember@knights.ucf.edu', '71545930149929e5af6f6afee97be0d7c8a5', 'f969d2f9e0bb', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'edwin', 'edwin@knights.ucf.edu', '777ad771155030a872d3db9be6d994a13942', '5967ea93772a', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ernest', 'ernest@knights.ucf.edu', '12e4fb8dec8550304babaea2b4ac42919760', 'e1a0119da553', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zoie', 'zoie@knights.ucf.edu', '4b21808709708dd87d538c5cfa7463ea9492', '1a614898a2e8', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'liam', 'liam@knights.ucf.edu', '09a7ed37b951ee4cd652724814faa70f1960', 'd8226a9be587', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lilianna', 'lilianna@knights.ucf.edu', 'c3b416784c917a5541839f993c74fb242b46', 'bddafb329a73', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'tabitha', 'tabitha@knights.ucf.edu', '69d0beb12e4f2cd18fa93eee204ad8f95085', 'eb5c8e25d486', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mallory', 'mallory@knights.ucf.edu', '6e1fea01ed521612e6356565a942a084456c', '33195eb496d3', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'martha', 'martha@knights.ucf.edu', '00b1f4b561e71cd2e2ba99618f189cfa5371', 'f22a69cb1dc2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rhea', 'rhea@knights.ucf.edu', '810e3f4b6b3ff87754d2a9c55d99bc416819', '9395181855c8', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'adriana', 'adriana@knights.ucf.edu', 'e78c60c69c1091a4ebc5cd833deeb78e6b5d', 'e233b22cc30c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kayleigh', 'kayleigh@knights.ucf.edu', 'fd65393cb36e55deff6aba70e1f3e50f1262', '7fb14754f52d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'maia', 'maia@knights.ucf.edu', '4bc0a0b3206ac3247dada9c4dfdd77202994', '147e78113556', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'heath', 'heath@knights.ucf.edu', 'a2fb68d7646bc27b806a88acfdf1d73918c2', '337b5391d021', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kinley', 'kinley@knights.ucf.edu', 'fccad54e2e481fc3242669cd90998db9bee4', '4659056b410e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'katelyn', 'katelyn@knights.ucf.edu', 'b0b51fd6cb66e8c54de31a08eddd90e06672', 'd72a3817bc67', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'gianna', 'gianna@knights.ucf.edu', '5d2f414d230e9b8da665ac8c241350e83e87', 'ff0b6f8c785d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'julissa', 'julissa@knights.ucf.edu', '707de18bedc8d6f739a3d517194e6e85aa22', '684b33f5d4d5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'seth', 'seth@knights.ucf.edu', '2702c37e3579297d53a62cd6a2971f88f445', '6dfd0d25b34f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'adrien', 'adrien@knights.ucf.edu', '9c26f39ca776607f0e9054b28b7c84214ea6', 'b2dccadce06d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cynthia', 'cynthia@knights.ucf.edu', 'e1809c939127abe575da7bcf4e512c6215cb', '4bd32b8979aa', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'shelby', 'shelby@knights.ucf.edu', '5799bd163f34c21f5f6424b9215e9d2d00ff', '8d5aec5ea1dc', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brent', 'brent@knights.ucf.edu', '982e9bcfecd0e5bc45986895a0eefbb7af49', 'c00c20f62a7c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'scarlett', 'scarlett@knights.ucf.edu', '9f03a6d5913e91117edec0a65ea70a4c119f', '8a8708e30f6f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'vera', 'vera@knights.ucf.edu', '4ae2aa9a9d9fd1a9175feecdde98fdb48d26', 'cddfcb71c11f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'teagan', 'teagan@knights.ucf.edu', 'cfd39e5f460ffceaddbde89aec94b032ae8a', '3d4d3a8397e7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'elisha', 'elisha@knights.ucf.edu', 'b28a3745be554c61811c15385236d2cda335', '8fcac21a7baf', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'judson', 'judson@knights.ucf.edu', 'afec312d9d7357468f4f4999642303fd284a', 'b27250f53deb', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'julie', 'julie@knights.ucf.edu', '0b5326b35a03f9c140876699f922cd229924', '1f0879dd52c0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dominic', 'dominic@knights.ucf.edu', 'cb355ac6e81a4966742b6b7cc034ddd256a1', '0675508a6df0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'maisie', 'maisie@knights.ucf.edu', '4e643e05a08d7d22bfd6385cbdab9c14be23', '8bc267c16d30', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kenia', 'kenia@knights.ucf.edu', '6c672a786a482bac0667c9944389668ed46a', '34729eb6dee5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jayvion', 'jayvion@knights.ucf.edu', '3b768b4b4fb78dd0716456eecad3a39b1ed3', 'a130f199cb11', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'amos', 'amos@knights.ucf.edu', 'c0b8b963e69c0a893ce4a1caf3c69a9b0933', 'fd5a5175ada7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'miya', 'miya@knights.ucf.edu', 'a2deb6c3493f90e934be1a796095b0dfd324', 'ecc3030d6d07', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'willie', 'willie@knights.ucf.edu', '3b790a2e41331ba069fd5355b2f5b258e647', '533f9ae0c355', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'elliott', 'elliott@knights.ucf.edu', '2ecc1ad97536da4deed660a3bffb9d025138', 'edfafa808ed5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'gracie', 'gracie@knights.ucf.edu', '3ae42c99b413c7e8054bd02a0a312735c7b7', '72c5e4002f05', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'iker', 'iker@knights.ucf.edu', '166a861658b86313b0d02c170e7661bed14f', '1540701af73f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zachariah', 'zachariah@knights.ucf.edu', '4bf7dfeb3ae2b698f26985d3d0d12392f5be', 'dc6a9bf499ef', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'harold', 'harold@knights.ucf.edu', '1b8d28813d491b7deecdf881c69ec7e706a6', 'f8dba7a9c5cc', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kamden', 'kamden@knights.ucf.edu', 'bdfb0f28d20d35d42fd22243d42c15f04df3', 'b8d3bec2f5f4', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'larry', 'larry@knights.ucf.edu', 'b3085c2c0f9b89a1b57eb66e03658cd2d051', 'aaa665580b5c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kiana', 'kiana@knights.ucf.edu', '24f165666c90c187f5b295a646e9eee33f4d', '5755eff31846', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lilly', 'lilly@knights.ucf.edu', '8f19aa5352657a649e6f46697c68dcdd94b9', '677803b9d926', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'janiyah', 'janiyah@knights.ucf.edu', '00394919d8965855e7eda0d172b2ca1ce4eb', '75ed10284c08', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cara', 'cara@knights.ucf.edu', 'acb06b49f0f3e63b5925102e7189b07c29b8', '1ca42826a6d5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aryanna', 'aryanna@knights.ucf.edu', 'c601f61f473cbaf741ac8c260bd1582dae78', '0b4405b62147', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aryan', 'aryan@knights.ucf.edu', '8cbbc94b99a3ea18c2d6597c5b86536109e3', '066326d51fad', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'calvin', 'calvin@knights.ucf.edu', '04d7cb57d31cedfc11137bcb8ba3b500d59f', '926943570e59', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jabari', 'jabari@knights.ucf.edu', 'b09e8d6b37697b17a07aed12536a3fb57478', '67b7ad9b44b2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rebecca', 'rebecca@knights.ucf.edu', 'd010b9fac43a794828e73685b1bbbf9a3c72', '25a9b6260f51', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bridget', 'bridget@knights.ucf.edu', 'b686d600c03e758e2896d060081628c231b9', '5b05c06974e2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'tyler', 'tyler@knights.ucf.edu', '29453dd4221458c4cd1a073503815261ea1b', 'c646c51eae06', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'paislee', 'paislee@knights.ucf.edu', '12fd4b992352b6a915fa12080d71c2e4c733', '26404b0db7de', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'george', 'george@knights.ucf.edu', '34e6820da7a87d683908c993da27c3efbdf5', 'c2ee830c5f56', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'haiden', 'haiden@knights.ucf.edu', 'bc3660cabc72768fabd808306e9d04d60af5', '660f07578f63', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dash', 'dash@knights.ucf.edu', '1729abdb088dfde8a52ec269ce52a225fb2f', '4978ad2f25e6', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rafael', 'rafael@knights.ucf.edu', '0c0b8f3c817bf3f599cc4eb6da929e21c2bc', '576848fb9310', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'simone', 'simone@knights.ucf.edu', '0a7e45194118f9c2a8ebcbd8f097fa27bc24', '5d28ad1ed008', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mauricio', 'mauricio@knights.ucf.edu', '7674bf5bea73d61a358723e75922e4a872e3', '85eaf95ddf8f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lorelai', 'lorelai@knights.ucf.edu', '9b38983a801a618085ccdc06e2b7eaf2c5ce', '2de4d00c03fa', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'keira', 'keira@knights.ucf.edu', 'c591de9aed387a3eca0e84c5d8055b208446', '5be53eac91d7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'barbara', 'barbara@knights.ucf.edu', '3d7c499d66f5d722f1f641b7496c0311ca47', 'db7af54c6a81', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'coraline', 'coraline@knights.ucf.edu', 'f619fe7c00d7062c695458a5a0f484eb6e56', '2a1524c63609', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'april', 'april@knights.ucf.edu', 'dd33633597d043dc90b802fade3c0bafa2b4', '438184f46f1b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nola', 'nola@knights.ucf.edu', 'ab18f9477007b10b026a8f2244787ea78386', 'e4391c35f71d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'milo', 'milo@knights.ucf.edu', '0a2b98097e8d87687354971d6529ebee958e', 'acc771ec101f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'davian', 'davian@knights.ucf.edu', '9826f488423b9f49dec61ee409a17ad31ea2', '2d3f6dcc79b8', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'augustus', 'augustus@knights.ucf.edu', '674f570568204bbe19968e650a12a9d4f388', '9d9a13d117e3', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kara', 'kara@knights.ucf.edu', '10ca3f80eba8de9a3f496b1b773cfe2e091c', '8c2b181e72ec', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'holland', 'holland@knights.ucf.edu', '8382eb42605cd89e775e23e2621cc9221a4f', '96c9fbfbcc3e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'royal', 'royal@knights.ucf.edu', '00eabcede1327fc0305daf2d4b5d9f83dd38', '14d8955b981e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lilyanna', 'lilyanna@knights.ucf.edu', 'daf9f141858384a105367b2e1d5003a993f5', '7d2bd054f4ea', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'reyna', 'reyna@knights.ucf.edu', '9e1ee1fd21ffb8cff7144937e1de8fae9a40', 'c1497ffa9f2d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nathalie', 'nathalie@knights.ucf.edu', '61dbe06385806e831ef4cca3b69892222d91', '94cbdc94abe7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'arya', 'arya@knights.ucf.edu', '9709110b05d97705204c92bbe3c4297febf2', 'b14399c12a51', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rex', 'rex@knights.ucf.edu', 'aa7e974d3212acee50db138fa9fa7b74266e', '0d20265c63b4', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kensley', 'kensley@knights.ucf.edu', 'a1044c04779376d22c166e5738c54553c14b', '82363d4a0144', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'hunter', 'hunter@knights.ucf.edu', '5e2bfa3a0254c776b58d6cfeca9eb155073d', '5479c0c635d8', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dennis', 'dennis@knights.ucf.edu', '0796cb39d1914e61c03e5934c1450e1cd7b2', 'f043271c27d1', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ayden', 'ayden@knights.ucf.edu', 'e75c92a83f309358579847f2b0b2bb604080', '7e2be5516f24', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'wayne', 'wayne@knights.ucf.edu', 'd663087fd78d2679187b8b47d5f1c9e6401f', '17a29c0644f5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'manuel', 'manuel@knights.ucf.edu', 'c5f0cc9b0a1648f90a204240201e3f3fcb0f', '65a5e266f4c6', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'autumn', 'autumn@knights.ucf.edu', '1f79dacbb11af409f4b27b9710542a0a6a0b', '852dd53369b2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ean', 'ean@knights.ucf.edu', '1c5d56ef6c38a98f1d4aff7d3d2fe958a0b4', 'ad41f162cb69', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'camilo', 'camilo@knights.ucf.edu', '51b1d0efcefef2f06173ef5ee732b2dfb4a6', '3d774b4ff22b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'finn', 'finn@knights.ucf.edu', 'a1627ecd27a0abdada29970279d01d7ceb29', '01b78176f3e8', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'andy', 'andy@knights.ucf.edu', 'a9caf1c83ddf787aaf2455fa87ac1a19157b', '915cea9ba783', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mabel', 'mabel@knights.ucf.edu', '879df38b364c98bf2f00117d8cf5e92202b7', '39ebba7089de', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'steven', 'steven@knights.ucf.edu', '71ab6353ebf30cb9e3da8ab0918520af6afb', 'b9b0ccd8abba', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kamren', 'kamren@knights.ucf.edu', 'c306b989f82c89999a757197777f2c4775e2', 'fd717f857165', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brett', 'brett@knights.ucf.edu', '97d0ea04ed57b1166810df4a2c9fb87c7f36', 'f4604bd68e55', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jenny', 'jenny@knights.ucf.edu', '3274ebfe3d952ff3a7867b8f99adf2a941bf', '76a562509398', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kylee', 'kylee@knights.ucf.edu', 'ff0994ec7b214e1e1e77ea53c57811843011', 'b8cb2d5c2326', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jayce', 'jayce@knights.ucf.edu', '433c5b790c00170a2ac87f29b6bd81478017', 'a98deeba6546', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'madeline', 'madeline@knights.ucf.edu', '0e46393ea85529b3ec365175a6dc84dbdcb0', '2080d3a147e5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zaniyah', 'zaniyah@knights.ucf.edu', 'a4724ae868efdcb3cf463cd8f98a1262d948', 'b7e096707d2e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brynn', 'brynn@knights.ucf.edu', '8d879c27031bd1780db23ca3b5581d5ad34e', '732bcb39bd78', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sarahi', 'sarahi@knights.ucf.edu', '2089c5effe4af3a7a715c276e76e20f5aab2', '8cf237547862', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aaron', 'aaron@knights.ucf.edu', 'd64c02db3df7b3ca7497afec3c3da41dc583', 'bcedadcac11f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kailani', 'kailani@knights.ucf.edu', 'ff6566092d2ece9c73ea48a96f5ed4d4401e', 'e1b974f85472', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'winter', 'winter@knights.ucf.edu', '6d15530672275501ae0369436b60d35b0c22', '7e98be796d61', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'owen', 'owen@knights.ucf.edu', 'fd23f98aeb025a14c13349478abb43668667', 'a73bd4edb1a0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'fatima', 'fatima@knights.ucf.edu', '731cbb033e6ae76c3b122d7362d0e724fd88', 'd2f93fac9d44', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'drew', 'drew@knights.ucf.edu', 'fc598453db1d4d595ea9414e4d8894da6001', 'd89a84c27c16', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sam', 'sam@knights.ucf.edu', '1b6fdbe0ead7bf8ad5a50c2d89092b84c685', '92e546c87086', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'weston', 'weston@knights.ucf.edu', 'a83efc409e0ea1d2dccd1e9a081fe3ed0e80', 'e02b76f39619', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'crosby', 'crosby@knights.ucf.edu', '3c87a19e381c84b68baffb067d3dda027e67', 'e5365593fc80', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brandon', 'brandon@knights.ucf.edu', 'be861e83fbe4f7d6dd59acbe9844e3f824ad', 'b9b14117d087', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alina', 'alina@knights.ucf.edu', 'b83f8998619e2e1ebefc94b1f4452e249145', 'dc66e0db76a6', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'marcel', 'marcel@knights.ucf.edu', '095cfbee647af4b47d87268b3d365c76ce8e', '68e4a2c78a3b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'belen', 'belen@knights.ucf.edu', 'a99a6bad374ed9ae4aff17eb04f47b4d86f6', '8bdf7434281e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'shaun', 'shaun@knights.ucf.edu', 'bc7b23a83d543908c9dd0a13810147cbbffd', '959edd0407f7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lawson', 'lawson@knights.ucf.edu', '7cf5bf26ca600d938498dbf44cc1f672859a', 'df07abc56994', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'elaina', 'elaina@knights.ucf.edu', 'c898b12f766a42978bc839aec929622bd07a', 'f4b834e04e68', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kaden', 'kaden@knights.ucf.edu', '9099ac72376cc2446ebe3f520277c360fd70', '4699c344547f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dorian', 'dorian@knights.ucf.edu', '6c9db73cd0dc4d90e8a92d9df8a250df7857', '7f4495d52cf5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kassandra', 'kassandra@knights.ucf.edu', '1feff1aa73ace3a5baf7b2d89fa4c3c04e59', '60acf0de7f60', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'albert', 'albert@knights.ucf.edu', 'a4ea07c92611745298b6fea61ca9e59663ea', 'ffc96d5409c8', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'hugo', 'hugo@knights.ucf.edu', 'de74b0d45529ff17511b3725543b71779f80', '3aab75434cf2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'anya', 'anya@knights.ucf.edu', '312ecc1eaab31d745a32bd81558161b57b51', 'fedf555b6377', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'eliza', 'eliza@knights.ucf.edu', 'bd500151c67a7a22001d42233d788c94f869', '85357525d9d5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'omari', 'omari@knights.ucf.edu', 'bc33449593071fa2b3e077df04fa0c65ace7', 'f89f32e0f678', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'robin', 'robin@knights.ucf.edu', '6caa634ebc713e76c11f67e6eda062ea76d0', '87eb1f010361', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'vivian', 'vivian@knights.ucf.edu', 'da63bc24901428784a41ca73f41724864236', 'cb08d20503b5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'gideon', 'gideon@knights.ucf.edu', 'd959aecf5e044ee44b434fa9007845e6b222', '48c82cd50d7a', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'caden', 'caden@knights.ucf.edu', '69c609ba3fd61474f046cc907b1a55cb33ef', '267e0db03693', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'huxley', 'huxley@knights.ucf.edu', '8313c0c30523dc08aa878628c4e114bb1a93', '79cce00df949', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'valentin', 'valentin@knights.ucf.edu', '2116e0633ff104fb8fe76eb0d64931948362', '68b847949aed', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'noe', 'noe@knights.ucf.edu', '5dc954d2d783c0d04eac9f9b36a075a73db1', 'e4d310566e75', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kashton', 'kashton@knights.ucf.edu', '8cdaf73ece3dc469291166f798eab217d3a1', 'c973f6308603', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'naomi', 'naomi@knights.ucf.edu', '35124c894cfce83b2644a18091e068022d9e', 'dea0d8831054', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'marvin', 'marvin@knights.ucf.edu', 'c5e46a23f5fb7421913e3e1c1cb3bb91f2a8', '31d3667bbc97', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kallie', 'kallie@knights.ucf.edu', '3e4940b034d667456dcef261d6b050d576bb', '24fa5578b286', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kenley', 'kenley@knights.ucf.edu', 'e01021a7d9663dea16507ab24113d37b2ca2', 'd77db9f9c1d5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nathanael', 'nathanael@knights.ucf.edu', '905a0a24dd20816d71722390028df42ad716', '82b109992154', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alani', 'alani@knights.ucf.edu', '06b9c9ae5f960f16f09edbb4ad2f90572dda', 'd2389f10f1ca', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mariana', 'mariana@knights.ucf.edu', '58ae058e05463d00e7582aa4d4d24f1f5cf8', '61851cf96ead', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sophie', 'sophie@knights.ucf.edu', '702313c0ea4bea783ed4c4cb89d7c762980f', '8fab6d255145', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sloane', 'sloane@knights.ucf.edu', 'b2d0523402a3bdcd5603cc170db983af05ed', '8bd9c477c39e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zeke', 'zeke@knights.ucf.edu', '1045d6b9220a681ad73613b53095a5bc3960', '03239244779d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'neymar', 'neymar@knights.ucf.edu', 'efb9153d29bd91c4f7eeaa5aa17f52589b12', '3585ba7e2e32', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'danna', 'danna@knights.ucf.edu', '9d927754e47fcda077c406426b38c34f3738', 'fab8f97e4fd0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jamison', 'jamison@knights.ucf.edu', '39828c504808620e4a74eecb4e11086a4662', 'e1f1630c843d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zariah', 'zariah@knights.ucf.edu', '878a6816478f9a756930387c21a5a045f7e5', 'bb0e998cedcc', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jaida', 'jaida@knights.ucf.edu', 'dbb91bc07190418a5e902585571c06adda33', 'fdb5978ffd1c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'savannah', 'savannah@knights.ucf.edu', '2abac87244af1aca356ffa88b1fad506a8e7', 'bf028e33991d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sincere', 'sincere@knights.ucf.edu', '5bced131311664a8ff4aac06a6a9b27d067d', 'f0b673908e1b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'davion', 'davion@knights.ucf.edu', '5eb4444e62accfafea63170bd247f4a17298', '0c2b100b2d4f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zendaya', 'zendaya@knights.ucf.edu', '8bc49d8450e8024cd37eb8c85037174aa540', 'a975d427395f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'karlee', 'karlee@knights.ucf.edu', '466e62636d357ee35ac4293f8c438a1cfdf1', '2cd91036b727', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'leroy', 'leroy@knights.ucf.edu', '386fa1c3d36bed92584620820d8b8de8f108', '3d32eea6581f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'tiana', 'tiana@knights.ucf.edu', '18393e0416ad5371264bd396a3f1227e9377', '1d66d5df99d5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alicia', 'alicia@knights.ucf.edu', '85be3af76d37e2af4f59c27c17135052c15c', 'aa3a3c3d7765', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ariya', 'ariya@knights.ucf.edu', '63d7f661cb3279bf0d4d5854fbde8ac9af9d', 'ac309a137775', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'collin', 'collin@knights.ucf.edu', '18b4c98fae84215d85d9c33fc76c73874758', '992b6efd6d34', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'morgan', 'morgan@knights.ucf.edu', 'ea7fbf198123c47f39cbbc40ff176ee414ae', '9018c1d626ca', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zuri', 'zuri@knights.ucf.edu', '657dc12b38f409c5d2b797ed7241bc909ec5', '511bbc84de88', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'malik', 'malik@knights.ucf.edu', 'f0611057dcc71302dda77ed5c6162b5e6dfe', '3371545b4167', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lamar', 'lamar@knights.ucf.edu', '5aeaf95c77b6583c5c9cc7c72975cc2bfc73', '1909b78c1c66', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jillian', 'jillian@knights.ucf.edu', '82151d7be83d2e36f2d21d11f051d7b91c94', '42ec1f7a82d1', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'enrique', 'enrique@knights.ucf.edu', '59cbf3e1ddf6003a19ad9d595dafd2740699', '2631f3c309bc', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kane', 'kane@knights.ucf.edu', 'fe2745fca3daec4164c62f47d8d35e1987ed', '590c22106e68', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'stephen', 'stephen@knights.ucf.edu', '389615f644995ee0f3bbfc03ef0bdc176111', 'df17c92c8e35', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'javon', 'javon@knights.ucf.edu', '8c4e7bbc4ee4e65669c30e174569d66f505d', '4b465b8268d1', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jacob', 'jacob@knights.ucf.edu', '961aa7b6f9d85013f24bed7f420f63cf0180', '6155101b20f5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'deacon', 'deacon@knights.ucf.edu', '019ac9ff1f0e36318b52f5a9a593e4a85c22', '712d0659b067', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ahmad', 'ahmad@knights.ucf.edu', 'd0efbc792717c61888a4db52eb7812bafb91', '2f54bddbe6d0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'giana', 'giana@knights.ucf.edu', 'e938e68426ed777f34c7c325ec9f5ae9bc6a', 'c068ddac8fca', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'luciana', 'luciana@knights.ucf.edu', '59ea721d9685b7119ed542f8d411156d5bb3', '4c8ff30b9295', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cherish', 'cherish@knights.ucf.edu', '7c09707dd50c3eb5d8e9824f30b4e08aa426', 'eb234499094f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brielle', 'brielle@knights.ucf.edu', 'f2b35d0c536277d1f641c4cfba7532516700', '54d136459546', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jairo', 'jairo@knights.ucf.edu', 'ef0bab6c15386e4ca0f5769dfbb4577e6584', '88c8ef54de22', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lydia', 'lydia@knights.ucf.edu', 'a66e7cc4d8b813dac5a7b091836ea899b0f6', 'c1ccdd73e6f0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'darren', 'darren@knights.ucf.edu', '300b0a9c194e27decdc8a0123c9ee32723f1', '9d56aba771b0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cassius', 'cassius@knights.ucf.edu', 'b76fd53aa82f18ad9b7bfad0df9d58b713dc', 'aea6b01f33b9', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rowan', 'rowan@knights.ucf.edu', '0e8c30c0be186d89f63cbabe8df5e41cc389', 'ac027fe0cc61', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bryanna', 'bryanna@knights.ucf.edu', '99b8d5637552e6c3a029df24480a5059f1a3', 'e1b5a411116a', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nicole', 'nicole@knights.ucf.edu', 'aa6cd2ea40fb75835df451cc48cca6fdf9bc', '0bf0db1ce7b1', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'elaine', 'elaine@knights.ucf.edu', '0c293f0361b5f7839c70d1133432a50069cb', '8cd806e6e7e4', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'barrett', 'barrett@knights.ucf.edu', '73da4bad8ab5e7174738041a722b9ac788ed', '31c41abb06dc', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'madalyn', 'madalyn@knights.ucf.edu', 'fb64610dded2828014e32507d79769710ea2', 'ef93667050aa', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'giancarlo', 'giancarlo@knights.ucf.edu', 'c20842254fc817166f5a7ba8c55c20c33a27', '00912e13b6cf', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kyleigh', 'kyleigh@knights.ucf.edu', 'f8fdea67b05e8b57e7a2e8d74b5c221a46da', '12e6309b2ca4', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ryder', 'ryder@knights.ucf.edu', 'd1e7e88a3eaa82fecc1ffe177aba1cbeb9d7', '27ee8a7a7bb5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kyndall', 'kyndall@knights.ucf.edu', '32324f384eb44c1c14f04c63a952dda82698', 'eee7fc4dbf4c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bodhi', 'bodhi@knights.ucf.edu', 'aa52e75ca2ae1a82d0478866229cc123bdd3', '0a5b75612971', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'natasha', 'natasha@knights.ucf.edu', '37e0e395f1efc5b59c4c7eeb4fb5dca12712', 'dad7a7af8e73', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'corey', 'corey@knights.ucf.edu', '701509f36d65604551ccdf528478374d7879', 'f8a9808a6fbb', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'tony', 'tony@knights.ucf.edu', 'b907afb6f70563b74a5666415923f32685a5', '401d71f9dad9', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'charley', 'charley@knights.ucf.edu', 'b0b3bcc85221c55724d98f5b6ce3637db2aa', 'f851c7868ef7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'paloma', 'paloma@knights.ucf.edu', '60d0656d91e64b26c35b86ad30a4a0375b57', '5a7971d58289', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'monserrat', 'monserrat@knights.ucf.edu', '40b78883d98a8ef48046db9e7efa3ade482b', 'bf22bcee791e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'clare', 'clare@knights.ucf.edu', '69d2afcb06f53330d05fe1396c5bc3552697', '8fd608bc4967', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'khloe', 'khloe@knights.ucf.edu', '352ce25c9fd6fbc74b2370c3f77ae0a73bc4', 'e92f47567ba2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'simon', 'simon@knights.ucf.edu', '9319f77590e2b3413ded7316976b82ac3fff', '57bf288898fb', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'karina', 'karina@knights.ucf.edu', 'bdeb2dd7319c1179e4905b02878858c822a8', '9b9b0705c181', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'amelie', 'amelie@knights.ucf.edu', '321198a0e7e6007e1485d8a64b4edfc2402d', 'f64f6fbbec83', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'atlas', 'atlas@knights.ucf.edu', '8f6d046a0099a37ac16872da1652efe618e8', '7fe8493e05ee', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'isabel', 'isabel@knights.ucf.edu', '5d86c29202f5d10d29e39fe033380ebcd9d5', '6894cee9ae95', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'chaya', 'chaya@knights.ucf.edu', 'f1bf432ca6627d1149e3c03180d7fc494052', 'f1d4e3627abb', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'katherine', 'katherine@knights.ucf.edu', '292c24fe319636e74c2ae2694893045b082d', '61a4bce46301', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'branson', 'branson@knights.ucf.edu', '2e5501e015e7a11958413c2c4db4fa170462', '2a3e9f98a441', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'millie', 'millie@knights.ucf.edu', '33bc5b0c485b770c03e55210886b4e456241', 'a1e81bca08bb', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'veda', 'veda@knights.ucf.edu', 'f112da57c3b205e5878bc299d650086f2c12', '9a49f880ecdc', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'moriah', 'moriah@knights.ucf.edu', '978286a8ab7c4f8f193225dc79548290094b', 'd0a128f08eaf', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jordan', 'jordan@knights.ucf.edu', '5c0fd9446d8d827a625ca07b3496cd00d93e', '2b5d6d0b4ccd', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'madeleine', 'madeleine@knights.ucf.edu', '93e77beb0d4b3721d21baf9141e38361f40f', 'b88226dfbab3', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'joshua', 'joshua@knights.ucf.edu', '9528fda01759674af53bc069950fa2b9774e', '8b5f2c5e22ff', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kye', 'kye@knights.ucf.edu', 'd6fa2c733897607cfb5822234085a1496cb1', '4e485129d609', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'hassan', 'hassan@knights.ucf.edu', '320cf1a8d1ba7485a56a38c064906e15d5e7', '3872c84a04ca', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kaylynn', 'kaylynn@knights.ucf.edu', '510b1611718617590f213de4d86a01c62c74', 'ced79e93300c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'juliet', 'juliet@knights.ucf.edu', 'ea5874f25521d0d15098957303bb7355d200', '33f94c08d602', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'miranda', 'miranda@knights.ucf.edu', '2dac5336a0dd66420c8f646e252d895c32db', 'bcc16938b710', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bradley', 'bradley@knights.ucf.edu', '69b01812cd6e40d9fded9b380ce080e3dd64', '6f3218ead3b1', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'faye', 'faye@knights.ucf.edu', '2b7988bc6a01702dad5dbcdbe27479ff0fd5', '6f83aeee3c15', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'demetrius', 'demetrius@knights.ucf.edu', 'c0effa9ed6506c0e6f9bb1cb5037d7c848e1', 'c161d2d5d488', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ray', 'ray@knights.ucf.edu', 'd3d7a9ac99e1f3e7ae80624918ea96793e63', 'e92d6b691fc5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alannah', 'alannah@knights.ucf.edu', 'f013401fd213d380c7b692cebe3267e0eddf', 'fcc9c5c97d13', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jamal', 'jamal@knights.ucf.edu', 'efb4107f37c1ce9482a0dcc0f8b4c234e195', '3b38fef0992d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'baylor', 'baylor@knights.ucf.edu', 'f2dc832a7d588b7a97804396f14482fecdf9', 'd868a548c9fe', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jacqueline', 'jacqueline@knights.ucf.edu', '99f92d8f9514272972e6739683a507f27f25', '6afe8a74a5b0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'chanel', 'chanel@knights.ucf.edu', 'd9f176242166112a2f3b50c25db877cc5088', '23c674380761', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ameer', 'ameer@knights.ucf.edu', 'db71e2fe3f1d2f073a62bf92a88f6a545b35', '01947954c13d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lennon', 'lennon@knights.ucf.edu', '4b08219c87303aa31246ceb2dd5a1ec69f53', 'c4c4610fa1b2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cade', 'cade@knights.ucf.edu', 'aefa53f2b0c40feaecc5921791f6635d28a3', '1b1e8165a4e4', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'johan', 'johan@knights.ucf.edu', '842e0c3384e37215b95ba9dc1af46c2cdd27', 'aa9d376f5b92', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kaylee', 'kaylee@knights.ucf.edu', '57974298ae1480f947d013f631d8cf69c7d7', 'dfc8c1f2e866', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'monroe', 'monroe@knights.ucf.edu', '55ac5bfa350e2bc85085325e5bf50d4d4226', '70cdccdd8c2c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'maxton', 'maxton@knights.ucf.edu', 'cd848f2aa5dce0e9d06efe8d0e5ef5a3b668', '7f1938e87d44', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cory', 'cory@knights.ucf.edu', '27a520d495821cb83783037333eb4ace0cee', '0fb3f7f95e09', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'camilla', 'camilla@knights.ucf.edu', '4bd565adcfe38bc5adbfa407c6a6fd3003dc', 'c333ab10477d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jordyn', 'jordyn@knights.ucf.edu', '0b0748233d75b208c209b00474737b063cef', 'ad695b6fe9d2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'roland', 'roland@knights.ucf.edu', '97892292b3c06d0a53ee05628116dc17725f', 'b54a80e930fe', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kason', 'kason@knights.ucf.edu', '512a2e6880953389aaeca8394a5c7d4a3dd4', '35e08e47d9db', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'pedro', 'pedro@knights.ucf.edu', '4a937a6468acf7467844b8f62f6722f1661d', '4f0ca51b1163', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'esmeralda', 'esmeralda@knights.ucf.edu', '57d11e7832bf2a06d8434e937b55188d140a', '97901ea02329', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'diego', 'diego@knights.ucf.edu', '8fe9262dd31d2ba34ea53410bead99a1205f', '682faa5dcbd3', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'esther', 'esther@knights.ucf.edu', '6127df00042e2b53e42a89d5593f56d42e50', '27cf078874bf', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'evan', 'evan@knights.ucf.edu', '86b011b77085745cc178f6fe8794b9ddd1f1', '1ddffda4b624', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'chevy', 'chevy@knights.ucf.edu', '57d27f148836c06276a6af48d64c0e56d839', '74a2f4cba549', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'clayton', 'clayton@knights.ucf.edu', '17b6d3163ced512b22ebe85738671a5362e6', 'cf946b73e056', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'douglas', 'douglas@knights.ucf.edu', 'a93f5339f0a9dc7bf050c6366b2c3ff40abb', 'ec3198906d85', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'marcus', 'marcus@knights.ucf.edu', 'b11fe7c01ffcab3a2c70a721036e40881c7f', 'c50bd9fd2b8f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'silas', 'silas@knights.ucf.edu', 'bc151467213e2201a182c739f1ec579605b7', '0cf690c4c3f0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'luz', 'luz@knights.ucf.edu', '76748d389313d7f6db502f0163e143263452', '071c543b0673', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'olivia', 'olivia@knights.ucf.edu', 'c21044d2a3723729b133787fc5bd9664a4eb', '884122fa2792', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'elias', 'elias@knights.ucf.edu', 'a631714beacf1cd5bcc5a0418e87f609499e', '16a406a871b1', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zion', 'zion@knights.ucf.edu', '535ea71a2da186adf87a0dff4c8580678386', '1771115ffb0b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'blaze', 'blaze@knights.ucf.edu', 'f98f5b0f787b6ecf47efe30a1dada4c8e69e', '8e534be1f490', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'heavenly', 'heavenly@knights.ucf.edu', '1d34bb48385986274a9559adba5bbc17b428', 'df789ffbf78b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bruce', 'bruce@knights.ucf.edu', 'b0c178292ce2d9356b4b6aecc08b0885e3ce', '41c168020f47', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'phoebe', 'phoebe@knights.ucf.edu', '11f059d3937688b967883679c0d8e01a300f', 'a48f6e3d2efb', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kyra', 'kyra@knights.ucf.edu', 'b3a13ce00432f80db8605bd7f462d104c7d5', '6372bf739580', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'carter', 'carter@knights.ucf.edu', '064fb451ca086a753f9eb379425c1ac8998d', '872a3c86d749', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'malaki', 'malaki@knights.ucf.edu', '3f73f3a85efd332a1ea46375ec2a769739fb', 'c23e57c76f29', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'adalynn', 'adalynn@knights.ucf.edu', 'fbfc092232b2c6ba2410c780f32ae85c4774', '8886579c46d7', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cannon', 'cannon@knights.ucf.edu', 'ced809686d8ada16f120a998616e3097df9e', '4d14107fc90d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'denver', 'denver@knights.ucf.edu', '7dcce86df7e5febebad3b0300bc98ba1e365', '49ccd96b09e8', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'gloria', 'gloria@knights.ucf.edu', '50c3b853b1ae4cadfeb45c0be823adf98f42', '55a8e2fc3ee2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kaylin', 'kaylin@knights.ucf.edu', '385c5013860925295bb550f44873d9752a31', '3d9bf6e842e2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'johnny', 'johnny@knights.ucf.edu', '56fb080cdd61f1103854ba5a30e0fa0b35ac', '81c45a3ad8a6', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'erik', 'erik@knights.ucf.edu', '217e30baea46edd2113e4f09881dbec6228b', '5633f0bba403', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cristiano', 'cristiano@knights.ucf.edu', 'f1eab4b68de3f0c1a5d23f5be3d4078a34dd', '94721a78b2d4', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'oliver', 'oliver@knights.ucf.edu', 'c0e925daedaa02614dc3a2b1f0293a245930', '60a13551240b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'hannah', 'hannah@knights.ucf.edu', '2ec0b7e35879bef35d6b6984db6e0dbfdbc0', '2e340c216b1a', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'eddie', 'eddie@knights.ucf.edu', '85cd34020d7a95fb2f046a5b6b9b1818b87b', '8d85f2e3a94e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kenzie', 'kenzie@knights.ucf.edu', '99326736676bf4dd0c323f5ca3bd82bc2464', 'bfee0ce6d33b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'addison', 'addison@knights.ucf.edu', 'b14a7ed21719202e5b8a4e6a1a37ecf03910', '83efce80a76b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'waylon', 'waylon@knights.ucf.edu', '81c144f8a4917106b8322674d4ad067dda22', 'c42265f009a2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'magnus', 'magnus@knights.ucf.edu', 'd79889f7a774f8d819943c3c463d6b1cf0c6', '41e550a839f3', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'charles', 'charles@knights.ucf.edu', '2dd5e7bac03ad39b850a36fd91b99b8a9c6b', 'a1aed5c3607f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'luka', 'luka@knights.ucf.edu', 'b6509a48b6faaa985062f0ba86c9b0ab6326', '5386ba2f5ef8', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alec', 'alec@knights.ucf.edu', '3ddf9ab532797b6801d673f7cdeefcd19455', '19c5dbbafe21', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'julia', 'julia@knights.ucf.edu', '3093e01602b465f0cbfe71a3a18cad5a443c', '00155f550367', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brian', 'brian@knights.ucf.edu', '0a677cbe6c333ae7b94853d5d7a08bb47f48', '7bfb2fa5d5f8', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mekhi', 'mekhi@knights.ucf.edu', 'bde0870a706d8b9743488cde6e2e238e0539', 'ea598ac2b260', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'skyler', 'skyler@knights.ucf.edu', 'c4c8f3cb3f5f213d1e9a7fd4545ea03cb7dc', '238d3133d096', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'darius', 'darius@knights.ucf.edu', 'e3b262c771840fdf5a32a1ec3c09eb7da07a', 'f001051b8d7e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'laila', 'laila@knights.ucf.edu', 'd5881dcb0b11b834c4a419c1583487df7ba6', '703f52ab5061', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'karsyn', 'karsyn@knights.ucf.edu', 'f8182b96c81b37d21d5050bc94fc30951c72', 'ee4ba8e99286', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'gerardo', 'gerardo@knights.ucf.edu', '154e2ceb2461487e35587373a6a7a03d55e6', '6848651fac0b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'marshall', 'marshall@knights.ucf.edu', '5b616e0ffc7dc0ccfe5ff4aec7acccc21e77', 'aaf809d5d8c2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jett', 'jett@knights.ucf.edu', '65384b558014fbf04993e9c116f84ec5539f', 'b691f38e6e48', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'khaleesi', 'khaleesi@knights.ucf.edu', 'a1e1fc033c5ad6b3a43b7224626c3717978f', '52acea1cb508', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'yahya', 'yahya@knights.ucf.edu', 'dc4aebbb326b48c951d038f5c94fc7d4d5aa', '999827715962', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kyson', 'kyson@knights.ucf.edu', 'd34d0bfa242e9f15b97d714e0586b7e6e3fc', '23fb28d63126', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bonnie', 'bonnie@knights.ucf.edu', 'b60b10990339fa5e73b146aefe1fba041e6f', '21ee973b9e5d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nolan', 'nolan@knights.ucf.edu', '9f2ed75fc65420ffadcbef9e24cfd9b66d27', 'c02d5e7194cc', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'joyce', 'joyce@knights.ucf.edu', '641ee077a8d8a1f7f2980987aaf4d46b8406', '0a53ec8a1194', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'paisley', 'paisley@knights.ucf.edu', 'b4ba3143d477d3a9ba016ae3751eb77969b5', '7bde453da003', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sidney', 'sidney@knights.ucf.edu', 'b23627bd1afcb76d49c00abf95a6302a2edb', 'f6cee6932006', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lachlan', 'lachlan@knights.ucf.edu', '1a94928859b8b713c40500d52cab07ce4e22', '0252e49d92fc', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'remington', 'remington@knights.ucf.edu', 'b8e5a24631078b638c64b9dba77af0fcf4e4', 'ac6d4296b87c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'moses', 'moses@knights.ucf.edu', '2f8b7a0db304bfa2b0d44e9cd66afd5db9b0', 'ddeec195bd12', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'king', 'king@knights.ucf.edu', 'a72b7d31ff85891de62d8b33f7e11741648e', '8041070afebb', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'israel', 'israel@knights.ucf.edu', 'c3b9e704213faf2e37cd8ecb9f7c1af5ca47', '4917d616c2bc', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'joe', 'joe@knights.ucf.edu', '00874bf133d573a9e6cfc589524dd8dee706', '7a691b448c43', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'victor', 'victor@knights.ucf.edu', '163f73c8221c0c36eb8621f1a9848f167ef9', '94beb7f812ec', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'franklin', 'franklin@knights.ucf.edu', '9dffad7470cb2b52fd236c58ac9d2c191f92', '9ebae1f044c5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aiden', 'aiden@knights.ucf.edu', '50ee854c63a03334688ce38b869430a98304', 'f88dfd21a656', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ethan', 'ethan@knights.ucf.edu', 'e3904546274e4e926d7726ecd2e6e156ad2d', '7d38b5c8efce', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'emersyn', 'emersyn@knights.ucf.edu', '28c818b09394a90c00757dcd205f50ea4a50', 'fada6db6e674', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'laura', 'laura@knights.ucf.edu', 'da0896efec626c12ad7fed48dd11d4791203', 'b4466794f44d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alianna', 'alianna@knights.ucf.edu', 'c7a8cc73f6d955f68133dc1acc81f67664a0', '170ef4e9b166', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'galilea', 'galilea@knights.ucf.edu', '5a656f2a6bdee74e822e18cf525f747604bd', '783988d6348e', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'chelsea', 'chelsea@knights.ucf.edu', '55f530ef2ca020d8ee507260241113d2a072', '1232440c2545', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'guadalupe', 'guadalupe@knights.ucf.edu', 'b23b33bbfcbe76c515d00db9f16d555af5be', '64ba6ec98569', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dana', 'dana@knights.ucf.edu', '6856dca5742160632f447669f3b6fda25b9a', '75ae14605367', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'deshawn', 'deshawn@knights.ucf.edu', '797a54e669579db9c6e4ffb53c0991698e2f', '6b040d1e42c0', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jane', 'jane@knights.ucf.edu', '5c579b4ce465ed8dbc6cbc2f323b8babbe17', '55a467333b12', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'melina', 'melina@knights.ucf.edu', 'a71a02fbd03119ce8e0a75349638b8532642', 'bd072dbecba5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'colby', 'colby@knights.ucf.edu', '868ed3116d91e11b241b87e035479a978ff0', 'be9bb9da14ea', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'harlan', 'harlan@knights.ucf.edu', '026860906b06a8e1f5ce248476b2aa72ba61', 'c38ad612f2da', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kole', 'kole@knights.ucf.edu', '0be97ef63fca826e875c693ef837e601e244', 'b4281f50f38a', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'briana', 'briana@knights.ucf.edu', '44c1b8919989ea96e5dfee3aa684ecdbd670', 'e69826c5b26c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'joel', 'joel@knights.ucf.edu', '875fd568dc68832838df005e16f248eb51be', 'e1f8b0855e35', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'harry', 'harry@knights.ucf.edu', 'be9c52a36fcd0b41ae058cb732649be5ab08', '52451f8f4a3b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'thatcher', 'thatcher@knights.ucf.edu', '030b2f104371fb1b986b324c9567d487596d', 'e8262b5f621d', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'arabella', 'arabella@knights.ucf.edu', '519bb1e686243295fc414636ac505c0cb860', 'eee80c11ef25', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zaire', 'zaire@knights.ucf.edu', '92a71ad89faee30a5db7350a431fa8950118', '26ac49cd7fe1', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'anaya', 'anaya@knights.ucf.edu', '31b3d9aacfbf2cf7185c8501b60ee9f395d8', 'fc885643d430', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'tristan', 'tristan@knights.ucf.edu', '8992709bd5b211d78c78a9b602cbbb4a3e70', '81750c89adc2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'reyansh', 'reyansh@knights.ucf.edu', 'a9e4a506a2f30e227180218fd854e70e6637', '2ff60361bd02', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'leyla', 'leyla@knights.ucf.edu', '068d1065925c77766a82b3b19e65f9b69056', 'bd184e901c18', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'madelynn', 'madelynn@knights.ucf.edu', '7339d2504652716a3a662a8821b5f24accd9', '6d15ce2e2bac', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'vanessa', 'vanessa@knights.ucf.edu', '87000f5acf0400dad5be853b7e530d26c8dd', '89fe86f6f807', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jazmin', 'jazmin@knights.ucf.edu', 'a350ae4b714b6ada0bc7f6f7ec4bfd4d7401', '85a392938222', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'riaan', 'riaan@knights.ucf.edu', '4600954e43ca12e037e4fbbe906e9e3e60c8', '85bfbaf5d17b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'stephanie', 'stephanie@knights.ucf.edu', '094ac881128bc38a8e32a159a0e632f5659d', '36f69e2fb2a2', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'eileen', 'eileen@knights.ucf.edu', '5b70210ad92aa5bec1061c8975eab781dc4c', 'd97bd4085307', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ann', 'ann@knights.ucf.edu', '3bba0a0ac8f36ae6d99b0e18342014ae863c', '0962aaa5f5bc', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'apollo', 'apollo@knights.ucf.edu', '4b4801baa8a4f097c123004066ed5e521197', 'b2f82f53dd47', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'hailey', 'hailey@knights.ucf.edu', '07c3f202aba6267bd10a1f1bcbaf467ce834', 'a33b5eba03cb', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'penelope', 'penelope@knights.ucf.edu', '2c633c7bb3aee5ee39add0303a8dd489bedf', '797dbc2e2e0c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'patrick', 'patrick@knights.ucf.edu', 'b9fa6a58022e6c3c2ace05cdba5b27e0ac9e', 'c2363f9ab047', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brady', 'brady@knights.ucf.edu', '7f2b67df5500187efea937170e3efd16a5d8', 'a8851f21de2f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mason', 'mason@knights.ucf.edu', 'fdb928f4f425f2a7a00e8f6c0dc0c36f9f09', 'b4def6af8e05', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'leah', 'leah@knights.ucf.edu', '02b434ebb062fb9636125c520f6277e97961', 'e3898ed97cf3', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'blaise', 'blaise@knights.ucf.edu', 'baf2e03bb9e3eb07b23f775444fdd1701965', '9f3ed0aaec43', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'juan', 'juan@knights.ucf.edu', '93dd8d1d070920a8a6fb7be87c9850fb6d46', 'becb556ef8aa', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zayne', 'zayne@knights.ucf.edu', 'e6833bca305731a5e58584914e2d23289c49', 'ae1424407f2c', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aurelia', 'aurelia@knights.ucf.edu', 'd9fc6e0000566fd14c7f61c2c853943c8b40', '706839591626', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'emily', 'emily@knights.ucf.edu', 'e95103ec2d7ab510797b1a9d96764debeb89', '86c38bc25ea3', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jaxen', 'jaxen@knights.ucf.edu', '19e22178f76aa0c65345a2da2fcd55f7f0a1', 'b9de5f6c5cab', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nevaeh', 'nevaeh@knights.ucf.edu', '8de2b5cdb1ab148a670860ddd51d27b42d9b', '2395bfaac20f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alan', 'alan@knights.ucf.edu', '59ab95d3a6f6fa9f37734f0ee73dd5931384', 'c8ec096aa688', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'arlo', 'arlo@knights.ucf.edu', 'ac89341e873461d95310ef3936c3fa0e8e72', '5c2e2e12578b', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kailyn', 'kailyn@knights.ucf.edu', 'cb1cf3cff266b48a0d42e8aeb1d969a11495', '0efd56230f4f', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'corinne', 'corinne@knights.ucf.edu', 'c53b86f43f1f6352ae63d4514b76ef8709bc', '45c02397c7c5', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'emery', 'emery@knights.ucf.edu', '7c70f3ef958894ef6ac4372748a1d584ba56', 'aeebd1255280', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jackson', 'jackson@knights.ucf.edu', '73d048fc827c03207eb1308a8c7e8cea88bf', '5ce582e28ff3', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'halle', 'halle@knights.ucf.edu', '5dae6a3964b802ca0d5643b7878d324c5da8', '45decd3ae282', '2016-07-20 05:02:36');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aiyana', 'aiyana@knights.ucf.edu', '327bf999d4a5b11db1a441dd4b00b7d883f8', 'e9a8aa4bc04a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sloan', 'sloan@knights.ucf.edu', '8cc82a818c1d07a6b3f8c3beb5c04ad829b3', 'fd8386081660', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'joziah', 'joziah@knights.ucf.edu', '0727edbb3017e9746858575322a37b01dfac', 'a5b41c2f3774', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cash', 'cash@knights.ucf.edu', 'bba03c9b75a26133ae7bdcb00fe22f1e9e2a', '4ab59373c4f2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lochlan', 'lochlan@knights.ucf.edu', 'ed5ca45fd8337d11f0284b41e1e00653a871', 'd4079e4478d6', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jesse', 'jesse@knights.ucf.edu', 'ed86a876c4d65ca1c90d1dea2768d3b14f8c', '519f9ce61eb3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'marilyn', 'marilyn@knights.ucf.edu', '5eda590a3747b03bf1172917da87a832d0d4', '7788073e15ba', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'saylor', 'saylor@knights.ucf.edu', '2eaf4a2e4d967b80f29d80ec59813fcac232', '2c9e39bce9f5', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'elyse', 'elyse@knights.ucf.edu', 'ce1f6285bcd01e3d9f4a2f799aefb3cb0917', '697194c08fa4', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'william', 'william@knights.ucf.edu', '0b110a39203beee7eba2a0eeb66bf7c316f9', 'ef5894da4520', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'julian', 'julian@knights.ucf.edu', '8759a51ade9dae91bcbc5a3c99d374bbe092', 'd2ccc82bae6e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'victoria', 'victoria@knights.ucf.edu', 'd0c55130b3917ecdd2a046171b44e83d7912', '55102b0cec57', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'miles', 'miles@knights.ucf.edu', 'a4017278409ef655952a44f867981d3681b7', '7f06d0b6a503', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sky', 'sky@knights.ucf.edu', '0d02d461c6df9af2a5e5278d6c33ce565486', '351cc6372ba2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mara', 'mara@knights.ucf.edu', '42762c16678f16753606b1d062c84f2b6b03', '3213a8c28222', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lucas', 'lucas@knights.ucf.edu', '236a5a31ac0fd5bf160e4f01954809432261', '7d49b618b577', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'andre', 'andre@knights.ucf.edu', '6a49ace5120d8be932682c2b06be8eb8b597', 'ec21061fd1d9', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'levi', 'levi@knights.ucf.edu', '03601719467789790621c886f326fd5b4bc4', '740c81bc1f1f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'eliseo', 'eliseo@knights.ucf.edu', '9bccc84790c17e768f11eb19e70bb21da0aa', 'ef3e75100cae', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'princeton', 'princeton@knights.ucf.edu', '406c621a7b0ef39bfb92307f28ef55b0f766', '8bb4ac901c83', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'soren', 'soren@knights.ucf.edu', '8149b3c7a6a3a2287d74bc33ec6bf1accec9', '227670b38406', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ronin', 'ronin@knights.ucf.edu', '93b1cd2102f56759f4c95dbff0b6ebbe9e76', '77be5f7831d0', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'evalyn', 'evalyn@knights.ucf.edu', '4e5025722c485388a2f9f6d541855f6fa4ed', 'd0d9ca11db16', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lillie', 'lillie@knights.ucf.edu', '7ea1bafa73dee113e6b0e7fa15a453dbdc41', '5380c3d8e852', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ashlynn', 'ashlynn@knights.ucf.edu', 'dae3f10b2995bf7a66a11af09d2280a84941', '0f48149301d6', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'edith', 'edith@knights.ucf.edu', '6c872ccdabca7ae77ba57f46a1865ce75483', '86b8fd8d76a1', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'vincent', 'vincent@knights.ucf.edu', 'b65830e8762029f4ff35d1154965114156a5', 'e7e5af9442b5', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'perla', 'perla@knights.ucf.edu', '3f3ef39e0147ced0dc3f0f66950f8194a147', '58b6fc2c77e3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'leo', 'leo@knights.ucf.edu', '7ef83961aa348c8c0c7af0110ca511594678', 'e31ff383f95f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sullivan', 'sullivan@knights.ucf.edu', '425c7d8cdc37931268f0215c31c3617e2f71', '52ab46f642b6', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alyssa', 'alyssa@knights.ucf.edu', 'cf3086a02b13a65cb795eaec65ed564d7051', '87d101665ae7', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'colten', 'colten@knights.ucf.edu', 'e3199aa169f559559ae7e46b89abbce6da88', 'e908c52786f1', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jimmy', 'jimmy@knights.ucf.edu', 'e8b1154b1cd02a8bd2a092024452d445d91b', '19b74fe03d26', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sarai', 'sarai@knights.ucf.edu', 'c589453592dbc9c04b20cbcb4b6e5f95aa02', '9feb593762f4', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'charlie', 'charlie@knights.ucf.edu', '45d6777853c70de02cbe0eb3da36b62f86d9', 'cd115f252e7d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lucy', 'lucy@knights.ucf.edu', '3ae14bd0be7e7e99290a48f8ac70c0298a53', 'aaabe156fa88', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'wyatt', 'wyatt@knights.ucf.edu', '3752ae1e93718915c1a54c6a6b70407e3d57', '01dc9a567acb', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ellie', 'ellie@knights.ucf.edu', '0e7ed4bd0eb12d0a967326b24c29eee5668c', 'd11f3f9b833d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cristopher', 'cristopher@knights.ucf.edu', 'a5c117b5624a5561c19dd9c4fd92034c1ead', '433e20dc432f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dominique', 'dominique@knights.ucf.edu', 'f9a705512fe238164792014d20c40cbcc708', '712f805c81ff', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kade', 'kade@knights.ucf.edu', '864a34868ee80bf8b00f0845041cc171ae5a', 'eb891f18750b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'forrest', 'forrest@knights.ucf.edu', '3451c77f7cc9cc8e99b9d418b542cda455d9', '66e5c57d6174', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'caitlyn', 'caitlyn@knights.ucf.edu', 'c8d446dc51c9fbb29af2e9769e4a47d6b54d', 'f5b4521718d8', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'demi', 'demi@knights.ucf.edu', 'b05ec34b343fdeb096051bdd5c42f49ea9fa', 'aa393d49a9e5', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lorenzo', 'lorenzo@knights.ucf.edu', '5dc4bc88ec15532a658a08080d5c16259c5d', 'c59b063cc12b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aliza', 'aliza@knights.ucf.edu', '8932e010104dddd56e5579aa93432f8b7295', '0a86fecd5e82', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'janelle', 'janelle@knights.ucf.edu', '29cf5d5b2c2b987dab22eefecbfdb5a00b43', '02e84c36b9a8', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'abraham', 'abraham@knights.ucf.edu', 'cc95e3e4560245fdb94b2001cf7db00c97f3', '29a96f6b947e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'wilder', 'wilder@knights.ucf.edu', '31a55de9ceeaec1957d6884be8e5a528b831', '25ea65873e07', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'junior', 'junior@knights.ucf.edu', 'a925fabffcd22ce4efb68197d0a661e5828d', 'b5a024620dbb', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'isabelle', 'isabelle@knights.ucf.edu', '56a94dda01f79d9d785f97a299bdf9d1893b', 'f70a57b756b3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'peyton', 'peyton@knights.ucf.edu', '482c6217a2ac0cbfaca4825a2b14346fda43', '0b2178c3a13b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'keenan', 'keenan@knights.ucf.edu', 'c9f22cf5065b3063d17e0cc1eb364e735e0b', 'aecc47c8cf3a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'addisyn', 'addisyn@knights.ucf.edu', '17d4509d74cc269edc4139055f0d6f34f683', '98b1efceeea2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mackenzie', 'mackenzie@knights.ucf.edu', 'b5655b0eca07d4571b7675f7a4ef96354da6', '1f643cbaeef9', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'saniyah', 'saniyah@knights.ucf.edu', 'a7ab2c1aa71f17eca1174dbd6b5c9c999177', '877963171ba8', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'quinn', 'quinn@knights.ucf.edu', '5a654dad06627f2e6f2a17d5f24d6d2d4efc', 'a371ff6339e8', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'niko', 'niko@knights.ucf.edu', '10d24b1062b7acaa9326b47abdcdf92e7efd', 'a73cc4fc9a9d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mya', 'mya@knights.ucf.edu', 'ef8dae9fbab3824b909ffd7a660df02ad7a6', '10f3aedb2eaa', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'milana', 'milana@knights.ucf.edu', 'fe854ffd0b95b21f0631ad910de542567a33', 'd7ec64d40045', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lyra', 'lyra@knights.ucf.edu', '5cee627d4b8a1a1b08e0cca5038cac4c34a1', 'd0d8fdccb09b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'chance', 'chance@knights.ucf.edu', '72cee8b198d6a602580628ca3f9abe68dd5c', '388ad9f9b5ea', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'baylee', 'baylee@knights.ucf.edu', '845336d6ac4ad4bea1d0d4e0ab33126cfff2', '01f14de1f2e1', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'corbin', 'corbin@knights.ucf.edu', 'ceb0eed0ee2e1d252d229aa233d87bbfb10a', '54c0e6aee2cc', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'reginald', 'reginald@knights.ucf.edu', '8ad6edc8e47f16474073e11e72ebadb5891d', '2538383753bb', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jaylee', 'jaylee@knights.ucf.edu', '4b6d783fc13c597fb95a8357b043b1ef3252', 'da890276ce16', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'anne', 'anne@knights.ucf.edu', 'e581c34f604c22bc27fd5f412d331557a9fd', 'e34672846e54', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mary', 'mary@knights.ucf.edu', 'ff1fcd4efc4157bc72811c78d94fd433695c', '2ed8a0cce468', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jewel', 'jewel@knights.ucf.edu', 'f952556907e75df311c10340dbf74fa28cac', '978fdeef390f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'porter', 'porter@knights.ucf.edu', '8b7fea0aac6c329729bed1974edf6fda9c37', '23a0d0a10697', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'conor', 'conor@knights.ucf.edu', '2b6f1a664d8fe921cc6cbb71465f0abcb2a0', '1d512be5e545', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'giovani', 'giovani@knights.ucf.edu', 'd0f356e7de55af53f377681450c39a902afc', '2d98ce52c88a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dwayne', 'dwayne@knights.ucf.edu', 'b1087de16649d002104a7d34dae34674ce0c', 'cae174357bd0', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'casen', 'casen@knights.ucf.edu', '296426683c747236ee418e6a7ef81ec29819', 'ae2cc1bb97f3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'erin', 'erin@knights.ucf.edu', '99dde0becec9c5c239b24dca8d7a2336ddbe', 'dd5b128cfd86', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kellen', 'kellen@knights.ucf.edu', '5922fd4eee4961ec530ac0ba2970e6d93378', '04be9150aeb4', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'beckham', 'beckham@knights.ucf.edu', '3d877fcd2d617e998e6630023e12f66713f1', '2914e0d72440', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'henley', 'henley@knights.ucf.edu', '836074c3e81f552f15103c47a13931e276b1', '485997ba6d38', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'greyson', 'greyson@knights.ucf.edu', 'b4c9921d9c9e45b1e84dc95cfe73c06ef1b3', 'f0dabb91449e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jameson', 'jameson@knights.ucf.edu', 'fe81723579481bed6217cf54cdb788281090', '19a40764eb36', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kaitlynn', 'kaitlynn@knights.ucf.edu', '50c5ac2027705a25c6a18ab5f83e4f1097f1', 'aa73f2b0df82', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'reid', 'reid@knights.ucf.edu', 'd62245fd05f0a4dd814b50068f07fc79f542', 'a156730ff476', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'margaret', 'margaret@knights.ucf.edu', 'c90127d008d81633e3ef1e79f17cc40f672f', '1cb21bdd51ad', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'devin', 'devin@knights.ucf.edu', '4f84e82db892ba9a91052507b801b188a17d', '4ab50c010840', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'teresa', 'teresa@knights.ucf.edu', '578b6296d2f39fa8073ed4b02bd146cb9a43', 'b55456361ea3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'quinton', 'quinton@knights.ucf.edu', '4f9d628813babecf6a8ca6bbe3d0b69c5360', '80ed0ddd292c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lily', 'lily@knights.ucf.edu', '6ffeb58d87d6239a1456dd1423774f8451cc', '289ef1fda6ce', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'clarissa', 'clarissa@knights.ucf.edu', 'ed71752b05157e8a0d22953633f4d78aafde', '57e34f9d3836', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rhys', 'rhys@knights.ucf.edu', 'cc2fff5394e5da714cfbcdd5fd8dcfd127a7', 'fdcabf8f58f1', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'emilee', 'emilee@knights.ucf.edu', '3eb3fb94ff99e03290ac694114a2dc78ce3a', 'cc7b447dacb7', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ahmed', 'ahmed@knights.ucf.edu', '480152ba326afbf2968f330046a681a68fbe', '931eec31609e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'tristen', 'tristen@knights.ucf.edu', 'b153bd24addc5326e17185b592a24150ed62', '99b022bc1ed3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'amy', 'amy@knights.ucf.edu', '628e935a8580d42cb45ad85447b5677536d5', '0fe9cd5b9903', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ishaan', 'ishaan@knights.ucf.edu', '3d1986347f16cca1f89a7d3c244e407a6a20', 'c8f1d5ceec3d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ian', 'ian@knights.ucf.edu', '07cbd6d0975ecad75b4f7f0ea182ca2a0670', '5a3f540e246e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'hadlee', 'hadlee@knights.ucf.edu', '098798d975b4253b771552b4e7cb7a50223f', 'e02ec207ee88', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lucca', 'lucca@knights.ucf.edu', '743166a83e435a4d6964e909dca2448a54d3', '0ecdc3ef4e26', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nickolas', 'nickolas@knights.ucf.edu', 'bf0a3fdddb85244f72010c40fb8237cad9c1', 'd61f4f94be05', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'chris', 'chris@knights.ucf.edu', '026b48414db4953e1b5b5883ad1c1e5017ff', '843d480de093', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sasha', 'sasha@knights.ucf.edu', '610a9056ea122f70e99384405cfc382c8d91', 'ebd1260948c1', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aspen', 'aspen@knights.ucf.edu', 'ab6fed47f76ca839aa16c44ead5f44604107', '17ed55edb63d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mario', 'mario@knights.ucf.edu', '22eee2e1997bcd61c14e00af4a7fb4e9acba', '0f81e5e83be1', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'haley', 'haley@knights.ucf.edu', '58d08c98e09fdf88195956a186759e3f73f8', '69aaf6e24245', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'yaretzi', 'yaretzi@knights.ucf.edu', '8839fb7947fe73d0b803fa8cc758da4a8a11', '0043435832c1', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'maggie', 'maggie@knights.ucf.edu', '67939bea1afdc6ede1036f1f1510b3121db3', 'df5f2d19481f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ronnie', 'ronnie@knights.ucf.edu', 'a6448c6119958579ce60b6dc7a8396cce3c2', 'a518d1fda0cb', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'harmoni', 'harmoni@knights.ucf.edu', '5b592febc22cd5184a4d645f7fef44b3cd4e', 'ae0304d2a869', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'leia', 'leia@knights.ucf.edu', '99808eb35a75c2cfdd48d5a212cc2dd8feae', 'f0c50d58edf0', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nova', 'nova@knights.ucf.edu', '3009419591f3da787e65a8d2d58f75ac0007', '2221ca5f92af', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'liliana', 'liliana@knights.ucf.edu', 'e7fc79a3c96ef0ba0be160c045da2af58593', '4e817e83ae85', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jonas', 'jonas@knights.ucf.edu', '944d6fa52f723eb7af4727b7d99b647b87ae', '0a6d1585ab22', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'felicity', 'felicity@knights.ucf.edu', '4998ed7b293028877c18e7e5062c277c4d67', 'd3a8d316bb8d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'estrella', 'estrella@knights.ucf.edu', 'f48a297fa1eb3407d78d794d31e5f591ed87', '0f07237d01a0', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'terrell', 'terrell@knights.ucf.edu', 'de0a9519c661b89f526decd1f4ca0cb2ab15', '24ed7ebf374c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'marco', 'marco@knights.ucf.edu', 'dea0e4d1f02a0cf30cafd8e7f58cdae6adb1', 'ef24cd7caf78', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'arden', 'arden@knights.ucf.edu', '2df7630c38699b643a0a84f07db64f29de28', '44cea8918703', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ayla', 'ayla@knights.ucf.edu', '6ed5d657251005911a95e2c459409eddf6de', 'ea05209121f9', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'flynn', 'flynn@knights.ucf.edu', '536a5ee329e26b3ab74c803f88fd4bcb37a9', '85013ed0d1e0', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'esme', 'esme@knights.ucf.edu', 'cf3b62bc66b2b60f41770d3683c49aac2f72', '5ab6bdb930c7', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'amelia', 'amelia@knights.ucf.edu', 'c18518feeba804a1b74f72216753826c7334', 'fe01b2c33327', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'daphne', 'daphne@knights.ucf.edu', 'a64f9cfd4a67c2f8d5ebc59d69cf78ed2aa2', '4011ab92112f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'georgia', 'georgia@knights.ucf.edu', 'da16f6d7a949bc47a89fff7f4802f82a8cfd', '6f49714a5d70', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'allie', 'allie@knights.ucf.edu', '6044717b2513b8a87b537d282730eb3a8442', '37994a542833', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'coleman', 'coleman@knights.ucf.edu', '7524a867c310bcf458d8f1e3ad4cceb86237', '2726f6348337', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'camren', 'camren@knights.ucf.edu', 'ce53182e5ae7f12ec4447b3bfd87b5ff08ea', '904f75757dea', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'osvaldo', 'osvaldo@knights.ucf.edu', '7679233ac69f07e793cafcff9eb0f21aa7d4', 'cffdf1106d86', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'carmelo', 'carmelo@knights.ucf.edu', 'ae33ea7f6b630ccc1ac57fab9cf21e8526b5', 'cd09212f0174', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'elsie', 'elsie@knights.ucf.edu', '107db61de34f10822be201c6ad5a8694abf3', '67c34d73b824', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rylee', 'rylee@knights.ucf.edu', '63f4d0ee071a56bc03b3ea02f6201b5c4e3e', '84d13f7b2780', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'makenna', 'makenna@knights.ucf.edu', '742cc6b694a6a104e4222a4bd80021ba7005', 'a958c26ab2ba', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ingrid', 'ingrid@knights.ucf.edu', '5f17150e11793b7b7d3d8f4242a35ad5f005', 'ce3ce5b83a58', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bristol', 'bristol@knights.ucf.edu', 'e8900def57aee07baf7669b3565968f9e8f5', 'fbbde4dfaaba', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'maci', 'maci@knights.ucf.edu', '3d5ba62421c87f463f37c221ca22adfbc9ef', '8cb555a66a40', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mikaela', 'mikaela@knights.ucf.edu', 'edcf4d41f18271b81999aed2b3bb0dc8bac7', '263a10c2ecd1', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'boone', 'boone@knights.ucf.edu', 'f668254fadb84437e9e8a95c16fef41e95a7', 'b4f7cfc88f10', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'preston', 'preston@knights.ucf.edu', '4f48c666e25c9fbcbcf50e77aa98823f69dd', 'ab7548db71f0', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bella', 'bella@knights.ucf.edu', 'c58cd12735ba134d62d97f46ca9e616e2a7d', '87fe33c3dc9a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'amare', 'amare@knights.ucf.edu', '455c0c47896843d97efbb0f220ebc49a55f8', '9f97327924fe', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sage', 'sage@knights.ucf.edu', 'eb56cdfb232b0d111ee81afc841efd1b194e', '6ed59d287971', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alaya', 'alaya@knights.ucf.edu', '9354e386631adc6903d18d4e68e08db63c99', 'd241784f09c8', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'olive', 'olive@knights.ucf.edu', 'dea5cf00e06cdb4a65c01052e4c0ab74b97d', '8a2a24c5f22b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'hattie', 'hattie@knights.ucf.edu', '2770e9079407769b81f649dacde560e70b3b', '625b6cc82c9e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'holden', 'holden@knights.ucf.edu', '9800a3350702baa8958b3a3a2c6f1b8e5395', 'a571689beb34', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kellan', 'kellan@knights.ucf.edu', '757750e3827ee6dc99c57556b6618f88e383', '587d0a28bf03', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'amira', 'amira@knights.ucf.edu', '3615feca3dcfc3deb0e9f56fac4934afc5db', 'efa2b880b9e7', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'estella', 'estella@knights.ucf.edu', '1e8da39ad9befa58e1d39ce5c8ab12348fbe', 'afbafd005c5a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'justus', 'justus@knights.ucf.edu', 'f06a2dbb9d9598eb276e4f94729e2b9d81c5', '8847824ab5fe', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'imani', 'imani@knights.ucf.edu', 'a29ed0345eb4a8b91e653ea9fa22da4c8020', '940997ec67dd', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'izabella', 'izabella@knights.ucf.edu', '513b5e3419ab221bc641bf7018fcdb8cfb4b', '4c848dbe83e0', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'angel', 'angel@knights.ucf.edu', '439d4b19032035c9b81f18c96059b054290e', '887e13adf2e8', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bruno', 'bruno@knights.ucf.edu', 'f1e2e58d9bb548787806c11f27a4d5d09e21', 'f0833bd11108', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'annabelle', 'annabelle@knights.ucf.edu', '44efd83d72077dccf2f4989d84f60112f5bb', '3edb59302c3d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'emmy', 'emmy@knights.ucf.edu', 'a690c7731b7e63d4dc510bdba3ae41a9e9fc', '889e5af2c6ac', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'billy', 'billy@knights.ucf.edu', 'f6bd6ed9a5a70e517ef386d8bccc8ed8fea7', 'd312d99d570d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'major', 'major@knights.ucf.edu', '2800cf36bbec3d4b52d6374dafc579f2190a', '93a33b84d0b4', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'carly', 'carly@knights.ucf.edu', 'bf42d44f33e87b791bd961263681d0c615c6', '453dc7efafa7', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mariyah', 'mariyah@knights.ucf.edu', '45fe2bf008d9f3018f2528f8a36cc4234e9c', '9e83a31cf856', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aden', 'aden@knights.ucf.edu', 'adb23656062f880e0cd49cf557193776e22b', '88e8573ea615', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'javier', 'javier@knights.ucf.edu', '4a29a47061457ef8c60d4b9ef33c7d715516', '4508664f571b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'celia', 'celia@knights.ucf.edu', 'fdeda77db14758f50ac57564a9a9d888aef2', '84e0c38ab334', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dylan', 'dylan@knights.ucf.edu', '02f2e824f19f56f7caa6c2f3262f35f5fd31', 'c79b54ca6291', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jessica', 'jessica@knights.ucf.edu', 'dc2e4a29ebf44c224e9a7967fd0d1747222e', 'ed88c6f36102', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'freddy', 'freddy@knights.ucf.edu', 'c8a1f89fa7dddea7624dcd70c03d45ec9a37', 'a6e0ad532636', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kolby', 'kolby@knights.ucf.edu', 'af60f1456d73ee36446783c63092f875bd45', 'a31bb5d028a6', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'valerie', 'valerie@knights.ucf.edu', '246f9b03e88cd9ddf7ef22fdc4ad3a73fc8e', 'b8743909a855', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'frankie', 'frankie@knights.ucf.edu', '94bbcdcb3590ccd2f861299c7acf6443608d', 'f7c982fe5cb7', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'gage', 'gage@knights.ucf.edu', '44ecfeb236d5f7d87c4f38a3c6844d5c6f65', 'cc7d49db2c6f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'enzo', 'enzo@knights.ucf.edu', 'f8a61f8bf40cddbc71eb6ee71f35d8f6db18', '14a3a7b388b2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'paula', 'paula@knights.ucf.edu', '1935a08443d62a867e3f67c6a7f2ec31ad63', '8508f9bf81cc', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'tenley', 'tenley@knights.ucf.edu', '7ab195adf7cb55c8b7566d6f855c54a672ee', '606fe38d2c7b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'colin', 'colin@knights.ucf.edu', 'd5cee75d1abdaf57e242ef1924b0b5df7c83', '05dc2e3066c3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'royce', 'royce@knights.ucf.edu', '6c064103c8bc6ec00d3fc72e77c507e3be29', '94a522dea73b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'damon', 'damon@knights.ucf.edu', '9a2461ad800a67f13c7f8d704ceaba6361d5', '7a429743bcce', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'emilio', 'emilio@knights.ucf.edu', 'c0bb17f6f910fd82deb863376be1a4f0bae2', 'ddd8dc67dd98', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'reese', 'reese@knights.ucf.edu', 'e913d4d5e11dff50111b292579c5bf903b04', 'cede564f6fd9', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bodie', 'bodie@knights.ucf.edu', '16665534c792b4bbf8069b69504af2ed2a57', '4ac89cb27c2a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'maryam', 'maryam@knights.ucf.edu', '80e89aadace659f30032afd808673989d500', '4cc90604a28f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'asa', 'asa@knights.ucf.edu', 'eceb33722c3eee08ad9d613776ed4a9c521c', '0e757a125585', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nasir', 'nasir@knights.ucf.edu', 'e190b75be0b6b81667e52c737e484721ba8c', '722edd30b43e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aliyah', 'aliyah@knights.ucf.edu', 'ca725e8333f2373a98d222ba770931028db9', '8567305e9270', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dillon', 'dillon@knights.ucf.edu', '2ef2b3a8a90e8f18c4a4a68e3c9a527ebfe4', '111a77184010', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'abigail', 'abigail@knights.ucf.edu', '3f6aca63b235f389dc3d9b737bf29891da03', '95e734645a15', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'melissa', 'melissa@knights.ucf.edu', '518072cddb9baa63887a5c7ca9b276e8eb71', '54267821c4b2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jeremy', 'jeremy@knights.ucf.edu', 'a9c1c7bbf42b3b5eedec489d6fb8ce5c0c9e', '79a4fa3d1eb7', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brooke', 'brooke@knights.ucf.edu', '7951b9f17f67e040f6abb4064b09dc76e4a1', '5c077a131a3a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'finnegan', 'finnegan@knights.ucf.edu', 'fc1edeb6bc327c226e6eb928b6b0478b1e1a', 'a4116348a973', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'harper', 'harper@knights.ucf.edu', '589c5adbbfabbe49257756b32f4e4f5b5379', '288d6d1245e7', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jadiel', 'jadiel@knights.ucf.edu', 'a6fd37e3642ca6e2e575209fe491d08cf0e6', '6d6ec464613a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zachary', 'zachary@knights.ucf.edu', '050945e755847649d75caa22ce2ef01613c5', 'be4e8fe65f1c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'hazel', 'hazel@knights.ucf.edu', 'b97f8220dc752c1fa8a8e1cf601637f7fd48', 'bfc838f57d16', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nayeli', 'nayeli@knights.ucf.edu', '871161390ad16187a8f8cb8e6b8e51cd6803', '8c38d6b80fcb', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'haven', 'haven@knights.ucf.edu', 'a9a50cb89994f169dd718cf63de961f76ccd', '938f0f6adb63', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'louis', 'louis@knights.ucf.edu', 'd4b94802d37777aab96d89a57d503d4fef29', 'b440a7ef8836', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kynlee', 'kynlee@knights.ucf.edu', 'd9c9c3c5c44ad6036d8b52fda3ea02acef84', '9981de2086f8', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'amir', 'amir@knights.ucf.edu', 'c93e95d31282f6d530332349439987b4c54b', 'f36a66a3fd0a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'stella', 'stella@knights.ucf.edu', 'd26e4b102a0a439d57ec707a0ec6f7ebe5b5', 'd6ce215b7b0c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'micheal', 'micheal@knights.ucf.edu', '866ac0e140d68d6001a09d334d84988e9ebd', '5f960de664d2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kian', 'kian@knights.ucf.edu', '6b9ceb441e7ca4cda4800fd896c348c05795', '3c3d5fa5d538', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'logan', 'logan@knights.ucf.edu', 'edd6ce80418e4d8e42922d6be57d85cfdc4a', 'bd973d173dea', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ezequiel', 'ezequiel@knights.ucf.edu', 'bce129d421262185a66e59c5b1be868519e7', '46308ce83b04', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kamdyn', 'kamdyn@knights.ucf.edu', 'dd22b5346a111bcd0b2f9d40e66cd89bf7d5', 'c10065d130b6', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lana', 'lana@knights.ucf.edu', 'ffe687e5d213f5ec2c16ee893d4c53fdcb48', 'b79c80ffd93e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'elijah', 'elijah@knights.ucf.edu', 'ec02032b7d91081efdb3f0d1b797a2ec4c33', '644c557c30ab', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'truman', 'truman@knights.ucf.edu', '8deeed8ea25da2518cd4f0c2dbefca3068d8', 'e50e75eaa40b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'maleah', 'maleah@knights.ucf.edu', 'b11c3a6b9ce247831e5d9d10c4d1574ca7e4', 'a97ee8bc85ec', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cody', 'cody@knights.ucf.edu', 'cff5cee837838de7c90596a4e736540e9f08', 'edcbbd6d677c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ellen', 'ellen@knights.ucf.edu', '631152ee9a147a9af9aa68c86c23a70c7475', '4b9798c2d497', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lia', 'lia@knights.ucf.edu', '4a1b6265c5880137632afbbc8fea0c671512', '0cf02af8bbc7', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'prince', 'prince@knights.ucf.edu', '4a88bff8284a2767c868aea5a24e40ed5a56', '469669707c30', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mila', 'mila@knights.ucf.edu', '3750b02f12525241684e86c1bd8f1cd5b617', '9f84ec045765', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jordynn', 'jordynn@knights.ucf.edu', '9c38f5cb03e5a67a7ea837b391886424dc73', 'b8da2daf4a25', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'christopher', 'christopher@knights.ucf.edu', '7793594bc293fbab13852929f5e5afe6c487', 'fb12d8f752e0', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'taliyah', 'taliyah@knights.ucf.edu', '8264908cd8e9ce4b75cb48aedbd84f496f64', 'cc6aab577a32', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'axel', 'axel@knights.ucf.edu', 'b3cca53917511d06862cfe1b409caacb44be', 'e31f3dc55b64', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'derrick', 'derrick@knights.ucf.edu', '63e5217c28db1afe88df8091db3e74782ab4', 'aeffb9c0aae2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kennedy', 'kennedy@knights.ucf.edu', '1bc34ad93e27c137d3bab049ab9f48140837', 'de5e6efad5e2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'seamus', 'seamus@knights.ucf.edu', '67fdb2c8b51b489bc9c1a6936477d86071f3', 'c94fc477c8a5', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'christina', 'christina@knights.ucf.edu', '022929d5ac9e2df9cd638878c1fe462be0ba', '7292641a2609', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dangelo', 'dangelo@knights.ucf.edu', 'f439f800cdd891fa798d84058437c4698667', 'b27d889fc717', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'erick', 'erick@knights.ucf.edu', '5723200b4a2ab1149257522f0b749615b043', '38640033e377', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'santino', 'santino@knights.ucf.edu', '2ad5b77090e8057d82fff657c4d6dc676567', '8f6a55d9102c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jaylynn', 'jaylynn@knights.ucf.edu', '8ec6a166095f5c2f805eb4b51e835766aa57', 'fadc587625aa', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'melany', 'melany@knights.ucf.edu', 'c7ea4203417682379aa2aec017c310847dc5', 'bd53c982db82', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aniyah', 'aniyah@knights.ucf.edu', '192632d3f1f0b61cfe1f01510c7c71f8884d', 'b822b2e7e874', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ally', 'ally@knights.ucf.edu', '738e37ed87938e398b3b14721561c3cc6051', '1b7cef635e4f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ashlyn', 'ashlyn@knights.ucf.edu', 'ed2eddf902bcbd191489a5cee8ebe889866b', '0951b34e37bb', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'liana', 'liana@knights.ucf.edu', '9fa23680b4529844ab00cc820b7e26e9065b', 'a3d0a7c6418a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sophia', 'sophia@knights.ucf.edu', '308ae729b48bca86e32435f54a52ae96b5d8', '5da628e2bda6', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brayden', 'brayden@knights.ucf.edu', '29ec101568b79a88726eef311591158da0de', '124e4c06ddb2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ronald', 'ronald@knights.ucf.edu', '6efcaf92d315e0c74b423e2e865c862e87b0', 'ff637d76c81e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'gracelynn', 'gracelynn@knights.ucf.edu', '5fb1d017d041e7673cea2df35b8a61a4c7be', 'efb47ce338bc', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'milania', 'milania@knights.ucf.edu', '2d143d8d20cd2474a9af0468eeda3d0f1d81', '20633bda518e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'braelynn', 'braelynn@knights.ucf.edu', '627aac5404f367139bdc1976156864883205', '2fcabd947329', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'veronica', 'veronica@knights.ucf.edu', 'ac5c027b0fefe5e3e05795bced3a75b227ba', 'a9bfe8d07ac3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kathleen', 'kathleen@knights.ucf.edu', 'e7b76add9341672c1f96d88f1a32a3bdc9d8', 'ebd65cd2d1d2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'leilani', 'leilani@knights.ucf.edu', 'c13f59f8b3cb3761497d23a430400b6673f0', '21b6a36d7ba8', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jessie', 'jessie@knights.ucf.edu', 'e3e0cfd68eca63207998016cd294dcf03c07', 'ab56aa84af42', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'paige', 'paige@knights.ucf.edu', '04fa541f8c4fe510b8856de669d901f9cda6', '04a72af3fd3c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'giovanni', 'giovanni@knights.ucf.edu', '8f3d7002b2ca488847496f9279ab7663040b', 'dc8915766902', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jax', 'jax@knights.ucf.edu', '4f5d792d4d42c20e67e1d13e20b02aee58cc', 'f56cf57fbd6e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jada', 'jada@knights.ucf.edu', 'a9657ed95868a3bcb9ebe505ca99d2b766b9', '8885319dbd1d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kenny', 'kenny@knights.ucf.edu', '2a5c6032e0ded1500b4d92f7b823157996c2', '3beaa06292f8', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kaia', 'kaia@knights.ucf.edu', '30f241dbbf45a25e9bb25787fe3394293f6c', '8429600b1662', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'vaughn', 'vaughn@knights.ucf.edu', '76c45ed671a6920c00249c5781946f61b168', '82c70c3fff14', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zain', 'zain@knights.ucf.edu', '30f4186d8a94183605e3d8bf28fd064af92e', '572330896dbb', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'anakin', 'anakin@knights.ucf.edu', '56cdf2bb2302f0ecf8cddba6d13ca81a92ca', '044c5d285e1e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alfred', 'alfred@knights.ucf.edu', 'c40a900ea6f712111b6fe49a7d824bfb07eb', 'e418a00d4ddd', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kevin', 'kevin@knights.ucf.edu', '08a04df1575f35668eca4ee2781796562bfb', '4ca59276bc30', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cason', 'cason@knights.ucf.edu', '8489cfa606c7236a2ccdc289e82e07bd5503', '4bdf0a2337ea', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kendrick', 'kendrick@knights.ucf.edu', '00a071f2f850f17d19c896cff1e7e8e39377', '1557d61f50ae', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'russell', 'russell@knights.ucf.edu', 'f118a3ac237ff3fc67f52cf2b044ceb8956a', '688d39fbac33', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'roselyn', 'roselyn@knights.ucf.edu', '50c455680a12ead49fdcf644d4d783119903', '57ee83e88bdd', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jonah', 'jonah@knights.ucf.edu', '0966390bad0d8991234def316e95fc74c4eb', 'b3a255fc9001', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sterling', 'sterling@knights.ucf.edu', '8e08763edf583cc6f8d7689f06f94f356409', 'bcd4c0619125', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alejandra', 'alejandra@knights.ucf.edu', '5e4055450fd02ec18c2a2c8571e36ed47a63', '5eef687f2215', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'anthony', 'anthony@knights.ucf.edu', '78fd62ad56913203a7c01c9ac3376ad5c49d', '77186d07a04f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'anastasia', 'anastasia@knights.ucf.edu', '6065da7bdf18809afb258942009b83bafaab', '95f079fc33d3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kinsley', 'kinsley@knights.ucf.edu', '6b18046f595fccdcec3844813e441cc353bb', 'f57243c55ad7', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'maddox', 'maddox@knights.ucf.edu', 'e82f9d75c3a2c1b4bd5fc83e76e9f6fddd5b', '23e808dd5b7e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'wren', 'wren@knights.ucf.edu', '83dcc2e99b784ed55f076d101b481934a89b', 'a504e4ee1bc0', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'noor', 'noor@knights.ucf.edu', 'b983b2e0a1266a1ec04b84d88ba2f3ff85f9', '0a0ccd28e5c1', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cruz', 'cruz@knights.ucf.edu', '092aa4276e64e67eeb00ff8ea42d8dbe0de0', 'd87e9fe8444a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'tatiana', 'tatiana@knights.ucf.edu', 'ab1b7ac900d005602dc96374deef2faa1eed', 'da523cc4708d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sergio', 'sergio@knights.ucf.edu', '8c83cba05931ba8af18501175abaedb59ce5', 'b704e8d81a8f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ryland', 'ryland@knights.ucf.edu', 'b9f9706cb4832ca546a5551643ad93089f44', 'aa16dab20ff1', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brooklyn', 'brooklyn@knights.ucf.edu', 'a7ebf679705eed678f4572a45e617a48610c', '8b4110b7194d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'michelle', 'michelle@knights.ucf.edu', 'b80ee0f44edabf4f05b819fed9bb6178e2d7', 'c5fd501e8097', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'avalynn', 'avalynn@knights.ucf.edu', 'fb83a04cd263b4e80fbd5198478ed71bcd84', '4d3717cf7875', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aleah', 'aleah@knights.ucf.edu', 'e366e6e988c34df2d3eb4b88a738965ceca5', '00ea3ccfdb78', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cheyenne', 'cheyenne@knights.ucf.edu', '3ef5dd640eb018eff60305d34a2ae52ec71d', 'e3f6839b1833', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'myra', 'myra@knights.ucf.edu', '6cc700dc88c225eda3ba2adc4b6bc741178c', '50764a9da35e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lola', 'lola@knights.ucf.edu', '33d377d4fba448207952c526ba9c11e4dc69', '324b65774fb7', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'averie', 'averie@knights.ucf.edu', '7084cc627e17cf1a3a1453c6dabf81fb0151', 'b1c9f051c3ea', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'molly', 'molly@knights.ucf.edu', '1f9cb7c64082c631a49551c94e835cb6af1e', 'c59e9663298d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'carolina', 'carolina@knights.ucf.edu', '150f355723d0ca2a10a654f680ea7226ff1a', '60adc5236ed3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'guillermo', 'guillermo@knights.ucf.edu', 'd1237d4e075af58c59a0ed2ea365bac48224', '486bbca67d3e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'london', 'london@knights.ucf.edu', '80f5b632f61113e98483348ec4363ca9a995', '84de52354e2c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aisha', 'aisha@knights.ucf.edu', '75a080b542526c5cc88a5588dbce62d12f2c', '24278792042e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'konnor', 'konnor@knights.ucf.edu', '33d7958216db1b8570dee995ab8dddfdd32a', 'bcda1e82b5ae', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'caiden', 'caiden@knights.ucf.edu', '34088d923e483ec9f4d5878da4e45ec50db0', '5316cd384db6', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'eli', 'eli@knights.ucf.edu', '22e7a89c3e22f1bc4e36212d2689c93266a2', '1d3544a5f6fd', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'gavin', 'gavin@knights.ucf.edu', '4ab0d4e48fe6502e3b9ab86cf8930327b36c', '8ea6bdd906a3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'eliana', 'eliana@knights.ucf.edu', '53140470af4c177ca1fb25c95b840d09f394', '246d731cd8bc', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dulce', 'dulce@knights.ucf.edu', '8bc1a8770176b9fee768ec99078cc08690f1', '722c8485810f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'adelyn', 'adelyn@knights.ucf.edu', '620cacf616ae60036c3038c48293be3d637f', 'b396aeca6574', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brooklynn', 'brooklynn@knights.ucf.edu', '1c7fde9cf1461dbd3b235b52a62ec1c749f9', '9c1345bc76ff', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'tucker', 'tucker@knights.ucf.edu', '2dacdd9f1b2a8080e294cac67bcfb6181cb1', '45df55b57e72', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'matthias', 'matthias@knights.ucf.edu', '9411a11e2a84df8cd6c80a6b729713a055cd', '11bf29deae84', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'carolyn', 'carolyn@knights.ucf.edu', '4a8a477cbd452027fe4701852493835333a7', '7a0609f044bd', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dixie', 'dixie@knights.ucf.edu', '4c55debad2261956f8f0859946f120ec9040', 'fa4fc864d98f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'thea', 'thea@knights.ucf.edu', '57887288992e5381245aec814c79cef323d0', '5b4315cf5d94', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'scott', 'scott@knights.ucf.edu', '7edc66a3920b5c239a5a95f7c73be3fa6631', 'fe19ed2c73e4', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'liberty', 'liberty@knights.ucf.edu', '2ca2fef4c1cbf583f31381d69b6d690bda27', 'ca98aead8899', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'karson', 'karson@knights.ucf.edu', '5558628acb3f5808891d46e22971bed2e690', '4ac2259c168f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'genesis', 'genesis@knights.ucf.edu', '337743d0922ae67afc48712191d1c4fd23a0', '4ea438587a3c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'grayson', 'grayson@knights.ucf.edu', 'c04fffbfc51cc0302d9ff09f7975e105c8c6', 'ad2bcae0c6d8', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'phillip', 'phillip@knights.ucf.edu', '29e1ca303c4550d5e4d208b3ea151af047cb', 'd19002add19a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'tegan', 'tegan@knights.ucf.edu', 'aba32a3834d50afdf27af15a8a91eff7ef5a', '7e669b7aad06', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'abel', 'abel@knights.ucf.edu', '306497528cf7dfbe5cb79f575df319730c7a', '1dc451390eb9', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'layla', 'layla@knights.ucf.edu', 'cdc546819e94ecb6fd8331e50a6ae598fa4e', 'dcc59a9b2c55', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nelson', 'nelson@knights.ucf.edu', '25dc14b2b58d147980e3b3ca9433963c02da', '1e536c8804f4', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ashton', 'ashton@knights.ucf.edu', 'ce5ecee89d123f95cbdada8345a96e8c3717', '144f8b86cad9', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'arturo', 'arturo@knights.ucf.edu', 'e69d2df88884417539bebd05b567daf256dc', '351ae0672ef4', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'julieta', 'julieta@knights.ucf.edu', '1d36d292da12c2336257f518047a642c6fb0', 'ddc454f8a58e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rivka', 'rivka@knights.ucf.edu', '8420757ab108d1fe6d977bf01f97b3b30207', '6efc012b414b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lila', 'lila@knights.ucf.edu', 'da7a9c995ba77d4e843a914d0883855e2142', 'd4b5abc042cf', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'james', 'james@knights.ucf.edu', '16cb2b82669740cba62962322234d334fded', '22e0371ee297', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jazlyn', 'jazlyn@knights.ucf.edu', '95ffc7bc0b318e310213bddfbaf173ef2a28', '7babcd80d85e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bria', 'bria@knights.ucf.edu', 'd73110375d296f274a8f838b8e52869620e2', '4b31169414aa', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'edward', 'edward@knights.ucf.edu', '17f03ab04071eb6501ce289ca3dbdb252164', '84e04003ee7a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'reed', 'reed@knights.ucf.edu', 'a0ea03ef1dea07dff1aa4b999e4401fe12a4', 'b1053ce646ee', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'wendy', 'wendy@knights.ucf.edu', '5aad86dbcb133e84d80dde88788e469b96f5', '5afa865c3a21', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'benjamin', 'benjamin@knights.ucf.edu', 'ac0f781957e4eac12bc2b1c513d1456e4004', '0f96f34f1e61', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'paul', 'paul@knights.ucf.edu', 'db6db9b9bb438a30773603270d352fe45134', 'cece9327af37', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kayden', 'kayden@knights.ucf.edu', 'd72fa0ecbe6c8bc6ce69c2e60a2726c40535', '531502c10d40', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'emmalee', 'emmalee@knights.ucf.edu', '1386274984859e9b9a92456fe543a9401c78', 'c22a0e6901b7', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'allen', 'allen@knights.ucf.edu', 'b79a35af17cd03281e59fb75f580925f469c', 'ac7049a082bf', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'taya', 'taya@knights.ucf.edu', 'e13a019f6af621da362ece7bf15987413fb2', '91ab612f1df9', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zaid', 'zaid@knights.ucf.edu', '1014415e80f474ddd1e4964e364800e8097c', '087b5e7b0438', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kristian', 'kristian@knights.ucf.edu', '2a096d180a51f70792121f1fa0f0dee73f73', 'abda88d47f55', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'donovan', 'donovan@knights.ucf.edu', '8498067830fd683a82c58a0d78eb8d03ab8c', '0ee69de464d3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jerry', 'jerry@knights.ucf.edu', '04df6967521f0efe40f8b7df34e44a506e6e', 'c6b7b6a915a0', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'genevieve', 'genevieve@knights.ucf.edu', '54bfb03ec2f08a83930ea16fcb8658c47959', 'da4b21b9054b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lisa', 'lisa@knights.ucf.edu', '375917b28bc98dc3899e6cbc6415769540f4', '8c594ebe3df4', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'xander', 'xander@knights.ucf.edu', '4a273e4f78c7c96475a8e14e7cbe5e8f270a', '7191e8d12cca', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'crystal', 'crystal@knights.ucf.edu', '1f3dfbbed44b41bb9cfb10f8859f5382070b', '948bd4dd1a4b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'landen', 'landen@knights.ucf.edu', '5a79f3c57ab09851e339d36783e8fe125108', '318a47a2b02c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jose', 'jose@knights.ucf.edu', 'eaa0ee0c99f2faf87b5215a2fd5a7ccf8356', 'b20128208f18', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'carl', 'carl@knights.ucf.edu', '563d92f9af74af9efa92730f6766c9061c9a', 'd7441fbb876a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kylan', 'kylan@knights.ucf.edu', 'ae0967f7824c5fd33b73d5cfbf3e9b231ed0', '076a9936d100', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rolando', 'rolando@knights.ucf.edu', '3e07269ac983d9997dda09e8c0a5bd390f66', 'f64685ba3e5c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'shawn', 'shawn@knights.ucf.edu', '21a9b1bfff38f8650f718a046ce8e61c244f', '53a468504790', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'matias', 'matias@knights.ucf.edu', '2619c8c08f7452ab3c462f6e1d027fcc2858', 'fbecc1ce084c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'draven', 'draven@knights.ucf.edu', '5e3b99db471bd94bb312befc888dbd153cfd', '95f06bc0763d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kelsey', 'kelsey@knights.ucf.edu', 'd6391d259f3a372d13e080c77bdbb7f6ef16', '758dd91a6bf1', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'emerie', 'emerie@knights.ucf.edu', 'cb4f745b7863e48180ea71702b001f48ef52', '47b8f51e3346', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'fernando', 'fernando@knights.ucf.edu', '31f143c0a5a154768cf24437d7165c5684f6', '2d8e3ee3c0a5', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'theo', 'theo@knights.ucf.edu', '1caf7fac286fa4e7f999ec81d32e95350816', '494eb446cf29', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aniya', 'aniya@knights.ucf.edu', 'd0020cc4ad8a5b62fb82d417a31c5ae33074', '501ab0f594f6', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'laney', 'laney@knights.ucf.edu', 'b3cd26415481f2ba328124c9c834d7fdefeb', '658d7598e385', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nathaniel', 'nathaniel@knights.ucf.edu', '4613dd0eb726028e1fcfe1479b1749fc61ee', 'd22e1fbd9643', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'wynter', 'wynter@knights.ucf.edu', 'b3dbfaf05985b2c3849153d550afc29af50d', '6914c2780e02', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aydin', 'aydin@knights.ucf.edu', 'c78803a945d6361cc3d80ceb3bef17b4cb92', '83afbc13bf81', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'river', 'river@knights.ucf.edu', '406538340758aa577bb9b9eab6042f75f86e', 'aac41a7bde3b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'celine', 'celine@knights.ucf.edu', 'cbab6b97ecda56d3746ea277de8451ceca1c', '6b42c73d528e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mae', 'mae@knights.ucf.edu', 'e28261d487c9923856d004167bb74656a45b', 'dad0e3b667a3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lea', 'lea@knights.ucf.edu', 'e6673ba323f8ddec6c63d5c2f8bfe8760063', 'b073da183a32', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jace', 'jace@knights.ucf.edu', 'fb598b468e100f89263ce12287e752667b46', 'eca30a31af43', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jermaine', 'jermaine@knights.ucf.edu', '4718e3553aed48e50df4480842e0f5c759f7', 'd494021d5215', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mckenna', 'mckenna@knights.ucf.edu', 'd11b9b455ae043e1ffff682240f3dc468447', '366789f727ec', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rudy', 'rudy@knights.ucf.edu', '10a404734c1711ca931ff1a87393e9e6ad79', '26add89a9988', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kaiden', 'kaiden@knights.ucf.edu', '287563452b76b61139be3cf16ff6fb07a8a5', 'd13bbd89df93', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'marlon', 'marlon@knights.ucf.edu', '068ad02fb0072a966f07e9b1d526cc75390e', 'b39744e6bcee', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jessa', 'jessa@knights.ucf.edu', 'e794e56e257673b730d86050280a90aada35', '798981530896', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lilia', 'lilia@knights.ucf.edu', 'b4f46f4401c42ef80367b4923dccdcc0da45', '17a4f8e7ac1e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'uriel', 'uriel@knights.ucf.edu', '18036e45b99e79bbd5a1eff28c507f07804b', '05c0f861bd4b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kylie', 'kylie@knights.ucf.edu', '143125af701ded07c3c4a50e138a4f2bfe8c', '2d4089b8d597', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kaelynn', 'kaelynn@knights.ucf.edu', '0bc53acaddd75d4299cdbf54b3755d44de32', '18871cbbabbf', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alexandra', 'alexandra@knights.ucf.edu', '3e98fb55c595188822cc0fe35a44f99077b0', '39eb345db71e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'daleyza', 'daleyza@knights.ucf.edu', 'e1c04bafc83375abce90bc7076de632a2b04', 'cf1ef51a5fa8', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'daniella', 'daniella@knights.ucf.edu', '665ae28ae388f0129f7076600fe9f0691a2c', '776de1c1cd30', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'monica', 'monica@knights.ucf.edu', '34efab37766b061647203ab6451c0fbcc2b5', '05248ab7ed13', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'allyson', 'allyson@knights.ucf.edu', '6ec61ef82455fcd93684e0dc9a4ca7abfeaa', '05c4de8f371b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'danny', 'danny@knights.ucf.edu', '131d65f48e682c10955fa58d4b006ff356ad', '9d06e286e3e0', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'judah', 'judah@knights.ucf.edu', '04efffdd57ff2b41f80a1d22c75b31bfaec9', '35fcc7a931a2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'layton', 'layton@knights.ucf.edu', 'bca5e32cbdacf968ce758bccb6295835a207', '7b1487870219', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'alijah', 'alijah@knights.ucf.edu', '87627ff4213394e01e7ca88de2c4eb8a83d0', 'b9223fc770bb', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aranza', 'aranza@knights.ucf.edu', '8b495eb25e2e3a5f9b192c8d476fbf63a6b7', 'cac69267f417', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sienna', 'sienna@knights.ucf.edu', '17040943d545a3e2050117281d8d66287b8a', '0c89d19e205e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nathaly', 'nathaly@knights.ucf.edu', '7c384084c0bf1bf87035e5b4641be2a5f3a2', '1a3cedeb34a9', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'miguel', 'miguel@knights.ucf.edu', '80247f3e8afeffa07dc648261f1b70921dc5', '00724adab6ec', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'diana', 'diana@knights.ucf.edu', '7e5be3229fb37f44216e6db2318f0bf6e7b6', 'bdd9ef96e4e5', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'matthew', 'matthew@knights.ucf.edu', 'f513f43e45718cd14ed2421c94a771612689', '258a95aabf65', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sarah', 'sarah@knights.ucf.edu', 'e5884dd861a93ec4b5e58a463a67eb66d60a', 'e44b1f4e1227', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lilliana', 'lilliana@knights.ucf.edu', '6a3704375603bd83fb2842808b4cae1c65bd', '7bf677385d77', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'princess', 'princess@knights.ucf.edu', '24105c35fd914c2903f40e89bb3438609dd9', 'b01a1805047f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'karen', 'karen@knights.ucf.edu', '4707bcb55759131b207b71ed15c8ea1ed72d', '5afc654e431f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'eve', 'eve@knights.ucf.edu', '69ce31512ac5d2eb39c824437890f259c0d2', 'af53c26c2fff', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sylvia', 'sylvia@knights.ucf.edu', '45d7b2cff4e08ca1ca4fc6e6f7f366807df1', '79fbdd984502', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'drake', 'drake@knights.ucf.edu', 'dffdf2e941ffd76c51cfc44a7c231af54dbd', '9b04ed3d135a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rogelio', 'rogelio@knights.ucf.edu', 'cbdff806038fce24d57b546a6f1d06633e7f', 'e388237973dd', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'raylan', 'raylan@knights.ucf.edu', 'a455d6a0b814aaeeca26fcb1554b03f2aac2', 'c32e9c0b75b4', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jaylin', 'jaylin@knights.ucf.edu', '8d07a2ae97aaaa9f4e0cf64fbe64619ac77a', 'a104f81d676f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lina', 'lina@knights.ucf.edu', '56ac1d3b175dd33898f5075069d6e332abc7', 'aae4c4358613', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'eduardo', 'eduardo@knights.ucf.edu', '0ca493e2413eb40bb241b182c9462e0950a4', 'a62159befb57', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jazlynn', 'jazlynn@knights.ucf.edu', 'bf850c8df674ac3980b1f54ee35157a65137', '7fc3edede86f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rebekah', 'rebekah@knights.ucf.edu', '7933de6be1d0cc6b72e35107137e7a2b5c7b', 'bbccac3e7a40', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'adonis', 'adonis@knights.ucf.edu', '37bd6a3a429f9780dda186af8c72dd504b21', 'baaf2e55f91e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'thaddeus', 'thaddeus@knights.ucf.edu', '378ce6fe5ac3cbd82595ab79e53e4078f615', '0ffa3bb85f1c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aubrielle', 'aubrielle@knights.ucf.edu', '7d03489dcbb92497674830dadcd7595e5f66', '1695329a1d8e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ivory', 'ivory@knights.ucf.edu', '6bbc6abb37ce9d43beceb0ee6d5ae826aa33', '42a38e0fd6ab', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'reece', 'reece@knights.ucf.edu', 'ecee68e469c71e968ef47b8543f813819dad', '8f1f2edbb30f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'amiyah', 'amiyah@knights.ucf.edu', 'e0d71de30c4ce4e56b152fa2ca50755f6044', 'd57aa3769f70', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'harmony', 'harmony@knights.ucf.edu', '627b41067674ef533ba60e290685f76741e1', 'ed6fcbcf6637', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'everly', 'everly@knights.ucf.edu', 'a421554076041c446a9e0d3710cf81fdd499', '11cc4a3ec8e2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'issac', 'issac@knights.ucf.edu', 'c668072a6a1bf7f8a05c78587a99307a92ab', '52e471efa9af', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'clara', 'clara@knights.ucf.edu', '5fb33a517293f5df6f7dfc35709a08531407', '05274efc89cb', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'adrienne', 'adrienne@knights.ucf.edu', 'f47a1776e5f71b877de3a83d0d5843b9c8c8', '5d8038ad83f5', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ben', 'ben@knights.ucf.edu', '1f452faf9b6822eb952e9419a277fa9b9745', '227715b7c9a4', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'santana', 'santana@knights.ucf.edu', '7c98640b94292098095ccb41aa5ec90d6e92', '09559feaca45', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mitchell', 'mitchell@knights.ucf.edu', 'd6516cf6da82f589d5e50970f2377c02f064', '6506bcff2ceb', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'juelz', 'juelz@knights.ucf.edu', '547845b73803db0ec190628fe4e99c562ae4', '5c6846f15d71', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'valeria', 'valeria@knights.ucf.edu', 'ebb6800702195d6b2ec1093769b6325e6065', '48d30a4e333c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'samir', 'samir@knights.ucf.edu', 'ce5887e57465c82cbae2afe1e6371e3ddd72', '91d2ed9dda1a', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kamron', 'kamron@knights.ucf.edu', 'b33d5335a07def20fc20f979978decbc9d28', '5688af5f062c', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jamari', 'jamari@knights.ucf.edu', 'e5a4f7591801a14dd15955be64b14054ec06', 'f2f4d6141c9d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aaden', 'aaden@knights.ucf.edu', 'da87523dceac494897ba6aae62722ade7668', '54baab8bb9f5', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'sandra', 'sandra@knights.ucf.edu', '43f60f9466fa0db980e4c923c3e337c5cb1c', 'c79c28cba3e6', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'elena', 'elena@knights.ucf.edu', 'feb3553b2f1f382acbbf818167237ab43d86', 'af5be73bd6bc', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cameron', 'cameron@knights.ucf.edu', '69ad7b724f82407c54f0023c15699aee7b9c', 'b4ed5621ae19', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'keagan', 'keagan@knights.ucf.edu', 'f7b6ba0e4ae7407e9e5e7639f15bb4457724', 'af297484600d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'urijah', 'urijah@knights.ucf.edu', '1dc06324df5e45b81e1172e6566065ddb057', 'faab728ae34e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'allan', 'allan@knights.ucf.edu', 'a5a808675590ec9f072a74b61fc1d789fb84', '467745154db5', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rowen', 'rowen@knights.ucf.edu', 'b61ef38fec86cde421ad8bec411c839486e4', '1e280e40f61f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'bryson', 'bryson@knights.ucf.edu', '1a69fc50a8a47a0f360162d9854946995a61', 'aa37fd64c3e1', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'fiona', 'fiona@knights.ucf.edu', 'ae0e9a24c9178126627b7dcebb9ca80746dc', '0cf94c87ca36', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'braelyn', 'braelyn@knights.ucf.edu', '0154376f75e6d31643737b5ca1f6ec79979b', 'b126f489e6de', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'mckinley', 'mckinley@knights.ucf.edu', 'c08e98d63dc1b24b0bbd33adae8860d6e3f3', '906876f82937', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kingsley', 'kingsley@knights.ucf.edu', '9b0f234ae44405b78c88f34bf4429e949623', 'bfdca2f5308b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'jeremiah', 'jeremiah@knights.ucf.edu', 'c84871d1320fa64e4a0cf65b4fe33e8c02bf', 'c3b42b66c2d4', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'hudson', 'hudson@knights.ucf.edu', '829ac9adbca304255f87d7f0757919957747', '1ddd67b4fda5', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'dallas', 'dallas@knights.ucf.edu', 'cdb8b58e2e0022fb29d42e4b202e354d6ead', 'ccb752daa962', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'carla', 'carla@knights.ucf.edu', '5d36105e62a2785f078d3467ba36c967ee73', '52e6a76dbcad', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'heather', 'heather@knights.ucf.edu', '59adb74131c76e350e80dec565a6e78c50b3', 'cc18a882eed9', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'aubrie', 'aubrie@knights.ucf.edu', 'fd4ef535ad974f78ecc78ac8295e0468dd88', 'e946a6b3d6c8', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'angelique', 'angelique@knights.ucf.edu', 'e8dcb31dab0b0d5491a4be81efbe8d57d8fc', '952f2d1b93cc', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'anika', 'anika@knights.ucf.edu', '6f7c007308a766bdf18b1d0be72a83246319', '61f6af842068', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'ava', 'ava@knights.ucf.edu', '0d462c4f8e6f2bd5a41a6c32c0065fb052b4', '5bf7fd40c850', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'daisy', 'daisy@knights.ucf.edu', 'dfb85eb67533fe57876ace528469e821535c', 'dbf03be490e4', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'macy', 'macy@knights.ucf.edu', 'd4df5141ec28ce2e88787a2be3848ad166e3', '402fac911ec2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'abram', 'abram@knights.ucf.edu', '1180e4565abe954754146a7015777fed0eeb', '9f0117192571', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'hayes', 'hayes@knights.ucf.edu', 'dfdc8e80441688ea725c11db40159cbec7f8', '4e5fad3eb147', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'brinley', 'brinley@knights.ucf.edu', '3a4be84d9dae2d222ff7458e0c91de72b443', 'f1d0a4fbf62d', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'colette', 'colette@knights.ucf.edu', '792c6e9d1488ee3e4a525d602d5d81b1f895', '46cf94be4578', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'wade', 'wade@knights.ucf.edu', '0fa513d648e85bacf571c72e5c839ed9b696', '517b72a4f8e1', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'misael', 'misael@knights.ucf.edu', 'dd54cb317eefc702748e345222c3b98104fc', '8ce09d320ff6', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'agustin', 'agustin@knights.ucf.edu', '9875d991f77afc82ee576b1b57be988a1af5', '23b8fc951ee9', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'eva', 'eva@knights.ucf.edu', '00233e4b4754bbed74a020895217e224a67e', 'ddb5aabb05d4', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'avianna', 'avianna@knights.ucf.edu', '180f969530ae385fb258e8ded25b2e092427', '3a1bf5be5dfd', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'antoine', 'antoine@knights.ucf.edu', '9054989e3c918136a98aff4d63ecf0e39327', '24c4ba29a260', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nehemiah', 'nehemiah@knights.ucf.edu', '98c241bdc5172a63a295b9f4a66761a4ac4c', '3b805b3ad0a7', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'miriam', 'miriam@knights.ucf.edu', '895eed3355e5338790c130e1f0ede024a487', '32c9b4951624', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'elizabeth', 'elizabeth@knights.ucf.edu', 'e460c298fe850ccdc2fa09510d315378ea6f', '9c9383885278', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'leanna', 'leanna@knights.ucf.edu', 'f02a1a97c2d46eca3f95dde23f093f56dd77', 'd884fd0bb023', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'nixon', 'nixon@knights.ucf.edu', 'cc47a8b0c5d57fbbe8f36b9c4341518940f0', '2e4414883e69', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'myah', 'myah@knights.ucf.edu', '58dd1e679d479265288b7d9bfcfa29521e5d', 'd1b80c21cf3f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'tiffany', 'tiffany@knights.ucf.edu', '1ad603f3c62495f15f71085ee003471ca1fa', '432982abc624', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'deborah', 'deborah@knights.ucf.edu', '1c81a4d7da7fb7b168b40f634a6747341fae', 'ad482e72357b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'elianna', 'elianna@knights.ucf.edu', '271979d72b68bad33f7feb00334e3c9ffdb6', '124f84dbde23', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'amirah', 'amirah@knights.ucf.edu', 'ad93ebdb856d2aad9f965ad725cc36a089fe', 'd4367936f8c3', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'rocco', 'rocco@knights.ucf.edu', '5a21ef56d1f4b5306d9f393e82d0f687109a', '10d680cfe385', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'amalia', 'amalia@knights.ucf.edu', '4b59cccbeafe7401f34ab89beb9f0ca48875', '51daa2c5eb3e', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'harvey', 'harvey@knights.ucf.edu', '33bf71f891f85d38750c0287145a8dd746e4', '2bce0df992b8', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'izaiah', 'izaiah@knights.ucf.edu', 'c31ce142aff4d2f98c40e72d75ecfbe4bc14', 'fd09f66bfd73', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'zayn', 'zayn@knights.ucf.edu', 'e26bbb39dd13abc4bb49d37b00dc5a00eac5', '7fd6d708a29b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'hanna', 'hanna@knights.ucf.edu', '10d93390738d81a631c4569d4b38198c98f3', '22d9bff8ba95', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'cassidy', 'cassidy@knights.ucf.edu', '6e980ea3ba75cdfb4c083d9eaa733382161c', '8f2e05a838ec', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'anabella', 'anabella@knights.ucf.edu', '0bcf2e56c9718b846d389dcecf11ed42280f', '265e179b8e1f', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kathryn', 'kathryn@knights.ucf.edu', 'bd38f63ce2f80b1fcdaf7f5784b76c82d3cb', '6aab4dae39c2', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'delilah', 'delilah@knights.ucf.edu', '86b8c39ed3bd71f5307eec7f1894247cae92', 'abaa7885b27b', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'lee', 'lee@knights.ucf.edu', 'eab4ee8c1b96f985530d17ee8b06f0426b3a', 'd13fc68a3e13', '2016-07-20 05:02:37');
INSERT INTO project.student (uid, username, email, password, salt, created) VALUES (1, 'kenna', 'kenna@knights.ucf.edu', '9645d365d298f6739e6ba9b0d890a1da0572', '0c0bc9bf598e', '2016-07-20 05:02:37');


INSERT INTO project.university (name, domain, sid, created, latitude, longitude, motto, `desc`, image) VALUES ('University of Central Florida', 'ucf.edu', 1, '2016-07-20 04:40:35', 28.6024274, -81.20005989999999, 'Reach for the Stars', 'The <strong>University of Central Florida (UCF)</strong> is an American public research university in Orlando, Florida. It is the largest university in the United States by undergraduate enrollment, and the second largest by total enrollment.
<p><p>
Founded in 1963, UCF opened to provide personnel to support the U.S. space program at the Kennedy Space Center and Cape Canaveral Air Force Station on Florida''s Space Coast. As its academic scope broadened, it was renamed from Florida Technological University to the University of Central Florida in 1978. While initial enrollment was only 1,948 students, enrollment today amounts to some 60,821 students from 140 countries and all 50 states and Washington, D.C. The majority of the student population is located on the university''s main campus just 13 miles (21 km) east-northeast of downtown Orlando, and 55 miles (89 km) southwest of Daytona Beach.', 'https://upload.wikimedia.org/wikipedia/en/a/a0/UCF_Knightro_logo.png');

INSERT INTO project.rso_data (name, `desc`, created, sid, uid, approved) VALUES ('Team Instinct', 'The BEST Pokemon Go team', '2016-07-08 12:14:14', 1, 1, 0);
INSERT INTO project.rso_data (name, `desc`, created, sid, uid, approved) VALUES ('Team Valor', 'The meh Pokemon Go team', '2016-07-10 6:23:23', 30, 1, 0);
INSERT INTO project.rso_data (name, `desc`, created, sid, uid, approved) VALUES ('Team Mystic', 'The bleh Pokemon go team', '2016-07-10 12:13:35', 52, 1, 0);
INSERT INTO project.rso_data (name, `desc`, created, sid, uid, approved) VALUES ('#HackMIT', 'Come hax with us.', '2016-07-10 12:13:35', 52, 1, 0);


INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (2, 4);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (4, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (6, 2);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (10, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (12, 3);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (18, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (26, 3);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (31, 3);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (46, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (52, 2);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (66, 2);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (71, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (76, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (81, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (85, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (96, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (99, 3);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (104, 2);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (108, 2);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (115, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (165, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (182, 3);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (196, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (251, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (286, 3);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (290, 2);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (294, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (299, 2);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (308, 2);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (385, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (390, 3);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (405, 2);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (406, 3);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (480, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (490, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (486, 2);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (489, 3);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (490, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (680, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (690, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (785, 1);
INSERT INTO project.rso_membership (`sid`, `rid`) VALUES (768, 2);


