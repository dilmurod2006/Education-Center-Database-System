-- =============================================
-- Fayl: 04_seed_data_fixed.sql
-- Maqsad: Stress Test uchun REALISTIK KATTA MA'LUMOTLAR (TUZATILGAN)
-- =============================================

-- 1. CLEANUP
TRUNCATE TABLE FinancialLogs, MonthlyCharges, Payments, Attendance, Enrollments, GroupSchedules, Groups, Students, Teachers, Rooms, Courses, Specializations, DaysOfWeek RESTART IDENTITY CASCADE;

-- =============================================
-- 2. STATIC DATA
-- =============================================
INSERT INTO DaysOfWeek (DayName) VALUES ('Monday'), ('Tuesday'), ('Wednesday'), ('Thursday'), ('Friday'), ('Saturday'), ('Sunday');

INSERT INTO Specializations (SpecName) VALUES 
('Software Engineering'), ('Frontend React'), ('Backend .NET'), ('Mobile Flutter'), 
('Cyber Security'), ('Data Science & AI'), ('English Language'), ('IELTS Preparation'),
('Russian Language'), ('Arabic Language'), ('Graphic Design'), ('UX/UI Design'),
('Accounting 1C'), ('Digital Marketing'), ('Project Management'), ('DevOps Engineering');

INSERT INTO CourseCategories (CategoryName) VALUES ('Programming'), ('Languages'), ('Design'), ('Business'), ('Kids IT'), ('Security');

INSERT INTO PaymentMethods (MethodName) VALUES ('Cash'), ('UzCard'), ('Humo'), ('Click'), ('Payme'), ('Visa'), ('Uzum Nasiya');

INSERT INTO Rooms (RoomName, Capacity)
SELECT 
    CASE 
        WHEN num <= 110 THEN 'Lab ' || num 
        WHEN num <= 210 THEN 'Classroom ' || num 
        ELSE 'Lecture Hall ' || num 
    END, 
    CASE WHEN num > 300 THEN 50 ELSE 20 END
FROM (
    SELECT generate_series(101, 110) as num UNION ALL
    SELECT generate_series(201, 210) as num UNION ALL
    SELECT generate_series(301, 310) as num
) as rooms;

INSERT INTO TimeSlots (StartTime, EndTime) VALUES 
('08:00', '09:30'), ('09:40', '11:10'), ('11:20', '12:50'), 
('14:00', '15:30'), ('15:40', '17:10'), ('18:00', '19:30');

-- =============================================
-- 3. SEMI-STATIC DATA
-- =============================================
INSERT INTO Courses (CourseName, CategoryID, MonthlyFee, LessonPrice, DurationWeeks) VALUES 
('Python Backend Foundation', 1, 1200000, 100000, 24),
('Java Enterprise Edition', 1, 1500000, 120000, 24),
('Frontend ReactJS & VueJS', 1, 1000000, 85000, 18),
('Flutter Mobile Development', 1, 1400000, 110000, 20),
('General English Beginner', 2, 600000, 50000, 12),
('IELTS Intensive 7.0', 2, 900000, 75000, 12),
('Graphic Design & Photoshop', 3, 800000, 65000, 16),
('SMM & Digital Marketing', 4, 700000, 60000, 8),
('Cyber Security Basics', 6, 1800000, 150000, 12),
('Kids Robotics', 5, 500000, 40000, 24);

-- =============================================
-- 4. DYNAMIC BIG DATA (Advanced Generation)
-- =============================================

DO $$
DECLARE
    -- Ism va Familiyalar
    v_first_names text[] := ARRAY[
        'Ali', 'Vali', 'Sardor', 'Jasur', 'Bekzod', 'Otabek', 'Ulugbek', 'Jamshid', 'Farrux', 'Bobur', 
        'Sanjar', 'Abbos', 'Javohir', 'Bilol', 'Muhammad', 'Aziz', 'Sherzod', 'Dilshod', 'Eldor', 'Firdavs',
        'Guli', 'Lola', 'Dildora', 'Shahzoda', 'Malika', 'Aziza', 'Madina', 'Sevara', 'Nigora', 'Rayhona',
        'Ziyoda', 'Fotima', 'Zuhra', 'Kamola', 'Barno', 'Dilnoza', 'Feruza', 'Gulnoza', 'Laylo', 'Munisa'
    ];
    v_last_names text[] := ARRAY[
        'Aliyev', 'Valiyev', 'Karimov', 'Rahimov', 'Abdullayev', 'Tursunov', 'Nazarov', 'Yusupov', 'Ahmedov', 'Saidov', 
        'Sharipov', 'Ismoilov', 'Shukurov', 'Zokirov', 'Salimov', 'Usmonov', 'Qodirov', 'Mirzayev', 'Norov', 'Ergashev',
        'Rustamov', 'Sultonov', 'Yoqubov', 'Mahmudov', 'Azimov', 'Jalilov', 'Oripov', 'Rasulov', 'Sobirov', 'Xolmatov'
    ];

    v_student_id INT;
    v_group_id INT;
    v_course_id INT;
    v_teacher_id INT;
    v_fname text;
    v_lname text;
    
    -- YANGI O'ZGARUVCHILAR (Statistics fix uchun)
    v_rand float; 
    v_status varchar;
    
    i INT;
