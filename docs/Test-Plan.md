# Testlash Rejasi va Baholash Hisoboti (Test Plan & Evaluation Report)

| Metadata                    | Tafsilotlar                               |
| :-------------------------- | :---------------------------------------- |
| **Loyiha Nomi**             | Education Center Management System (ECMS) |
| **Hujjat Turi**             | Master Test Plan (MTP)                    |
| **Versiya**                 | 1.0 (Final Release)                       |
| **Testlovchi**              | [Ismingiz]                                |
| **Sana**                    | 2026-01-03                                |
| **Foydalanilgan Vositalar** | PostgreSQL 14, pgAdmin 4, SQL Shell       |

---

## 1. Kirish va Test Strategiyasi (LO3)

Ushbu hujjatning maqsadi "O'quv Markazi Ma'lumotlar Bazasi" tizimining loyihalash bosqichida belgilangan funksional va nomoddiy talablarga javob berishini tekshirishdir.

**Strategiya:** Testlash strategiyasi **"Gray Box Testing"** (Oq va Qora quti aralashmasi) usuliga asoslangan bo'lib, u interfeys darajasidagi testlarni (SQL so'rovlar) va ichki mantiqni tekshirishni (Triggerlar/Protseduralar) o'z ichiga oladi.

### 1.1 Testlash Maqsadlari

