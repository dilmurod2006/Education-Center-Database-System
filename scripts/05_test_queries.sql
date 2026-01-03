-- =============================================
-- Fayl: 05_test_queries.sql
-- Maqsad: Tizim to'g'ri ishlaganini isbotlovchi so'rovlar
-- =============================================

-- 1. Balans tekshiruvi (Kutilgan: 1.5mln - 1mln = 500k)
SELECT StudentID, FirstName, LastName, Balance 
FROM Students 
WHERE StudentID = 1;

-- 2. Moliya tarixi (Triggerlar yozgan loglar)
SELECT LogDate, Type, Amount, Description 
FROM FinancialLogs 
ORDER BY LogID;

-- 3. Complex Join (Distinction uchun) - Guruhdagi talabalar va ularning qarzdorligi
SELECT 
    g.GroupName,
    c.CourseName,
    t.LastName AS Teacher,
    s.FirstName || ' ' || s.LastName AS Student,
    s.Balance
FROM Enrollments e
JOIN Groups g ON e.GroupID = g.GroupID
JOIN Courses c ON g.CourseID = c.CourseID
JOIN Teachers t ON g.TeacherID = t.TeacherID
JOIN Students s ON e.StudentID = s.StudentID
WHERE s.Balance < 0; -- Qarzdorlarni topish