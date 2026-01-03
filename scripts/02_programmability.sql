-- =============================================
-- Fayl: 02_programmability.sql
-- Maqsad: Stored Procedures va Functions (Business Logic)
-- =============================================

-- Function: To'lov qabul qilish logikasi
CREATE OR REPLACE FUNCTION fn_AfterPayment()
RETURNS TRIGGER AS $$
BEGIN
    -- Balansni yangilash
    UPDATE Students SET Balance = Balance + NEW.Amount WHERE StudentID = NEW.StudentID;
    
    -- Audit log yozish
    INSERT INTO FinancialLogs (StudentID, Type, Amount, Description)
    VALUES (NEW.StudentID, 'Payment', NEW.Amount, 'Hisob to''ldirildi');
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function: Oylik to'lovni avtomatik yechish logikasi
CREATE OR REPLACE FUNCTION fn_CheckMonthlyBilling()
RETURNS TRIGGER AS $$
DECLARE
    v_fee DECIMAL(10,2);
    v_student_id INT;
    v_billing_date DATE;
BEGIN
    -- Kerakli ma'lumotlarni olish
    SELECT c.MonthlyFee, e.StudentID, e.NextBillingDate 
    INTO v_fee, v_student_id, v_billing_date
    FROM Enrollments e
    JOIN Groups g ON e.GroupID = g.GroupID
    JOIN Courses c ON g.CourseID = c.CourseID
    WHERE e.EnrollmentID = NEW.EnrollmentID;

    -- Billing sanasi tekshiruvi
    IF CURRENT_DATE >= v_billing_date THEN
        UPDATE Students SET Balance = Balance - v_fee WHERE StudentID = v_student_id;
        
        INSERT INTO FinancialLogs (StudentID, Type, Amount, Description)
        VALUES (v_student_id, 'MonthlyFee', v_fee, 'Avtomatik oylik to''lov yechildi');

        INSERT INTO MonthlyCharges (EnrollmentID, Amount) VALUES (NEW.EnrollmentID, v_fee);

        -- Keyingi to'lov sanasini surish
        UPDATE Enrollments SET NextBillingDate = (v_billing_date + INTERVAL '1 month')
        WHERE EnrollmentID = NEW.EnrollmentID;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Procedure: Kursni tark etganda qayta hisob-kitob
CREATE OR REPLACE PROCEDURE sp_EarlyExitRecalculate(p_EnrollmentID INT)
LANGUAGE plpgsql
AS $$
DECLARE 
    v_student_id INT;
    v_attended_count INT;
    v_lesson_price DECIMAL(10,2);
    v_monthly_fee DECIMAL(10,2);
    v_refund_amount DECIMAL(10,2);
BEGIN
    SELECT e.StudentID, c.LessonPrice, c.MonthlyFee 
    INTO v_student_id, v_lesson_price, v_monthly_fee
    FROM Enrollments e
    JOIN Groups g ON e.GroupID = g.GroupID
    JOIN Courses c ON g.CourseID = c.CourseID
    WHERE e.EnrollmentID = p_EnrollmentID;

    SELECT COUNT(*) INTO v_attended_count 
    FROM Attendance 
    WHERE EnrollmentID = p_EnrollmentID AND Status IN ('Present', 'Late');

    -- Formula: To'langan Oylik - (O'qilgan darslar * Dars narxi)
    v_refund_amount := v_monthly_fee - (v_attended_count * v_lesson_price);

    IF v_refund_amount > 0 THEN
        UPDATE Students SET Balance = Balance + v_refund_amount WHERE StudentID = v_student_id;
        
        INSERT INTO FinancialLogs (StudentID, Type, Amount, Description)
        VALUES (v_student_id, 'Adjustment', v_refund_amount, 'Qayta hisob: ' || v_attended_count || ' ta dars uchun darsbay hisoblandi');
    END IF;
END;
$$;