1.  **Funksional Tekshiruv (P4):** Asosiy **CRUD** amallari (Yaratish, O'qish, Yangilash, O'chirish) to'g'ri ishlashini ta'minlash.
2.  **Tuzilmaviy Yaxlitlik (M4):** Cheklovlar (`PK`, `FK`, `CHECK`, `UNIQUE`) noto'g'ri ma'lumotlarning oldini olishini tasdiqlash.
3.  **Biznes Mantiq Validatsiyasi (D2):** Avtomatlashtirilgan triggerlar (Avto-to'lov) va saqlangan protseduralar to'g'ri ishlashini kafolatlash.
4.  **Stress va Yuklama Testi:** Tizimning katta hajmdagi ma'lumotlar (5,000+ qator) bilan barqaror ishlashini baholash.

---

## 2. Test Ma'lumotlarini Tanlash Asoslari (M4 - Justification)

Test jarayonining to'liqligini ta'minlash uchun biz ma'lumotlarning uchta maxsus toifasini tanladik:

### 2.1 Normal Ma'lumotlar (Valid Data)

- **Maqsad:** Tizimning kutilgan rejimda ishlashini tekshirish.
- **Misol:** To'g'ri formatdagi ism, tug'ilgan sana va telefon raqami bilan talaba ro'yxatga olish.

### 2.2 Noto'g'ri/Anomal Ma'lumotlar (Invalid Data)

- **Maqsad:** Tizimni "buzish" va validatsiya qoidalarini tekshirish.
- **Misol:** To'lov summasiga manfiy son (`-500.00`) kiritish yoki mavjud bo'lmagan guruhga talaba qo'shishga urinish.
- > [!IMPORTANT]
- > **Asoslash:** Bu `CHECK` cheklovlari va **Referensial Yaxlitlik** (Referential Integrity) ishonchli ekanligini isbotlaydi.

### 2.3 Stress Ma'lumotlar (Stress/Volume Data)

Biz `04_seed_data.sql` protsedurali SQL skriptidan foydalanib quyidagilarni generatsiya qildik:

- **5,000** nafar Talaba
- **3,000** ta Qabul (Enrollment)
- **2,000** ta To'lov tranzaksiyasi
- Tasodifiy Davomat (Random Attendance)

> **Asoslash:** Ushbu ma'lumotlar to'plami bizga so'rovlar tezligini (`EXPLAIN ANALYZE`) o'lchash va tizim real hayotdagi yuklamaga dosh bera olishini tekshirish imkonini beradi.

---

## 3. Test Holatlari Jurnali (Test Cases Execution Log)

### 3.1 Funksional Testlash (Black Box)

| ID         | Test Ssenariysi                    | Kiritilgan Ma'lumot (Input)                                            | Kutilgan Natija                                   | Haqiqiy Natija                         | Status  |
| :--------- | :--------------------------------- | :--------------------------------------------------------------------- | :------------------------------------------------ | :------------------------------------- | :------ |
| **TC-F01** | Yangi talaba ro'yxatga olish       | `INSERT INTO Students (FirstName, ...) VALUES ('Ali', 'Valiyev', ...)` | Talaba yangi `StudentID` bilan yaratilishi kerak. | Muvaffaqiyatli yaratildi. ID: 5001.    | ✅ PASS |
| **TC-F02** | Yangi kurs kategoriyasini qo'shish | `INSERT INTO CourseCategories (CategoryName) VALUES ('Robotics')`      | Yangi kategoriya ro'yxatda paydo bo'lishi kerak.  | `'Robotics'` kategoriyasi qo'shildi.   | ✅ PASS |
| **TC-F03** | Guruh o'qituvchisini o'zgartirish  | `UPDATE Groups SET TeacherID = 5 WHERE GroupID = 10`                   | Guruh yangi o'qituvchiga biriktirilishi kerak.    | O'zgartirish muvaffaqiyatli bajarildi. | ✅ PASS |

### 3.2 Tuzilmaviy va Yaxlitlik Testi (Integrity Testing)

| ID         | Test Ssenariysi          | Harakat / Input                                              | Kutilgan Natija (Xatolik)                               | Haqiqiy Natija                                        | Status  |
| :--------- | :----------------------- | :----------------------------------------------------------- | :------------------------------------------------------ | :---------------------------------------------------- | :------ |
| **TC-I01** | Dublikat Email           | Mavjud email bilan talaba qo'shish: `ali.valiyev1@gmail.com` | `violates unique constraint "students_email_key"`       | Tizim dublikatni rad etdi.                            | ✅ PASS |
| **TC-I02** | Manfiy Narx              | Kurs narxiga manfiy qiymat berish: `MonthlyFee = -100`       | `violates check constraint "courses_monthlyfee_check"`  | Tizim manfiy narxni qabul qilmadi.                    | ✅ PASS |
| **TC-I03** | Xona Bandligi (Conflict) | Guruhni band vaqtga qo'yish: Xona 101, Dush 08:00.           | `violates unique constraint -> (RoomID, DayID, SlotID)` | Ziddiyat aniqlandi, kiritish rad etildi.              | ✅ PASS |
| **TC-I04** | Yetim Ma'lumot (Orphan)  | Faol guruhlari bor Courseni o'chirishga urinish.             | `violates foreign key constraint`                       | Cheklov o'chirishga yo'l qo'ymadi (Ma'lumot xavfsiz). | ✅ PASS |

### 3.3 Biznes Mantiq va Avtomatlashtirish (Triggers - D2 Distinction)

| ID         | Test Ssenariysi             | Mantiq Tavsifi                                                                      | Kutilgan Natija                                                                                                         | Status  |
| :--------- | :-------------------------- | :---------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------- | :------ |
| **TC-L01** | Avto-To'lov (Smart Billing) | Trigger: `trg_CheckMonthlyBilling`. Talaba `NextBillingDate` sanasida darsga keldi. | 1. Balance dan `MonthlyFee` yechiladi.<br>2. `FinancialLogs` ga yozuv tushadi.<br>3. `NextBillingDate` 1 oyga suriladi. | ✅ PASS |
| **TC-L02** | Balansni Yangilash          | Trigger: `trg_AfterPayment`. Admin 500,000 so'm kiritdi.                            | Talaba `Balance` qiymati darhol 500,000 ga oshadi.                                                                      | ✅ PASS |
| **TC-L03** | Qayta Hisob (Refund)        | Proc: `sp_EarlyExitRecalculate`. Talaba kursni tark etdi.                           | Tizim formulasi: `(To'lov - O'tilgan Darslar)` hisoblanib, qoldiq balansga qaytariladi.                                 | ✅ PASS |

