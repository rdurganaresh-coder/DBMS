-- SQL QUERY OPTIMIZATION 
use sample;

show index from users;
SELECT * FROM users as i where name = 'e8c065 a29e9f52'




Explain FORMAT=JSON SELECT * FROM users as i where mobile = 2323432423;

select * from - optimization 
insert query - 
 
EXPLAIN ANALYZE SELECT * FROM users as i where mobile = 2323432423;
-- EXPLAIN 


| Column             | Meaning                                                                                                                            |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------- |
|   id               | Step number in execution order.                                                                                                    |
|   SELECT_type      | Type of SELECT (SIMPLE, PRIMARY, SUBQUERY, etc.).                                                                                  |
|   table            | The table being accessed.                                                                                                          |
|   type of search   | Join type — shows how MySQL searches the table (best to worst: `system` → `const` → `eq_ref` → `ref` → `range` → `index` → `ALL`). |
|   possibl _keys    | Indexes that might be used.                                                                                                        |
|   key              | The actual index MySQL chose.                                                                                                      |
|   rows             | Estimated rows MySQL will examine.                                                                                                 |
|   Extra            | Additional execution details (e.g., "Using where", "Using index", "Using filesort").                                               |



EXPLAIN ANALYZE

EXPLAIN FORMAT=JSON select * from consumers where mobile = 8052890253;




SELECT 
    c.custId,
    c.customerName,
    o.orderId,
    p.productName,
    oi.qty,
    total_per_order.total_amount
FROM customers c
JOIN orders o 
    ON c.custId = o.custId
JOIN order_items oi 
    ON o.orderId = oi.orderId
JOIN products p 
    ON oi.productCode = p.productCode
JOIN (
    -- Subquery to calculate total amount per order
    SELECT 
        oi_sub.orderId,
        SUM(oi_sub.qty * p_sub.salePrice) AS total_amount
    FROM order_items oi_sub
    JOIN products p_sub 
        ON oi_sub.productCode = p_sub.productCode
    GROUP BY oi_sub.orderId
) AS total_per_order
    ON o.orderId = total_per_order.orderId
ORDER BY c.customerName, o.orderId;


Explain select * from users where id = 501;

Explain WITH HighValueOrders AS (
  SELECT
    custId,
    SUM(orderAmount) AS totalAmount
  FROM
    orders
  GROUP BY
    custId
  HAVING
    SUM(orderAmount) > 1000
)
SELECT
  c.customerName,
  h.totalAmount
FROM
  customers c
JOIN
  HighValueOrders h
ON
  c.custId = h.custId;
  
EXPLAIN
SELECT customerName
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.custId = c.custId
      AND orderAmount > 100
);
  
EXPLAIN  SELECT
  custId,
  shippedDate,
  orderAmount,
  AVG(orderAmount) OVER (
    PARTITION BY shippedDate
  ) AS avg_amount_by_shippedDate
FROM
  orders;





-- 1 SELECT only needed columns

❌ Bad:

 SELECT * FROM customers;

✅ Good:

SELECT custId, first_name, last_name, email 
FROM customers;


-- 2 Filter early with WHERE

❌ Bad:

SELECT customer_id, first_name, last_name, email 
FROM customers;
-- filtering done later in application code (inefficient)


✅ Good:

SELECT customer_id, first_name, last_name, email 
FROM customers
WHERE country = 'USA' AND active = 1;

-- The database filters before sending the result set.

SELECT  * from users;

-- 3 Use LIMIT / TOP for pagination

SELECT custId, customerName,custEmail
FROM customers
WHERE country = 'USA'
ORDER BY customerName
LIMIT 20 OFFSET 20;

-- This fetches only the subset of rows you need for a given page.


-- INDEXs 


-- Single-Column Index

CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

SELECT * FROM orders WHERE customer_id = 105;

EXPLAIN SELECT * FROM orders WHERE customer_id = 105;

select count(*) from users;
-- Composite Index
-- Useful when filtering on multiple columns.

CREATE INDEX idx_orders_customer_date
ON orders(customer_id, order_date);

