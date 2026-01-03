-- ==============================================================================
-- MASTER TEST SUITE: Education Center Database System
-- Author: Senior QA Engineer
-- Version: 1.0
-- Purpose: Validation of DDL, Integrity, Business Logic, and Performance
-- ==============================================================================

-- =============================================
-- SECTION 1: Structural & Integrity Testing
-- =============================================

-- T1.1: Verify CHECK Constraint (Negative Course Price)
-- Expected: Error (check constraint violation)
INSERT INTO Courses (CourseName, MonthlyFee, LessonPrice) 
VALUES ('Invalid Course', -100.00, 50.00); 

-- T1.2: Verify UNIQUE Constraint (Duplicate Email)
-- Prerequisites: Ensure 'test@example.com' exists first
INSERT INTO Students (FirstName, LastName, Email, DateOfBirth) 
VALUES ('Test', 'User', 'test@example.com', '2000-01-01');
-- Attempt Duplicate (Expected: Error)
INSERT INTO Students (FirstName, LastName, Email, DateOfBirth) 
VALUES ('Duplicate', 'User', 'test@example.com', '2000-01-01');

-- T1.3: Verify Referential Integrity (Orphan Deletion)
-- Try to delete a Course that has active Groups
DELETE FROM Courses WHERE CourseID = (SELECT CourseID FROM Groups LIMIT 1);
-- Expected: Error (Foreign Key Constraint violation)

-- T1.4: Room Conflict Prevention
-- Attempt to book same Room, Day, Slot for two different groups
-- Assumes GroupID 1 and 2 exist, and RoomID 1 exists
INSERT INTO GroupSchedules (GroupID, DayID, SlotID, RoomID) VALUES (1, 1, 1, 1);
INSERT INTO GroupSchedules (GroupID, DayID, SlotID, RoomID) VALUES (2, 1, 1, 1);
-- Expected: Error (Unique Constraint violation on RoomID, DayID, SlotID)

-- =============================================
-- SECTION 2: Functional Testing (User Stories)
-- =============================================

-- T2.1: Register a New Student
INSERT INTO Students (FirstName, LastName, DateOfBirth, Email, Phone)
VALUES ('John', 'Doe', '2005-08-15', 'john.doe@new.com', '+998901112233');
-- Validation
SELECT * FROM Students WHERE Email = 'john.doe@new.com';

-- T2.2: Create a Group and Assign Teacher
INSERT INTO Groups (GroupName, CourseID, TeacherID, StartDate)
VALUES ('Python-Foundation-001', 1, 1, CURRENT_DATE);
-- Validation
SELECT * FROM Groups WHERE GroupName = 'Python-Foundation-001';

-- T2.3: Enroll Student into Group
INSERT INTO Enrollments (StudentID, GroupID, NextBillingDate)
VALUES (
    (SELECT StudentID FROM Students WHERE Email = 'john.doe@new.com'),
    (SELECT GroupID FROM Groups WHERE GroupName = 'Python-Foundation-001'),
    CURRENT_DATE + INTERVAL '1 month'
);
-- Validation
SELECT * FROM Enrollments WHERE StudentID = (SELECT StudentID FROM Students WHERE Email = 'john.doe@new.com');

-- T2.4: Mark Attendance
INSERT INTO Attendance (EnrollmentID, AttendanceDate, Status)
VALUES (
    (SELECT EnrollmentID FROM Enrollments WHERE StudentID = (SELECT StudentID FROM Students WHERE Email = 'john.doe@new.com') LIMIT 1),
    CURRENT_DATE,
    'Present'
);

-- =============================================
-- SECTION 3: Business Logic & Automation (Distinction)
-- =============================================

-- T3.1: Auto-Billing Logic (Manual Simulation)
-- Scenario: Set NextBillingDate to today for a test student
UPDATE Enrollments 
SET NextBillingDate = CURRENT_DATE 
WHERE EnrollmentID = 1;

-- Verification Before: Check Balance and Logs
SELECT Balance FROM Students WHERE StudentID = (SELECT StudentID FROM Enrollments WHERE EnrollmentID = 1);

-- Action: Trigger Attendance (which triggers Billing)
INSERT INTO Attendance (EnrollmentID, AttendanceDate, Status)
VALUES (1, CURRENT_DATE, 'Present');

-- Verification After:
-- 1. Balance should decrease by MonthlyFee
-- 2. NextBillingDate should increase by 1 month
-- 3. FinancialLogs should have a new entry
SELECT s.Balance, e.NextBillingDate 
FROM Students s 
JOIN Enrollments e ON s.StudentID = e.StudentID 
WHERE e.EnrollmentID = 1;

SELECT * FROM FinancialLogs WHERE StudentID = (SELECT StudentID FROM Enrollments WHERE EnrollmentID = 1) ORDER BY LogDate DESC LIMIT 1;

-- T3.2: Payment Trigger Validation
-- Action: Add Money
INSERT INTO Payments (StudentID, MethodID, Amount) VALUES (1, 1, 200000);
-- Validation: Check if Balance increased automatically
SELECT * FROM FinancialLogs WHERE StudentID = 1 ORDER BY LogDate DESC LIMIT 1;

-- T3.3: Early Exit Refund (Stored Procedure)
-- Call the procedure for a specific enrollment
CALL sp_EarlyExitRecalculate(1);
-- Validation: Check for 'Adjustment' log
SELECT * FROM FinancialLogs WHERE Type = 'Adjustment' AND StudentID = (SELECT StudentID FROM Enrollments WHERE EnrollmentID = 1);

-- =============================================
-- SECTION 4: Performance & Stress Testing
-- =============================================

-- P4.1: Analyze Student Payments Timeline
EXPLAIN ANALYZE 
SELECT 
    s.FirstName, 
    s.LastName, 
    COUNT(p.PaymentID) as TotalTransactions, 
    SUM(p.Amount) as TotalPaid
FROM Students s
JOIN Payments p ON s.StudentID = p.StudentID
GROUP BY s.StudentID, s.FirstName, s.LastName
HAVING SUM(p.Amount) > 1000000
ORDER BY TotalPaid DESC;

-- P4.2: Group Capacity Analysis
EXPLAIN ANALYZE 
SELECT 
    g.GroupName, 
    c.CourseName, 
    t.LastName as Teacher, 
    COUNT(e.StudentID) as ActualStudents,
    r.Capacity,
    (r.Capacity - COUNT(e.StudentID)) as SeatsAvailable
FROM Groups g
JOIN Courses c ON g.CourseID = c.CourseID
JOIN Teachers t ON g.TeacherID = t.TeacherID
JOIN Enrollments e ON g.GroupID = e.GroupID
JOIN GroupSchedules gs ON g.GroupID = gs.GroupID
JOIN Rooms r ON gs.RoomID = r.RoomID
GROUP BY g.GroupName, c.CourseName, t.LastName, r.Capacity;

-- =============================================
-- SECTION 5: Edge Case Testing
-- =============================================

-- E5.1: Negative Payment Amount
INSERT INTO Payments (StudentID, MethodID, Amount) VALUES (1, 1, -500);
-- Expected: Check constraint violation (Amount > 0)

-- E5.2: Invalid Attendance Status
INSERT INTO Attendance (EnrollmentID, AttendanceDate, Status) VALUES (1, CURRENT_DATE + 1, 'Sleeping');
-- Expected: Check constraint violation (Status IN 'Present','Absent','Late')

-- E5.3: End Time before Start Time (TimeSlot)
INSERT INTO TimeSlots (StartTime, EndTime) VALUES ('14:00', '13:00');
-- Expected: Check constraint violation (EndTime > StartTime)
