-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

drop database if exists HW_3;
create database HW_3;
use HW_3;

drop table if exists users;
create table users (
id serial primary key,
created_at varchar(100),
updated_at varchar(100)
);

INSERT into users (created_at, updated_at) 
VALUES
  (NOW(),NOW()),
  (NOW(),NOW()),  
  (NOW(),NOW()),
  (NOW(),NOW()),
  (NOW(),NOW()),
  (NOW(),NOW()),
  (NOW(),NOW()),
  (NOW(),NOW()),
  (NOW(),NOW()),  
  (NOW(),NOW());
 
/* Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10.
   Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения. */
 
UPDATE users set 
  created_at = concat(FLOOR(RAND()*27+1),'.',FLOOR(RAND()*11+1),'.',FLOOR(RAND()*(2020-1980+1)+1980),' ',FLOOR(RAND()*24),':',FLOOR(RAND()*60))
  limit 10;
 
 UPDATE users set 
  updated_at = concat(FLOOR(RAND()*27+1),'.',FLOOR(RAND()*11+1),'.',FLOOR(RAND()*(2020-1980+1)+1980),' ',FLOOR(RAND()*24),':',FLOOR(RAND()*60))
  limit 10;
 
SELECT STR_TO_DATE(created_at, "%d.%m.%Y %k:%i") FROM users;
SELECT STR_TO_DATE(updated_at, "%d.%m.%Y %k:%i") FROM users;

UPDATE users SET created_at = STR_TO_DATE(created_at, "%d.%m.%Y %k:%i");
UPDATE users SET updated_at = STR_TO_DATE(updated_at, "%d.%m.%Y %k:%i");

ALTER TABLE users MODIFY created_at DATETIME;
ALTER TABLE users MODIFY updated_at DATETIME;

/*В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.*/

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
id SERIAL PRIMARY KEY,
name VARCHAR(255) NOT NULL,
price DECIMAL(10, 2) NOT NULL,
value INT
);

INSERT INTO storehouses_products VALUES (1,'maiores',12.70,'5'),(2,'alias',56.80,'1'),(3,'porro',55.84,'9'),(4,'laborum',96.13,'1'),(5,'optio',90.87,'0'),(6,'sed',31.04,'5'),(7,'eos',18.65,'10'),(8,'voluptas',64.74,'7'),(9,'et',34.98,'4'),(10,'perspiciatis',85.21,'3'),(11,'molestiae',80.93,'3'),(12,'libero',8.92,'9'),(13,'cum',32.39,'2'),(14,'non',4.30,'0'),(15,'animi',95.48,'10'),(16,'est',1.15,'0'),(17,'doloribus',25.77,'7'),(18,'dolores',37.86,'3'),(19,'esse',93.26,'8'),(20,'ipsum',48.16,'8');

SELECT name, price, value FROM storehouses_products
	ORDER BY IF (value > 0, 0, 1), value;

/*(по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)*/

alter table users
	add (name varchar(50),
		 birth_month varchar(40));
		
insert into users (name, birth_month)
VALUES ('Roxane','June'),('Joelle','May'),('Paxton','May'),('Marquise','May'),('Lora','January'),('Baylee','November'),('Fleta','February'),('Clemens','August'),('Myrtice','August'),('Nikki','September'),('Genevieve','February'),('Bailey','September'),('Toni','December'),('Dangelo','December'),('Margret','November'),('Anahi','January'),('Lacy','August'),('Wyman','October'),('Vince','August'),('Kayley','February'),('Lane','June'),('Quinton','March'),('Abner','December'),('Andrew','January'),('Ruben','December'),('Don','March'),('Judy','September'),('Amari','February'),('Jillian','May'),('Tamara','December'),('Raven','June'),('Lee','February'),('Orie','September'),('Emilia','September'),('Mandy','December'),('Doug','December'),('Verla','April'),('Lorenz','February'),('Abbey','November'),('Russel','November'),('Ricky','June'),('Van','April'),('Colby','November'),('Tevin','March'),('Baby','April'),('Noemy','April'),('Vergie','August'),('Raoul','December'),('Shyanne','September'),('Vita','February');

select name, birth_month from users
	where birth_month = 'May' or birth_month = 'August'
	order by birth_month, name;

/*(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.*/

-- Не очень хорошо понимаю задание, но попытаюсь. Воспользуюсь таблицей storehouses_products.

SELECT * FROM storehouses_products
	WHERE id IN (5, 1, 2);

SELECT * from storehouses_products
	ORDER BY FIELD (5,1,2,id) Desc;


