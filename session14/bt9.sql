USE social_network;

CREATE TABLE IF NOT EXISTS delete_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    deleted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_by INT
);

DELIMITER $$

CREATE PROCEDURE sp_delete_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE v_count INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_count
    FROM posts
    WHERE post_id = p_post_id
      AND user_id = p_user_id;

    IF v_count = 0 THEN
        ROLLBACK;
    ELSE
        DELETE FROM likes
        WHERE post_id = p_post_id;

        DELETE FROM comments
        WHERE post_id = p_post_id;

        DELETE FROM posts
        WHERE post_id = p_post_id;

        UPDATE users
        SET posts_count = posts_count - 1
        WHERE user_id = p_user_id;

        INSERT INTO delete_log (post_id, deleted_by)
        VALUES (p_post_id, p_user_id);

        COMMIT;
    END IF;
END $$

DELIMITER ;

CALL sp_delete_post(1, 1);
CALL sp_delete_post(2, 1);

SELECT * FROM posts;
SELECT * FROM likes;
SELECT * FROM comments;
SELECT * FROM users;
SELECT * FROM delete_log;
