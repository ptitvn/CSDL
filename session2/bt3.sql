USE session02;

DROP TABLE IF EXISTS enrollment;

CREATE TABLE enrollment (
    student_id      CHAR(10) NOT NULL,
    subject_id      CHAR(10) NOT NULL,
    enrollment_date DATE NOT NULL,

    PRIMARY KEY (student_id, subject_id),

    CONSTRAINT fk_enroll_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_enroll_subject
        FOREIGN KEY (subject_id)
        REFERENCES subject(subject_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE INDEX idx_enroll_subject ON enrollment(subject_id);

