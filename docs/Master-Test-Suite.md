# Asosiy Test To'plami (Master Test Suite): Education Center Database System

| **Loyiha Nomi** | Education Center Management System (ECMS) |
| :-------------- | :---------------------------------------- |
| **Hujjat Turi** | Asosiy Test To'plami (SQL Validatsiya)    |
| **Rol**         | Senior Database QA Engineer               |
| **Sana**        | 2026-01-03                                |

Ushbu hujjat ECMS ma'lumotlar bazasining yaxlitligi (integrity), funksionalligi va samaradorligini tekshirish uchun test strategiyasi, ssenariylari, kiruvchi ma'lumotlar va kutilayotgan natijalarni belgilaydi.

---

## 1-BO'LIM: Tuzilmaviy va Yaxlitlik Testi (Ma'lumotlar Validatsiyasi)

**Maqsad (M4):** Ma'lumotlar bazasi sxemasi biznes qoidalarini `CHECK`, `UNIQUE` va `Foreign Key` (Tashqi Kalit) cheklovlari orqali qanchalik to'g'ri bajarayotganini tekshirish.

| Test ID       | Test Ssenariysi                 | SQL Test Mantig'i (Qisqacha)                                                          | Kiruvchi Ma'lumot            | Kutilgan Natija                                                                                   | Status |
| :------------ | :------------------------------ | :------------------------------------------------------------------------------------ | :--------------------------- | :------------------------------------------------------------------------------------------------ | :----- |
| **TC-STR-01** | **Manfiy Narx Validatsiyasi**   | `Courses` jadvaliga manfiy narx bilan `INSERT` qilishga urinish.                      | `MonthlyFee = -100`          | **Xatolik:** `CHECK constraint violation (MonthlyFee > 0)`                                        |        |
| **TC-STR-02** | **Dublikat Email Oldini Olish** | `Students` jadvaliga mavjud email bilan `INSERT` qilishga urinish.                    | `Email = 'test@example.com'` | **Xatolik:** `UNIQUE constraint violation (students_email_key)`                                   |        |
| **TC-STR-03** | **Yetim Yozuvlar (Orphan)**     | Bog'langan `Groups` mavjud bo'lgan `Courses` yozuvini `DELETE` qilish.                | `DELETE CourseID=1`          | **Xatolik:** `Foreign Key constraint violation (update or delete on table "courses" violates...)` |        |
| **TC-STR-04** | **Xona Bandligi (Double-Book)** | `GroupSchedules` ga bir xil `RoomID`, `DayID`, `SlotID` kiritishga urinish.           | `Room=1, Day=1, Slot=1`      | **Xatolik:** `UNIQUE constraint violation (RoomID, DayID, SlotID)`                                |        |
| **TC-STR-05** | **Vaqt Paradoksi Tekshiruvi**   | `TimeSlots` jadvaliga Tugash vaqti Boshlanish vaqtidan oldin bo'lgan vaqtni kiritish. | `14:00 - 13:00`              | **Xatolik:** `CHECK constraint violation (EndTime > StartTime)`                                   |        |

---

## 2-BO'LIM: Funksional Testlash (Foydalanuvchi Hikoyalari)

**Maqsad (P4):** Ma'lumotlar bazasi asosiy biznes operatsiyalarini (CRUD) qo'llab-quvvatlashini tasdiqlash.

| Test ID       | Foydalanuvchi Hikoyasi (User Story) | SQL Operatsiyasi             | Kutilgan Natija                                                       | Status |
| :------------ | :---------------------------------- | :--------------------------- | :-------------------------------------------------------------------- | :----- |
| **TC-FUN-01** | **Talabani Ro'yxatga Olish**        | `INSERT INTO Students...`    | `Students` jadvaliga yangi qator avtomatik ID bilan qo'shildi.        |        |
| **TC-FUN-02** | **Guruh Yaratish**                  | `INSERT INTO Groups...`      | Yangi guruh yaratildi, to'g'ri O'qituvchi va Kursga bog'landi.        |        |
| **TC-FUN-03** | **Talabani Qabul Qilish (Enroll)**  | `INSERT INTO Enrollments...` | Talaba Guruhga bog'landi. `IsActive` qiymati avtomatik `TRUE` bo'ldi. |        |
| **TC-FUN-04** | **Davomatni Bel -gilash**           | `INSERT INTO Attendance...`  | Aniq sana va talaba uchun davomat yozuvi yaratildi.                   |        |