SELECT * 
FROM orders
WHERE customer_id = 105 
  AND order_date >= '2025-01-01';


-- Clustered Index: physically orders the table data.
# Example: Primary Key usually creates a clustered index automatically.

-- Non-Clustered Index: a separate structure pointing to the table rows.

select * from users;
-- Clustered index (if not already the PK)
CREATE CLUSTERED INDEX idx_orders_date
ON orders(order_date);

-- Non-clustered index
CREATE NONCLUSTERED INDEX idx_orders_status
ON orders(status);

-- Key Optimization Tips
# Use indexes for columns in WHERE, JOIN, and ORDER BY.
# Avoid indexing small tables — the overhead isn’t worth it.
# Don’t over-index — slows down write performance.
# Check query performance with:

EXPLAIN SELECT ... ;




-- JOIN Optimization

-- Avoid unnecessary joins

❌ Bad — joins to a table just to get a value you don’t really need:


SELECT *
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN regions r ON c.region_id = r.region_id;

-- If you never use regions data, you’re just slowing things down.

✅ Good:

EXPLAIN SELECT o.orderId, o.orderDate, c.customerName
FROM orders o
JOIN customers c ON o.custId = c.custId;


-- Filter early in the JOIN

❌ Bad — filtering after the join:

SELECT o.order_id, c.customer_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.country = 'USA';


✅ Good — filter inside the join condition:

 SELECT o.orderId, c.customerName
FROM orders o
JOIN customers c 
  ON o.custId = c.custId 
  AND c.country = 'USA';
  
-- This reduces the rows joined in the first place.


-- Example with multiple joins + pagination
  
  users
  orders
  cart
  checkout
  wishlist
  
SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    p.product_name
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id 
    AND c.country = 'USA'
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
WHERE o.status = 'SHIPPED'
ORDER BY o.order_date DESC
LIMIT 20 OFFSET 0;  -- First page

-- Why this is optimized:
✔️ Only necessary columns selected.
✔️ Filtering on country inside the join.
✔️ Filtering orders by status before pagination.
✔️ LIMIT used for pagination.
✔️ Joins are on indexed primary/foreign keys (customer_id, order_id, product_id).





select custId from orders;
select custId from orders group by custid;


-- How to Minimize DISTINCT Usage

-- 1. Fix the Root Cause of Duplicates
-- Duplicates often come from joins or improper grouping.

SELECT DISTINCT c.name, o.order_id
FROM customers c
JOIN orders o ON c.id = o.customer_id;

-- Optimized 
SELECT c.name, o.order_id
FROM customers c
JOIN orders o ON c.id = o.customer_id
AND o.status = 'active';

-- 2. Use GROUP BY Instead
-- If you’re aggregating anyway, GROUP BY eliminates duplicates naturally:

SELECT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.name;


-- 3. Ensure Indexes Match the DISTINCT Columns
-- If the DISTINCT columns are indexed, the DB can read sorted data directly without a full sort.

CREATE INDEX idx_customer_name ON customers(name);
SELECT DISTINCT name FROM customers;

-- Use EXISTS Instead of DISTINCT on Joins

-- With DISTINCT
SELECT DISTINCT c.id, c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id;

-- Faster with EXISTS
SELECT c.custId, c.customerName
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.custId = c.custId
);

-- 4. Avoid SELECT * with DISTINCT

SELECT DISTINCT customer_id FROM orders;

update orders set order_status = 'APPROVED' where orderId = '10419';
select * from orders where orderId = 10419 ;

ALTER TABLE orders
ADD COLUMN order_status
ENUM('PENDING', 'APPROVED', 'SHIPPED', 'DELIVERED','NOT DELIVERED')
NOT NULL DEFAULT 'PENDING';
    

-- UNION vs UNION ALL


-- UNION
SELECT id, name FROM customers_2024
UNION
SELECT id, name FROM customers_2025;


-- UNION ALL
SELECT id, name FROM customers_2024
UNION ALL
SELECT id, name FROM customers_2025;



