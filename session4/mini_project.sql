
DROP DATABASE IF EXISTS session4;
CREATE DATABASE IF NOT EXISTS session4;
USE session4;

CREATE TABLE student (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    CONSTRAINT chk_student_dob CHECK (date_of_birth <= CURRENT_DATE)
);

CREATE TABLE teacher (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE course (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    total_sessions INT NOT NULL,
    teacher_id INT NOT NULL,
    CONSTRAINT chk_course_sessions CHECK (total_sessions > 0),
    CONSTRAINT fk_course_teacher FOREIGN KEY (teacher_id)
        REFERENCES teacher(teacher_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enroll_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT uq_enrollment UNIQUE (student_id, course_id),
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id)
        REFERENCES student(student_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_enroll_course FOREIGN KEY (course_id)
        REFERENCES course(course_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE score (
    score_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    mid_score DECIMAL(3,1) NOT NULL,
    final_score DECIMAL(3,1) NOT NULL,
    CONSTRAINT chk_mid_score CHECK (mid_score BETWEEN 0 AND 10),
    CONSTRAINT chk_final_score CHECK (final_score BETWEEN 0 AND 10),
    CONSTRAINT uq_score UNIQUE (student_id, course_id),
    CONSTRAINT fk_score_student FOREIGN KEY (student_id)
        REFERENCES student(student_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_score_course FOREIGN KEY (course_id)
        REFERENCES course(course_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);



INSERT INTO teacher(full_name, email) VALUES
('Do Thanh Ha', 'ha.gv@uni.edu'),
('Nguyen Quoc Huy', 'huy.gv@uni.edu'),
('Tran Hong Lan', 'lan.gv@uni.edu'),
('Le Tuan Minh', 'minh.gv@uni.edu'),
('Pham Ngoc Son', 'son.gv@uni.edu');

INSERT INTO course(course_name, description, total_sessions, teacher_id) VALUES
('SQL Co Ban', 'Hoc DDL/DML, rang buoc, truy van', 10, 1),
('Lap Trinh Web', 'HTML/CSS/JS co ban', 12, 2),
('Cau Truc Du Lieu', 'Mang, danh sach, ngan xep, hang doi', 14, 3),
('Java Core', 'OOP, class, interface', 15, 4),
('Python Co Ban', 'Cu phap, ham, list/dict', 10, 5);

INSERT INTO student(full_name, date_of_birth, email) VALUES
('Nguyen Van An', '2004-03-12', 'an.sv@uni.edu'),
('Tran Thi Bich', '2003-11-02', 'bich.sv@uni.edu'),
('Le Minh Chau', '2004-07-20', 'chau.sv@uni.edu'),
('Pham Quang Duy', '2003-09-15', 'duy.sv@uni.edu'),
('Vo Thi Em', '2004-01-08', 'em.sv@uni.edu');

INSERT INTO enrollment(student_id, course_id, enroll_date) VALUES
(1, 1, '2025-12-01'),
(1, 2, '2025-12-02'),
(2, 1, '2025-12-01'),
(3, 3, '2025-12-03'),
(4, 4, '2025-12-04'),
(5, 5, '2025-12-05');

INSERT INTO score(student_id, course_id, mid_score, final_score) VALUES
(1, 1, 7.5, 8.2),
(1, 2, 6.5, 7.0),
(2, 1, 8.0, 8.5),
(3, 3, 7.0, 7.7),
(4, 4, 6.8, 7.2);


UPDATE student
SET email = 'an.new@uni.edu'
WHERE student_id = 1;

UPDATE course
SET description = 'SQL: CREATE/ALTER/DROP, INSERT/UPDATE/DELETE, SELECT, JOIN'
WHERE course_id = 1;

UPDATE score
SET final_score = 9.0
WHERE student_id = 2 AND course_id = 1;


DELETE FROM score
WHERE student_id = 1 AND course_id = 2;

DELETE FROM enrollment
WHERE student_id = 1 AND course_id = 2;



SELECT student_id, full_name, date_of_birth, email
FROM student;

SELECT teacher_id, full_name, email
FROM teacher;

SELECT course_id, course_name, description, total_sessions, teacher_id
FROM course;

SELECT enrollment_id, student_id, course_id, enroll_date
FROM enrollment;

SELECT score_id, student_id, course_id, mid_score, final_score
FROM score;
