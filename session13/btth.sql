DROP DATABASE IF EXISTS SocialNetworkDB;
CREATE DATABASE SocialNetworkDB;
USE SocialNetworkDB;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    total_posts INT DEFAULT 0
);

-- Bảng Posts: Đã bỏ DEFAULT CURRENT_TIMESTAMP để bạn tự nhập
CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at DATETIME, -- Bạn sẽ tự nhập ngày giờ vào đây
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE post_audits (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME 
);

-- 2. TẠO TRIGGER (Giữ nguyên logic các Task)
DELIMITER //
-- task 1
CREATE TRIGGER tg_CheckPostContent
BEFORE INSERT ON posts
FOR EACH ROW
BEGIN
    IF NEW.content IS NULL OR TRIM(NEW.content) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nội dung bài viết không được để trống!';
    END IF;
END //

-- task2
CREATE TRIGGER tg_UpdatePostCountAfterInsert
AFTER INSERT ON posts
FOR EACH ROW
BEGIN
    UPDATE users 
    SET total_posts = total_posts + 1 
    WHERE user_id = NEW.user_id;
END //

-- task 3
CREATE TRIGGER tg_LogPostChanges
AFTER UPDATE ON posts
FOR EACH ROW
BEGIN
    IF OLD.content <> NEW.content THEN
        INSERT INTO post_audits(post_id, old_content, new_content, changed_at)
        VALUES (OLD.post_id, OLD.content, NEW.content, NOW());
    END IF;
END //

-- task 4
CREATE TRIGGER tg_UpdatePostCountAfterDelete
AFTER DELETE ON posts
FOR EACH ROW
BEGIN
    UPDATE users 
    SET total_posts = total_posts - 1 
    WHERE user_id = OLD.user_id;
END //

DELIMITER ;



-- A. Thử nghiệm Insert
INSERT INTO users (username) VALUES ('NguyenVanA');

-- Nhập bài viết và TỰ ĐIỀN thời gian created_at
INSERT INTO posts (user_id, content, created_at) 
VALUES (1, 'Chào buổi sáng!', '2024-01-01 08:00:00');

-- Thêm một bài viết khác với thời gian khác
INSERT INTO posts (user_id, content, created_at) 
VALUES (1, 'Chúc ngủ ngon!', '2024-01-01 22:30:15');

-- Xem kết quả (Bạn sẽ thấy thời gian hiện đúng như bạn đã nhập)
SELECT * FROM posts;
SELECT * FROM users;

-- B. Thử nghiệm Update
UPDATE posts SET content = 'Nội dung đã sửa!' WHERE post_id = 1;
SELECT * FROM post_audits;

-- C. Thử nghiệm Delete
DELETE FROM posts WHERE post_id = 1;
SELECT * FROM users;