USE social_network;

CREATE TABLE IF NOT EXISTS friend_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    from_user_id INT NOT NULL,
    to_user_id INT NOT NULL,
    status ENUM('pending','accepted','rejected') DEFAULT 'pending'
);

CREATE TABLE IF NOT EXISTS friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    PRIMARY KEY (user_id, friend_id)
);

ALTER TABLE users
ADD COLUMN IF NOT EXISTS friends_count INT DEFAULT 0;

DELIMITER $$

CREATE PROCEDURE sp_accept_friend_request(
    IN p_request_id INT,
    IN p_to_user_id INT
)
BEGIN
    DECLARE v_from_user_id INT;
    DECLARE v_status VARCHAR(10);
    DECLARE v_count INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    START TRANSACTION;

    SELECT from_user_id, status
    INTO v_from_user_id, v_status
    FROM friend_requests
    WHERE request_id = p_request_id
      AND to_user_id = p_to_user_id
    FOR UPDATE;

    IF v_from_user_id IS NULL OR v_status <> 'pending' THEN
        ROLLBACK;
    ELSE
        SELECT COUNT(*) INTO v_count
        FROM friends
        WHERE user_id = v_from_user_id
          AND friend_id = p_to_user_id;

        IF v_count > 0 THEN
            ROLLBACK;
        ELSE
            INSERT INTO friends (user_id, friend_id)
            VALUES (v_from_user_id, p_to_user_id);

            INSERT INTO friends (user_id, friend_id)
            VALUES (p_to_user_id, v_from_user_id);

            UPDATE users
            SET friends_count = friends_count + 1
            WHERE user_id IN (v_from_user_id, p_to_user_id);

            UPDATE friend_requests
            SET status = 'accepted'
            WHERE request_id = p_request_id;

            COMMIT;
        END IF;
    END IF;
END $$

DELIMITER ;

CALL sp_accept_friend_request(1, 2);

SELECT * FROM friends;
SELECT * FROM users;
SELECT * FROM friend_requests;
