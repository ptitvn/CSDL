CREATE DATABASE IF NOT EXISTS SocialNetworkDB;
USE SocialNetworkDB;


CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);


CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);


CREATE TABLE Friends (
    user_id INT,
    friend_id INT,
    status VARCHAR(20) CHECK (status IN ('pending', 'accepted')),
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES Users(user_id) ON DELETE CASCADE
);


CREATE TABLE Likes (
    user_id INT,
    post_id INT,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE
);


-- Bài 1: Quản lý người dùng (Thêm dữ liệu & Hiển thị)
INSERT INTO Users (username, password, email) VALUES ('an_nguyen', 'pass123', 'an@example.com');
SELECT * FROM Users;

-- Bài 2: Hiển thị thông tin công khai bằng VIEW
CREATE VIEW vw_public_users AS
SELECT user_id, username, created_at
FROM Users;

-- Bài 3: Tối ưu tìm kiếm người dùng bằng INDEX
CREATE INDEX idx_username ON Users(username);


-- Bài 4: Quản lý bài viết bằng Stored Procedure
DELIMITER //
CREATE PROCEDURE sp_create_post(IN p_user_id INT, IN p_content TEXT)
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE user_id = p_user_id) THEN
        INSERT INTO Posts (user_id, content) VALUES (p_user_id, p_content);
    ELSE
        SELECT 'Lỗi: User không tồn tại' AS message;
    END IF;
END //
DELIMITER ;

-- Bài 5: Hiển thị News Feed bằng VIEW (7 ngày gần nhất)
CREATE VIEW vw_recent_posts AS
SELECT * FROM Posts 
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY);

-- Bài 6: Tối ưu truy vấn bài viết (Index cho user_id và Composite Index)
CREATE INDEX idx_post_user_id ON Posts(user_id);
CREATE INDEX idx_user_posts_created ON Posts(user_id, created_at DESC);

-- Bài 7: Thống kê hoạt động bằng Stored Procedure (Dùng OUT)
DELIMITER //
CREATE PROCEDURE sp_count_posts(IN p_user_id INT, OUT p_total INT)
BEGIN
    SELECT COUNT(*) INTO p_total FROM Posts WHERE user_id = p_user_id;
END //
DELIMITER ;



-- Bài 8: Kiểm soát dữ liệu bằng View WITH CHECK OPTION
CREATE VIEW vw_active_users AS
SELECT * FROM Users WHERE status = 'active'
WITH CHECK OPTION;

-- Bài 9: Quản lý kết bạn bằng Stored Procedure
DELIMITER //
CREATE PROCEDURE sp_add_friend(IN p_user_id INT, IN p_friend_id INT)
BEGIN
    IF p_user_id = p_friend_id THEN
        SELECT 'Lỗi: Không thể tự kết bạn' AS message;
    ELSE
        INSERT INTO Friends (user_id, friend_id, status) VALUES (p_user_id, p_friend_id, 'pending');
    END IF;
END //
DELIMITER ;

-- Bài 10: Gợi ý bạn bè bằng Procedure (WHILE + Logic)
DELIMITER //
CREATE PROCEDURE sp_suggest_friends(IN p_user_id INT, INOUT p_limit INT)
BEGIN
    SELECT user_id, username FROM Users 
    WHERE user_id <> p_user_id 
    AND user_id NOT IN (SELECT friend_id FROM Friends WHERE user_id = p_user_id)
    LIMIT p_limit;
END //
DELIMITER ;

-- Bài 11: Thống kê tương tác nâng cao
CREATE INDEX idx_likes_post_id ON Likes(post_id);
CREATE VIEW vw_top_posts AS
SELECT post_id, COUNT(*) AS total_likes
FROM Likes
GROUP BY post_id
ORDER BY total_likes DESC
LIMIT 5;



-- Bài 12: Quản lý bình luận
DELIMITER //
CREATE PROCEDURE sp_add_comment(IN p_user_id INT, IN p_post_id INT, IN p_content TEXT)
BEGIN
    DECLARE u_exists INT;
    DECLARE p_exists INT;
    SELECT COUNT(*) INTO u_exists FROM Users WHERE user_id = p_user_id;
    SELECT COUNT(*) INTO p_exists FROM Posts WHERE post_id = p_post_id;
    IF u_exists > 0 AND p_exists > 0 THEN
        INSERT INTO Comments (post_id, user_id, content) VALUES (p_post_id, p_user_id, p_content);
    ELSE
        SELECT 'Lỗi: Dữ liệu không tồn tại' AS message;
    END IF;
END //
DELIMITER ;

CREATE VIEW vw_post_comments AS
SELECT c.content, u.username, c.created_at FROM Comments c
JOIN Users u ON c.user_id = u.user_id;

-- Bài 13: Quản lý lượt thích
DELIMITER //
CREATE PROCEDURE sp_like_post(IN p_user_id INT, IN p_post_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Likes WHERE user_id = p_user_id AND post_id = p_post_id) THEN
        INSERT INTO Likes (user_id, post_id) VALUES (p_user_id, p_post_id);
    END IF;
END //
DELIMITER ;

CREATE VIEW vw_post_likes AS
SELECT post_id, COUNT(*) AS like_count FROM Likes GROUP BY post_id;

-- Bài 14: Tìm kiếm người dùng & bài viết
DELIMITER //
CREATE PROCEDURE sp_search_social(IN p_option INT, IN p_keyword VARCHAR(100))
BEGIN
    IF p_option = 1 THEN
        SELECT * FROM Users WHERE username LIKE CONCAT('%', p_keyword, '%');
    ELSEIF p_option = 2 THEN
        SELECT * FROM Posts WHERE content LIKE CONCAT('%', p_keyword, '%');
    ELSE
        SELECT 'Lỗi: Tùy chọn 1 (User) hoặc 2 (Post)' AS message;
    END IF;
END //
DELIMITER ;
