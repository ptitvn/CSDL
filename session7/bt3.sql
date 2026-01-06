CREATE DATABASE session7;
USE session7;

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL
);

INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(201, 1, '2025-12-01', 1200000.00),
(202, 2, '2025-12-03',  350000.00),
(203, 3, '2025-12-05', 2500000.00),
(204, 1, '2025-12-10',  900000.00),
(205, 4, '2025-12-12', 3200000.00),
(206, 2, '2025-12-15',  700000.00);

SELECT id, customer_id, order_date, total_amount
FROM orders
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM orders
);
