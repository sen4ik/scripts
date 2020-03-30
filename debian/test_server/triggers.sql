delimiter //

drop trigger if exists `artur_sentsov_db`.customer_delete //

CREATE TRIGGER `artur_sentsov_db`.customer_delete AFTER DELETE on `artur_sentsov_db`.customers
FOR EACH ROW
BEGIN
DELETE FROM `artur_sentsov_db`.orders
    WHERE `artur_sentsov_db`.orders.customer_id = old.id;
END

//

delimiter ;
