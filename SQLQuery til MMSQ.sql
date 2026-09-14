-- =============================================
-- Views & Functions -- T-SQL (MSSQL)
-- Kræver education-db-mssql.sql kørt først
-- =============================================

USE education;
GO

-- =============================================
-- VIEWS
-- =============================================

-- Øvelse 1: Studenteroverblik
IF OBJECT_ID('dbo.student_overview', 'V') IS NOT NULL DROP VIEW dbo.student_overview;
GO
CREATE VIEW student_overview AS
SELECT
    s.name AS student_name,
    p.name AS program_name,
    p.level AS program_level
FROM Students s
JOIN Programs p ON p.id = s.programId;
GO

SELECT * FROM student_overview WHERE program_level = 'Top-op';


-- Øvelse 2: Ikke beståede eksamener
IF OBJECT_ID('dbo.failed_exams', 'V') IS NOT NULL DROP VIEW dbo.failed_exams;
GO
CREATE VIEW failed_exams AS
SELECT
    s.name AS student_name,
    e.programId,
    e.grade
FROM Exams e
JOIN Students s ON s.id = e.studentId
WHERE e.grade < 2;
GO

SELECT * FROM failed_exams;


-- Øvelse 3: Gennemsnitskarakter per program
IF OBJECT_ID('dbo.program_avg_grades', 'V') IS NOT NULL DROP VIEW dbo.program_avg_grades;
GO
CREATE VIEW program_avg_grades AS
SELECT
    p.name AS program_name,
    ROUND(AVG(CAST(e.grade AS DECIMAL(10,2))), 2) AS avg_grade
FROM Programs p
JOIN Exams e ON e.programId = p.id
GROUP BY p.id, p.name;
GO

SELECT * FROM program_avg_grades ORDER BY avg_grade DESC;


-- Øvelse 4: Tilmeldinger per kursus
IF OBJECT_ID('dbo.course_enrollments', 'V') IS NOT NULL DROP VIEW dbo.course_enrollments;
GO
CREATE VIEW course_enrollments AS
SELECT
    c.name AS course_name,
    p.name AS program_name,
    COUNT(e.studentId) AS enrolled_count
FROM Courses c
JOIN Programs p ON p.id = c.programId
LEFT JOIN Enrollments e ON e.courseId = c.id
GROUP BY c.id, c.name, p.name;
GO

SELECT * FROM course_enrollments ORDER BY enrolled_count DESC;


-- Øvelse 5a: Aktive studerende (EXISTS-version -- opdaterbar)
IF OBJECT_ID('dbo.active_students', 'V') IS NOT NULL DROP VIEW dbo.active_students;
GO
CREATE VIEW active_students AS
SELECT s.id, s.name, s.programId
FROM Students s
WHERE EXISTS (
    SELECT 1 FROM Exams e
    WHERE e.studentId = s.id AND e.grade >= 2
);
GO

-- Test opdatering: UPDATE active_students SET name = 'Test Navn' WHERE id = 1;


-- Øvelse 5b: Aktive studerende (JOIN-version -- ikke opdaterbar)
IF OBJECT_ID('dbo.active_students_join', 'V') IS NOT NULL DROP VIEW dbo.active_students_join;
GO
CREATE VIEW active_students_join AS
SELECT DISTINCT s.id, s.name, s.programId
FROM Students s
JOIN Exams e ON e.studentId = s.id
WHERE e.grade >= 2;
GO

-- Test opdatering (fejler): UPDATE active_students_join SET name = 'Test Navn' WHERE id = 1;

GO

-- =============================================
-- FUNCTIONS
-- =============================================

-- Øvelse 1: Antal studerende
IF OBJECT_ID('dbo.get_student_count', 'FN') IS NOT NULL DROP FUNCTION dbo.get_student_count;
GO
CREATE FUNCTION get_student_count()
RETURNS BIGINT
AS
BEGIN
    RETURN (SELECT COUNT(*) FROM Students);
END;
GO

-- Test: SELECT dbo.get_student_count();


-- Øvelse 2: Gennemsnitskarakter for et program
IF OBJECT_ID('dbo.get_avg_grade', 'FN') IS NOT NULL DROP FUNCTION dbo.get_avg_grade;
GO
CREATE FUNCTION get_avg_grade(@p_program_id INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN (
        SELECT AVG(CAST(grade AS DECIMAL(10,2)))
        FROM Exams
        WHERE programId = @p_program_id
    );
END;
GO

-- Test: SELECT dbo.get_avg_grade(1);
-- Alle programmer: SELECT p.name, dbo.get_avg_grade(p.id) AS avg_grade FROM Programs p;


-- Øvelse 3: Studerende på et kursus (tabel-returnerende funktion)
IF OBJECT_ID('dbo.get_students_on_course', 'TF') IS NOT NULL DROP FUNCTION dbo.get_students_on_course;
GO
CREATE FUNCTION get_students_on_course(@course_id INT)
RETURNS TABLE
AS
RETURN (
    SELECT s.name AS student_name
    FROM Students s
    JOIN Enrollments e ON e.studentId = s.id
    WHERE e.courseId = @course_id
);
GO

-- Test: SELECT * FROM dbo.get_students_on_course(1);

GO
SELECT 'Views og functions oprettet!' AS status;
GO