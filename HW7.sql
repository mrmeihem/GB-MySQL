use shop;

-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

select DISTINCT u.name, o.id as order_id 
from users u 
inner join orders o 
on u.id = o.user_id;

-- Выведите список товаров products и разделов catalogs, который соответствует товару.

select p.name as product_name, c.name as catalog_name 
from products p 
left join catalogs c
on p.catalog_id = c.id;

-- Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.

select iz.name, v.name from 
(select f.id, c.name from flights f
left join cities c
on f.from = c.label
order by f.id
) as iz
inner join
(select f.id, c.name from cities c
right join flights f
on f.to = c.label
order by f.id
) as v
on iz.id = v.id;