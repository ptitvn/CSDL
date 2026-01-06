CREATE DATABASE session7;
USE session7;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(12,2) NOT NULL
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL
);

INSERT INTO products (id, name, price) VALUES
(1, 'Laptop', 15000000),
(2, 'Mouse', 250000),
(3, 'Keyboard', 550000),
(4, 'Monitor', 3500000),
(5, 'Printer', 4200000),
(6, 'USB Cable', 120000),
(7, 'Headphone', 890000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(101, 1, 1),
(101, 2, 2),
(102, 3, 1),
(103, 1, 1),
(104, 4, 2),
(105, 2, 1),
(106, 6, 3);

SELECT id, name, price
FROM products
WHERE id IN (
    SELECT product_id
    FROM order_items
);
