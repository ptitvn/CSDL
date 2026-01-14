DELIMITER //
CREATE PROCEDURE add_user(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_created_at DATE
)
BEGIN
    INSERT INTO users (username, email, created_at) 
    VALUES (p_username, p_email, p_created_at);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_user_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN

    IF NEW.email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Email không đúng định dạng (phải chứa @ và .)';
    END IF;

    IF NEW.username NOT REGEXP '^[a-zA-Z0-9_]+$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Username chỉ được chứa chữ cái, số và dấu gạch dưới';
    END IF;
END //
DELIMITER ;

CALL add_user('david_99', 'david@gmail.com', '2025-02-01');

CALL add_user('user 123!', 'user123@gmail.com', '2025-02-03');

SELECT * FROM users;