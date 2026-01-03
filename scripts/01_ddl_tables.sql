-- =============================================
-- 1. DATABASE VA ASOSIY JADVALLAR (PostgreSQL)
-- =============================================

-- ENUM o'rniga CHECK constraintlar ishlatamiz (xatolik kamroq bo'ladi)

-- 1. DaysOfWeek
CREATE TABLE DaysOfWeek (
    DayID SERIAL PRIMARY KEY,
    DayName VARCHAR(20) NOT NULL UNIQUE CHECK (DayName IN ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'))
);

-- 2. Specializations
CREATE TABLE Specializations (
    SpecID SERIAL PRIMARY KEY,
    SpecName VARCHAR(100) NOT NULL UNIQUE
);

-- 3. CourseCategories
CREATE TABLE CourseCategories (
    CategoryID SERIAL PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);

-- 4. PaymentMethods
CREATE TABLE PaymentMethods (
    MethodID SERIAL PRIMARY KEY,
    MethodName VARCHAR(50) NOT NULL UNIQUE
);

-- 5. Students
CREATE TABLE Students (
    StudentID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Balance DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Teachers
CREATE TABLE Teachers (
    TeacherID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    SpecID INT,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    PasswordHash VARCHAR(255) NOT NULL,
    FOREIGN KEY (SpecID) REFERENCES Specializations(SpecID) ON DELETE SET NULL
);

-- 7. Courses
CREATE TABLE Courses (
    CourseID SERIAL PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    CategoryID INT,
    MonthlyFee DECIMAL(10,2) NOT NULL CHECK (MonthlyFee > 0),
    LessonPrice DECIMAL(10,2) NOT NULL CHECK (LessonPrice > 0),
    DurationWeeks INT NOT NULL DEFAULT 4,
    FOREIGN KEY (CategoryID) REFERENCES CourseCategories(CategoryID) ON DELETE SET NULL
);

-- =============================================
-- 2. SCHEDULING (GURUXLAR VA XONALAR)
-- =============================================

-- 8. Rooms
CREATE TABLE Rooms (
    RoomID SERIAL PRIMARY KEY,
    RoomName VARCHAR(50) NOT NULL UNIQUE,
    Capacity INT NOT NULL DEFAULT 0
);

-- 9. TimeSlots
CREATE TABLE TimeSlots (
    SlotID SERIAL PRIMARY KEY,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    CHECK (EndTime > StartTime)
);

-- 10. Groups
CREATE TABLE Groups (
    GroupID SERIAL PRIMARY KEY,
    GroupName VARCHAR(100) NOT NULL,
    CourseID INT NOT NULL,
    TeacherID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID)
);

-- 11. GroupSchedules
CREATE TABLE GroupSchedules (
    GroupScheduleID SERIAL PRIMARY KEY,
    GroupID INT NOT NULL,
    DayID INT NOT NULL,
    SlotID INT NOT NULL,
    RoomID INT NOT NULL,
    FOREIGN KEY (GroupID) REFERENCES Groups(GroupID) ON DELETE CASCADE,
    FOREIGN KEY (DayID) REFERENCES DaysOfWeek(DayID),
    FOREIGN KEY (SlotID) REFERENCES TimeSlots(SlotID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    UNIQUE (GroupID, DayID, SlotID),
    UNIQUE (RoomID, DayID, SlotID)
);

-- =============================================
-- 3. OPERATSION JADVALLAR (BILLING LOGIC)
-- =============================================

-- 12. Enrollments
CREATE TABLE Enrollments (
    EnrollmentID SERIAL PRIMARY KEY,
    StudentID INT NOT NULL,
    GroupID INT NOT NULL,
    EnrollmentDate DATE DEFAULT CURRENT_DATE,
    NextBillingDate DATE NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (GroupID) REFERENCES Groups(GroupID) ON DELETE CASCADE,
    UNIQUE (StudentID, GroupID)
);

-- 13. Attendance
CREATE TABLE Attendance (
    AttendanceID SERIAL PRIMARY KEY,
    EnrollmentID INT NOT NULL,
    AttendanceDate DATE NOT NULL,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Present','Absent','Late')),
    FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID) ON DELETE CASCADE,
    UNIQUE (EnrollmentID, AttendanceDate)
);

-- 14. Payments
CREATE TABLE Payments (
    PaymentID SERIAL PRIMARY KEY,
    StudentID INT NOT NULL,
    MethodID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (MethodID) REFERENCES PaymentMethods(MethodID)
);

-- 15. FinancialLogs (Triggerlar ishlashi uchun kerak)
CREATE TABLE FinancialLogs (
    LogID SERIAL PRIMARY KEY,
    StudentID INT,
    Type VARCHAR(50),
    Amount DECIMAL(10,2),
    Description TEXT,
    LogDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

-- 16. MonthlyCharges (Audit)
CREATE TABLE MonthlyCharges (
    MonthlyChargeID SERIAL PRIMARY KEY,
    EnrollmentID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    ChargeDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID)
);