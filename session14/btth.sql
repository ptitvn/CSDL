CREATE DATABASE IF NOT EXISTS social_network_db;
USE social_network_db;

DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    total_posts INT DEFAULT 0
);

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (username, total_posts) VALUES ('nguyen_van_a', 0);
INSERT INTO users (username, total_posts) VALUES ('le_thi_b', 0);

DROP PROCEDURE IF EXISTS sp_create_post;

DELIMITER //

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
  
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    
    BEGIN
 
        ROLLBACK;
        SELECT 'LOI: Giao dich that bai. He thong da tu dong ROLLBACK toan bo.' AS Message;
    END;

    IF p_content IS NULL OR TRIM(p_content) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'LOI: Noi dung bai viet khong duoc de trong.';
    END IF;

    START TRANSACTION;

        INSERT INTO posts (user_id, content) 
        VALUES (p_user_id, p_content);

        UPDATE users 
        SET total_posts = total_posts + 1 
        WHERE user_id = p_user_id;

    COMMIT;
    
    SELECT 'THANH CONG: Bai viet da duoc dang!' AS Message;

END //

DELIMITER ;

CALL sp_create_post(3, ' ');

SELECT * FROM users;
SELECT * FROM posts;
