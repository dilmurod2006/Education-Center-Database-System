# Foydalanuvchi Qo'llanmasi (User Manual)

| Metadata             | Tafsilotlar                                |
| :------------------- | :----------------------------------------- |
| **Tizim Nomi**       | Education Center Management System (ECMS)  |
| **Foydalanuvchilar** | Administratorlar, Menejerlar, Buxgalterlar |
| **Versiya**          | 1.0                                        |
| **Sana**             | 2026-01-03                                 |
| **Til**              | O'zbek                                     |

---

## 1. Tizim Haqida Umumiy Ma'lumot

Ushbu tizim o'quv markazining kundalik faoliyatini avtomatlashtirish uchun ishlab chiqilgan. Tizim Excel jadvallari o'rnini bosadi va quyidagi imkoniyatlarni beradi:

- **Markazlashgan Baza:** Barcha talabalar, o'qituvchilar va to'lovlar yagona joyda saqlanadi.
- **Avtomatik Hisob-kitob:** Oylik to'lovlar va qarzdorliklar tizim tomonidan avtomatik hisoblanadi (Inson omilisiz).
- **Xatolar Oldini Olish:** Bir vaqtning o'zida ikkita guruhni bitta xonaga qo'yish yoki manfiy to'lov kiritish kabi xatolarga yo'l qo'yilmaydi.

---

## 2. Ishni Boshlash (Getting Started)

Tizim bilan ishlash uchun sizga **pgAdmin 4** yoki shunga o'xshash interfeys kerak bo'ladi. Barcha amallar SQL buyruqlari yoki grafik interfeys orqali bajariladi.

> [!IMPORTANT] > **Asosiy Qoidalar:**
>
> - **Qizil maydonlar:** `NOT NULL` deb belgilangan ustunlar bo'sh qolishi mumkin emas.
> - **Sana formati:** Sanalarni har doim `'YYYY-MM-DD'` (Yil-Oy-Kun) formatida kiriting (Masalan: `'2026-01-03'`).
> - **Telefon raqam:** Xalqaro formatda kiritish tavsiya etiladi (`+998901234567`).

---

## 3. Kundalik Vazifalar (Daily Operations)

### 3.1 Yangi Talabani Ro'yxatga Olish

Yangi kelgan talabani bazaga kiritish.

**SQL Buyrug'i:**

```sql
INSERT INTO Students (FirstName, LastName, DateOfBirth, Phone, Email)
VALUES ('Ali', 'Valiyev', '2005-05-10', '+998901234567', 'ali@example.com');
```

> **Eslatma:** Agar kiritilgan Email bazada mavjud bo'lsa, tizim xatolik beradi (_Duplicate Key_). Iltimos, boshqa email ishlating.

### 3.2 Yangi Guruh Yaratish

O'quv kursi uchun guruh ochish va o'qituvchi biriktirish.

**Qadamlar:**

1.  `Groups` jadvaliga guruh nomini kiriting.
2.  `GroupSchedules` jadvaliga dars vaqtlarini kiriting.

> [!WARNING] > **Diqqat! (Conflict Check):**
> Agar siz tanlagan vaqtda (`DayID`, `SlotID`) tanlangan xona (`RoomID`) band bo'lsa, tizim guruhni saqlashga ruxsat bermaydi. Iltimos, bo'sh xona yoki boshqa vaqtni tanlang.

### 3.3 Talabani Guruhga Qo'shish (Enrollment)

Talaba shartnoma tuzgandan so'ng, uni guruhga biriktirish kerak.

```sql
INSERT INTO Enrollments (StudentID, GroupID, NextBillingDate)
VALUES (101, 5, '2026-02-01');
```

