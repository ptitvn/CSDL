USE session02;

DROP TABLE IF EXISTS score;
DROP TABLE IF EXISTS enrollment;
DROP TABLE IF EXISTS subject;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS class;

CREATE TABLE class (
    class_id    CHAR(10) PRIMARY KEY,
    class_name  VARCHAR(50) NOT NULL UNIQUE,
    school_year SMALLINT NOT NULL,
    CONSTRAINT chk_class_year CHECK (school_year BETWEEN 2000 AND 2100)
);

CREATE TABLE student (
    student_id CHAR(10) PRIMARY KEY,
    full_name  VARCHAR(80) NOT NULL,
    dob        DATE NOT NULL,
    class_id   CHAR(10) NOT NULL,

    CONSTRAINT fk_student_class
        FOREIGN KEY (class_id)
        REFERENCES class(class_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE INDEX idx_student_class_id ON student(class_id);

CREATE TABLE teacher (
    teacher_id CHAR(10) PRIMARY KEY,
    full_name  VARCHAR(80) NOT NULL,
    email      VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE subject (
    subject_id   CHAR(10) PRIMARY KEY,
    subject_name VARCHAR(80) NOT NULL,
    credits      INT NOT NULL,
    teacher_id   CHAR(10) NOT NULL,

    CONSTRAINT chk_subject_credits CHECK (credits > 0),

    CONSTRAINT fk_subject_teacher
        FOREIGN KEY (teacher_id)
        REFERENCES teacher(teacher_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE INDEX idx_subject_teacher_id ON subject(teacher_id);

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

CREATE INDEX idx_enroll_subject_id ON enrollment(subject_id);

CREATE TABLE score (
    student_id    CHAR(10) NOT NULL,
    subject_id    CHAR(10) NOT NULL,
    process_score DECIMAL(4,2) NOT NULL,
    final_score   DECIMAL(4,2) NOT NULL,

    -- Mỗi SV chỉ có 1 kết quả cho mỗi môn
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

CREATE INDEX idx_score_subject_id ON score(subject_id);
