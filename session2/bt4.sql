USE session02;

CREATE TABLE teacher (
    teacher_id CHAR(10) PRIMARY KEY,
    full_name  VARCHAR(80) NOT NULL,
    email      VARCHAR(100) NOT NULL UNIQUE
);

ALTER TABLE subject
ADD COLUMN teacher_id CHAR(10) NOT NULL;

ALTER TABLE subject
ADD CONSTRAINT fk_subject_teacher
FOREIGN KEY (teacher_id)
REFERENCES teacher(teacher_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;
