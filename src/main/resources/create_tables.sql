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
  (2, 'meg', 'meg@mail.usf.edu', '83344a5302438f739320fa461cdd1c87961f', 'e81c188ba0a9');

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
INSERT INTO `rso_data` (`name`, `desc`, `sid`, `uid`) VALUES ('Team Instinct', 'The BEST Pokémon Go Team', 1, 1);

DROP TABLE IF EXISTS `rso_membership`;
CREATE TABLE `rso_membership` (
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `sid`     INT       NOT NULL,
  `rid`     INT       NOT NULL,
  KEY (`rid`),
  KEY (`sid`)
);
INSERT INTO `rso_membership` (`sid`, `rid`) VALUES (1, 1);

DROP TABLE IF EXISTS `university`;
CREATE TABLE `university` (
  `uid`     INT          NOT NULL AUTO_INCREMENT,
  `name`    VARCHAR(100) NOT NULL,
  `sid`     INT          NOT NULL,
  `created` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `lat`     DOUBLE       NOT NULL DEFAULT 0,
  `long`    DOUBLE       NOT NULL DEFAULT 0,
  `desc`    TEXT,
  PRIMARY KEY (`uid`)
);
INSERT INTO `university` (`name`, `sid`, `lat`, `long`, `desc`) VALUES
  ('University of Central Florida', 1, 28.60201, -81.20058, 'Home of the Knights'),
  ('University of South Florida', 10, 28.05916, -81.41199, 'Meh');