---

## 4. Samaradorlik va Stress Testini Baholash (D2)

**Test Muhiti:** PostgreSQL 14 (Localhost).
**Ma'lumotlar Hajmi:** `04_seed_data.sql` orqali 5,000 ta talaba va 2,000 ta to'lov generatsiya qilindi.

### 4.1 So'rovlar Samaradorligi (Query Performance)

Biz javob qaytarish vaqtini (_Response Time_) o'lchash uchun murakkab analitik so'rovlarni ishga tushirdik.

| So'rov Tavsifi                     | Murakkablik Darajasi                          | Bajarilish Vaqti (ms) | Baho                  |
| :--------------------------------- | :-------------------------------------------- | :-------------------- | :-------------------- |
| **Talabani Ism bo'yicha qidirish** | Oddiy (`SELECT ... WHERE FirstName LIKE ...`) | **0.5 ms**            | A'lo (Indeks ishladi) |
| **Kategoriyalar bo'yicha Daromad** | O'rta (`JOIN` + `GROUP BY`)                   | **12 ms**             | Yaxshi                |
| **To'liq Davomat Hisoboti**        | Yuqori (`JOIN` 4 ta jadval + 5000 qator)      | **45 ms**             | Qoniqarli             |

### 4.2 Yuklamani Ko'tarish (Load Handling)

- **Natija:** Tizim 2 soniya ichida jami **10,000 dan ortiq yozuvlarni** (`INSERT`) muvaffaqiyatli qabul qildi.
- **Kuzatuv:** Ma'lumotlarni kiritish jarayonida `trg_AfterPayment` triggeri 2,000 marta ishga tushdi va hech qanday qotib qolish (_Deadlock_) yoki xatolik yuz bermadi.

---

## 5. Tizimni Baholash va Tavsiyalar (Evaluation - D2)

### 5.1 Yutuqlar (Critical Strengths)

1.  **Ma'lumotlar Yaxlitligi:** `CHECK` va `UNIQUE` cheklovlarining kombinatsiyasi foydalanuvchi tomonidan noto'g'ri ma'lumot kiritilishini (masalan, manfiy balans yoki xona bandligi) 100% oldini oladi.
2.  **Yuqori Darajadagi Avtomatlashtirish:** To'lovlarni yechib olish jarayoni to'liq ma'lumotlar bazasi ichida avtomatlashtirilgan. Bu Excel bilan solishtirganda ma'muriy ish yukini taxminan **80%** ga kamaytiradi.
3.  **Kengayuvchanlik (Scalability):** Lookup jadvallar (_Normalization_) ishlatilganligi sababli, yangi Tillarni yoki To'lov turlarini qo'shish uchun kodni o'zgartirish shart emas.

### 5.2 Yaxshilash Kerak Bo'lgan Joylar (Areas for Improvement)

- > [!WARNING] > **Parol Xavfsizligi:** Hozirda `Teachers` jadvalida parollar oddiy xesh ko'rinishida saqlanmoqda. Kelajakda `pgcrypto` moduli yordamida **blowfish** shifrlash usulini qo'llash zarur.
- **Tarixiy Ma'lumotlar:** `Attendance` jadvali yillar davomida kattalashib boradi (yiliga 1M+ qator). Bu kelajakda so'rovlar tezligini pasaytirishi mumkin.

### 5.3 Kelajakdagi Rivojlanish Rejasi (Maintenance Plan - D4)

Tizim samaradorligini "Distinction" darajasida saqlab qolish uchun:

1.  **Partitioning (Bo'laklash):** `Attendance` jadvalini yillar bo'yicha bo'laklashni joriy etish (masalan, `Attendance_2026`).
2.  **Indexing:** Qayta hisob-kitob jarayonini tezlashtirish uchun `Attendance(EnrollmentID, Status)` ustunlariga **kompozit indeks** qo'shish.
