# Assignment #9 - Events & Schedules Solutions
**Topics:** Events, Intervals Schedules - INSERT UPDATE DELETE  
**Dialect:** MySQL (Standard Event Scheduler Syntax)

---

## Pre-requisite Note
Before executing scheduled events in MySQL, ensure that the event scheduler background thread is explicitly enabled on your database server:
```sql
SET GLOBAL event_scheduler = ON;
```

---

## Section 1: Advance Level Events

### 1. Create an event that runs daily and moves orders older than 6 months from the orders table to an orders_archive table.
```sql
CREATE EVENT ev_daily_archive_orders
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- Copy old rows to archive
    INSERT INTO orders_archive
    SELECT * FROM orders 
    WHERE order_date < NOW() - INTERVAL 6 MONTH;
    
    -- Purge archived rows from active table
    DELETE FROM orders 
    WHERE order_date < NOW() - INTERVAL 6 MONTH;
END;
```

### 2. Create an event that runs every hour to delete records from a user_sessions table where expiry_time is less than the current time.
```sql
CREATE EVENT ev_hourly_purge_sessions
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
DO
    DELETE FROM user_sessions 
    WHERE expiry_time < NOW();
```

### 3. Write an event that runs once a week to insert 5 random coupon codes into a coupons table.
```sql
CREATE EVENT ev_weekly_generate_coupons
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- Insert 5 iterations of randomly generated strings
    INSERT INTO coupons (coupon_code, discount_percent, created_at) VALUES 
    (UPPER(SUBSTRING(MD5(RAND()), 1, 8)), 15.00, NOW()),
    (UPPER(SUBSTRING(MD5(RAND()), 1, 8)), 15.00, NOW()),
    (UPPER(SUBSTRING(MD5(RAND()), 1, 8)), 15.00, NOW()),
    (UPPER(SUBSTRING(MD5(RAND()), 1, 8)), 15.00, NOW()),
    (UPPER(SUBSTRING(MD5(RAND()), 1, 8)), 15.00, NOW());
END;
```

### 4. Schedule a monthly event to generate invoice summaries and insert them into an invoice_summary table on the 1st of every month at midnight.
```sql
CREATE EVENT ev_monthly_invoice_summary
ON SCHEDULE EVERY 1 MONTH
STARTS DATE_FORMAT(NOW() + INTERVAL 1 MONTH, '%Y-%m-01 00:00:00')
DO
    INSERT INTO invoice_summary (summary_month, total_invoiced, invoice_count)
    SELECT 
        DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m'),
        SUM(total_amount),
        COUNT(invoice_id)
    FROM invoices
    WHERE invoice_date >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01 00:00:00')
      AND invoice_date < DATE_FORMAT(NOW(), '%Y-%m-01 00:00:00');
```

### 5. Create an event that resets all users' login_attempts to 0 at midnight every day.
```sql
CREATE EVENT ev_daily_reset_login_attempts
ON SCHEDULE EVERY 1 DAY
STARTS DATE_FORMAT(NOW() + INTERVAL 1 DAY, '%Y-%m-%d 00:00:00')
DO
    UPDATE users 
    SET login_attempts = 0;
```

---

## Section 2: Hard Level Events

### 6. Schedule an event that runs every Sunday and deletes users from the users table who haven’t logged in for over 1 year.
```sql
CREATE EVENT ev_weekly_purge_inactive_users
ON SCHEDULE EVERY 1 WEEK
STARTS DATE_FORMAT(NOW() + INTERVAL (7 - WEEKDAY(NOW())) DAY, '%Y-%m-%d 03:00:00') -- Upcoming Sunday at 3:00 AM
DO
    DELETE FROM users 
    WHERE last_login < NOW() - INTERVAL 1 YEAR;
```

### 7. Write an event that runs every day at 6 AM to apply a 10% discount on products in the products table where the category = 'Clearance'.
```sql
CREATE EVENT ev_daily_clearance_discount
ON SCHEDULE EVERY 1 DAY
STARTS DATE_FORMAT(NOW() + INTERVAL 1 DAY, '%Y-%m-%d 06:00:00')
DO
    UPDATE products 
    SET price = price * 0.90 
    WHERE category = 'Clearance';
```

### 8. Create an event that runs every 6 hours and copies data from inventory to inventory_backup.
```sql
CREATE EVENT ev_quad_daily_inventory_backup
ON SCHEDULE EVERY 6 HOUR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- Flush existing tracking backup table to keep a fresh operational slice
    TRUNCATE TABLE inventory_backup;
    
    -- Populate fresh snapshot
    INSERT INTO inventory_backup
    SELECT * FROM inventory;
END;
```

### 9. Create a scheduled event to update a notification table with entries for users whose subscription is going to expire in 7 days.
```sql
CREATE EVENT ev_daily_subscription_expiry_alert
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
    INSERT INTO notifications (user_id, message, created_at)
    SELECT 
        user_id, 
        'Your subscription will expire in exactly 7 days. Renew now!', 
        NOW()
    FROM subscriptions 
    WHERE DATE(expiry_date) = CURDATE() + INTERVAL 7 DAY;
```

### 10. Create an annual event that runs on 1st January to insert a predefined list of holidays into a holiday_calendar table.
```sql
CREATE EVENT ev_annual_holiday_population
ON SCHEDULE EVERY 1 YEAR
STARTS DATE_FORMAT(NOW() + INTERVAL 1 YEAR, '%Y-01-01 00:00:00')
DO
BEGIN
    INSERT INTO holiday_calendar (holiday_date, holiday_name) VALUES 
    (DATE_FORMAT(NOW(), '%Y-01-01'), 'New Year\'s Day'),
    (DATE_FORMAT(NOW(), '%Y-07-04'), 'Independence Day'),
    (DATE_FORMAT(NOW(), '%Y-11-25'), 'Thanksgiving Day'),
    (DATE_FORMAT(NOW(), '%Y-12-25'), 'Christmas Day');
END;
```