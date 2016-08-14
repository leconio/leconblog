BEGIN;
CREATE TABLE `blog_nav` (
  `id`          INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `name`        VARCHAR(40)            NOT NULL,
  `url`         VARCHAR(200),
  `status`      INTEGER                NOT NULL,
  `create_time` DATETIME(6)            NOT NULL
);
CREATE TABLE `blog_category` (
  `id`          INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `name`        VARCHAR(40)            NOT NULL,
  `parent_id`   INTEGER,
  `rank`        INTEGER                NOT NULL,
  `status`      INTEGER                NOT NULL,
  `create_time` DATETIME(6)            NOT NULL
);
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
);
ALTER TABLE `blog_article` ADD CONSTRAINT `category_id_refs_id_651a4bf4` FOREIGN KEY (`category_id`) REFERENCES `blog_category` (`id`);
CREATE TABLE `blog_column_article` (
  `id`         INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `column_id`  INTEGER                NOT NULL,
  `article_id` INTEGER                NOT NULL,
  UNIQUE (`column_id`, `article_id`)
);
ALTER TABLE `blog_column_article` ADD CONSTRAINT `article_id_refs_id_dc58e971` FOREIGN KEY (`article_id`) REFERENCES `blog_article` (`id`);
CREATE TABLE `blog_column` (
  `id`          INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `name`        VARCHAR(40)            NOT NULL,
  `summary`     LONGTEXT               NOT NULL,
  `status`      INTEGER                NOT NULL,
  `create_time` DATETIME(6)            NOT NULL
);
ALTER TABLE `blog_column_article` ADD CONSTRAINT `column_id_refs_id_b854df1c` FOREIGN KEY (`column_id`) REFERENCES `blog_column` (`id`);
CREATE TABLE `blog_carousel` (
  `id`          INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `title`       VARCHAR(100)           NOT NULL,
  `summary`     LONGTEXT,
  `img`         VARCHAR(200)           NOT NULL,
  `article_id`  INTEGER                NOT NULL,
  `create_time` DATETIME(6)            NOT NULL
);
ALTER TABLE `blog_carousel` ADD CONSTRAINT `article_id_refs_id_908901e3` FOREIGN KEY (`article_id`) REFERENCES `blog_article` (`id`);
CREATE TABLE `blog_news` (
  `id`          INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  `title`       VARCHAR(100)           NOT NULL,
  `summary`     LONGTEXT               NOT NULL,
  `news_from`   INTEGER                NOT NULL,
  `url`         VARCHAR(200)           NOT NULL,
  `create_time` DATETIME(6)            NOT NULL,
  `pub_time`    DATETIME(6)            NOT NULL
);
-- The following references should be added but depend on non-existent tables:
-- ALTER TABLE `blog_article` ADD CONSTRAINT `author_id_refs_id_d87d831a` FOREIGN KEY (`author_id`) REFERENCES `liucl_auth_liucluser` (`id`);
CREATE INDEX `blog_category_410d0aac` ON `blog_category` (`parent_id`);
CREATE INDEX `blog_article_e969df21` ON `blog_article` (`author_id`);
CREATE INDEX `blog_article_6f33f001` ON `blog_article` (`category_id`);
CREATE INDEX `blog_column_article_3baa5244` ON `blog_column_article` (`column_id`);
CREATE INDEX `blog_column_article_e669cc35` ON `blog_column_article` (`article_id`);
CREATE INDEX `blog_carousel_e669cc35` ON `blog_carousel` (`article_id`);

COMMIT;