/*Подсчитайте средний возраст пользователей в таблице users*/

truncate table users; 

alter table users
	add birth_date Date;

INSERT INTO users (name, birth_date) 
VALUES ('Herminio','1984-06-29'),('Matilda','1995-07-13'),('Tevin','1977-08-28'),('Vilma','1983-11-30'),('Sid','1996-11-17'),('Kris','1970-03-27'),('Hertha','2010-10-24'),('Abbey','1990-06-25'),('Lexie','1995-09-10'),('Winifred','1979-09-10'),('Arianna','2007-06-21'),('Mike','2002-11-06'),('Gabrielle','1980-05-12'),('Samantha','2000-09-21'),('Sunny','1977-08-02'),('Susana','2003-01-10'),('Jalen','2000-02-11'),('Lisa','1986-02-07'),('Darryl','1990-10-05'),('Layne','1984-04-15'),('Kyleigh','1985-03-30'),('Mauricio','1991-06-27'),('Ludie','1989-01-05'),('Alanis','2005-01-22'),('Albina','1973-02-13'),('Joesph','1988-02-22'),('Vada','2010-05-21'),('Jerry','2009-10-01'),('Justice','2010-08-08'),('Itzel','2002-11-04'),('Philip','1992-12-28'),('Ike','1995-05-11'),('Jazlyn','1993-08-19'),('Edgar','1990-08-30'),('Stewart','2001-11-07'),('Zachariah','1985-09-08'),('Abraham','1972-01-21'),('Sonia','2006-12-22'),('Keara','1991-09-20'),('Sincere','2000-10-01'),('Elmira','1985-07-18'),('Lorenz','1987-10-11'),('Hosea','1982-01-28'),('Frieda','1973-07-13'),('Narciso','1988-03-24'),('Corrine','1983-05-03'),('Hallie','1989-07-28'),('Magdalena','1980-07-21'),('Newell','1999-04-07'),('Xander','1973-09-20'),('Austen','1998-03-06'),('Pietro','1977-10-05'),('Bill','2004-12-26'),('Michele','2010-01-04'),('Sid','1984-10-08'),('Franz','1995-03-26'),('Delpha','2004-02-27'),('Cleora','1989-05-08'),('Dayna','1974-10-27'),('Kailyn','1995-12-31'),('Wallace','2006-12-22'),('Noelia','1992-07-25'),('Brando','2009-03-10'),('Alfredo','2002-08-25'),('Rollin','1973-05-28'),('Wilson','1982-01-25'),('Americo','2005-05-03'),('Nathaniel','2001-12-31'),('Bonita','1996-01-03'),('Laurence','2008-05-30'),('Sydney','1986-08-07'),('Chesley','1994-04-16'),('Koby','1988-06-04'),('Daphne','2007-01-23'),('Bennie','2006-07-30'),('Cheyenne','2007-05-19'),('Dallas','1981-08-26'),('Charlotte','2001-03-29'),('Cathrine','1977-01-16'),('Karli','1984-03-02'),('Erna','1994-07-01'),('Ella','1995-10-11'),('Lorena','1980-11-30'),('Bridget','1970-09-18'),('Fredy','1977-12-29'),('Rosina','1998-02-27'),('Jaron','2001-03-29'),('Shannon','2000-01-26'),('Lester','1986-10-28'),('Winifred','1998-12-16'),('Gladys','1977-04-23'),('Jabari','1972-12-13'),('Lyla','1992-05-14'),('Jamar','1976-05-16'),('Candido','2006-11-28'),('Tommie','1996-06-15'),('Gardner','1999-08-20'),('Gennaro','1978-05-14'),('Merritt','1979-11-09'),('Alison','1979-11-18');

alter table users
	add age tinyint;

update users
	set age = (YEAR(CURRENT_DATE)-YEAR(`birth_date`))-(RIGHT(CURRENT_DATE,5)<RIGHT(`birth_date`,5)
  );

SELECT AVG(age) FROM users;

/*Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/

SELECT DAYNAME(birth_date) as Day_of_the_week, DAYOFWEEK(birth_date) as No_of_the_weekday, COUNT(*) as Birth_days_count FROM users 
	group by DAYOFWEEK(birth_date) 
	order by  IF (birth_date is null, 1, 0), DAYOFWEEK(birth_date);


/*(по желанию) Подсчитайте произведение чисел в столбце таблицы.*/

alter table users
	add testing_log tinyint;

insert into users (testing_log)
	values (1),(2),(3),(4),(5);

SELECT  exp(sum(ln(testing_log))) FROM users;