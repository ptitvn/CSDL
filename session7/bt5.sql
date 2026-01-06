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
(401, 1, '2025-12-01', 1200000.00),
(402, 1, '2025-12-05',  800000.00),
(403, 2, '2025-12-03', 2500000.00),
(404, 2, '2025-12-10',  900000.00),
(405, 3, '2025-12-12', 3200000.00),
(406, 4, '2025-12-15',  700000.00),
(407, 5, '2025-12-18', 1100000.00),
(408, 3, '2025-12-20', 1500000.00);

SELECT id, name, email
FROM customers
WHERE id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) = (
        SELECT MAX(total_spent)
        FROM (
            SELECT customer_id, SUM(total_amount) AS total_spent
            FROM orders
            GROUP BY customer_id
        ) AS t
    )
);
