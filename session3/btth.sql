INSERT INTO SinhVien (student_id, full_name, date_of_birth, gender, email, phone)
VALUES
(1, 'Nguyen Van An', '2002-05-10', 'M', 'an.nguyen@gmail.com', '0901234567'),
(2, 'Tran Thi Binh', '2001-11-22', 'F', 'binh.tran@gmail.com', '0912345678'),
(3, 'Le Minh Chau', '2002-03-15', 'F', 'chau.le@gmail.com', '0923456789'),
(4, 'Pham Quoc Dat', '2000-08-01', 'M', 'dat.pham@gmail.com', '0934567890'),
(5, 'Hoang Gia Huy', '2001-12-30', 'M', 'huy.hoang@gmail.com', '0945678901'),
(6, 'Vo Thi Kim', '2002-07-19', 'F', 'kim.vo@gmail.com', '0908887776'),
(7, 'Do Minh Long', '2001-09-09', 'M', 'long.do@gmail.com', '0977111222'),
(8, 'Bui Thi Mai', '2003-01-25', 'F', 'mai.bui@gmail.com', '0988123456'),
(9, 'Nguyen Quoc Nam', '2002-10-02', 'M', 'nam.nguyen@gmail.com', '0966333444'),
(10, 'Tran Thanh Nga', '2001-04-14', 'F', 'nga.tran@gmail.com', '0955000111');
INSERT INTO MonHoc (course_id, course_name, credits)
VALUES
(101, 'Database Fundamentals', 3),
(102, 'SQL Basic', 2),
(103, 'SQL Advanced', 3),
(104, 'Java Programming', 4),
(105, 'Web Development', 3),
(106, 'Data Structures', 4),
(107, 'Operating Systems', 3),
(108, 'Computer Networks', 3),
(109, 'Software Engineering', 3),
(110, 'Information Systems', 2);
INSERT INTO DangKy (registration_id, student_id, course_id, semester, registration_date)
VALUES
(1001, 1, 101, '2024HK1', '2024-01-05'),
(1002, 2, 102, '2024HK1', '2024-01-06'),
(1003, 3, 103, '2024HK1', '2024-01-06'),
(1004, 4, 104, '2024HK1', '2024-01-07'),
(1005, 5, 105, '2024HK1', '2024-01-07'),
(1006, 6, 106, '2024HK1', '2024-01-08'),
(1007, 7, 107, '2024HK2', '2024-06-03'),
(1008, 8, 108, '2024HK2', '2024-06-03'),
(1009, 9, 109, '2024HK2', '2024-06-04'),
(1010, 10, 110, '2024HK2', '2024-06-04');
SELECT student_id, full_name
FROM SinhVien;

SELECT course_name, credits
FROM MonHoc;

SELECT student_id, course_id
FROM DangKy;

UPDATE SinhVien
SET email = 'an.nguyen02@gmail.com'
WHERE student_id = 1;

UPDATE MonHoc
SET credits = 4
WHERE course_id = 105;

DELETE FROM DangKy
WHERE registration_id = 1010;

DELETE FROM DangKy
WHERE student_id = 5;

DELETE FROM SinhVien
WHERE student_id = 5;

