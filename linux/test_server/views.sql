CREATE OR REPLACE VIEW `all_v` AS 
SELECT o.`order_id`, o.`customer_id`, c.`first_name`, c.`last_name`, o.`product_id`, p.`title`, p.`sku`, p.`price`, o.`quantity`, p.`in_stock` FROM `orders` AS o 
INNER JOIN `products` AS p ON o.`product_id` = p.`id`
INNER JOIN `customers` AS c ON o.`customer_id` = c.`id`;