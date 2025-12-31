DROP DATABASE IF EXISTS session03;
CREATE DATABASE session03;
USE session03;

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(150) UNIQUE
);

INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES
(1 , 'Nguyễn Văn An', '2002-05-10', 'an.nguyen@gmail.com'),
(2 , 'Trần Thị Bình', '2001-08-22', 'binh.tran@gmail.com'),
(3 , 'Lê Văn Cường', '2003-01-15', 'cuong.le@gmail.com');

SELECT * FROM Student;

SELECT student_id, full_name
FROM Student;
