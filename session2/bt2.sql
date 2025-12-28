USE session02;

DROP TABLE IF EXISTS subject;
DROP TABLE IF EXISTS student;

CREATE TABLE student (
    student_id CHAR(10) PRIMARY KEY, 
    full_name  VARCHAR(80) NOT NULL
);


CREATE TABLE subject (
    subject_id   CHAR(10) PRIMARY KEY, 
    subject_name VARCHAR(80) NOT NULL,
    credits      INT NOT NULL,
    CHECK (credits > 0)                
);
