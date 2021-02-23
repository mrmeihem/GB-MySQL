-- 01
/* Для Windows пришлось помучаться с файлом конфигурации:
Win+R для вызова CMD, services.msc. В списке нашел MySQL и двойным кликом открыл окно свойств. 
В Path to executable нешел место, где расположен и как называется файл конфигурации: 
C:\ProgramData\MySQL\MySQL Server 8.0\my.ini.
*/

-- 02

DROP DATABASE IF EXISTS test;
CREATE DATABASE test;
USE test;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) DEFAULT 'anonymus'
);

-- 03

-- mysqldump -u meihem -p test > testdump.sql (я не через root работаю, а под пользователем meihem)

-- mysql -u meihem -p test_2 < testdump.sql

-- 04

-- mysqldump -u meihem -p mysql --where="1=1 limit 100" > mysqldump.sql