BEGIN

    -- A) TEACHERS
    FOR i IN 1..20 LOOP
        v_fname := v_first_names[floor(random() * array_length(v_first_names, 1)) + 1];
        v_lname := v_last_names[floor(random() * array_length(v_last_names, 1)) + 1];
        
        INSERT INTO Teachers (FirstName, LastName, SpecID, Email, Phone, PasswordHash)
        VALUES (v_fname, v_lname, floor(random()*15)+1, lower(v_fname || '.' || v_lname || i || '@edu.uz'), '+9989' || floor(random() * 90000000 + 10000000), 'hash_pass_' || i);
    END LOOP;

    -- B) GROUPS
    FOR i IN 1..100 LOOP
        v_course_id := floor(random()*10) + 1;
        v_teacher_id := floor(random()*20) + 1;
        
        INSERT INTO Groups (GroupName, CourseID, TeacherID, StartDate)
        VALUES ((SELECT CourseName FROM Courses WHERE CourseID = v_course_id) || '-G' || i, v_course_id, v_teacher_id, '2025-01-01'::DATE + (floor(random()*30) || ' days')::INTERVAL) 
        RETURNING GroupID INTO v_group_id;

        BEGIN
            IF i % 2 = 0 THEN
                INSERT INTO GroupSchedules (GroupID, DayID, SlotID, RoomID) VALUES 
                (v_group_id, 2, floor(random()*6)+1, floor(random()*30)+1),
                (v_group_id, 4, floor(random()*6)+1, floor(random()*30)+1),
                (v_group_id, 6, floor(random()*6)+1, floor(random()*30)+1);
            ELSE
                INSERT INTO GroupSchedules (GroupID, DayID, SlotID, RoomID) VALUES 
                (v_group_id, 1, floor(random()*6)+1, floor(random()*30)+1),
                (v_group_id, 3, floor(random()*6)+1, floor(random()*30)+1),
                (v_group_id, 5, floor(random()*6)+1, floor(random()*30)+1);
            END IF;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;

    -- C) STUDENTS
    FOR i IN 1..5000 LOOP
        v_fname := v_first_names[floor(random() * array_length(v_first_names, 1)) + 1];
        v_lname := v_last_names[floor(random() * array_length(v_last_names, 1)) + 1];
        INSERT INTO Students (FirstName, LastName, DateOfBirth, Email, Phone, Balance)
        VALUES (v_fname, v_lname, '2000-01-01'::DATE + (floor(random()*365*6) || ' days')::INTERVAL, lower(v_fname || '.' || v_lname || i || '@gmail.com'), '+9989' || floor(random() * 89999999 + 10000000), 0);
    END LOOP;

    -- D) ENROLLMENTS
    FOR i IN 1..3000 LOOP
        v_student_id := floor(random()*5000) + 1;
        v_group_id := floor(random()*100) + 1;
        BEGIN
            INSERT INTO Enrollments (StudentID, GroupID, EnrollmentDate, NextBillingDate)
            VALUES (v_student_id, v_group_id, '2025-01-05', '2025-01-05');
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;

    -- E) PAYMENTS
    FOR i IN 1..2000 LOOP
        v_student_id := floor(random()*5000) + 1;
        INSERT INTO Payments (StudentID, MethodID, Amount)
        VALUES (v_student_id, floor(random()*7)+1, (floor(random()*20)+5) * 100000);
    END LOOP;
    
    -- ==========================================================
    -- F) ATTENDANCE (TUZATILGAN QISM)
    -- Mantiq: 70% Present, 20% Late, 10% Absent
    -- ==========================================================
    FOR i IN 1..5000 LOOP
        
        -- 1. Tasodifiy sonni bir marta generatsiya qilamiz
        v_rand := random(); 

        -- 2. Statusni aniqlaymiz (IF/ELSE orqali aniq mantiq)
        IF v_rand < 0.70 THEN
            v_status := 'Present'; -- 0.00 dan 0.69 gacha (70%)
        ELSIF v_rand < 0.90 THEN
            v_status := 'Late';    -- 0.70 dan 0.89 gacha (20%)
        ELSE
            v_status := 'Absent';  -- 0.90 dan yuqori (10%)
        END IF;

        BEGIN
            INSERT INTO Attendance (EnrollmentID, AttendanceDate, Status)
            SELECT 
                EnrollmentID, 
                '2025-01-10', 
                v_status  -- Hisoblangan statusni ishlatamiz
            FROM Enrollments 
            ORDER BY RANDOM() 
            LIMIT 1;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;

END $$;