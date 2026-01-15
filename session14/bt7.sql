CREATE DATABASE IF NOT EXISTS social_network;
USE social_network;

ALTER TABLE users
ADD COLUMN following_count INT DEFAULT 0,
ADD COLUMN followers_count INT DEFAULT 0;

CREATE TABLE IF NOT EXISTS followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    PRIMARY KEY (follower_id, followed_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (followed_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS follow_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    message VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE PROCEDURE sp_follow_user(
    IN p_follower_id INT,
    IN p_followed_id INT
)
BEGIN
    DECLARE v_count INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id IN (p_follower_id, p_followed_id);

    IF v_count < 2 THEN
        INSERT INTO follow_log(message)
        VALUES ('User không tồn tại');
        ROLLBACK;
    ELSEIF p_follower_id = p_followed_id THEN
        INSERT INTO follow_log(message)
        VALUES ('Không thể tự follow chính mình');
        ROLLBACK;
    ELSE
        SELECT COUNT(*) INTO v_count
        FROM followers
        WHERE follower_id = p_follower_id
          AND followed_id = p_followed_id;

        IF v_count > 0 THEN
            INSERT INTO follow_log(message)
            VALUES ('Đã follow trước đó');
            ROLLBACK;
        ELSE
            INSERT INTO followers (follower_id, followed_id)
            VALUES (p_follower_id, p_followed_id);

            UPDATE users
            SET following_count = following_count + 1
            WHERE user_id = p_follower_id;

            UPDATE users
            SET followers_count = followers_count + 1
            WHERE user_id = p_followed_id;

            COMMIT;
        END IF;
    END IF;
END $$

DELIMITER ;

CALL sp_follow_user(1, 2);
CALL sp_follow_user(1, 1);
CALL sp_follow_user(1, 2);
CALL sp_follow_user(1, 999);

SELECT * FROM users;
SELECT * FROM followers;
SELECT * FROM follow_log;
