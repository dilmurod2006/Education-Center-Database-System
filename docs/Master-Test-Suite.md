# Master Test Suite: Education Center Database System

| **Project Name**  | Education Center Management System (ECMS) |
| :---------------- | :---------------------------------------- |
| **Document Type** | Master Test Suite (SQL Validation)        |
| **Role**          | Senior Database QA Engineer               |
| **Date**          | 2026-01-03                                |

This document defines the testing strategy, scenarios, input data, and expected outcomes to validate the integrity, functionality, and performance of the ECMS database.

---

## SECTION 1: Structural & Integrity Testing (Data Validation)

**Objective (M4):** Verify that the database schema enforces business rules through `CHECK`, `UNIQUE`, and Foreign Key constraints.

| Test Case ID  | Test Scenario                  | SQL Test Logic (Summary)                                                     | Input Data                   | Expected Result                                                                                 | Pass/Fail |
| :------------ | :----------------------------- | :--------------------------------------------------------------------------- | :--------------------------- | :---------------------------------------------------------------------------------------------- | :-------- |
| **TC-STR-01** | **Negative Price Validation**  | Attempt `INSERT` into `Courses` with negative fee.                           | `MonthlyFee = -100`          | **Error:** `CHECK constraint violation (MonthlyFee > 0)`                                        |           |
| **TC-STR-02** | **Duplicate Email Prevention** | Attempt `INSERT` into `Students` with existing email.                        | `Email = 'test@example.com'` | **Error:** `UNIQUE constraint violation (students_email_key)`                                   |           |
| **TC-STR-03** | **Orphan Record Prevention**   | Attempt `DELETE` from `Courses` that has linked `Groups`.                    | `DELETE CourseID=1`          | **Error:** `Foreign Key constraint violation (update or delete on table "courses" violates...)` |           |
| **TC-STR-04** | **Room Double-Booking**        | Attempt `INSERT` into `GroupSchedules` for same `RoomID`, `DayID`, `SlotID`. | `Room=1, Day=1, Slot=1`      | **Error:** `UNIQUE constraint violation (RoomID, DayID, SlotID)`                                |           |
| **TC-STR-05** | **Time Paradox Check**         | Attempt `INSERT` into `TimeSlots` where End < Start.                         | `14:00 - 13:00`              | **Error:** `CHECK constraint violation (EndTime > StartTime)`                                   |           |

---

## SECTION 2: Functional Testing (User Stories)

**Objective (P4):** Validate that the database supports core business operations (CRUD).

| Test Case ID  | User Story           | SQL Operation                | Expected Result                                          | Pass/Fail |
| :------------ | :------------------- | :--------------------------- | :------------------------------------------------------- | :-------- |
| **TC-FUN-01** | **Register Student** | `INSERT INTO Students...`    | New row added to `Students` table with generated ID.     |           |
| **TC-FUN-02** | **Create Group**     | `INSERT INTO Groups...`      | New group created, linked to correct Teacher and Course. |           |
| **TC-FUN-03** | **Enroll Student**   | `INSERT INTO Enrollments...` | Student linked to Group. `IsActive` defaults to `TRUE`.  |           |
| **TC-FUN-04** | **Mark Attendance**  | `INSERT INTO Attendance...`  | Attendance record created for specific date/student.     |           |

---

## SECTION 3: Business Logic & Automation Testing (The "Distinction" Part)

**Objective (D2):** Verify that Triggers and Stored Procedures correctly automate complex business rules.

### TC-BIO-01: Auto-Billing Logic (Smart Trigger)

- **Scenario:** A student attends class (`INSERT Attendance`) on their `NextBillingDate`.
- **Trigger:** `trg_CheckMonthlyBilling`
- **Expected Automations:**
  1.  **Deduction:** Student `Balance` decreases by `Courses.MonthlyFee`.
  2.  **Audit:** New row added to `MonthlyCharges` and `FinancialLogs`.
  3.  **Scheduling:** `Enrollments.NextBillingDate` advances by 1 month.

### TC-BIO-02: Payment Processing

- **Scenario:** Admin adds a payment record (`INSERT INTO Payments`).
- **Trigger:** `trg_AfterPayment`
- **Expected Result:** Student `Balance` is immediately updated. `FinancialLogs` records the transaction type "Payment".

### TC-BIO-03: Early Exit Refund (Stored Procedure)

- **Scenario:** Student leaves course early. Call `sp_EarlyExitRecalculate(EnrollmentID)`.
- **Logic:** $Refund = Fee - (Attended \times LessonPrice)$
- **Expected Result:** If Refund > 0, Student `Balance` increases. 'Adjustment' log entry created.

---

## SECTION 4: Performance & Stress Testing (Big Data)

**Objective:** Measure system performance under load using `EXPLAIN ANALYZE`.

### Analytical Query 1: Student Financial Report

- **Purpose:** Calculate total payments per student for top contributors.
- **Complexity:** JOINs (`Students` + `Payments`), Aggregation (`SUM`, `COUNT`), Filtering (`HAVING`).
- **Target:** Execution time < 50ms on 5,000 rows.

### Analytical Query 2: Resource Utilization (Room Capacity)

- **Purpose:** Compare `Room.Capacity` vs Actual Enrolled students per group.
- **Complexity:** Multi-Join (`Groups` -> `Enrollments` -> `Schedules` -> `Rooms`).
- **Target:** Execution time < 100ms.

---

## SECTION 5: Edge Case Testing (Negative Testing)

**Objective:** Ensure system robustness against invalid or nonsensical usage.

| Test Case ID  | Scenario              | Input                 | Expected System Behavior                                                            |
| :------------ | :-------------------- | :-------------------- | :---------------------------------------------------------------------------------- |
| **TC-EDG-01** | **Zero Payment**      | `Amount = 0`          | **Blocked:** `CHECK (Amount > 0)` prevents zero-value transactions.                 |
| **TC-EDG-02** | **Unknown Status**    | `Status = 'Sleeping'` | **Blocked:** `CHECK IN ('Present', ...)` rejects defining new statuses dynamically. |
| **TC-EDG-03** | **Future Attendance** | (Optional Constraint) | If implemented, prevents marking attendance for future dates.                       |

---

**Certified by:** Antigravity (Senior QA Engineer)
