USE mini_social_network;

CREATE TABLE user_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE post_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    action VARCHAR(100),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE like_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    post_id INT,
    action VARCHAR(50),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE friend_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    friend_id INT,
    action VARCHAR(50),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE PROCEDURE sp_register_user(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists';
    END IF;

    IF EXISTS (SELECT 1 FROM users WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already exists';
    END IF;

    INSERT INTO users(username, password, email)
    VALUES (p_username, p_password, p_email);
END$$

CREATE TRIGGER trg_after_register
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO user_log(user_id, action)
    VALUES (NEW.user_id, 'REGISTER');
END$$

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    IF p_content IS NULL OR LENGTH(TRIM(p_content)) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Content is empty';
    END IF;

    INSERT INTO posts(user_id, content)
    VALUES (p_user_id, p_content);
END$$

CREATE TRIGGER trg_after_post
AFTER INSERT ON posts
FOR EACH ROW
BEGIN
    INSERT INTO post_log(post_id, action)
    VALUES (NEW.post_id, 'CREATE_POST');
END$$

ALTER TABLE posts ADD COLUMN like_count INT DEFAULT 0;

CREATE TRIGGER trg_like_insert
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;

    INSERT INTO like_log(user_id, post_id, action)
    VALUES (NEW.user_id, NEW.post_id, 'LIKE');
END$$

CREATE TRIGGER trg_like_delete
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;

    INSERT INTO like_log(user_id, post_id, action)
    VALUES (OLD.user_id, OLD.post_id, 'UNLIKE');
END$$

CREATE PROCEDURE sp_send_friend_request(
    IN p_sender INT,
    IN p_receiver INT
)
BEGIN
    IF p_sender = p_receiver THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot friend yourself';
    END IF;

    IF EXISTS (
        SELECT 1 FROM friends
        WHERE user_id = p_sender AND friend_id = p_receiver
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Request already exists';
    END IF;

    INSERT INTO friends(user_id, friend_id, status)
    VALUES (p_sender, p_receiver, 'pending');
END$$

CREATE TRIGGER trg_friend_request
AFTER INSERT ON friends
FOR EACH ROW
BEGIN
    INSERT INTO friend_log(user_id, friend_id, action)
    VALUES (NEW.user_id, NEW.friend_id, 'REQUEST');
END$$

CREATE TRIGGER trg_friend_accept
AFTER UPDATE ON friends
FOR EACH ROW
BEGIN
    IF OLD.status = 'pending' AND NEW.status = 'accepted' THEN
        INSERT IGNORE INTO friends(user_id, friend_id, status)
        VALUES (NEW.friend_id, NEW.user_id, 'accepted');

        INSERT INTO friend_log(user_id, friend_id, action)
        VALUES (NEW.user_id, NEW.friend_id, 'ACCEPT');
    END IF;
END$$

CREATE PROCEDURE sp_update_friend(
    IN p_user INT,
    IN p_friend INT,
    IN p_action VARCHAR(20)
)
BEGIN
    START TRANSACTION;

    IF p_action = 'DELETE' THEN
        DELETE FROM friends WHERE user_id = p_user AND friend_id = p_friend;
        DELETE FROM friends WHERE user_id = p_friend AND friend_id = p_user;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid action';
    END IF;

    COMMIT;
END$$

CREATE PROCEDURE sp_delete_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    START TRANSACTION;

    IF NOT EXISTS (
        SELECT 1 FROM posts
        WHERE post_id = p_post_id AND user_id = p_user_id
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not owner';
    END IF;

    DELETE FROM posts WHERE post_id = p_post_id;

    COMMIT;
END$$

CREATE PROCEDURE sp_delete_user(
    IN p_user_id INT
)
BEGIN
    START TRANSACTION;

    DELETE FROM users WHERE user_id = p_user_id;

    COMMIT;
END$$

DELIMITER ;

CALL sp_register_user('alice', '123', 'alice@mail.com');
CALL sp_register_user('bob', '123', 'bob@mail.com');
CALL sp_register_user('carol', '123', 'carol@mail.com');

SELECT * FROM users;
SELECT * FROM user_log;

CALL sp_register_user('alice', '123', 'alice2@mail.com');

CALL sp_create_post(1, 'Hello world');
CALL sp_create_post(1, 'Second post');
CALL sp_create_post(2, 'Bob post');

SELECT * FROM posts;
SELECT * FROM post_log;

CALL sp_create_post(1, '');

INSERT INTO likes VALUES (2, 1, NOW());
INSERT INTO likes VALUES (3, 1, NOW());

SELECT post_id, like_count FROM posts;

DELETE FROM likes WHERE user_id = 2 AND post_id = 1;

SELECT post_id, like_count FROM posts;
SELECT * FROM like_log;

INSERT INTO likes VALUES (3, 1, NOW());

CALL sp_send_friend_request(1, 2);
CALL sp_send_friend_request(1, 3);

SELECT * FROM friends;

CALL sp_send_friend_request(1, 1);

UPDATE friends
SET status = 'accepted'
WHERE user_id = 1 AND friend_id = 2;

SELECT * FROM friends;
SELECT * FROM friend_log;

CALL sp_update_friend(1, 2, 'DELETE');

SELECT * FROM friends;

CALL sp_delete_post(1, 1);

SELECT * FROM posts;
SELECT * FROM likes;
SELECT * FROM comments;

CALL sp_delete_user(3);

SELECT * FROM users;
SELECT * FROM posts;
SELECT * FROM friends;
