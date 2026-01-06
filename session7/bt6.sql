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
(501, 1, '2025-12-01', 1200000.00),
(502, 1, '2025-12-05',  800000.00),
(503, 2, '2025-12-03', 2500000.00),
(504, 2, '2025-12-10',  900000.00),
(505, 3, '2025-12-12', 3200000.00),
(506, 3, '2025-12-20', 1500000.00),
(507, 4, '2025-12-15',  700000.00),
(508, 5, '2025-12-18', 1100000.00);

SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > (
    SELECT AVG(total_spent)
    FROM (
        SELECT customer_id, SUM(total_amount) AS total_spent
        FROM orders
        GROUP BY customer_id
    ) AS t
);
