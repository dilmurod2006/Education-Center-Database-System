-- =============================================
-- Fayl: 03_triggers.sql
-- Maqsad: Funksiyalarni jadvallardagi hodisalarga bog'lash
-- =============================================

CREATE TRIGGER trg_AfterPayment
AFTER INSERT ON Payments
FOR EACH ROW
EXECUTE FUNCTION fn_AfterPayment();

CREATE TRIGGER trg_CheckMonthlyBilling
BEFORE INSERT ON Attendance
FOR EACH ROW
EXECUTE FUNCTION fn_CheckMonthlyBilling();