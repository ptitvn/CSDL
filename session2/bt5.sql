USE session02;

DROP TABLE IF EXISTS score;

CREATE TABLE score (
    student_id     CHAR(10) NOT NULL,
    subject_id     CHAR(10) NOT NULL,
    process_score  DECIMAL(4,2) NOT NULL, 
    final_score    DECIMAL(4,2) NOT NULL,  

    PRIMARY KEY (student_id, subject_id),

    CONSTRAINT fk_score_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_score_subject
        FOREIGN KEY (subject_id)
        REFERENCES subject(subject_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT chk_process_score CHECK (process_score BETWEEN 0 AND 10),
    CONSTRAINT chk_final_score   CHECK (final_score BETWEEN 0 AND 10)
);
