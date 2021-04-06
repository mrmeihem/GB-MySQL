DROP VIEW IF EXISTS stories_by_chapter_depth;

CREATE VIEW stories_by_chapter_depth AS
SELECT s2.id, s2.storyname, COUNT(c2.id) AS 'chapters_depth'
FROM stories s2 
JOIN (storylinks s, chapters c2)
ON (s2.id = s.stories_id AND s.parent_chapters_id = c2.id)
GROUP BY s2.id
ORDER BY chapters_depth DESC;


DROP VIEW IF EXISTS stories_most_added_to_favourites;

CREATE VIEW stories_most_added_to_favourites AS
SELECT s2.id, s2.storyname, count(b2.users_id) AS 'most_added_to_favourites'
FROM stories s2 
RIGHT JOIN bookmarks b2
ON b2.stories_id = s2.id
WHERE b2.favourite = '1'
GROUP BY b2.users_id
ORDER BY most_added_to_favourites DESC;

DROP VIEW IF EXISTS stories_most_bookmarked;

CREATE VIEW stories_most_bookmarked AS
SELECT s2.id, s2.storyname, count(b2.users_id) AS 'most_bookmarked'
FROM stories s2 
RIGHT JOIN bookmarks b2
ON b2.stories_id = s2.id
GROUP BY b2.users_id
ORDER BY most_bookmarked DESC;

