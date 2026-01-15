USE social_network;

ALTER TABLE posts
ADD COLUMN comments_count INT DEFAULT 0;

CREATE TABLE IF NOT EXISTS comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

DELIMITER $$

CREATE PROCEDURE sp_post_comment(
    IN p_post_id INT,
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO comments(post_id, user_id, content)
    VALUES (p_post_id, p_user_id, p_content);

    SAVEPOINT after_insert;

    UPDATE posts
    SET comments_count = comments_count + 1
    WHERE post_id = p_post_id;

    COMMIT;
END $$

DELIMITER ;

CALL sp_post_comment(1, 1, 'Bình luận thành công');

DELIMITER $$

CREATE PROCEDURE sp_post_comment_fail(
    IN p_post_id INT,
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK TO after_insert;
        COMMIT;
    END;

    START TRANSACTION;

    INSERT INTO comments(post_id, user_id, content)
    VALUES (p_post_id, p_user_id, p_content);

    SAVEPOINT after_insert;

    UPDATE posts
    SET comments_count = comments_count + 1
    WHERE post_id = -1;

    COMMIT;
END $$

DELIMITER ;

CALL sp_post_comment_fail(1, 1, 'Bình luận nhưng lỗi cập nhật count');

SELECT * FROM comments;
SELECT post_id, comments_count FROM posts;
