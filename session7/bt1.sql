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
(5, 'Vo Thanh Em', 'em@gmail.com'),
(6, 'Hoang Gia Huy', 'huy@gmail.com'),
(7, 'Do Ngoc Khang', 'khang@gmail.com');

INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(101, 1, '2025-12-01', 1500000.00),
(102, 2, '2025-12-03', 350000.00),
(103, 1, '2025-12-10', 990000.00),
(104, 3, '2025-12-15', 2200000.00),
(105, 4, '2025-12-20', 780000.00),
(106, 2, '2025-12-25', 1300000.00),
(107, 6, '2025-12-28', 450000.00);

SELECT id, name, email
FROM customers
WHERE id IN (
    SELECT customer_id
    FROM orders
);
