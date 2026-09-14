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








