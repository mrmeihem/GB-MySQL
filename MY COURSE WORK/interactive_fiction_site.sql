/*Задача:

Создать базу данных для сайта с интерактивными историями. Каждый пользователь может создать свою историю и пригласить других людей для написания новых глав. Главы связанны друг с другом по принципу вопрос-ответ: в конце каждой главы задается вопрос, на который читатель может ответить одним из предложенных способов, каждый из которых ведет в другой главе. Таким образом достигается интерактивность историй.*/
DROP DATABASE IF EXISTS interactive_fiction_site;
CREATE DATABASE interactive_fiction_site;
USE interactive_fiction_site;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(100) NOT NULL,
  `password` VARCHAR(64) NOT NULL  COMMENT 'Под хэш 128',
  gender CHAR(1) NOT null  COMMENT 'Пол',
  email VARCHAR(100) NOT NULL  COMMENT 'Уникальный email',
  birthday DATE NOT NULL,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  aboutme VARCHAR(255) NULL,
  location VARCHAR(100) NULL,
  deleted TINYINT NOT NULL DEFAULT 0,
  UNIQUE unique_email (email))  COMMENT 'Пользователи сайта';

DROP TABLE IF EXISTS tags;
CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  UNIQUE unique_tag_name (name)) COMMENT 'Тэги';

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  UNIQUE unique_cat_name (name)) COMMENT 'Категории';

DROP TABLE IF EXISTS stories;
CREATE TABLE stories (
  id SERIAL PRIMARY KEY,
  users_id BIGINT UNSIGNED NOT NULL,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  storyname TEXT NOT NULL,
  storyintro MEDIUMTEXT  COMMENT 'Первая страница истории',
  question TEXT,
  categories_id BIGINT UNSIGNED NOT NULL,
  `access` TINYINT NOT NULL DEFAULT 0 COMMENT 'Ограничение доступа к редактированию/дописанию истории',
  CONSTRAINT fk_stories_users
  	FOREIGN KEY (users_id)
    REFERENCES users (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_stories_categories
  	FOREIGN KEY (categories_id)
    REFERENCES categories (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION) COMMENT 'Начальные страницы историй';

DROP TABLE IF EXISTS storytags;
CREATE TABLE storytags (	
  stories_id BIGINT UNSIGNED NOT NULL,
  tags_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (stories_id, tags_id),
  CONSTRAINT fk_storytags_stories
    FOREIGN KEY (stories_id)
    REFERENCES stories (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_storytags_tags
    FOREIGN KEY (tags_id)
    REFERENCES tags (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE) COMMENT 'Принадлежность тэгов историям';

DROP TABLE IF EXISTS bookmarks;
CREATE TABLE bookmarks (
  users_id BIGINT UNSIGNED NOT NULL,
  stories_id BIGINT UNSIGNED NOT NULL,
  favourite TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (users_id, stories_id),
  CONSTRAINT fk_bookmarks_users
    FOREIGN KEY (users_id)
    REFERENCES users (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_bookmarks_stories
    FOREIGN KEY (stories_id)
    REFERENCES stories (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE) COMMENT 'Закладки и любимые';

DROP TABLE IF EXISTS chapters;
CREATE TABLE chapters (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  content LONGTEXT NULL,
  question TEXT NULL) COMMENT 'Главы историй';

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  users_id SERIAL PRIMARY KEY,
  stories_id BIGINT UNSIGNED NULL,
  chapters_id BIGINT UNSIGNED NULL,
  CONSTRAINT fk_likes_stories
    FOREIGN KEY (stories_id)
    REFERENCES stories (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_likes_chapters
    FOREIGN KEY (chapters_id)
    REFERENCES chapters (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE) COMMENT 'Лайки';

DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  users_id BIGINT UNSIGNED,
  stories_id BIGINT UNSIGNED,
  chapters_id BIGINT UNSIGNED,
  `comment` TEXT NOT NULL,
  CONSTRAINT fk_comments_users
    FOREIGN KEY (users_id)
    REFERENCES users (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_comments_stories
    FOREIGN KEY (stories_id)
    REFERENCES stories (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_comments_chapters
    FOREIGN KEY (chapters_id)
    REFERENCES chapters (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE) COMMENT 'Комментарии';

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
  id SERIAL PRIMARY KEY,
  users_from BIGINT UNSIGNED,
  users_to BIGINT UNSIGNED,
  message MEDIUMTEXT NOT NULL,
  `time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status SMALLINT NOT NULL COMMENT 'sent, failed, delivered, accepted',
  CONSTRAINT fk_messages_users_from
    FOREIGN KEY (users_from)
    REFERENCES users (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_messages_users_to
    FOREIGN KEY (users_to)
    REFERENCES users (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE) COMMENT 'Личные сообщения';

DROP TABLE IF EXISTS storylinks;
CREATE TABLE storylinks (
  stories_id BIGINT UNSIGNED,
  parent_chapters_id BIGINT UNSIGNED,
  answer TEXT NOT NULL,
  child_chapters_id BIGINT UNSIGNED,
  PRIMARY KEY (parent_chapters_id, child_chapters_id),
  CONSTRAINT fk_storylinks_stories
    FOREIGN KEY (stories_id)
    REFERENCES stories (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_storylinks_parent_chapters
    FOREIGN KEY (parent_chapters_id)
    REFERENCES chapters (id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT fk_storylinks_child_chapters
    FOREIGN KEY (child_chapters_id)
    REFERENCES chapters (id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE) COMMENT 'Связь глав историй';

DROP TABLE IF EXISTS story_accesses;
CREATE TABLE story_accesses (
  stories_id BIGINT UNSIGNED NOT NULL,
  users_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (stories_id, users_id),
  CONSTRAINT fk_story_accesses_stories
    FOREIGN KEY (stories_id)
    REFERENCES stories (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_story_accesses_users
    FOREIGN KEY (users_id)
    REFERENCES users (id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE) COMMENT 'Доступ к редактированию/дописанию истории';
