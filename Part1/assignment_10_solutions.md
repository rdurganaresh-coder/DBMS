# Assignment #10 - Indexes Solutions

## Topics: Indexes, Clustered index, Non-Clustered index, Composite index

### Section 1: Advance Level Index

#### 1. Create a simple index on the email column of a users table and explain how it improves query performance.
```sql
CREATE INDEX idx_users_email ON users(email);
```
**Explanation:** 
A simple index creates a separate, optimized B-Tree data structure storing the `email` values and pointers to their corresponding rows. Instead of performing a slow sequential full-table scan to locate a specific email address, the database engine can traverse the B-Tree log-linear path (Index Seek), drastically reducing disk I/O and query execution time.

#### 2. Create a clustered index on the order_id column of an orders table. Explain how data is physically stored in this case.
```sql
-- Note: In many RDBMS like MySQL (InnoDB), the Primary Key automatically forms the Clustered Index.
-- If creating explicitly (e.g., in SQL Server):
CREATE CLUSTERED INDEX idx_orders_order_id ON orders(order_id);
```
**Explanation:** 
When a clustered index is created, the physical rows of data in the table are sorted and stored sequentially on disk ordered by the index key (`order_id`). The leaf nodes of a clustered index contain the actual data rows themselves. Consequently, a table can only have **one** clustered index because physical rows can only be arranged on disk in a single ordering sequence.

#### 3. Create a non-clustered index on the product_name column of a products table. Show a query that benefits from this index.
```sql
CREATE INDEX idx_products_product_name ON products(product_name);

-- Query that benefits from this index:
SELECT product_id, product_name, price 
FROM products 
WHERE product_name = 'Wireless Mouse';
```

#### 4. Create a composite index on the first_name and last_name columns of a customers table. Write a query that uses both columns efficiently.
```sql
CREATE INDEX idx_customers_name ON customers(first_name, last_name);

-- Query that uses both columns efficiently:
SELECT customer_id, phone_number 
FROM customers 
WHERE first_name = 'Jane' AND last_name = 'Smith';
```

#### 5. Create an event that resets all users' login_attempts to 0 at midnight every day.
```sql
-- Ensure the event scheduler is turned on
SET GLOBAL event_scheduler = ON;

CREATE EVENT ev_reset_login_attempts
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_DATE + INTERVAL 1 DAY) -- Starts exactly at midnight tonight
DO
  UPDATE users SET login_attempts = 0;
```

---

### Section 2: Hard Level Events

#### 6. Create a unique index on the username column in the users table to prevent duplicate entries.
```sql
CREATE UNIQUE INDEX idx_unique_username ON users(username);
```

#### 7. Create a query using the index on status in the orders table to retrieve all records with status = 'SHIPPED'.
```sql
-- Assumed index creation: CREATE INDEX idx_orders_status ON orders(status);
SELECT order_id, customer_id, status, shipped_date
FROM orders FORCE INDEX (idx_orders_status) -- Optional hint to ensure the index is utilized
WHERE status = 'SHIPPED';
```

#### 8. Create an index on the created_at column in the posts table. Write a query to fetch all posts from the last 7 days using this index.
```sql
CREATE INDEX idx_posts_created_at ON posts(created_at);

-- Query fetching posts from the last 7 days:
SELECT post_id, title, created_at 
FROM posts 
WHERE created_at >= NOW() - INTERVAL 7 DAY;
```

#### 9. Use EXPLAIN to analyze how an index is being used in a SELECT query on the customers table with an index on email.
```sql
EXPLAIN SELECT customer_id, first_name, email 
FROM customers 
WHERE email = 'alex@example.com';
```

#### 10. Write the same SELECT query before and after creating an index on the phone_number column of the contacts table. Measure and compare performance.
```sql
-- 1. Query Execution before creating index (Measures Full Table Scan Baseline)
SELECT contact_id, name, phone_number 
FROM contacts 
WHERE phone_number = '+1234567890';

-- 2. Create the index
CREATE INDEX idx_contacts_phone_number ON contacts(phone_number);

-- 3. Query Execution after creating index (Measures Index Seek Speed)
SELECT contact_id, name, phone_number 
FROM contacts 
WHERE phone_number = '+1234567890';

-- Performance Measurement (MySQL Command-Line Tool / Client profiling check):
-- SHOW PROFILES;
```
