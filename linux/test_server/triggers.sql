delimiter //

drop trigger if exists `artur_sentsov_db`.customer_delete //

CREATE TRIGGER `artur_sentsov_db`.customer_delete AFTER DELETE on `artur_sentsov_db`.customers
FOR EACH ROW
BEGIN
DELETE FROM `artur_sentsov_db`.orders
    WHERE `artur_sentsov_db`.orders.customer_id = old.id;
END

//

drop trigger if exists `artur_sentsov_db`.order_insert_trg //

CREATE TRIGGER `artur_sentsov_db`.order_insert_trg
AFTER INSERT
   ON `artur_sentsov_db`.orders FOR EACH ROW
BEGIN
	
    DECLARE v_in_stock int(11) default 0;
    
    SELECT in_stock INTO v_in_stock FROM `artur_sentsov_db`.products WHERE id = NEW.product_id;
    
    UPDATE `artur_sentsov_db`.products SET `artur_sentsov_db`.products.in_stock = (v_in_stock - NEW.quantity);    

END;

//

delimiter ;

