-- 1

SELECT s.id AS 'id', s.storyname AS 'name of the story', u.username AS 'autor', c.name AS 'category' FROM stories s
JOIN (users u, categories c)
ON (s.users_id = u.id AND s.categories_id = c.id);

-- 2

SELECT name FROM tags
WHERE id IN (
	SELECT tags_id FROM storytags
	WHERE stories_id = (
		SELECT id FROM users
		WHERE username = 'yskiles'
	)
);

-- 3

select s.id, s.storyname, s.access, s2.parent_chapters_id as 'chapters_id' from stories s
join storylinks s2
on s.id = s2.stories_id

union

select s.id, s.storyname, s.access, s2.child_chapters_id as 'chapters_id' from stories s
join storylinks s2
on s.id = s2.stories_id;

-- 4

select u.username, count(sa.stories_id) as 'stories user have access to edit' from users u
right join story_accesses sa
on sa.users_id = u.id 
where u.deleted != b'0'
group by u.username
order by 'stories user have access to edit';

-- 5

select s.storyname, count(l.stories_id) as 'likes count' from stories s 
join likes l
on s.id = l.stories_id
group by l.stories_id
limit 5;

