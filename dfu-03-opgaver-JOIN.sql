-- INNER JOIN: Students & Ennrollments
-- 1. Skriv forespørgslen. Vis hver studerende sammen med de kurser de er tilmeldt, med kursets navn og ikke kun dets id.
SELECT s.name AS student_name, c.name AS course_name
FROM "Students" s
INNER JOIN "Enrollments" e ON e.studentId = s.id
INNER JOIN "Courses" c ON c.id = e.courseId;

-- Tæl rækkerne. Hvor mange rækker får du, og hvor mange studerende findes der i alt? Forklar forskellen.
SELECT * FROM "Enrollments";

-- Find de forsvundne. Hvilke studerende er slet ikke med i resultatet, og hvorfor?
SELECT * FROM "Students";

-- Prøv uden ON. Skriv et CROSS JOIN mellem Students og Courses, tæl rækkerne, og forklar hvad et join uden betingelse gør.
SELECT s.name AS student_name, c.name AS course_name
FROM "Students" s
CROSS JOIN "Courses" c;


-- Sammenlign skrivemåder. Skriv samme forespørgsel med kommaseparerede tabeller i FROM og betingelsen i WHERE. Hvilken af de to er lettest at læse, og hvilken beskytter dig bedst mod at glemme betingelsen?
SELECT s.name AS student_name, c.name AS course_name
FROM "Students" s, "Enrollments" e, "Courses" c
WHERE e.studentId = s.id 
AND c.id = e.courseId;


-- LEFT JOIN: Students & Ennrollments
-- 1. Vis alle studerende med deres tilmeldinger, også de studerende der ikke er tilmeldt noget.
Select s.name AS student_name, c.name AS name_course
From "Students" s
LEFT JOIN "Ennrollments" e on e.studentId = s.id 