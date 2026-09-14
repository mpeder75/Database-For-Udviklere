-- VIEWS

-- Simpelt view: studenteroverblik
-- 1. Opret viewet student_overview, der viser den studerendes navn, programnavn og programniveau.
CREATE VIEW student_overview AS
SELECT s.name AS student_name, 
	   p.name AS program_name,
	   p.level AS program_level
FROM "Students" s
INNER JOIN "Programs" p ON s.programId = p.id

SELECT * FROM student_overview;

-- Brug viewet. Skriv en SELECT mod viewet med et WHERE-filter, fx kun studerende på niveau Top-op.
CREATE OR REPLACE VIEW student_overview AS
SELECT s.name AS student_name, 
       p.name AS program_name,
       p.level AS program_level
FROM "Students" s
INNER JOIN "Programs" p ON s.programId = p.id;

SELECT * FROM student_overview WHERE program_level = 'Top-op';

-- Ryd op. Skriv den DROP-sætning der fjerner viewet igen uden at fejle hvis det ikke findes.
DROP VIEW IF EXISTS student_overview;


-- View med filter: ikke beståede eksamener
-- 1. Opret viewet failed_exams, der viser alle studerende og karakterer hvor karakteren er under 02.
CREATE VIEW failed_exams AS
SELECT s.name AS student_name, e.grade
FROM "Exams" e
JOIN "Students" s ON e.studentid = s.id 
WHERE e.grade < 2;

SELECT * FROM failed_exams;

-- 5. Filtrér oveni. Skriv en forespørgsel mod viewet der kun viser rækker for ét bestemt program, og forklar i hvilken rækkefølge de to filtre virker.
CREATE OR REPLACE VIEW failed_exams AS
SELECT s.name AS student_name, e.grade, e.programId
FROM "Exams" e
JOIN "Students" s ON e.studentId = s.id
WHERE e.grade < 2;

SELECT * FROM failed_exams WHERE programId = 1;

DROP VIEW IF EXISTS failed_exams;


-- Aggregeret view: gennemsnitskarakter per program

-- Opret viewet program_avg_grades, der viser hvert programnavn og programmets gennemsnitlige karakter beregnet ud fra Exams.
-- Brug GROUP BY på programmet.
-- Afrund gennemsnittet til to decimaler, så resultatet er læsbart.
-- Tag stilling til programmer uden eksamener. Skal de vises med NULL, eller skal de udelades? Vælg og begrund, og implementér dit valg.
CREATE VIEW program_avg_grades AS
SELECT ROUND(AVG(e.grade), 2) AS avg_grade, p.name AS program_name
FROM "Exams" e
JOIN "Programs" p ON e.programId = p.id
GROUP BY p.id, p.name;

SELECT * FROM program_avg_grades ORDER BY avg_grade DESC;

DROP VIEW IF EXISTS program_avg_grades;


-- View med join over flere tabeller: tilmeldinger per kursus
CREATE VIEW course_enrollments AS
SELECT c.name AS course_name,
       p.name AS program_name,
       COUNT(e.studentId) AS enrolled_count
FROM "Courses" c
JOIN "Programs" p ON p.id = c.programId
LEFT JOIN "Enrollments" e ON e.courseId = c.id
GROUP BY c.id, c.name, p.name;

SELECT * FROM course_enrollments ORDER BY enrolled_count DESC;


-- Opdatering via view: aktive studerende

CREATE OR REPLACE VIEW active_students AS
SELECT s.id, s.name, s.programId
FROM "Students" s
WHERE EXISTS (
    SELECT 1 FROM "Exams" e
    WHERE e.studentId = s.id AND e.grade >= 2
);

CREATE OR REPLACE VIEW active_students_join AS
SELECT DISTINCT s.id, s.name, s.programId
FROM "Students" s
JOIN "Exams" e ON e.studentId = s.id
WHERE e.grade >= 2;

UPDATE active_students SET name = 'Test Navn' WHERE id = 1;
UPDATE active_students_join SET name = 'Test Navn' WHERE id = 1;

SELECT table_name, is_updatable 
FROM information_schema.views 
WHERE table_schema = 'public';




-- Functions
-- Lav funktionen get_student_count(), der returnerer det totale antal studerende i Students.
CREATE FUNCTION get_student_count()
RETURNS bigint
LANGUAGE sql
AS $$
    SELECT COUNT(*) FROM "Students";
$$;

SELECT get_student_count();

-- opgave 5 i plpgsql
CREATE OR REPLACE FUNCTION get_student_count()
RETURNS bigint
LANGUAGE plpgsql
AS $$
DECLARE
    result bigint;
BEGIN
    SELECT COUNT(*) INTO result FROM "Students";
    RETURN result;
END;
$$;

DROP FUNCTION IF EXISTS get_student_count();

-- Function med parameter: gennemsnitskarakter for et program
-- Lav funktionen get_avg_grade(programId INT), der returnerer den gennemsnitlige karakter for alle eksamener i det pågældende program.
CREATE FUNCTION get_avg_grade(p_programId INT)
RETURNS numeric
LANGUAGE sql
AS $$
 SELECT AVG(grade) FROM "Exams"
 WHERE programId = p_programId;
$$;

SELECT get_avg_grade(1);
SELECT get_avg_grade(2);
SELECT get_avg_grade(3);
SELECT get_avg_grade(4);
SELECT get_avg_grade(5);


-- Function der returnerer en tabel: studerende på et kursus
-- Lav funktionen get_students_on_course(course_id INT), der returnerer en tabel med navne på alle studerende, der er tilmeldt et bestemt kursus.
-- Brug RETURNS TABLE til at beskrive den tabel funktionen leverer.
-- Kald funktionen i FROM, fx SELECT * FROM get_students_on_course(1);.
-- Kvalificér dine kolonner. Kolonnenavnene i RETURNS TABLE opfører sig som variable inde i funktionen. 
-- Prøv bevidst at skrive SELECT name FROM "Students" uden alias og se hvad der sker.
-- Svar på spørgsmålet: er dette den mest optimale måde at udføre denne handling på? 
-- Sammenlign med en almindelig join-forespørgsel og med et view, og begrund hvornår du ville vælge hvad.
CREATE OR REPLACE FUNCTION get_students_on_course(course_id INT)
RETURNS TABLE (student_name varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT s.name
    FROM "Students" s
    JOIN "Enrollments" e ON e.studentId = s.id
    WHERE e.courseId = course_id;
END;
$$;

SELECT * FROM get_students_on_course(1);
