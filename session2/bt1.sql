USE session02;

DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS class;

CREATE TABLE class (
    class_id CHAR(10) PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    school_year SMALLINT NOT NULL
);

CREATE TABLE student (
    student_id CHAR(10) PRIMARY KEY,
    full_name VARCHAR(80) NOT NULL,
    dob DATE NOT NULL,
    class_id CHAR(10) NOT NULL,
    CONSTRAINT fk_student_class
        FOREIGN KEY (class_id)
        REFERENCES class(class_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

INSERT INTO class VALUES ('C01', 'Lớp 10A1', 2025);
INSERT INTO student VALUES ('SV01', 'Nguyễn Văn A', '2008-05-10', 'C01');

SELECT * FROM class;
SELECT * FROM student;
