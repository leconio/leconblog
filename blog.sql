#blog sql start
BEGIN;
CREATE TABLE `blog_nav` (
  `id`          INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `name`        VARCHAR(40)            NOT NULL,
  `url`         VARCHAR(200),
  `status`      INTEGER                NOT NULL,
  `create_time` DATETIME(6)            NOT NULL
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE TABLE `blog_category` (
  `id`          INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `name`        VARCHAR(40)            NOT NULL,
  `parent_id`   INTEGER,
  `rank`        INTEGER                NOT NULL,
  `status`      INTEGER                NOT NULL,
  `create_time` DATETIME(6)            NOT NULL
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
ALTER TABLE `blog_category` ADD CONSTRAINT `parent_id_refs_id_965b3351` FOREIGN KEY (`parent_id`) REFERENCES `blog_category` (`id`);
CREATE TABLE `blog_article` (
  `id`          INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `author_id`   INTEGER                NOT NULL,
  `category_id` INTEGER                NOT NULL,
  `title`       VARCHAR(100)           NOT NULL,
  `en_title`    VARCHAR(100)           NOT NULL,
  `img`         VARCHAR(200)           NOT NULL,
  `tags`        VARCHAR(200),
  `summary`     LONGTEXT               NOT NULL,
  `content`     LONGTEXT               NOT NULL,
  `view_times`  INTEGER                NOT NULL,
  `zan_times`   INTEGER                NOT NULL,
  `is_top`      BOOL                   NOT NULL,
  `rank`        INTEGER                NOT NULL,
  `status`      INTEGER                NOT NULL,
  `pub_time`    DATETIME(6)            NOT NULL,
  `create_time` DATETIME(6)            NOT NULL,
  `update_time` DATETIME(6)            NOT NULL
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
ALTER TABLE `blog_article` ADD CONSTRAINT `category_id_refs_id_651a4bf4` FOREIGN KEY (`category_id`) REFERENCES `blog_category` (`id`);
CREATE TABLE `blog_column_article` (
  `id`         INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `column_id`  INTEGER                NOT NULL,
  `article_id` INTEGER                NOT NULL,
  UNIQUE (`column_id`, `article_id`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
ALTER TABLE `blog_column_article` ADD CONSTRAINT `article_id_refs_id_dc58e971` FOREIGN KEY (`article_id`) REFERENCES `blog_article` (`id`);
CREATE TABLE `blog_column` (
  `id`          INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `name`        VARCHAR(40)            NOT NULL,
  `summary`     LONGTEXT               NOT NULL,
  `status`      INTEGER                NOT NULL,
  `create_time` DATETIME(6)            NOT NULL
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
ALTER TABLE `blog_column_article` ADD CONSTRAINT `column_id_refs_id_b854df1c` FOREIGN KEY (`column_id`) REFERENCES `blog_column` (`id`);
CREATE TABLE `blog_carousel` (
  `id`          INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `title`       VARCHAR(100)           NOT NULL,
  `summary`     LONGTEXT,
  `img`         VARCHAR(200)           NOT NULL,
  `article_id`  INTEGER                NOT NULL,
  `create_time` DATETIME(6)            NOT NULL
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
ALTER TABLE `blog_carousel` ADD CONSTRAINT `article_id_refs_id_908901e3` FOREIGN KEY (`article_id`) REFERENCES `blog_article` (`id`);
CREATE TABLE `blog_news` (
  `id`          INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `title`       VARCHAR(100)           NOT NULL,
  `summary`     LONGTEXT               NOT NULL,
  `news_from`   INTEGER                NOT NULL,
  `url`         VARCHAR(200)           NOT NULL,
  `create_time` DATETIME(6)            NOT NULL,
  `pub_time`    DATETIME(6)            NOT NULL
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
-- The following references should be added but depend on non-existent tables:
-- ALTER TABLE `blog_article` ADD CONSTRAINT `author_id_refs_id_d87d831a` FOREIGN KEY (`author_id`) REFERENCES `liucl_auth_liucluser` (`id`);
CREATE INDEX `blog_category_410d0aac` ON `blog_category` (`parent_id`);
CREATE INDEX `blog_article_e969df21` ON `blog_article` (`author_id`);
CREATE INDEX `blog_article_6f33f001` ON `blog_article` (`category_id`);
CREATE INDEX `blog_column_article_3baa5244` ON `blog_column_article` (`column_id`);
CREATE INDEX `blog_column_article_e669cc35` ON `blog_column_article` (`article_id`);
CREATE INDEX `blog_carousel_e669cc35` ON `blog_carousel` (`article_id`);

COMMIT;
#blog sql end

#auth sql start
BEGIN;
CREATE TABLE `liucl_auth_liucluser_groups` (
  `id`           INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `liucluser_id` INTEGER                NOT NULL,
  `group_id`     INTEGER                NOT NULL,
  UNIQUE (`liucluser_id`, `group_id`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
ALTER TABLE `liucl_auth_liucluser_groups` ADD CONSTRAINT `group_id_refs_id_42c7db63` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);
CREATE TABLE `liucl_auth_liucluser_user_permissions` (
  `id`            INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `liucluser_id`  INTEGER                NOT NULL,
  `permission_id` INTEGER                NOT NULL,
  UNIQUE (`liucluser_id`, `permission_id`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
ALTER TABLE `liucl_auth_liucluser_user_permissions` ADD CONSTRAINT `permission_id_refs_id_e0913cbf` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`);
CREATE TABLE `liucl_auth_liucluser` (
  `id`           INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `password`     VARCHAR(128)           NOT NULL,
  `last_login`   DATETIME(6),
  `is_superuser` BOOL                   NOT NULL,
  `username`     VARCHAR(30)            NOT NULL UNIQUE,
  `first_name`   VARCHAR(30)            NOT NULL,
  `last_name`    VARCHAR(30)            NOT NULL,
  `email`        VARCHAR(254)           NOT NULL,
  `is_staff`     BOOL                   NOT NULL,
  `is_active`    BOOL                   NOT NULL,
  `date_joined`  DATETIME(6)            NOT NULL,
  `img`          VARCHAR(200)           NOT NULL,
  `intro`        VARCHAR(200)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
ALTER TABLE `liucl_auth_liucluser_groups` ADD CONSTRAINT `liucluser_id_refs_id_179003ba` FOREIGN KEY (`liucluser_id`) REFERENCES `liucl_auth_liucluser` (`id`);
ALTER TABLE `liucl_auth_liucluser_user_permissions` ADD CONSTRAINT `liucluser_id_refs_id_23e7ea50` FOREIGN KEY (`liucluser_id`) REFERENCES `liucl_auth_liucluser` (`id`);
CREATE INDEX `liucl_auth_liucluser_groups_ac5ca68c` ON `liucl_auth_liucluser_groups` (`liucluser_id`);
CREATE INDEX `liucl_auth_liucluser_groups_5f412f9a` ON `liucl_auth_liucluser_groups` (`group_id`);
CREATE INDEX `liucl_auth_liucluser_user_permissions_ac5ca68c` ON `liucl_auth_liucluser_user_permissions` (`liucluser_id`);
CREATE INDEX `liucl_auth_liucluser_user_permissions_83d7f98b` ON `liucl_auth_liucluser_user_permissions` (`permission_id`);

COMMIT;
#auth sql end
#comment sql start
BEGIN;
CREATE TABLE `liucl_comments_comment` (
  `id`          INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `user_id`     INTEGER                NOT NULL,
  `article_id`  INTEGER                NOT NULL,
  `text`        LONGTEXT               NOT NULL,
  `create_time` DATETIME(6)            NOT NULL,
  `parent_id`   INTEGER,
  `isAnonymous` BOOL                   NOT NULL,
  `from_ip`     VARCHAR(20)            NOT NULL
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
ALTER TABLE `liucl_comments_comment` ADD CONSTRAINT `user_id_refs_id_bf1d52e0` FOREIGN KEY (`user_id`) REFERENCES `liucl_auth_liucluser` (`id`);
ALTER TABLE `liucl_comments_comment` ADD CONSTRAINT `article_id_refs_id_8c678832` FOREIGN KEY (`article_id`) REFERENCES `blog_article` (`id`);
ALTER TABLE `liucl_comments_comment` ADD CONSTRAINT `parent_id_refs_id_8997b32b` FOREIGN KEY (`parent_id`) REFERENCES `liucl_comments_comment` (`id`);
CREATE INDEX `liucl_comments_comment_6340c63c` ON `liucl_comments_comment` (`user_id`);
CREATE INDEX `liucl_comments_comment_e669cc35` ON `liucl_comments_comment` (`article_id`);
CREATE INDEX `liucl_comments_comment_410d0aac` ON `liucl_comments_comment` (`parent_id`);

COMMIT;
#commont sql end
#system sql start
BEGIN;
CREATE TABLE `liucl_system_notification` (
  `id`           INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `title`        VARCHAR(100)           NOT NULL,
  `text`         LONGTEXT               NOT NULL,
  `url`          VARCHAR(200),
  `from_user_id` INTEGER,
  `to_user_id`   INTEGER                NOT NULL,
  `type`         VARCHAR(20),
  `is_read`      INTEGER                NOT NULL,
  `create_time`  DATETIME(6)            NOT NULL,
  `update_time`  DATETIME(6)            NOT NULL
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
ALTER TABLE `liucl_system_notification` ADD CONSTRAINT `from_user_id_refs_id_540892ff` FOREIGN KEY (`from_user_id`) REFERENCES `liucl_auth_liucluser` (`id`);
ALTER TABLE `liucl_system_notification` ADD CONSTRAINT `to_user_id_refs_id_540892ff` FOREIGN KEY (`to_user_id`) REFERENCES `liucl_auth_liucluser` (`id`);
CREATE TABLE `liucl_system_link` (
  `id`          INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `title`       VARCHAR(100)           NOT NULL,
  `url`         VARCHAR(200),
  `type`        VARCHAR(20),
  `create_time` DATETIME(6)            NOT NULL,
  `update_time` DATETIME(6)            NOT NULL
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
CREATE INDEX `liucl_system_notification_0e7efed3` ON `liucl_system_notification` (`from_user_id`);
CREATE INDEX `liucl_system_notification_bc172800` ON `liucl_system_notification` (`to_user_id`);

COMMIT;
#end