CREATE DATABASE session7;
USE session7;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

INSERT INTO customers (id, name, email) VALUES
(1, 'Nguyen Van An', 'an@gmail.com'),
(2, 'Tran Thi Bich', 'bich@gmail.com'),
(3, 'Le Minh Chau', 'chau@gmail.com'),
(4, 'Pham Quang Duy', 'duy@gmail.com'),
(5, 'Vo Thanh Em', 'em@gmail.com');

INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(301, 1, '2025-12-01', 1200000.00),
(302, 1, '2025-12-03',  350000.00),
(303, 2, '2025-12-05', 2500000.00),
(304, 3, '2025-12-10',  900000.00),
(305, 3, '2025-12-12', 3200000.00),
(306, 3, '2025-12-15',  700000.00),
(307, 5, '2025-12-18', 1100000.00);

SELECT
    c.name AS customer_name,
    (
        SELECT COUNT(*)
        FROM orders o
        WHERE o.customer_id = c.id
    ) AS order_count
FROM customers c;
