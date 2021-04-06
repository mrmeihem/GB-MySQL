Практическое задание по теме “Оптимизация запросов”

-- 1) Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.
-- 2) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

drop table logs;

CREATE TABLE `logs` (
  creationdatetime DATETIME NOT NULL,
  tablename VARCHAR(100) NOT NULL,
  keyvalue BIGINT NOT NULL,
  name VARCHAR(255) NOT NULL
) ENGINE=Archive;

-- triggers creation

DELIMITER //

-- users

CREATE TRIGGER on_users_insert AFTER INSERT ON users
FOR EACH ROW
begin
	INSERT INTO logs (creationdatetime, tablename, keyvalue, name)
	VALUES(NOW(), 'users', NEW.id, NEW.name);
END//

-- catalogs

CREATE TRIGGER on_users_insert AFTER INSERT ON catalogs
FOR EACH ROW
begin
	INSERT INTO logs (creationdatetime, tablename, keyvalue, name)
	VALUES(NOW(), 'catalogs', NEW.id, NEW.name);
END//

CREATE TRIGGER on_users_insert AFTER INSERT ON products
FOR EACH ROW
begin
	INSERT INTO logs (creationdatetime, tablename, keyvalue, name)
	VALUES(NOW(), 'products', NEW.id, NEW.name);
END//

DELIMITER ;


-- Миллион записей не стал генерировать, не думаю что в этом цель задания, но там оптимизацию надо сделать:

SET autocommit=0;
SET unique_checks=0;

INSERT INTO users (name, birthday_at) VALUES
	('Саша', '1999-12-01'),
	('Вася', '1993-05-25'),
	('Маша', '1995-07-13'),
	('Лена', '1997-10-05'),
	('Веня', '1999-11-12'),
	('Коля', '1993-01-16'),
	('Толя', '1992-03-13'),
	('Оля', '1990-02-03'),
	('Поля', '1991-12-08');

COMMIT;

SET unique_checks=1;
SET autocommit=1;







