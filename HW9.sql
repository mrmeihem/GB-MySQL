/*Практическое задание по теме “Транзакции, переменные, представления”
В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.*/

START TRANSACTION;

INSERT INTO sample.users (name, birthday_at, created_at, updated_at)
SELECT name, birthday_at, created_at, updated_at
FROM shop.users
WHERE  id = 1;

COMMIT;

/*Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.*/

use shop;
drop view if exists v;

CREATE VIEW v AS SELECT p.name as product_name, c.name as category_name FROM products p, catalogs c
WHERE p.catalog_id = c.id;


/*(по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.
(по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.*/

/*Практическое задание по теме “Администрирование MySQL” (эта тема изучается по вашему желанию)
Создайте двух пользователей которые имеют доступ к базе данных shop. Первому пользователю shop_read должны быть доступны только запросы на чтение данных, второму пользователю shop — любые операции в пределах базы данных shop.*/


CREATE USER shop_read IDENTIFIED WITH sha256_password BY 'pass';
GRANT USAGE, SELECT ON shop.* TO 'shop_read'@'localhost';
CREATE USER shop IDENTIFIED WITH sha256_password BY 'pass';
GRANT ALL ON shop.* TO 'shop_read'@'localhost';

/*(по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ, имя пользователя и его пароль. Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.*/

/*Практическое задание по теме “Хранимые процедуры и функции, триггеры"
Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/


DROP FUNCTION IF EXISTS shop.hello;

DELIMITER $$

CREATE FUNCTION shop.hello()
RETURNS TEXT
begin
	IF HOUR(NOW()) < 6 THEN
		RETURN 'Good night' ;
	ELSE IF (HOUR(NOW()) > 6) AND (HOUR(NOW()) < 12) THEN
		RETURN 'Good morning';
	ELSE IF (HOUR(NOW()) > 12) AND (HOUR(NOW()) < 18) THEN
		RETURN 'Good afternoon';
	ELSE
		RETURN 'Good night';
	END IF
END$$

DELIMITER ;


/*В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.*/

DELIMITER $$

CREATE TRIGGER check_products BEFORE INSERT ON products
FOR EACH ROW 
BEGIN
	IF (name IS NULL) AND (description IS NULL)
	    SIGNAL SQLSTATE '45000'
      	SET MESSAGE_TEXT = 'Insert canceled';
	END if;
END$$

DELIMITER ;

/*(по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.*/



