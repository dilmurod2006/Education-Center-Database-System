-- =============================================
-- Fayl: 00_cleanup.sql
-- Maqsad: Mavjud barcha obyektlarni o'chirish (Toza start uchun)
-- =============================================

DROP TRIGGER IF EXISTS trg_AfterPayment ON Payments;
DROP TRIGGER IF EXISTS trg_CheckMonthlyBilling ON Attendance;
DROP FUNCTION IF EXISTS fn_AfterPayment;
DROP FUNCTION IF EXISTS fn_CheckMonthlyBilling;
DROP PROCEDURE IF EXISTS sp_EarlyExitRecalculate;

-- Jadvallarni o'chirish (Foreign Key xatoliklarini oldini olish uchun CASCADE ishlatamiz)
DROP TABLE IF EXISTS MonthlyCharges CASCADE;
DROP TABLE IF EXISTS FinancialLogs CASCADE;
DROP TABLE IF EXISTS Payments CASCADE;
DROP TABLE IF EXISTS Attendance CASCADE;
DROP TABLE IF EXISTS Enrollments CASCADE;
DROP TABLE IF EXISTS GroupSchedules CASCADE;
DROP TABLE IF EXISTS Groups CASCADE;
DROP TABLE IF EXISTS TimeSlots CASCADE;
DROP TABLE IF EXISTS Rooms CASCADE;
DROP TABLE IF EXISTS Courses CASCADE;
DROP TABLE IF EXISTS Teachers CASCADE;
DROP TABLE IF EXISTS Students CASCADE;
DROP TABLE IF EXISTS PaymentMethods CASCADE;
DROP TABLE IF EXISTS CourseCategories CASCADE;
DROP TABLE IF EXISTS Specializations CASCADE;
DROP TABLE IF EXISTS DaysOfWeek CASCADE;