-- Performance Impact
Let’s compare:
✔️ UNION = Merge + Sort + Remove Duplicates
✔️ UNION ALL = Merge Only
✔️ If each query returns 1 million rows:
✔️ UNION → requires sorting & comparing all 2M rows.
✔️ UNION ALL → simply appends 1M + 1M rows.




-- Avoid != or <> in WHERE Clauses


-- Likely causes full scan
SELECT * 
FROM orders
WHERE status = 'Shipped';

# Here, the database must look at every row to find non-completed statuses.

-- How to Optimize
# a) Use Positive Matching Instead
-- If the logic allows, check for the value you want, not the value you don’t.

-- Bad
WHERE status != 'inactive'

-- Better
WHERE status = 'active'

# b) Use IN or NOT IN for Specific Exclusions
-- NOT IN can still be slow for large datasets, but is sometimes easier to index than !=:

-- Instead of
WHERE status != 'cancelled'

-- Use
WHERE status IN ('pending', 'active', 'processing')

# c) Use Range Conditions for Numbers/Dates
-- Range filters allow index usage:

-- Bad
WHERE quantity <> 5

-- Better
WHERE quantity < 5 OR quantity > 5

use sample;



-- Use EXISTS Instead of IN for Subqueries

-- Using IN (may scan entire subquery result)
SELECT *
FROM customers
WHERE id IN (SELECT customer_id FROM orders WHERE amount > 1000);

-- Using EXISTS (stops at first match per customer)
SELECT *
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
      AND o.amount > 1000
);





-- Batch Large Operations

-- Delete in batches of 10,000
DELETE FROM orders
WHERE order_date < '2024-01-01'
LIMIT 10000;

--  Batch Updates
UPDATE orders
SET status = 'archived'
WHERE order_date < '2024-01-01'
LIMIT 5000;


-- Faster: multiple rows per insert
INSERT INTO orders_archive (id, order_date, amount)
VALUES 
(1, '2024-01-01', 100.0),
(2, '2024-01-02', 200.0),
(3, '2024-01-03', 300.0);



john 
johnas
johans
jonny john 
john hari 
jai hari john kishan 


WHERE name LIKE 'John%'

-- Optimize LIKE Searches
-- 1. Why LIKE Can Be Slow
# B-tree indexes (used in most relational databases) can only speed up searches if the pattern starts with a fixed value.
# If the pattern starts with a wildcard (%term or %term%), the database can’t use the index and must scan all rows.


-- 2. Index-Friendly LIKE Patterns
✅ Index can be used:

WHERE name LIKE 'John%'

❌ Index cannot be used:

WHERE name LIKE '%John'
WHERE name LIKE '%John%'
-- Because the database doesn’t know where in the string to start searching.

-- Use Prefix Matching Whenever Possible

WHERE email LIKE '@gmail.com'

WHERE email_domain = 'gmail.com'



-- CTEs vs Derived Tables ( Minimize Subqueries & Use CTEs Instead ) 


-- Derived Table (Subquery in FROM)

SELECT d.customer_id, COUNT(*) AS order_count
FROM (
    SELECT customer_id, order_id
    FROM orders
    WHERE order_date >= '2024-01-01'
) d
GROUP BY d.customer_id;

-- CTE (Common Table Expression)

WITH recent_orders AS (
    SELECT customer_id, order_id
    FROM orders
    WHERE order_date >= '2024-01-01'
)
SELECT customer_id, COUNT(*) AS order_count
FROM recent_orders
GROUP BY customer_id;


--  Reuse Results

WITH active_customers AS (
    SELECT id
    FROM customers
    WHERE active = 1
)
SELECT COUNT(*) FROM active_customers;
SELECT AVG(order_total) FROM orders WHERE customer_id IN (SELECT id FROM active_customers);

-- Using a Derived Table

SELECT e.department_id, e.salary, d.avg_salary
FROM employees e
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) d ON e.department_id = d.department_id;

-- Using CTE

WITH dept_avg AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.department_id, e.salary, a.avg_salary
FROM employees e
JOIN dept_avg a ON e.department_id = a.department_id;








