# The student table
CREATE TABLE `student` (
  `uid`      INT          NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(100) NOT NULL,
  `email`    VARCHAR(100) NOT NULL,
  `password` VARCHAR(36)  NOT NULL,
  `salt`     VARCHAR(12)  NOT NULL,
  `created`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`uid`)
);

# Stores session data
CREATE TABLE `session` (
  `created` TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `uid`     INT         NOT NULL,
  `ip`      INT         NOT NULL,
  `token`   VARCHAR(36) NOT NULL,
  KEY (`uid`),
  KEY (`ip`)
);