> [!TIP] > **Muhim:** `NextBillingDate` (Keyingi to'lov sanasi) ni to'g'ri belgilang. Tizim aynan shu sanada talaba balansidan pul yechadi.

---

## 4. Moliyaviy Boshqaruv (Financial Management)

Bu tizimning eng aqlli qismi hisoblanadi.

### 4.1 To'lov Qabul Qilish

Talaba kassaga pul to'laganda quyidagi amal bajariladi:

```sql
INSERT INTO Payments (StudentID, MethodID, Amount)
VALUES (101, 1, 500000); -- 101-talaba, Naqd (1), 500 ming so'm
```

**Natija (Avtomatizatsiya):**

1.  Siz talaba balansini qo'lda o'zgartirishingiz shart emas.
2.  Tizim (`trg_AfterPayment` triggeri) avtomatik ravishda talabaning **Balance** ustuniga `500,000` qo'shadi.
3.  `FinancialLogs` jadvaliga audit uchun yozuv tushadi.

### 4.2 Oylik To'lovni Yechish (Billing)

**Siz hech narsa qilishingiz shart emas!**

Talaba darsga kelib, davomat qilinganda:

1.  Tizim tekshiradi: _"Bugun to'lov kuni (NextBillingDate) keldimi?"_
2.  Agar kelgan bo'lsa: Tizim talaba balansidan kurs narxini yechib oladi.
3.  To'lov sanasini keyingi oyga suradi.

### 4.3 Kursni Tark Etish va Qayta Hisob (Refund)

Agar talaba kursni yarmida tashlab ketsa, qoldiq pulni qaytarish uchun maxsus buyruqdan foydalaning:

```sql
CALL sp_EarlyExitRecalculate(205); -- 205 bu EnrollmentID
```

**Tizim nima qiladi?**

- Talaba qatnashgan darslarni sanaydi.
- `To'langan summa - (Darslar soni * Dars narxi)` formulasini ishlatadi.
- Ortiqcha pulni talaba balansiga qaytaradi.

---

## 5. Davomat Yuritish (Attendance)

O'qituvchi yoki administrator har bir dars uchun davomat kiritishi shart.

```sql
INSERT INTO Attendance (EnrollmentID, AttendanceDate, Status)
VALUES (205, '2026-01-03', 'Present');
```

**Ruxsat etilgan Statuslar:**

- `'Present'` - Bor
- `'Absent'` - Yo'q
- `'Late'` - Kechikdi

> Boshqa so'zlar (masalan, 'Keldi', 'Sababli') kiritilsa, tizim xatolik beradi.

---

## 6. Hisobotlar va Tahlil (Reporting)

Rahbariyat uchun kerakli ma'lumotlarni olish uchun tayyor so'rovlar (Queries):

### 6.1 Qarzdorlar Ro'yxati

Balansi 0 dan kam bo'lgan barcha talabalarni ko'rish:

```sql
SELECT FirstName, LastName, Phone, Balance
FROM Students
WHERE Balance < 0;
```

### 6.2 O'qituvchilar Yuklamasi

Qaysi o'qituvchida nechta guruh va talaba bor?

```sql
SELECT t.FirstName, COUNT(g.GroupID) as Guruhlar_Soni
FROM Teachers t
JOIN Groups g ON t.TeacherID = g.TeacherID
GROUP BY t.FirstName;
```

### 6.3 Guruhdagi Bo'sh Joylar

Qaysi guruh to'lib qolganini tekshirish:

```sql
SELECT g.GroupName, r.Capacity, COUNT(e.StudentID) as Band_Joylar
FROM Groups g
JOIN GroupSchedules gs ON g.GroupID = gs.GroupID
JOIN Rooms r ON gs.RoomID = r.RoomID
JOIN Enrollments e ON g.GroupID = e.GroupID
GROUP BY g.GroupName, r.Capacity;
```

---

## 7. Muammolar va Yechimlar (Troubleshooting)

Foydalanish jarayonida chiqishi mumkin bo'lgan eng keng tarqalgan xatolar:

| Xatolik Xabari (Error Message)                                        | Sababi                                                               | Yechimi                                                               |
| :-------------------------------------------------------------------- | :------------------------------------------------------------------- | :-------------------------------------------------------------------- |
| `duplicate key value violates unique constraint "students_email_key"` | Siz kiritmoqchi bo'lgan Email allaqachon boshqa talabada mavjud.     | Emailni tekshiring yoki boshqasini kiriting.                          |
| `violates check constraint "courses_monthlyfee_check"`                | Kurs narxiga manfiy son yoki 0 kiritdingiz.                          | Narx musbat bo'lishi shart (masalan, 100000).                         |
| `violates unique constraint "groupschedules_..._key"`                 | Xona yoki vaqt band.                                                 | Jadvalni tekshirib, boshqa xona yoki vaqtni tanlang.                  |
| `violates foreign key constraint`                                     | Siz mavjud bo'lmagan ID (masalan, yo'q o'qituvchi IDsi) kiritdingiz. | Avval o'qituvchilar ro'yxatini (`SELECT * FROM Teachers`) tekshiring. |

---

## 8. Xavfsizlik Tavsiyalari

1.  **Parol:** O'zingizning ma'lumotlar bazasi parolingizni hech kimga bermang.
2.  **Backup:** Har kuni ish tugagandan so'ng, tizimdan zaxira nusxa (Backup) oling.
3.  **O'chirish:** `DELETE` buyrug'ini ishlatishda ehtiyot bo'ling. Talabani o'chirsangiz, uning barcha davomat va to'lov tarixi ham o'chib ketadi (_Cascade_). Agar shunchaki talaba o'qishni tugatgan bo'lsa, uni o'chirmang, shunchaki guruhdan chiqaring.
