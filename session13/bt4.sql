CREATE TABLE post_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    changed_by_user_id INT,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER before_post_update
BEFORE UPDATE ON posts
FOR EACH ROW
BEGIN
    IF OLD.content <> NEW.content THEN
        INSERT INTO post_history (post_id, old_content, new_content, changed_at, changed_by_user_id)
        VALUES (OLD.post_id, OLD.content, NEW.content, NOW(), OLD.user_id);
    END IF;
END //
DELIMITER ;


UPDATE posts 
SET content = 'This is my updated first post! Hello everyone.' 
WHERE post_id = 1;


UPDATE posts 
SET content = 'Charlie updated his thoughts.' 
WHERE post_id = 3;


SELECT * FROM post_history;


INSERT INTO likes (user_id, post_id) VALUES (3, 1);


SELECT post_id, content, like_count FROM posts WHERE post_id = 1;