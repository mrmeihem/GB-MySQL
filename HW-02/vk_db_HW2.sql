DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(100),
    lastname VARCHAR(100) COMMENT 'Фамилия', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(100) UNIQUE,
    password_hash varchar(100),
    phone BIGINT,
    is_deleted bit default 0,
    -- INDEX users_phone_idx(phone), -- помним: как выбирать индексы
    INDEX users_firstname_lastname_idx(firstname, lastname)
);

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id SERIAL PRIMARY KEY,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

-- NO ACTION
-- CASCADE 
-- RESTRICT
-- SET NULL
-- SET DEFAULT


ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE ON DELETE CASCADE;

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	-- id SERIAL PRIMARY KEY, -- изменили на составной ключ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    -- `status` TINYINT UNSIGNED,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'),
    -- `status` TINYINT UNSIGNED, -- в этом случае в коде хранили бы цифирный enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME on update now(),
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (target_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED,

	INDEX communities_name_idx(name),
	FOREIGN KEY (admin_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (community_id) REFERENCES communities(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

    -- записей мало, поэтому индекс будет лишним (замедлит работу)!
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    `size` INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_type_id) REFERENCES media_types(id) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),

    -- PRIMARY KEY (user_id, media_id) – можно было и так вместо id в качестве PK
  	-- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)  

/* намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме*/
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE

);

DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
  	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
	id SERIAL PRIMARY KEY,
	album_id BIGINT unsigned NOT NULL,
	media_id BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES photo_albums(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE `profiles` ADD CONSTRAINT fk_photo_id
    FOREIGN KEY (photo_id) REFERENCES photos(id)
    ON UPDATE CASCADE ON DELETE set NULL;
   
-- Home Work 2.01

-- Таблица комментариев к фото/видео.
DROP TABLE IF exists media_comments;
CREATE TABLE media_comments (
	id SERIAL PRIMARY KEY, -- каждый комментарий имеет свой айди
	media_id BIGINT unsigned NOT NULL, -- айди фото/видео, которому пренадлежит коммент
	user_id BIGINT unsigned NOT NULL, -- айди юзера
	`message` text, -- сообщение
	created_at DATETIME DEFAULT NOW(), -- время создания
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- время изменения комментария
	
	FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE, -- удаление медия удаляет комментарий, то же с апдейтом
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION -- удаление юзера не затрагивает коммент, апдейт - меняет.
);

-- Таблица блоги (стены)
DROP TABLE IF exists blogs;
CREATE TABLE blogs (
	id SERIAL PRIMARY KEY, -- айди стены
	user_id BIGINT unsigned NOT NULL, -- владелец
	blog_name text, -- имя блога
	blog_permission bool not null default 0, -- могут ли другие пользователи оставлять записи в блоге
	created_at DATETIME DEFAULT NOW(), -- время создания
	
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE -- удаление юзера удаляет и стену.
);

-- Таблица записи в блоге
DROP TABLE IF exists posts;
CREATE TABLE posts (
	id SERIAL PRIMARY KEY, -- айди поста
	user_id BIGINT unsigned NOT NULL, -- пост в блог можно написать чужому пользователю
	blog_id BIGINT unsigned NOT NULL, -- в какой блог пост
	media_id BIGINT unsigned default null, -- айди фото/видео в посте, по умолчанию null
	post_header text, -- заголовок записи в блоге
	post_text text, -- текст поста
	created_at DATETIME DEFAULT NOW(), -- время создания
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- время изменения комментария
	
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE, 
	FOREIGN KEY (blog_id) REFERENCES blogs(id) ON UPDATE CASCADE ON DELETE CASCADE, 
	FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Таблица комментарии к блогу
DROP TABLE IF exists blog_comments;
CREATE TABLE blog_comments (
	id SERIAL PRIMARY KEY, -- каждый комментарий имеет свой айди
	blog_id BIGINT unsigned NOT NULL, -- айди блога, которому пренадлежит коммент
	user_id BIGINT unsigned NOT NULL, -- айди юзера
	`message` text, -- сообщение
	created_at DATETIME DEFAULT NOW(), -- время создания
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- время изменения комментария
	
	FOREIGN KEY (blog_id) REFERENCES blogs(id) ON UPDATE CASCADE ON DELETE CASCADE, -- удаление записи удаляет комментарий, то же с апдейтом
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION -- удаление юзера не затрагивает коммент, апдейт - меняет.
);

-- Таблица shared posts
DROP TABLE IF exists shared_posts;
CREATE TABLE shared_posts (
	post_id BIGINT unsigned NOT NULL, -- айди расшаренного поста
	user_id BIGINT unsigned NOT NULL, -- айди юзера
	
	FOREIGN KEY (post_id) REFERENCES posts(id) ON UPDATE CASCADE ON DELETE CASCADE, -- удаление записи удаляет комментарий, то же с апдейтом
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION -- удаление юзера не затрагивает коммент, апдейт - меняет.
);



/*
-- Таблица фото/видео-альбомов вместо фотоальбомов. Просто другая версия.
DROP TABLE IF EXISTS media_albums;
CREATE TABLE `media_albums` (
	id SERIAL PRIMARY KEY, -- ключ
	name VARCHAR(150), -- название альбома
	creator_user_id BIGINT UNSIGNED, -- создатель альбома
	hidden bool not null default 0, -- альбом может быть скрытым. По умолчанию он открыт

	created_at DATETIME DEFAULT NOW(), -- время создания альбома
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- последнее изменение	
	
	FOREIGN KEY (creator_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL -- удаление юзера не удаляет альбом, изменение каскад
);*/


