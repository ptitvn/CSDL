USE session03;

INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES
(6, 'Võ Minh Khang', '2002-10-12', 'khang.vo@gmail.com');

SELECT *
FROM Student;


INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES
(6, 1, '2025-12-29'),
(6, 2, '2025-12-29');

INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES
(6, 3, '2025-12-29');

SELECT *
FROM Enrollment;

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES
(6, 1, 7.5, 8.0),
(6, 2, 6.5, 7.0);

UPDATE Score
SET final_score = 8.5
WHERE student_id = 6 AND subject_id = 2;

SELECT *
FROM Score;


DELETE FROM Enrollment
WHERE student_id = 6 AND subject_id = 3;


SELECT *
FROM Enrollment;


SELECT student_id, subject_id, mid_score, final_score
FROM Score;

SELECT student_id, subject_id, mid_score, final_score
FROM Score
WHERE student_id = 6;
