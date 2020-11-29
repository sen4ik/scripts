drop procedure if exists doWhile;
DELIMITER //  
CREATE PROCEDURE doWhile()   
BEGIN
DECLARE i INT DEFAULT 12; 
WHILE (i <= 12) DO
    INSERT INTO `bed` (room_id, bed_number) values (1, i);
    SET i = i+1;
END WHILE;
END;
//  

CALL doWhile(); 