-- Функция выдает главу с которой начинается история при вводе любой ее главы

DROP FUNCTION IF EXISTS find_starting_chapter;

DELIMITER $$

CREATE FUNCTION find_starting_chapter(chapter_id BIGINT)
RETURNS BIGINT READS SQL DATA
	BEGIN
		DECLARE starting_chapter BIGINT;
	
		SET starting_chapter = (
		SELECT parent_chapters_id FROM storylinks s 
		WHERE (parent_chapters_id = chapter_id OR child_chapters_id = chapter_id)
		ORDER BY parent_chapters_id
		LIMIT 1);
		RETURN starting_chapter;
	END$$
	
DELIMITER ;

-- Самые популярные истории в категории

DELIMITER $$

DROP PROCEDURE IF EXISTS `popular_stories`$$
CREATE PROCEDURE `popular_stories`(IN current_category_id BIGINT)
BEGIN
	-- exsists in favorites and likes
	SELECT b.stories_id FROM bookmarks b
	JOIN likes l
	ON b.stories_id = l.stories_id
	JOIN stories s
	ON b.stories_id = s.id
	WHERE (b.favourite = 1 AND s.categories_id = current_category_id)
	ORDER BY RAND()
	LIMIT 3;	
END$$

DELIMITER ;



