/* ================================
   FILE: ecommerce_subquery_project.sql
   CHỦ ĐỀ: THƯƠNG MẠI ĐIỆN TỬ
   ================================ */

-- 1. Tạo Database
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- 2. Xóa bảng nếu đã tồn tại (để chạy lại nhiều lần)
DROP TABLE IF EXISTS CHI_TIET_DON_HANG;
DROP TABLE IF EXISTS DON_HANG;
DROP TABLE IF EXISTS SAN_PHAM;
DROP TABLE IF EXISTS KHACH_HANG;

-- 3. Tạo bảng KHACH_HANG
CREATE TABLE KHACH_HANG (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50)
);

-- 4. Tạo bảng SAN_PHAM
CREATE TABLE SAN_PHAM (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(12,2)
);

-- 5. Tạo bảng DON_HANG
CREATE TABLE DON_HANG (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES KHACH_HANG(customer_id)
);

-- 6. Tạo bảng CHI_TIET_DON_HANG
CREATE TABLE CHI_TIET_DON_HANG (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES DON_HANG(order_id),
    FOREIGN KEY (product_id) REFERENCES SAN_PHAM(product_id)
);

-- 7. Dữ liệu mẫu KHACH_HANG
INSERT INTO KHACH_HANG VALUES
(1, 'Nguyen Van A', 'Ha Noi'),
(2, 'Tran Thi B', 'Da Nang'),
(3, 'Le Van C', 'HCM'),
(4, 'Pham Thi D', 'Ha Noi'),
(5, 'Hoang Van E', 'Can Tho');

-- 8. Dữ liệu mẫu SAN_PHAM
INSERT INTO SAN_PHAM VALUES
(101, 'Laptop Dell', 'Electronics', 20000000),
(102, 'iPhone 14', 'Electronics', 25000000),
(103, 'Tai nghe Bluetooth', 'Accessories', 1500000),
(104, 'Ban phim co', 'Accessories', 2000000),
(105, 'Man hinh 27 inch', 'Electronics', 7000000),
(106, 'Chuot khong day', 'Accessories', 800000);

-- 9. Dữ liệu mẫu DON_HANG
INSERT INTO DON_HANG VALUES
(1001, 1, '2024-01-10'),
(1002, 2, '2024-01-12'),
(1003, 1, '2024-01-15'),
(1004, 3, '2024-01-18'),
(1005, 4, '2024-01-20'),
(1006, 5, '2024-01-22');

-- 10. Dữ liệu mẫu CHI_TIET_DON_HANG
INSERT INTO CHI_TIET_DON_HANG VALUES
(1001, 101, 1),
(1001, 103, 2),

(1002, 102, 1),

(1003, 104, 1),
(1003, 103, 1),

(1004, 101, 1),
(1004, 106, 2),

(1005, 105, 1),

(1006, 103, 3),
(1006, 106, 1);

/* ================================
   KẾT THÚC FILE
   ================================ */
   
   
   
-- 1.1
SELECT
  sp.product_id,
  sp.product_name,
  sp.category,
  sp.price
FROM SAN_PHAM sp
WHERE sp.price > (SELECT AVG(price) FROM SAN_PHAM);

-- 1.2
SELECT
  sp.product_id,
  sp.product_name,
  sp.category,
  (SELECT IFNULL(SUM(ct.quantity),0)
   FROM CHI_TIET_DON_HANG ct
   WHERE ct.product_id = sp.product_id) AS total_sold
FROM SAN_PHAM sp
WHERE (SELECT IFNULL(SUM(ct.quantity),0)
       FROM CHI_TIET_DON_HANG ct
       WHERE ct.product_id = sp.product_id)
  <
  (SELECT AVG(t.total_sold)
   FROM (
     SELECT product_id, SUM(quantity) AS total_sold
     FROM CHI_TIET_DON_HANG
     GROUP BY product_id
   ) t);

-- 2.1
SELECT
  kh.customer_id,
  kh.customer_name,
  kh.city,
  (
    SELECT IFNULL(SUM(
      ct.quantity * (SELECT sp.price FROM SAN_PHAM sp WHERE sp.product_id = ct.product_id)
    ), 0)
    FROM CHI_TIET_DON_HANG ct
    WHERE (SELECT dh.customer_id FROM DON_HANG dh WHERE dh.order_id = ct.order_id) = kh.customer_id
  ) AS total_spent