---

## 3-BO'LIM: Biznes Mantiq va Avtomatlashtirish Testi ("Distinction" Qismi)

**Maqsad (D2):** Triggerlar va Saqlangan Protseduralar (Stored Procedures) murakkab biznes qoidalarini to'g'ri avtomatlashtirayotganini tekshirish.

### TC-BIO-01: Avtomatik To'lov Mantig'i (Smart Trigger)

- **Ssenariya:** Talaba o'zining `NextBillingDate` (Keyingi to'lov kuni) sanasida darsga keldi (`INSERT Attendance`).
- **Trigger:** `trg_CheckMonthlyBilling`
- **Kutilayotgan Avtomatlashtirish:**
  1.  **Yechib Olish:** Talaba `Balance` hisobidan `Courses.MonthlyFee` miqdori ayriladi.
  2.  **Audit:** `MonthlyCharges` va `FinancialLogs` jadvallariga yangi yozuv qo'shiladi.
  3.  **Rejalashtirish:** `Enrollments.NextBillingDate` 1 oyga oldinga suriladi.

### TC-BIO-02: To'lovni Qayta Ishlash

- **Ssenariya:** Admin to'lov yozuvini qo'shadi (`INSERT INTO Payments`).
- **Trigger:** `trg_AfterPayment`
- **Kutilgan Natija:** Talaba `Balance` qiymati darhol yangilanadi. `FinancialLogs` da "Payment" turidagi tranzaksiya qayd etiladi.

### TC-BIO-03: Erta Chiqib Ketish va Qayta Hisob (Stored Procedure)

- **Ssenariya:** Talaba kursni vaqtli tark etdi. `sp_EarlyExitRecalculate(EnrollmentID)` chaqiriladi.
- **Mantiq:** $Qaytarish = Narx - (Qatnashganlar \times DarsNarxi)$
- **Kutilgan Natija:** Agar Qaytarish summasi > 0 bo'lsa, Talaba `Balance` qiymati oshadi. 'Adjustment' log yozuvi yaratiladi.

---

## 4-BO'LIM: Samaradorlik va Yuklama Testi (Katta Ma'lumotlar)

**Maqsad:** `EXPLAIN ANALYZE` yordamida tizimning yuklama ostidagi ishlash tezligini o'lchash.

### Analitik So'rov 1: Talabalar Moliyaviy Hisoboti

- **Maqsad:** Eng ko'p to'lov qilgan talabalar bo'yicha umumiy to'lovlar summasini hisoblash.
- **Murakkablik:** JOINs (`Students` + `Payments`), Aggregatsiya (`SUM`, `COUNT`), Filtrlash (`HAVING`).
- **Nishon:** 5,000 qatorli ma'lumotda bajarilish vaqti < 50ms.

### Analitik So'rov 2: Resurslardan Foydalanish (Xona Sig'imi)

- **Maqsad:** Xona Sig'imi (`Room.Capacity`) va Haqiqiy yozilgan talabalar sonini solishtirish.
- **Murakkablik:** Multi-Join (`Groups` -> `Enrollments` -> `Schedules` -> `Rooms`).
- **Nishon:** Bajarilish vaqti < 100ms.

---

## 5-BO'LIM: Chegara Holatlari Testi (Negative Testing)

**Maqsad:** Tizimning noto'g'ri yoki mantiqsiz foydalanishga qarshi barqarorligini ta'minlash.

| Test ID       | Ssenariya               | Kirish Ma'lumoti      | Kutilayotgan Tizim Reaksiyasi                                                              |
| :------------ | :---------------------- | :-------------------- | :----------------------------------------------------------------------------------------- |
| **TC-EDG-01** | **Nol Qiymatli To'lov** | `Amount = 0`          | **Bloklandi:** `CHECK (Amount > 0)` nol qiymatli tranzaksiyalarni taqiqlaydi.              |
| **TC-EDG-02** | **Noma'lum Status**     | `Status = 'Sleeping'` | **Bloklandi:** `CHECK IN ('Present', ...)` yangi statuslarni dinamik kiritishni rad etadi. |
| **TC-EDG-03** | **Kelajakdagi Davomat** | (Ixtiyoriy Cheklov)   | Agar joriy qilingan bo'lsa, kelajak sanalar uchun davomat yozishni taqiqlaydi.             |

---

**Tasdiqladi:** Antigravity (Senior QA Engineer)
