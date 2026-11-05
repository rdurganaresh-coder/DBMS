```sql
CREATE DATABASE ecommerce_db;
USE ecommerce_db;
```

#  Users Table
```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
# Categories Table
```sql
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);
```
# Products Table
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);
```
# Orders Table
```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
```
# Order Items Table
```sql
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);
```
# Payments Table
```sql
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT UNIQUE,
    payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash on Delivery') NOT NULL,
    payment_status ENUM('Pending', 'Completed', 'Failed', 'Refunded') DEFAULT 'Pending',
    transaction_id VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);
```
# Shipments Table
```sql
CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT UNIQUE,
    tracking_number VARCHAR(50) UNIQUE,
    shipping_status ENUM('Pending', 'Dispatched', 'In Transit', 'Delivered') DEFAULT 'Pending',
    estimated_delivery DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);
```

#  Insert Commands
```sql
INSERT INTO users (name, email, password, phone, address) VALUES
('John Doe', 'john@example.com', 'password123', '1234567890', '123 Main St, NY'),
('Jane Smith', 'jane@example.com', 'password123', '0987654321', '456 Elm St, CA'),
('Alice Johnson', 'alice@example.com', 'password123', '9876543210', '789 Oak St, TX');

INSERT INTO categories (name, description) VALUES
('Electronics', 'Devices and gadgets'),
('Clothing', 'Men and Women clothing'),
('Books', 'Various kinds of books');

INSERT INTO products (name, description, price, stock, category_id) VALUES
('Laptop', 'High performance laptop', 899.99, 10, 1),
('Smartphone', 'Latest model smartphone', 499.99, 20, 1),
('T-shirt', '100% Cotton T-shirt', 19.99, 50, 2),
('Novel', 'Bestselling fiction novel', 9.99, 100, 3);

INSERT INTO orders (user_id, total_price, status) VALUES
(1, 519.98, 'Processing'),
(2, 899.99, 'Pending'),
(3, 19.99, 'Shipped');

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 2, 1, 499.99),
(1, 3, 1, 19.99),
(2, 1, 1, 899.99),
(3, 3, 1, 19.99);

INSERT INTO payments (order_id, payment_method, payment_status, transaction_id) VALUES
(1, 'Credit Card', 'Completed', 'TXN123456'),
(2, 'PayPal', 'Pending', 'TXN123457'),
(3, 'Cash on Delivery', 'Completed', NULL);

INSERT INTO shipments (order_id, tracking_number, shipping_status, estimated_delivery) VALUES
(1, 'TRACK123456', 'Dispatched', '2025-02-20'),
(2, 'TRACK123457', 'Pending', '2025-02-25'),
(3, 'TRACK123458', 'In Transit', '2025-02-18');
```

# SQL Practice Questions & Answers

## Core Concepts

### 1. SELECT * FROM
**Goal:** Fetch all details of employees who belong to the 'Sales' department.
```sql
SELECT * 
FROM employees 
WHERE department = 'Sales';
```

### 2. SELECT DISTINCT
**Goal:** List all unique payment modes used in transactions.
```sql
SELECT DISTINCT payment_mode 
FROM transactions;
```

### 3. COUNT
**Goal:** Count the number of employees in each department.
```sql
SELECT department, COUNT(*) AS total_employees 
FROM employees 
GROUP BY department;
```

### 4. Alias (AS)
**Goal:** Display employee names and their salary incremented by 10% as "New Salary".
```sql
SELECT emp_name, salary * 1.10 AS "New Salary" 
FROM employees;
```

### 5. WHERE
**Goal:** Get details of students who scored above 80 and are in grade 'A'.
```sql
SELECT * 
FROM students 
WHERE score > 80 AND grade = 'A';
```

### 6. LIMIT and ORDER BY
**Goal:** Retrieve the names of the top 3 highest scoring students.
```sql
SELECT student_name, score 
FROM students 
ORDER BY score DESC 
LIMIT 3;
```

### 7. Operators and Filtering
**Goal:** Get the employees who are either in 'HR' or 'IT' department and earn more than 70,000.
```sql
SELECT * 
FROM employees 
WHERE department IN ('HR', 'IT') AND salary > 70000;
```

### 8. BETWEEN, IN, LIKE, and ILIKE
**Goal:** Fetch products with prices between 100 and 500.
```sql
SELECT * 
FROM products 
WHERE price BETWEEN 100 AND 500;
```

### 9. CASE, IF, ELSE
**Goal:** Show the product name and its availability status as 'In Stock' if quantity > 0, else 'Out of Stock'.
```sql
SELECT product_name, 
       CASE 
           WHEN quantity > 0 THEN 'In Stock' 
           ELSE 'Out of Stock' 
       END AS availability 
FROM inventory;
```

### 10. COALESCE and NULLIF
**Goal:** Display customer names and delivery dates, but if the delivery date is NULL, show 'Not Delivered'.
```sql
SELECT customer_name, COALESCE(delivery_date, 'Not Delivered') AS delivery_status 
FROM orders_v2;
```

---

## Advanced Challenges

### 1. Combining Concepts
**Goal:** Retrieve all products whose names contain 'a' (case insensitive) and are priced between 50 and 200, ordered by price in ascending order.
```sql
SELECT * 
FROM products 
WHERE product_name ILIKE '%a%' AND price BETWEEN 50 AND 200 
ORDER BY price ASC;
```

### 2. Using CASE with Aggregate
**Goal:** Count the number of students in each grade and label it as 'High Count' if more than 1 student, otherwise 'Low Count'.
```sql
SELECT grade, 
       COUNT(*) AS student_count, 
       CASE 
           WHEN COUNT(*) > 1 THEN 'High Count' 
           ELSE 'Low Count' 
       END AS count_category 
FROM students 
GROUP BY grade;
```

### 3. Using COALESCE and NULLIF Together
**Goal:** Display employee names and their bonus (salary * 0.1). If the salary is NULL, show the bonus as 0. If the bonus is 0, show it as NULL.
```sql
SELECT emp_name, 
       NULLIF(COALESCE(salary * 0.1, 0), 0) AS bonus 
FROM employees;
```