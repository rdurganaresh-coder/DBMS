use sample;

-- EVENTS 

select * from orders_archive;
select * from customers;
select * from customer_audits;



#Example - 1

-- Auto-Archive Old Orders
-- Move orders older than 6 Year to an archive table.

CREATE table orders_archive LIKE orders;

CREATE EVENT archive_old_orders
ON SCHEDULE EVERY 1 MINUTE 
DO
  INSERT INTO orders_archive SELECT * FROM orders WHERE orderDate < NOW() - INTERVAL 6 MONTH;



#Example - 2

-- Auto-Expire Discount Coupons
-- Disable expired coupons every hour.

select * from coupons c;
  
CREATE EVENT expire_coupons
ON SCHEDULE EVERY 1 MINUTE 
DO
  UPDATE coupons SET status = 'expired' WHERE expiry_date > NOW();
  


#Example - 3 

-- Daily Sales Summary
-- Store daily sales total in a reporting table at midnight.



CREATE EVENT daily_sales_summary
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE + INTERVAL 1 DAY)
DO
  INSERT INTO sales_report (report_date, total_sales)
  SELECT CURDATE(), SUM(amount) FROM orders WHERE order_date = CURDATE();
  
  
#Example - 4 

-- Mark Inactive Inactive Customers
-- Mark Customers as inactive if they haven’t logged in for 30 days.


CREATE EVENT mark_inactive_users
ON SCHEDULE EVERY 1 DAY
DO
  UPDATE customers SET status = 'inactive'
  WHERE last_login < NOW() - INTERVAL 30 DAY;




#Example - 5

-- Clean Up Temp Data
-- Delete temporary rows older than 1 day from temp_sessions.


CREATE EVENT cleanup_temp_sessions
ON SCHEDULE EVERY 6 HOUR
DO
  DELETE FROM temp_sessions WHERE created_at < NOW() - INTERVAL 1 DAY;

  
  

#Example - 6

-- Limited-Time Offers
-- Enable and disable offers automatically.

  
-- Activate offer
CREATE EVENT activate_offer
ON SCHEDULE AT '2025-07-05 00:00:00'
DO
  UPDATE offers SET active = 1 WHERE id = 101;

  
  
-- Deactivate offer
CREATE EVENT deactivate_offer
ON SCHEDULE AT '2025-07-10 23:59:59'
DO
  UPDATE offers SET active = 0 WHERE id = 101;

 


