-- Create and use database
CREATE DATABASE E_Commerce;
USE E_Commerce;

-- 1. Create tables with constraints
CREATE TABLE categories (
    category_id SMALLINT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE order_status (
    status_id SMALLINT PRIMARY KEY AUTO_INCREMENT,
    status_code VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE carriers (
    carrier_id SMALLINT PRIMARY KEY AUTO_INCREMENT,
    carrier_name VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id SMALLINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    stock_qty INT DEFAULT 0,
    reorder_level INT DEFAULT 5,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    status_id SMALLINT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    shipped_date DATETIME,
    total_amount DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE cart_items (
    cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL UNIQUE,
    carrier_id SMALLINT NOT NULL,
    tracking_number VARCHAR(60),
    shipped_at DATETIME,
    delivered_at DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (carrier_id) REFERENCES carriers(carrier_id)
);
-- Create transactions table with foreign keys
CREATE TABLE transactions (
    t_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(12,2) NOT NULL,
    status ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Add index for better query performance
CREATE INDEX idx_transactions_customer ON transactions(customer_id);
CREATE INDEX idx_transactions_product ON transactions(product_id);
CREATE INDEX idx_transactions_status ON transactions(status);

-- 2. Create indexes
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_inventory_stock ON inventory(stock_qty);
CREATE INDEX idx_orders_customer_status ON orders(customer_id, status_id);
CREATE INDEX idx_cart_items_customer ON cart_items(customer_id);

-- 3. Insert sample data
-- Categories
INSERT INTO categories (category_name) VALUES
('Electronics'), ('Books'), ('Apparel'), ('Home & Kitchen'), ('Sports'),
('Toys'), ('Beauty'), ('Automotive'), ('Garden'), ('Health');

-- Order Status
INSERT INTO order_status (status_code) VALUES
('PLACED'), ('PAID'), ('SHIPPED'), ('DELIVERED'), ('CANCELLED'),
('RETURNED'), ('PROCESSING'), ('ON_HOLD'), ('FAILED'), ('REFUNDED');

-- Carriers
INSERT INTO carriers (carrier_name) VALUES
('DHL'), ('FedEx'), ('USPS'), ('UPS'), ('BlueDart'),
('Amazon Logistics'), ('Canada Post'), ('TNT'), ('Hermes'), ('Royal Mail');

-- Customers
INSERT INTO customers (first_name, last_name, email, phone) VALUES
('John', 'Smith', 'john.smith@example.com', '555-0101'),
('Sarah', 'Johnson', 'sarah.j@example.com', '555-0102'),
('Michael', 'Williams', 'michael.w@example.com', '555-0103'),
('Emily', 'Brown', 'emily.b@example.com', '555-0104'),
('David', 'Jones', 'david.j@example.com', '555-0105'),
('Jessica', 'Garcia', 'jessica.g@example.com', '555-0106'),
('Daniel', 'Miller', 'daniel.m@example.com', '555-0107'),
('Jennifer', 'Davis', 'jennifer.d@example.com', '555-0108'),
('Robert', 'Rodriguez', 'robert.r@example.com', '555-0109'),
('Lisa', 'Martinez', 'lisa.m@example.com', '555-0110'),
('Aarav', 'Sharma', 'aarav.sharma@example.com', '555-0101'),
('Isha', 'Verma', 'isha.verma@example.com', '555-0102'),
('Rohan', 'Mehta', 'rohan.mehta@example.com', '555-0103'),
('Ananya', 'Singh', 'ananya.singh@example.com', '555-0104'),
('Vivaan', 'Patel', 'vivaan.patel@example.com', '555-0105'),
('Priya', 'Reddy', 'priya.reddy@example.com', '555-0106'),
('Aditya', 'Kumar', 'aditya.kumar@example.com', '555-0107'),
('Sneha', 'Joshi', 'sneha.joshi@example.com', '555-0108'),
('Krishna', 'Nair', 'krishna.nair@example.com', '555-0109'),
('Meera', 'Desai', 'meera.desai@example.com', '555-0110');

-- Products
INSERT INTO products (category_id, name, description, price, active) VALUES
(1, 'Smartphone X', 'Latest smartphone with 128GB storage', 799.99, TRUE),
(1, 'Wireless Earbuds', 'Noise cancelling wireless earbuds', 149.99, TRUE),
(2, 'Database Design Book', 'Comprehensive guide to database design', 59.99, TRUE),
(2, 'Web Development Guide', 'Complete web development handbook', 49.99, TRUE),
(3, 'Men\'s T-Shirt', '100% cotton crew neck t-shirt', 24.99, TRUE),
(3, 'Women\'s Jeans', 'Slim fit blue jeans', 59.99, TRUE),
(4, 'Blender', 'High-speed kitchen blender', 89.99, TRUE),
(4, 'Air Fryer', 'Digital air fryer with 5QT capacity', 129.99, TRUE),
(5, 'Yoga Mat', 'Non-slip yoga mat 6mm thick', 29.99, TRUE),
(5, 'Dumbbell Set', 'Adjustable 20lb dumbbell set', 79.99, TRUE);

-- Inventory
INSERT INTO inventory (product_id, stock_qty, reorder_level) VALUES
(1, 15, 5), (2, 8, 10), (3, 20, 5), (4, 12, 5), (5, 30, 10),
(6, 18, 8), (7, 10, 5), (8, 6, 3), (9, 25, 10), (10, 7, 5);

-- Orders (with some older orders for reporting)
INSERT INTO orders (customer_id, status_id, order_date, shipped_date, total_amount) VALUES
(1, 2, '2025-05-01 10:00:00', NULL, 799.99),
(1, 3, '2025-05-10 09:30:00', '2025-05-11 12:00:00', 149.99),
(1, 4, '2025-04-15 14:00:00', '2025-04-16 09:00:00', 59.99),
(2, 2, '2025-05-05 11:15:00', NULL, 129.99),
(2, 3, '2025-05-12 13:45:00', '2025-05-13 10:30:00', 79.99),
(3, 1, '2025-05-15 16:20:00', NULL, 24.99),
(4, 5, '2025-04-20 08:30:00', NULL, 89.99),
(5, 2, '2025-05-08 14:10:00', NULL, 49.99),
(5, 3, '2025-05-14 10:45:00', '2025-05-15 08:00:00', 29.99),
(6, 4, '2025-04-25 12:00:00', '2025-04-26 14:00:00', 59.99),
(7, 2, '2025-05-03 09:00:00', NULL, 149.99),
(8, 3, '2025-05-11 15:30:00', '2025-05-12 11:00:00', 79.99),
(9, 1, '2025-05-16 10:20:00', NULL, 24.99),
(10, 2, '2025-05-07 13:00:00', NULL, 129.99);

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 799.99),
(2, 2, 1, 149.99),
(3, 3, 1, 59.99),
(4, 8, 1, 129.99),
(5, 10, 1, 79.99),
(6, 5, 1, 24.99),
(7, 7, 1, 89.99),
(8, 4, 1, 49.99),
(9, 9, 1, 29.99),
(10, 6, 1, 59.99),
(11, 2, 1, 149.99),
(12, 10, 1, 79.99),
(13, 5, 1, 24.99),
(14, 8, 1, 129.99);

-- Cart Items (some older than 7 days for abandoned cart query)
INSERT INTO cart_items (customer_id, product_id, quantity, added_at) VALUES
(1, 3, 1, '2025-05-10 08:00:00'),
(2, 1, 1, '2025-05-18 15:00:00'),
(3, 4, 2, '2025-05-19 09:00:00'),
(4, 5, 1, '2025-05-20 10:00:00'),
(5, 3, 3, '2025-05-18 11:30:00'),
(6, 7, 1, '2025-05-16 14:00:00'),
(7, 8, 2, '2025-05-17 12:00:00'),
(8, 9, 1, '2025-05-15 15:00:00'),
(9, 10, 1, '2025-05-20 16:00:00'),
(10, 1, 1, '2025-05-14 13:00:00'),
(3, 2, 1, '2025-05-05 09:00:00'), -- Older than 7 days
(5, 6, 1, '2025-05-04 14:30:00'); -- Older than 7 days

-- Shipments
INSERT INTO shipments (order_id, carrier_id, tracking_number, shipped_at, delivered_at) VALUES
(2, 1, 'DHL123456789', '2025-05-11 12:00:00', '2025-05-13 10:00:00'),
(3, 2, 'FDX987654321', '2025-04-16 09:00:00', '2025-04-18 14:00:00'),
(5, 3, 'USPS12345678', '2025-05-13 10:30:00', '2025-05-15 11:00:00'),
(9, 4, 'UPS87654321', '2025-05-15 08:00:00', '2025-05-17 09:30:00'),
(10, 5, 'BLD13579246', '2025-04-26 14:00:00', '2025-04-28 16:00:00'),
(12, 6, 'AMZ24681357', '2025-05-12 11:00:00', '2025-05-14 13:00:00');

-- Insert 25 sample transactions with varied statuses and amounts
INSERT INTO transactions (amount, status, payment_date, customer_id, product_id) VALUES
-- Completed transactions (aligned with existing orders)
(799.99, 'COMPLETED', '2025-05-01 10:05:22', 1, 1),
(149.99, 'COMPLETED', '2025-05-10 09:35:15', 1, 2),
(59.99, 'COMPLETED', '2025-04-15 14:03:45', 1, 3),
(129.99, 'COMPLETED', '2025-05-05 11:20:33', 2, 8),
(79.99, 'COMPLETED', '2025-05-12 13:50:18', 2, 10),
(24.99, 'COMPLETED', '2025-05-15 16:25:07', 3, 5),
(89.99, 'COMPLETED', '2025-04-20 08:35:42', 4, 7),
(49.99, 'COMPLETED', '2025-05-08 14:15:29', 5, 4),
(29.99, 'COMPLETED', '2025-05-14 10:50:11', 5, 9),
(59.99, 'COMPLETED', '2025-04-25 12:05:56', 6, 6),
(149.99, 'COMPLETED', '2025-05-03 09:05:38', 7, 2),
(79.99, 'COMPLETED', '2025-05-11 15:35:24', 8, 10),
(129.99, 'COMPLETED', '2025-05-07 13:10:47', 10, 8),

-- Failed transactions (card declines, etc.)
(799.99, 'FAILED', '2025-05-02 11:22:10', 1, 1), -- Retry of same product succeeded later
(149.99, 'FAILED', '2025-05-09 14:15:33', 2, 2), 
(89.99, 'FAILED', '2025-04-21 09:40:18', 4, 7), -- Later succeeded

-- Pending transactions (recent payments still processing)
(24.99, 'PENDING', NOW() - INTERVAL 30 MINUTE, 3, 5),
(59.99, 'PENDING', NOW() - INTERVAL 15 MINUTE, 6, 6),
(129.99, 'PENDING', NOW() - INTERVAL 5 MINUTE, 10, 8),

-- Refunded transactions
(79.99, 'REFUNDED', '2025-05-13 14:22:10', 2, 10), -- Partial return
(149.99, 'REFUNDED', '2025-05-04 16:45:29', 7, 2), -- Full refund
(59.99, 'REFUNDED', '2025-04-26 10:15:44', 6, 6), -- Wrong item shipped

-- Multiple transactions for same customer/product (testing relationships)
(29.99, 'COMPLETED', '2025-05-16 08:20:15', 9, 9), 
(29.99, 'COMPLETED', '2025-05-17 09:30:22', 9, 9), -- Repeat purchase
(24.99, 'COMPLETED', '2025-05-18 11:45:33', 3, 5); -- Different customer




-- 1. Product lookup
SELECT p.product_id, p.name, c.category_name, p.description, p.price, i.stock_qty
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN inventory i ON p.product_id = i.product_id
WHERE p.product_id = 1;

-- 2. Inventory warning
SELECT p.product_id, p.name, i.stock_qty, i.reorder_level
FROM products p
JOIN inventory i ON p.product_id = i.product_id
WHERE i.stock_qty < i.reorder_level;

-- 3. Customer order history
SELECT o.order_id, os.status_code, o.order_date, o.total_amount
FROM orders o
JOIN order_status os ON o.status_id = os.status_id
WHERE o.customer_id = 1
ORDER BY o.order_date;

-- 4. Best-selling items (last 30 days)
SELECT p.product_id, p.name, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY p.product_id, p.name
ORDER BY units_sold DESC
LIMIT 5;

-- 5. Revenue snapshot
SELECT SUM(total_amount) AS gross_revenue
FROM orders
WHERE order_date BETWEEN '2025-05-01' AND '2025-05-31';

-- 6. Abandoned carts
SELECT ci.cart_item_id, c.first_name, c.last_name, p.name AS product_name, ci.quantity, ci.added_at
FROM cart_items ci
JOIN customers c ON ci.customer_id = c.customer_id
JOIN products p ON ci.product_id = p.product_id
LEFT JOIN order_items oi ON oi.product_id = ci.product_id 
    AND oi.order_id IN (SELECT order_id FROM orders WHERE customer_id = ci.customer_id)
WHERE ci.added_at < DATE_SUB(CURDATE(), INTERVAL 7 DAY)
AND oi.order_item_id IS NULL;

-- 7. Average order value (AOV)
SELECT AVG(total_amount) AS avg_order_value
FROM orders
WHERE status_id IN (SELECT status_id FROM order_status WHERE status_code IN ('PAID', 'SHIPPED', 'DELIVERED'))
AND order_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

-- 8. Category performance
SELECT c.category_name, 
       SUM(oi.quantity * oi.unit_price) AS revenue,
       SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY c.category_name
ORDER BY revenue DESC;

-- 9. Repeat-purchase rate
SELECT 
    (COUNT(DISTINCT repeat_customers.customer_id) * 100.0 / 
    COUNT(DISTINCT all_customers.customer_id)) AS repeat_purchase_rate
FROM 
    (SELECT customer_id FROM orders GROUP BY customer_id HAVING COUNT(*) > 1) AS repeat_customers,
    (SELECT customer_id FROM orders) AS all_customers;

-- 10. Shipping delay monitor
SELECT o.order_id, c.first_name, c.last_name, 
       TIMESTAMPDIFF(HOUR, o.order_date, NOW()) AS hours_since_order
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status_id = (SELECT status_id FROM order_status WHERE status_code = 'PAID')
  AND o.shipped_date IS NULL
  AND TIMESTAMPDIFF(HOUR, o.order_date, NOW()) >= 48;
  
  -- 11. Payment failure rate
SELECT 
  (COUNT(CASE WHEN status = 'FAILED' THEN 1 END) * 100.0 / COUNT(*)) 
  AS failure_rate_percent
FROM transactions;

-- 12. Recent pending payments needing review
SELECT t.t_id, c.email, p.name, t.amount
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
JOIN products p ON t.product_id = p.product_id
WHERE t.status = 'PENDING'
AND t.payment_date < NOW() - INTERVAL 1 HOUR;

-- 13. total revenue
SELECT 
    SUM(amount) AS total_revenue
FROM 
    transactions
WHERE 
    status = 'COMPLETED';
