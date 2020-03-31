-- Author: sen4ik
-- Date: 03/03/2020
-- Below prodecure will recalculate totals for each order.

drop procedure if exists recalcTotals;

DELIMITER $$
CREATE PROCEDURE artur_sentsov_db.recalcTotals()
BEGIN

	DECLARE v_order_id int(11) default 0;
	DECLARE v_product_id int(11) default 0;
	DECLARE v_quantity int(11) default 0;
    DECLARE v_product_price DOUBLE;
    DECLARE v_total DOUBLE;
    DECLARE done INT DEFAULT 0;
	DECLARE ordersCur CURSOR FOR select id, product_id, quantity from artur_sentsov_db.orders; -- where id=2;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN ordersCur;
		cur_project_loop: LOOP
			FETCH FROM ordersCur INTO v_order_id, v_product_id, v_quantity;
			
            IF done THEN
				LEAVE cur_project_loop;
			END IF;
            
            SELECT price INTO v_product_price FROM artur_sentsov_db.products WHERE id = v_product_id;
            -- SELECT v_order_id, v_product_id, v_quantity, v_product_price;
            UPDATE artur_sentsov_db.orders SET total = round((v_quantity * v_product_price), 2) WHERE id = v_order_id;
            
		END LOOP cur_project_loop;
	CLOSE ordersCur;
    
END$$

DELIMITER ;

CALL artur_sentsov_db.recalcTotals();