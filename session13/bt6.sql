CREATE TABLE friendships (
    follower_id INT,
    followee_id INT,
    status ENUM('pending', 'accepted') DEFAULT 'accepted',
    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (followee_id) REFERENCES users(user_id) ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER after_friendship_insert
AFTER INSERT ON friendships
FOR EACH ROW
BEGIN
    IF NEW.status = 'accepted' THEN
        UPDATE users 
        SET follower_count = follower_count + 1 
        WHERE user_id = NEW.followee_id;
    END IF;
END //

CREATE TRIGGER after_friendship_delete
AFTER DELETE ON friendships
FOR EACH ROW
BEGIN
    IF OLD.status = 'accepted' THEN
        UPDATE users 
        SET follower_count = follower_count - 1 
        WHERE user_id = OLD.followee_id;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE follow_user(
    IN p_follower_id INT,
    IN p_followee_id INT,
    IN p_status ENUM('pending', 'accepted')
)
BEGIN
    IF p_follower_id = p_followee_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Cannot follow yourself';
    END IF;

    IF EXISTS (SELECT 1 FROM friendships WHERE follower_id = p_follower_id AND followee_id = p_followee_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Already following this user';
    END IF;

    INSERT INTO friendships (follower_id, followee_id, status) 
    VALUES (p_follower_id, p_followee_id, p_status);
END //
DELIMITER ;

CREATE VIEW user_profile AS
SELECT 
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    COALESCE(SUM(p.like_count), 0) AS total_likes,
    GROUP_CONCAT(p.content ORDER BY p.created_at DESC SEPARATOR ' | ') AS recent_posts
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.follower_count, u.post_count;

CALL follow_user(1, 2, 'accepted');
CALL follow_user(3, 2, 'accepted');
CALL follow_user(2, 1, 'accepted');

SELECT * FROM users;
SELECT * FROM user_profile;

DELETE FROM friendships WHERE follower_id = 1 AND followee_id = 2;

SELECT * FROM users;
SELECT * FROM user_profile;