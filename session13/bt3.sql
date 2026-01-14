use session13;
DROP TRIGGER IF EXISTS before_like_insert;
DROP TRIGGER IF EXISTS after_like_insert;
DROP TRIGGER IF EXISTS after_like_delete;
DROP TRIGGER IF EXISTS after_like_update;


DELIMITER //
CREATE TRIGGER before_like_insert
BEFORE INSERT ON likes
FOR EACH ROW
BEGIN
    DECLARE author_id INT;
    
    SELECT user_id INTO author_id FROM posts WHERE post_id = NEW.post_id;
    

    IF NEW.user_id = author_id THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: You cannot like your own post!';
    END IF;
END //


CREATE TRIGGER after_like_update
AFTER UPDATE ON likes
FOR EACH ROW
BEGIN
    IF OLD.post_id <> NEW.post_id THEN
  
        UPDATE posts SET like_count = like_count - 1 WHERE post_id = OLD.post_id;
  
        UPDATE posts SET like_count = like_count + 1 WHERE post_id = NEW.post_id;
    END IF;
END //
DELIMITER ;


INSERT INTO likes (user_id, post_id) VALUES (1, 1);


INSERT INTO likes (user_id, post_id) VALUES (2, 1);
SELECT post_id, like_count FROM posts WHERE post_id = 1;


SET @last_like_id = (SELECT MAX(like_id) FROM likes);
UPDATE likes SET post_id = 3 WHERE like_id = @last_like_id;


SELECT post_id, content, like_count FROM posts WHERE post_id IN (1, 3);


DELETE FROM likes WHERE like_id = @last_like_id;


SELECT * FROM posts;
SELECT * FROM user_statistics;