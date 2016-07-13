# The student table
#   sid       - student's ID number
#   uid       - the university the student belongs to
#   username  - the username the student created
#   email     - the email used during registration
#   password  - truncated sha512-salted+hashed password
#   salt      - randomly generated salt during registration
#   created   - the time the user account was created
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

# Stores session data
#   created   - the time this session was generated (logged in)
#   sid       - the student id this session belongs to
#   ip        - the ip address the student was on at the time
#   token     - the generated token for this session
CREATE TABLE `session` (
  `created` TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `sid`     INT         NOT NULL,
  `ip`      INT         NOT NULL,
  `token`   VARCHAR(36) NOT NULL,
  KEY (`sid`),
  KEY (`ip`)
);

# Stores RSO data
#   rid       - the RSO id (created automatically)
#   created   - when the RSO was created
#   sid       - the student in charge of this RSO
#   approved  - whether or not this RSO has been approved by an admin
CREATE TABLE `rso_data` (
  `rid`      INT          NOT NULL AUTO_INCREMENT,
  `name`     VARCHAR(100) NOT NULL,
  `desc`     TEXT,
  `created`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `sid`      INT          NOT NULL,
  `approved` TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`rid`)
);

# Stores RSO membership
#    created - when the user joined the RSO
#    sid - the user id of the user (student)
#    rid - the rso id of the rso that the student joined
#    uid - the university that the rso belongs to
CREATE TABLE `rso_membership` (
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `sid`     INT       NOT NULL,
  `rid`     INT       NOT NULL,
  `uid`     INT       NOT NULL,
  KEY (`rid`),
  KEY (`sid`)
);

# Information on a university
#   uid       - the university id, generated
#   sid       - the super_admin that created this university
#   created   - the time when the university was created
#   lat       - the latitude of the university
#   long      - the longitude of the university
#   desc      - the description of the university
CREATE TABLE `university` (
  `uid`     INT       NOT NULL AUTO_INCREMENT,
  `name`    VARCHAR(100) NOT NULL,
  `sid`     INT       NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `lat`     LONG      NOT NULL DEFAULT 0,
  `long`    LONG      NOT NULL DEFAULT 0,
  `desc`    TEXT,
  PRIMARY KEY (`uid`)
);
