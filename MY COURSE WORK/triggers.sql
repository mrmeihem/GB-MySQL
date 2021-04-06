DROP TABLE IF EXISTS chapters_backup;
CREATE TABLE chapters_backup (
 bckup_id SERIAL PRIMARY KEY,
 bckup_name VARCHAR(100) NOT NULL,
 bckup_content LONGTEXT NULL,
 bckup_question TEXT null,
 delete_date DATETIME DEFAULT NOW());
 
DELIMITER //

CREATE TRIGGER chapters_delete_back_up BEFORE DELETE ON chapters
FOR EACH ROW
BEGIN
	INSERT INTO chapters_backup 
	SET bckup_id = OLD.id,
		bckup_name = OLD.name,
		bckup_content = OLD.content,
		bckup_question = OLD.question;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER on_chapter_like AFTER INSERT ON likes
FOR EACH ROW
BEGIN
	INSERT INTO likes (stories_id) 
	SELECT stories_id FROM storylinks
	WHERE child_chapters_id = NEW.chapters_id;
END//

DELIMITER ;
