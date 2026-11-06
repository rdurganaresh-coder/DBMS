# Assignment #8 - Triggers & Types of Triggers
**Topics:** Triggers, Before After - INSERT UPDATE DELETE

---

## Section 1: Advance Level Trigger

### 1. Create a trigger that stores the inserted customer details in a separate `customer_audit` table whenever a new customer is added to the `customers` table.
```sql
CREATE TRIGGER after_customer_insert
AFTER INSERT ON customers
FOR EACH ROW
BEGIN
    INSERT INTO customer_audit (customer_id, customer_name, email, action_timestamp)
    VALUES (NEW.customer_id, NEW.customer_name, NEW.email, NOW());
END;
```

### 2. Write a trigger that prevents inserting or updating a product in the `inventory` table with stock quantity less than zero.
```sql
DELIMITER //

CREATE TRIGGER before_inventory_insert
BEFORE INSERT ON inventory
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock quantity cannot be less than zero.';
    END IF;
END //

CREATE TRIGGER before_inventory_update
BEFORE UPDATE ON inventory
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock quantity cannot be less than zero.';
    END IF;
END //

DELIMITER ;
```

### 3. Whenever an order is deleted from the `orders` table, copy the deleted record to the `deleted_orders` table using a trigger.
```sql
CREATE TRIGGER after_order_delete
AFTER DELETE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO deleted_orders (order_id, customer_id, order_date, total_amount, deleted_at)
    VALUES (OLD.order_id, OLD.customer_id, OLD.order_date, OLD.total_amount, NOW());
END;
```

### 4. Create a trigger on the `employees` table to track any update to the salary field and store the old salary, new salary, and timestamp in a `salary_history` table.
```sql
DELIMITER //

CREATE TRIGGER after_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_history (employee_id, old_salary, new_salary, change_timestamp)
        VALUES (OLD.employee_id, OLD.salary, NEW.salary, NOW());
    END IF;
END //

DELIMITER ;
```

### 5. Whenever an employee record is updated in the `employees` table, automatically update the `last_modified` column with the current timestamp.
```sql
CREATE TRIGGER before_employee_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    SET NEW.last_modified = NOW();
END;
```

---

## Section 2: Hard Level Triggers

### 6. Create a BEFORE INSERT trigger on the `users` table to convert the email field to lowercase before storing it.
```sql
CREATE TRIGGER before_user_insert_email_lower
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(NEW.email);
END;
```

### 7. When an invoice is deleted from the `invoices` table, use a trigger to automatically delete all associated records from the `invoice_items` table.
```sql
CREATE TRIGGER after_invoice_delete
AFTER DELETE ON invoices
FOR EACH ROW
BEGIN
    DELETE FROM invoice_items WHERE invoice_id = OLD.invoice_id;
END;
```

### 8. Use a BEFORE INSERT trigger to check for duplicate email addresses in the `users` table and prevent insertion if a duplicate is found (without using unique constraints).
```sql
DELIMITER //

CREATE TRIGGER before_user_insert_check_duplicate
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE email = NEW.email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duplicate email registration blocked.';
    END IF;
END //

DELIMITER ;
```

### 9. Create a BEFORE INSERT trigger on the `users` table to assign the default role 'customer' if no role is provided during insertion.
```sql
CREATE TRIGGER before_user_insert_default_role
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.role IS NULL OR NEW.role = '' THEN
        SET NEW.role = 'customer';
    END IF;
END;
```