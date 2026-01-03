# Education Center Database System (ECMS)

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14%2B-blue.svg) ![License](https://img.shields.io/badge/License-MIT-green.svg) ![Status](https://img.shields.io/badge/Status-Distinction-gold.svg)

**BTEC Level 4 Unit 10: Database Design & Development** topshirig'i doirasida ishlab chiqilgan, to'liq funksional va avtomatlashtirilgan o'quv markazi boshqaruv tizimi.

---

## 📋 Loyiha Haqida (Project Overview)

Ushbu loyiha o'quv markazlaridagi qog'ozbozlik va Excel jadvallariga asoslangan eskirgan boshqaruv usulini zamonaviy **Relyatsion Ma'lumotlar Bazasi (RDBMS)** orqali almashtirishga qaratilgan. Tizim nafaqat ma'lumotlarni saqlaydi, balki **PL/pgSQL Triggerlar va Funksiyalar** yordamida biznes jarayonlarini (to'lovlar, qarzdorlik, davomat) to'liq avtomatlashtiradi.

### 🔥 Asosiy Imkoniyatlar (Key Features)

- **⚡ Avtomatik Billing:** Talaba darsga kelganda (_Attendance_), tizim to'lov vaqtini tekshiradi va avtomatik ravishda balansdan pul yechadi.
- **📅 Smart Scheduling:** Bir xonaga bir vaqtda ikkita guruh qo'yilishini (_Conflict_) mantiqiy darajada oldini oladi.
- **🛡️ Moliyaviy Audit:** Barcha to'lovlar va yechimlar `FinancialLogs` jadvalida xavfsiz saqlanadi.
- **💸 Qayta Hisob (Refund):** Kursni erta tark etganda, qoldiq pulni avtomatik hisoblab qaytarish mexanizmi mavjud.
- **🔒 Ma'lumotlar Butunligi:** `CHECK`, `UNIQUE` va `FOREIGN KEY` constraintlar orqali xato ma'lumot kiritishning oldi olingan.

---

## 🛠 Texnologiyalar (Tech Stack)

| Kategoriya             | Texnologiya                   |
| :--------------------- | :---------------------------- |
| **Database Engine**    | PostgreSQL 14+                |
| **Languages**          | SQL, PL/pgSQL                 |
| **Design Methodology** | Crow's Foot Notation (ERD)    |
| **Tools**              | pgAdmin 4 / DBeaver / VS Code |

---

## 📂 Fayl Tuzilmasi (Project Structure)

Loyiha professional darajada modulli tashkil etilgan bo'lib, har bir fayl o'z vazifasiga ega:

```bash
Education-Center-Database-System/
├── docs/                           # 📚 Loyiha hujjatlari (Distinction Evidence)
│   ├── ERD-and-Normalization.md    # Ma'lumotlar bazasi sxemasi va 3NF tahlili
│   ├── Technical-Documentation.md  # Texnik arxitektura va xizmat ko'rsatish
│   ├── Test-Plan.md                # Test strategiyasi va natijalari
│   ├── User-Manual.md              # Foydalanuvchi uchun qo'llanma
│   └── Master-Test-Suite.md        # To'liq test to'plami (Master Suite)
├── scripts/                        # ⚙️ SQL Skriptlar (Ketma-ket yuritilishi shart)
│   ├── 00_cleanup.sql              # Tozalash (Drop Tables)
│   ├── 01_ddl_tables.sql           # Jadvallar yaratish (Schema)
│   ├── 02_programmability.sql      # Funksiya va Protseduralar (Logic)
│   ├── 03_triggers.sql             # Avtomatlashtirish (Triggers)
│   ├── 04_seed_data.sql            # Test ma'lumotlari (5000+ qator)
│   └── 05_test_queries.sql         # Analitik hisobotlar va testlar
└── README.md                       # Loyiha haqida
```

---

## 🚀 O'rnatish va Ishga Tushirish (Installation)

Loyihani o'z kompyuteringizda ishga tushirish uchun quyidagi qadamlarni bajaring:

### 1-qadam: Repositoryni yuklab oling

```bash
git clone https://github.com/dilmurod2006/Education-Center-Database-System.git
cd Education-Center-Database-System
```

### 2-qadam: Ma'lumotlar bazasini yarating

PostgreSQL terminalida (`psql`) yoki **pgAdmin** orqali yangi baza yarating:

```sql
CREATE DATABASE EducationDB;
```

### 3-qadam: Skriptlarni tartib bilan yuriting

Skriptlar bir-biriga bog'liq, shuning uchun raqamlar tartibida (00 -> 04) ishga tushirish **juda muhim**:

**Terminal orqali (Linux/Mac/Windows):**

```bash
psql -U postgres -d EducationDB -f scripts/00_cleanup.sql
psql -U postgres -d EducationDB -f scripts/01_ddl_tables.sql
psql -U postgres -d EducationDB -f scripts/02_programmability.sql
psql -U postgres -d EducationDB -f scripts/03_triggers.sql
psql -U postgres -d EducationDB -f scripts/04_seed_data.sql
```

> **Eslatma:** Agar pgAdmin ishlatsangiz, har bir faylni ochib, ketma-ket **Execute (F5)** tugmasini bosing.

---

## 🧪 Testlash va Natijalar

Tizim **Functional**, **Structural** va **Stress** testlardan muvaffaqiyatli o'tgan.

- **Yuklama:** 5,000 talaba va 10,000+ tranzaksiya bilan sinovdan o'tkazildi.
- **Tezlik:** O'rtacha so'rov vaqti **< 50ms** (`EXPLAIN ANALYZE` natijalari).
- **Batafsil:** [Test Hisoboti](docs/Test-Plan.md) va [Master Test Suite](docs/Master-Test-Suite.md)

---

## 📝 Muallif

**[Ismingiz]**

- **Kurs:** BTEC Level 4 HND in Digital Technologies
- **Fan:** Unit 10: Database Design and Development
- **ID:** [Talaba ID raqamingiz]
- **GitHub:** [@dilmurod2006](https://github.com/dilmurod2006)

---

_Loyiha 2026-yil yanvar oyida yakunlandi._
