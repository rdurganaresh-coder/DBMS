use sample;

-- Procedures 

select * from orders_archive;
select * from orders;
select * from customers;
select * from products;




#Ex-1
-- Get Orders by Customer ID

-- Krishna - 011 

DELIMITER $$

-- declare variable_name datatype varhcar(100)

CREATE PROCEDURE GetOrdersByCustomer(IN customerId INT)
BEGIN
    SELECT * FROM orders WHERE custId = customerId;
END$$

DELIMITER ;




CALL GetOrdersByCustomer(128);






















#Ex-2
-- Insert New Product (with auto logging)


DELIMITER $$

CREATE PROCEDURE AddProduct(
    IN p_code VARCHAR(100),
    IN p_name VARCHAR(100),
    IN p_buy DECIMAL(10,2),
    IN p_sale DECIMAL(10,2),
    IN p_stock INT
)
BEGIN
    INSERT INTO products (productCode,productname,buyPrice,salePrice,stock) 
    VALUES (p_code,p_name,p_buy,p_sale,p_stock);
    
    INSERT INTO product_logs (product_name, action, created_at)
    VALUES (p_name, 'INSERT', NOW());
END$$

DELIMITER ;
select * from product_logs;



CALL AddProduct('S10_1291','Exproduct2',1000,799,10);




#Ex-I
-- Auto Apply Discounts Based on Total Amount
DELIMITER $$

CREATE PROCEDURE ApplyDiscount(IN custId INT)
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(amount) INTO total FROM orders WHERE customer_id = custId;

    IF total > 10000 THEN
        UPDATE customers SET discount = 15 WHERE id = custId;
    ELSEIF total > 5000 THEN
        UPDATE customers SET discount = 10 WHERE id = custId;
    ELSE
        UPDATE customers SET discount = 5 WHERE id = custId;
    END IF;
END$$

DELIMITER ;


#ex - I 

DELIMITER $$

CREATE PROCEDURE GetOrderSummary(IN order_id INT)
BEGIN
    SELECT o.order_id, c.name AS customer_name, o.order_date, o.total_amount
    FROM Orders o
    JOIN Customers c ON o.customer_id = c.customer_id
    WHERE o.order_id = order_id;
    
    SELECT p.product_name, oi.quantity, oi.price
    FROM OrderItems oi
    JOIN Products p ON p.product_id = oi.product_id
    WHERE oi.order_id = order_id;
END $$

DELIMITER ;


#Ex-3
-- Update Stock After Sale

DELIMITER $$

CREATE PROCEDURE UpdateStock(
    IN prodId INT,
    IN quantitySold INT
)
BEGIN
    UPDATE products
    SET stock = stock - quantitySold
    WHERE id = prodId;
END$$

DELIMITER ;


#Ex-4
-- Generate Monthly Sales Report

DELIMITER $$

CREATE PROCEDURE MonthlySalesReport(IN reportMonth INT, IN reportYear INT)
BEGIN
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(total_amount) AS total_sales
    FROM orders
    WHERE MONTH(order_date) = reportMonth AND YEAR(order_date) = reportYear
    GROUP BY month;
END$$

DELIMITER ;

-- CALL MonthlySalesReport(6, 2025);













#Ex-5
-- Delete Inactive Customers (Last Order > 1 Year)

DELIMITER $$

CREATE PROCEDURE DeleteInactiveCustomers()
BEGIN
    DELETE FROM customers
    WHERE id NOT IN (
        SELECT DISTINCT customer_id FROM orders
        WHERE order_date > NOW() - INTERVAL 1 YEAR
    );
END$$

DELIMITER ;



-- Stored Procedure: ApplySmartDiscountToCategory

DELIMITER $$

CREATE PROCEDURE ApplySmartDiscountToCategory(IN cat_id INT)
BEGIN
    UPDATE Products
    SET price = 
        CASE
            WHEN price < 500 THEN price - (price * 0.30)
            WHEN price BETWEEN 500 AND 2000 THEN price - (price * 0.50)
            WHEN price > 2000 THEN price - (price * 0.70)
        END
    WHERE category_id = cat_id;
END $$

DELIMITER ;



-- Basic example with Cusor on Loops 


DELIMITER $$

CREATE PROCEDURE PrintEmployeeNames()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE emp_name VARCHAR(50);

    -- Cursor declaration
    DECLARE emp_cursor CURSOR FOR
        SELECT name FROM Employees;

    -- Declare continue handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open cursor
    OPEN emp_cursor;

    read_loop: LOOP
        FETCH emp_cursor INTO emp_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Action
        SELECT emp_name;
    END LOOP;

    CLOSE emp_cursor;
END$$

DELIMITER ;




-- CALL ApplySmartDiscountToCategory(3);


DELIMITER $$

CREATE PROCEDURE ApplySmartDiscountToCategory(IN cat_id INT)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE prod_id INT;
    DECLARE current_price DECIMAL(10,2);
    DECLARE discount_price DECIMAL(10,2);

    -- Cursor for active products in given category
    DECLARE cur CURSOR FOR
        SELECT product_id, price
        FROM Products
        WHERE category_id = cat_id AND is_active = 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO prod_id, current_price;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Apply discount based on price range
        IF current_price < 500 THEN
            SET discount_price = current_price - (current_price * 0.30);
        ELSEIF current_price BETWEEN 500 AND 2000 THEN
            SET discount_price = current_price - (current_price * 0.50);
        ELSE
            SET discount_price = current_price - (current_price * 0.70);
        END IF;

        -- Update product price
        UPDATE Products
        SET price = discount_price
        WHERE product_id = prod_id;

    END LOOP;

    CLOSE cur;
