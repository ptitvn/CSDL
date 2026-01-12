
USE social_network_pro;


DROP PROCEDURE IF EXISTS CalculateUserActivityScore;

DELIMITER $$

CREATE PROCEDURE CalculateUserActivityScore (
    IN  p_user_id INT,
    OUT activity_score INT,
    OUT activity_level VARCHAR(50)
)
BEGIN
    DECLARE post_count INT DEFAULT 0;
    DECLARE comment_count INT DEFAULT 0;
    DECLARE like_received_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO post_count
    FROM posts
    WHERE user_id = p_user_id;

    SELECT COUNT(*)
    INTO comment_count
    FROM comments
    WHERE user_id = p_user_id;

    SELECT COUNT(*)
    INTO like_received_count
    FROM likes l
    JOIN posts p ON l.post_id = p.post_id
    WHERE p.user_id = p_user_id;

    SET activity_score =
          post_count * 10
        + comment_count * 5
        + like_received_count * 3;

    CASE
        WHEN activity_score > 500 THEN
            SET activity_level = 'Rất tích cực';
        WHEN activity_score BETWEEN 200 AND 500 THEN
            SET activity_level = 'Tích cực';
        ELSE
            SET activity_level = 'Bình thường';
    END CASE;

END $$

DELIMITER ;

SET @activity_score = 0;
SET @activity_level = '';

CALL CalculateUserActivityScore(1, @activity_score, @activity_level);

SELECT 
    @activity_score AS DiemHoatDong,
    @activity_level AS MucDoHoatDong;

DROP PROCEDURE IF EXISTS CalculateUserActivityScore;
