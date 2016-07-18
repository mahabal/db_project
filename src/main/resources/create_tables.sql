CREATE DATABASE IF NOT EXISTS `project`;
USE project;

DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
  `sid`      INT          NOT NULL AUTO_INCREMENT,
  `uid`      INT          NOT NULL,
  `username` VARCHAR(100) NOT NULL,
  `email`    VARCHAR(100) NOT NULL,
  `password` VARCHAR(36)  NOT NULL,
  `salt`     VARCHAR(12)  NOT NULL,
  `created`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`sid`)
);
INSERT INTO `student` (`uid`, `username`, `email`, `password`, `salt`) VALUES
  (1, 'matt', 'matt@knights.ucf.edu', '83344a5302438f739320fa461cdd1c87961f', 'e81c188ba0a9'),
  (1, 'david', 'david@knights.ucf.edu', '83344a5302438f739320fa461cdd1c87961f', 'e81c188ba0a9'),
  (1, 'sean', 'sean@knights.ucf.edu', '83344a5302438f739320fa461cdd1c87961f', 'e81c188ba0a9'),
  (1, 'jennifer', 'jennifer@knights.ucf.edu', '83344a5302438f739320fa461cdd1c87961f', 'e81c188ba0a9'),
  (1, 'sarah', 'sarah@knights.ucf.edu', '83344a5302438f739320fa461cdd1c87961f', 'e81c188ba0a9'),
  (2, 'brandon', 'brandon@mail.usf.edu', '83344a5302438f739320fa461cdd1c87961f', 'e81c188ba0a9'),
  (2, 'john', 'john@mail.usf.edu', '83344a5302438f739320fa461cdd1c87961f', 'e81c188ba0a9'),
  (1, 'jane', 'jane@knights.ucf.edu', '83344a5302438f739320fa461cdd1c87961f', 'e81c188ba0a9'),
  (1, 'chelsea', 'chelsea@knights.ucf.edu', '83344a5302438f739320fa461cdd1c87961f', 'e81c188ba0a9'),
  (2, 'meg', 'meg@mail.usf.edu', '83344a5302438f739320fa461cdd1c87961f', 'e81c188ba0a9'),
  (3, 'jon', 'haas@mit.edu', '83344a5302438f739320fa461cdd1c87961f', 'e81c188ba0a9');

DROP TABLE IF EXISTS `session`;
CREATE TABLE `session` (
  `created` TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `sid`     INT         NOT NULL,
  `ip`      INT         NOT NULL,
  `token`   VARCHAR(36) NOT NULL,
  KEY (`sid`),
  KEY (`ip`)
);

DROP TABLE IF EXISTS `rso_data`;
CREATE TABLE `rso_data` (
  `rid`      INT          NOT NULL AUTO_INCREMENT,
  `name`     VARCHAR(100) NOT NULL,
  `desc`     TEXT,
  `created`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `sid`      INT          NOT NULL,
  `uid`      INT          NOT NULL,
  `approved` TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`rid`)
);

DROP TABLE IF EXISTS `rso_membership`;
CREATE TABLE `rso_membership` (
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `sid`     INT       NOT NULL,
  `rid`     INT       NOT NULL,
  KEY (`rid`),
  KEY (`sid`)
);
CREATE TRIGGER `rso_created` AFTER INSERT ON `rso_data` FOR EACH ROW INSERT INTO `rso_membership` (`rid`, `sid`)
VALUES (NEW.rid, NEW.sid);

INSERT INTO `rso_data` (`name`, `desc`, `sid`, `uid`) VALUES
  ('Team Instinct', 'The BEST Pokémon Go Team', 1, 1),
  ('Team Valor', 'The meh Pokémon Go Team', 2, 1),
  ('Team Mystic', 'The bleh Pokémon Go Team', 6, 2);

INSERT INTO `rso_membership` (`sid`, `rid`) VALUES
  (5, 1), (3, 1), (3, 1);

DROP TABLE IF EXISTS `university`;
CREATE TABLE `university` (
  `uid`       INT          NOT NULL AUTO_INCREMENT,
  `name`      VARCHAR(100) NOT NULL,
  `domain`    VARCHAR(100) NOT NULL,
  `sid`       INT          NOT NULL,
  `created`   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `latitude`  DOUBLE       NOT NULL DEFAULT 0,
  `longitude` DOUBLE       NOT NULL DEFAULT 0,
  `motto`     VARCHAR(100),
  `desc`      TEXT,
  `image`     TEXT,
  PRIMARY KEY (`uid`)
);
INSERT INTO `university` (`name`, `domain`, `sid`, `latitude`, `longitude`, `motto`, `desc`, `image`) VALUES
  ('University of Central Florida', 'ucf.edu', 1, 28.60201, -81.20058, 'Reach for the Stars',
   'The University of Central Florida (UCF) is an American public research university in Orlando, Florida. It is the largest university in the United States by undergraduate enrollment, and the second largest by total enrollment.',
   'https://upload.wikimedia.org/wikipedia/en/a/a0/UCF_Knightro_logo.png'),
  ('University of South Florida', 'usf.edu', 10, 28.0587078, -82.4160426, 'Truth and Wisdom',
   'The University of South Florida, also known as USF, is an American metropolitan public research university located in Tampa, Florida, United States. USF also a member institution of the State University System of Florida.',
   'http://www.sonshinetours.com/wp-content/uploads/USF_logo.png.gif'),
  ('Massachusetts Institute of Technology', 'mit.edu', 11, 42.360091, -71.09416, 'Mens et Manus',
   'The Massachusetts Institute of Technology (MIT) is a private research university in Cambridge, Massachusetts. Founded in 1861 in response to the increasing industrialization of the United States, MIT adopted a European polytechnic university model and stressed laboratory instruction in applied science and engineering. Researchers worked on computers, radar, and inertial guidance during World War II and the Cold War. Post-war defense research contributed to the rapid expansion of the faculty and campus under James Killian. The current 168-acre (68.0 ha) campus opened in 1916 and extends over 1 mile (1.6 km) along the northern bank of the Charles River basin.',
   'https://upload.wikimedia.org/wikipedia/en/thumb/4/44/MIT_Seal.svg/351px-MIT_Seal.svg.png');


DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
  `eid`          INT          NOT NULL AUTO_INCREMENT,
  `scope`        TINYINT      NOT NULL DEFAULT 1,
  `aid`          INT          NOT NULL DEFAULT 0,
  `name`         VARCHAR(100) NOT NULL,
  `desc`         TEXT         NOT NULL,
  `created`      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `date`         TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `location`     VARCHAR(100) NOT NULL,
  `latitude`     DOUBLE       NOT NULL DEFAULT 0,
  `longitude`    DOUBLE       NOT NULL DEFAULT 0,
  `contactname`  VARCHAR(100),
  `contactphone` VARCHAR(16),
  `contactemail` VARCHAR(100),
  `tags`         TEXT,
  PRIMARY KEY (`eid`)
);