END $$

DELIMITER ;



-- LOOP EXAMPLE 

DELIMITER $$

CREATE PROCEDURE DiscountLowStockProducts()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE prod_id INT;
    DECLARE curr_stock INT;

    DECLARE cur CURSOR FOR 
        SELECT product_id, stock FROM products;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO prod_id, curr_stock;
        IF done THEN
            LEAVE read_loop;
        END IF;

        IF curr_stock < 10 THEN
            -- Apply 10% discount
            UPDATE products
            SET price = price * 0.9
            WHERE product_id = prod_id;
        END IF;
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;






-- WHILE EXAMPLE 

DELIMITER $$

CREATE PROCEDURE WhileExample()
BEGIN
    DECLARE counter INT DEFAULT 1;
    DECLARE total INT DEFAULT 0;

    WHILE counter <= 5 DO
        SET total = total + counter;
        SET counter = counter + 1;
    END WHILE;

    SELECT CONCAT('Total Sum = ', total);
END$$

DELIMITER ;





-- REPEAT

DELIMITER $$

CREATE PROCEDURE RepeatExample()
BEGIN
    DECLARE counter INT DEFAULT 2;

    REPEAT
        SELECT CONCAT('Even Number = ', counter);
        SET counter = counter + 2;
    UNTIL counter > 10
    END REPEAT;
END$$

DELIMITER ;





-- Real World Example 

DELIMITER $$

CREATE PROCEDURE PrintProducts()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE prod_name VARCHAR(100);
    
    DECLARE cur CURSOR FOR SELECT name FROM products;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO prod_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Do something with prod_name
        SELECT CONCAT('Product: ', prod_name);
    END LOOP;
    CLOSE cur;
END$$

DELIMITER ;




-- All in One 

DELIMITER $$

CREATE PROCEDURE DiscountLowStockProducts()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE prod_id INT;
    DECLARE curr_stock INT;

    DECLARE cur CURSOR FOR 
        SELECT product_id, stock FROM products;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO prod_id, curr_stock;
        IF done THEN
            LEAVE read_loop;
        END IF;

        IF curr_stock < 10 THEN
            -- Apply 10% discount
            UPDATE products
            SET price = price * 0.9
            WHERE product_id = prod_id;
        END IF;
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;














-- Use Case: ProcessOrder

-- Suppose we have:

--orders table: order_id, customer_id, status
--order_items table: order_id, product_id, quantity
--products table: product_id, stock
--order_logs table: log_id, order_id, message, log_time


--We want to:

--Check stock for each item.

--If all items are in stock, reduce stock and mark order as 'Processed'.

--If not enough stock, mark order as 'Failed'.

--Log the actions.



DELIMITER $$

CREATE PROCEDURE ProcessOrder(IN in_order_id INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE prod_id INT;
    DECLARE qty INT;
    DECLARE curr_stock INT;
    DECLARE insufficient_stock INT DEFAULT 0;

    -- Cursor for order items
    DECLARE item_cursor CURSOR FOR
        SELECT product_id, quantity FROM order_items WHERE order_id = in_order_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open cursor and start loop
    OPEN item_cursor;

    read_loop: LOOP
        FETCH item_cursor INTO prod_id, qty;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Check current stock
        SELECT stock INTO curr_stock FROM products WHERE product_id = prod_id;

        IF curr_stock < qty THEN
            SET insufficient_stock = 1;
            -- Log insufficient stock
            INSERT INTO order_logs (order_id, message, log_time)
            VALUES (in_order_id, CONCAT('Insufficient stock for product ', prod_id), NOW());
        END IF;
    END LOOP;

    CLOSE item_cursor;

    -- If any item had insufficient stock, mark order as failed
    IF insufficient_stock = 1 THEN
        UPDATE orders SET status = 'Failed' WHERE order_id = in_order_id;
        INSERT INTO order_logs (order_id, message, log_time)
        VALUES (in_order_id, 'Order processing failed due to low stock', NOW());
    ELSE
        -- Process the order: Deduct stock
        OPEN item_cursor;
        SET done = FALSE;

        read_loop_2: LOOP
            FETCH item_cursor INTO prod_id, qty;
            IF done THEN
                LEAVE read_loop_2;
            END IF;

            UPDATE products
            SET stock = stock - qty
            WHERE product_id = prod_id;

            INSERT INTO order_logs (order_id, message, log_time)
            VALUES (in_order_id, CONCAT('Stock reduced for product ', prod_id), NOW());
        END LOOP;

        CLOSE item_cursor;

        UPDATE orders SET status = 'Processed' WHERE order_id = in_order_id;
        INSERT INTO order_logs (order_id, message, log_time)
        VALUES (in_order_id, 'Order processed successfully', NOW());
    END IF;
END$$

DELIMITER ;




































