use sample;

-- TRIGGERS

select * from order_items;
select * from customers;
select * from customer_audits;




#Example - 1

-- Audit Log: Track Inserts
-- Automatically log new user entries into an audit table.

{
id :  2
name : kanha
email : kdev@gmail.com
}

-- NEW - new data inserted

-- OLD 


CREATE TRIGGER after_user_insert
AFTER INSERT ON customers
FOR EACH ROW
BEGIN
    INSERT INTO customer_audits (id, name, email)
    VALUES (NEW.custId, NEW.customerName, NEW.custEmail);
END;

INSERT INTO sample.customers
(custId ,customerName, phone, addressLine1, addressLine2, city, state, postalCode, country, creditLimit, custEmail, dob)
VALUES(120,'Lakshya', '1231313', 'D', 'Delhi', 'New Delhi', 'New Delhi', '11012', 'India', 0, 'lakshy@gmail.com', '1998-06-30'); 







#Example - 2

-- Maintain a Stock Log
-- Automatically log stock changes after an update.


select * from stock_log p  ;


CREATE TRIGGER after_stock_update
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    INSERT INTO stock_log (product_id, old_stock, new_stock)
    VALUES (OLD.productCode, OLD.stock, NEW.stock);
END;




update products set stock = 50 where productCode = 'S10_1678';




#Example - 3 

-- Cascading Delete or Soft Delete
-- When deleting a user, store a copy in an archive table.

CREATE TABLE customers_archive LIKE customers;


CREATE TRIGGER before_customer_delete
BEFORE DELETE ON customers
FOR EACH ROW
BEGIN
    INSERT INTO customers_archive SELECT * FROM customers WHERE custId = OLD.custId;
END;

SELECT * FROM customers where custId not in (
select custId from orders group by custId);

delete from customers where custId = 120;

SELECT * FROM customers_archive where custId  = 120;

#Example - 4 

-- Inventory Management
-- Automatically decrease stock quantity when an order is placed



CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
  UPDATE products
  SET stock = stock - NEW.quantity
  WHERE id = NEW.product_id;
END;




#Example - 5

-- Prevent Negative Stock
-- Disallow order placement if not enough stock is available



-- select * from product where cartId = 123;
pid = 123
stock = 5;

stock = 0;


CREATE TRIGGER before_order_insert
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
  DECLARE current_stock INT;

  SELECT stock INTO current_stock FROM products WHERE id = NEW.product_id;

  IF current_stock < NEW.quantity THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Insufficient stock for this order';
  END IF;
END;







