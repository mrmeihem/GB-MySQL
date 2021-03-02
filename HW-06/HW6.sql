use vk;

-- Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

-- Для пользователя 1:
SELECT userid, COUNT(userid) as messages_ammout
FROM (SELECT from_user_id as userid
	  FROM messages
	  WHERE to_user_id = 1
	  UNION ALL
	  SELECT to_user_id AS userid
	  FROM messages
	  WHERE from_user_id = 1) AS users
GROUP BY userid
ORDER BY count(userid) DESC
LIMIT 1;


-- Подсчитать общее количество лайков, которые получили пользователи младше 10 лет

SELECT COUNT(*) as likes_cnt FROM likes
WHERE media_id IN (
SELECT id FROM media
WHERE user_id IN 
	(SELECT user_id 
	 FROM profiles
	 WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) <= 10));
	
-- Определить кто больше поставил лайков (всего): мужчины или женщины
select gndr as 'winner' from	
(	
select 'male' as gndr, count(*) as cnt from likes
where user_id in 
	(select user_id from profiles
	 where gender = 'm')
union
select 'female' as gndr, count(*) as cnt from likes
where user_id in 
	(select user_id from profiles
	 where gender = 'f')
) gender_conflict
order by cnt desc
limit 1;