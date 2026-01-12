/* =====================================================
   BÀI 3 – STORED PROCEDURE: CALCULATE BONUS POINTS
   DATABASE: social_network_pro
   ===================================================== */

/* 1. SỬ DỤNG DATABASE */
USE social_network_pro;


DROP PROCEDURE IF EXISTS CalculateBonusPoints;

DELIMITER $$

CREATE PROCEDURE CalculateBonusPoints (
    IN    p_user_id INT,
    INOUT p_bonus_points INT
)
BEGIN
    DECLARE post_count INT DEFAULT 0;

    SELECT COUNT(*) 
    INTO post_count
    FROM posts
    WHERE user_id = p_user_id;


    IF post_count >= 20 THEN
        SET p_bonus_points = p_bonus_points + 100;
    ELSEIF post_count >= 10 THEN
        SET p_bonus_points = p_bonus_points + 50;
    ELSE
        SET p_bonus_points = p_bonus_points;
    END IF;

END $$

DELIMITER ;

SET @bonus_points = 100;

CALL CalculateBonusPoints(1, @bonus_points);

SELECT @bonus_points AS DiemThuongSauCapNhat;

DROP PROCEDURE IF EXISTS CalculateBonusPoints;