FROM KHACH_HANG kh
WHERE
  (
    SELECT IFNULL(SUM(
      ct.quantity * (SELECT sp.price FROM SAN_PHAM sp WHERE sp.product_id = ct.product_id)
    ), 0)
    FROM CHI_TIET_DON_HANG ct
    WHERE (SELECT dh.customer_id FROM DON_HANG dh WHERE dh.order_id = ct.order_id) = kh.customer_id
  )
  >
  (
    SELECT AVG(x.total_spent)
    FROM (
      SELECT
        (SELECT dh.customer_id FROM DON_HANG dh WHERE dh.order_id = ct.order_id) AS customer_id,
        SUM(ct.quantity * (SELECT sp.price FROM SAN_PHAM sp WHERE sp.product_id = ct.product_id)) AS total_spent
      FROM CHI_TIET_DON_HANG ct
      GROUP BY customer_id
    ) x
  );


-- 2.2
SELECT
  kh.customer_id,
  kh.customer_name,
  kh.city
FROM KHACH_HANG kh
WHERE NOT EXISTS (
  SELECT 1
  FROM CHI_TIET_DON_HANG ct
  WHERE (SELECT dh.customer_id FROM DON_HANG dh WHERE dh.order_id = ct.order_id) = kh.customer_id
    AND (SELECT sp.price FROM SAN_PHAM sp WHERE sp.product_id = ct.product_id)
        <= (SELECT AVG(price) FROM SAN_PHAM)
)
AND EXISTS (
  -- đảm bảo khách này có phát sinh mua hàng (tránh trường hợp chưa mua gì mà vẫn “đúng”)
  SELECT 1
  FROM DON_HANG dh
  WHERE dh.customer_id = kh.customer_id
);

-- 3.1
SELECT
  dh.order_id,
  dh.customer_id,
  dh.order_date,
  (SELECT SUM(ct.quantity) FROM CHI_TIET_DON_HANG ct WHERE ct.order_id = dh.order_id) AS total_qty
FROM DON_HANG dh
WHERE
  (SELECT SUM(ct.quantity) FROM CHI_TIET_DON_HANG ct WHERE ct.order_id = dh.order_id)
  >
  (SELECT AVG(t.total_qty)
   FROM (
     SELECT order_id, SUM(quantity) AS total_qty
     FROM CHI_TIET_DON_HANG
     GROUP BY order_id
   ) t);
-- 3.2
SELECT
  dh.order_id,
  dh.customer_id,
  dh.order_date,
  (SELECT SUM(ct.quantity) FROM CHI_TIET_DON_HANG ct WHERE ct.order_id = dh.order_id) AS total_qty
FROM DON_HANG dh
WHERE
  (SELECT SUM(ct.quantity) FROM CHI_TIET_DON_HANG ct WHERE ct.order_id = dh.order_id)
  =
  (
    SELECT MAX(t2.total_qty)
    FROM (
      SELECT order_id, SUM(quantity) AS total_qty
      FROM CHI_TIET_DON_HANG
      GROUP BY order_id
    ) t2
    WHERE t2.total_qty >
      (SELECT AVG(t1.total_qty)
       FROM (
         SELECT order_id, SUM(quantity) AS total_qty
         FROM CHI_TIET_DON_HANG
         GROUP BY order_id
       ) t1)
  );
  
-- 4
SELECT
  sp.category,
  sp.product_id,
  sp.product_name,
  sp.price,
  (SELECT IFNULL(SUM(ct.quantity),0) FROM CHI_TIET_DON_HANG ct WHERE ct.product_id = sp.product_id) * sp.price
    AS revenue
FROM SAN_PHAM sp
WHERE
  (SELECT IFNULL(SUM(ct.quantity),0) FROM CHI_TIET_DON_HANG ct WHERE ct.product_id = sp.product_id) * sp.price
  =
  (
    SELECT MAX(
      (SELECT IFNULL(SUM(ct2.quantity),0) FROM CHI_TIET_DON_HANG ct2 WHERE ct2.product_id = sp2.product_id) * sp2.price
    )
    FROM SAN_PHAM sp2
    WHERE sp2.category = sp.category
  );
