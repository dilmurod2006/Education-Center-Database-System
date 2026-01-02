# Test Plan

## Education Center Database System

### Document Information
- **Project**: Education Center Database System
- **Unit**: BTEC Unit 10 - Database Design & Development
- **Version**: 1.0
- **Test Lead**: [To be assigned]
- **Last Updated**: January 2026

---

## Table of Contents
1. [Introduction](#introduction)
2. [Test Strategy](#test-strategy)
3. [Test Scope](#test-scope)
4. [Test Environment](#test-environment)
5. [Test Cases](#test-cases)
6. [Test Data](#test-data)
7. [Test Schedule](#test-schedule)
8. [Test Results](#test-results)
9. [Defect Management](#defect-management)
10. [Sign-Off](#sign-off)

---

## 1. Introduction

### 1.1 Purpose
This document outlines the comprehensive testing strategy for the Education Center Database System. It defines test objectives, scope, approach, resources, and schedule for testing activities.

### 1.2 Objectives
*[To be completed: Define testing objectives]*

- Verify database design meets requirements
- Validate data integrity and constraints
- Test all CRUD operations
- Ensure proper relationship implementation
- Validate business rules and logic
- Test security and access controls
- Verify backup and recovery procedures
- Assess performance and scalability

### 1.3 Test Deliverables
*[To be completed: List test deliverables]*

- Test plan document (this document)
- Test cases and test scripts
- Test data sets
- Test execution results
- Defect reports
- Test summary report

---

## 2. Test Strategy

### 2.1 Test Levels

#### Unit Testing
*[To be completed: Unit test approach]*
- Test individual tables and constraints
- Validate stored procedures
- Test triggers
- Verify views

#### Integration Testing
*[To be completed: Integration test approach]*
- Test table relationships
- Validate foreign key constraints
- Test multi-table queries
- Verify transaction handling

#### System Testing
*[To be completed: System test approach]*
- End-to-end workflow testing
- Complete business process validation
- User role and permission testing

#### Acceptance Testing
*[To be completed: Acceptance test approach]*
- User acceptance criteria validation
- Business requirement verification
- Performance benchmarking

### 2.2 Test Types

| Test Type | Description | Priority |
|-----------|-------------|----------|
| Functional Testing | Verify all features work correctly | High |
| Data Integrity Testing | Validate constraints and relationships | High |
| Security Testing | Test access controls and permissions | High |
| Performance Testing | Assess query performance | Medium |
| Stress Testing | Test under high load conditions | Medium |
| Recovery Testing | Verify backup and restore procedures | High |
| Usability Testing | Evaluate user interface (if applicable) | Low |

---

## 3. Test Scope

### 3.1 In Scope
*[To be completed: Define what will be tested]*

**Database Components:**
- All tables and their structures
- Primary key constraints
- Foreign key constraints
- Check constraints
- Unique constraints
- Default values
- Stored procedures
- Views
- Triggers
- Indexes

**Functional Areas:**
- Student management
- Course management
- Enrollment processes
- Attendance tracking
- Payment processing
- Reporting functionality

### 3.2 Out of Scope
*[To be completed: Define what will not be tested]*

- Front-end application (if separate)
- Third-party integrations (if any)
- Network infrastructure
- Hardware performance

---

## 4. Test Environment

### 4.1 Hardware Requirements
*[To be completed: Hardware specifications]*

- Server specifications
- Client machine requirements
- Network configuration

### 4.2 Software Requirements
*[To be completed: Software specifications]*

- Database Management System and version
- SQL client tools
- Testing tools
- Operating system

### 4.3 Test Database
*[To be completed: Test database setup]*

- Separate test database instance
- Test data population strategy
- Environment refresh procedures

---

## 5. Test Cases

### 5.1 Table Structure Tests

#### Test Case 1: Verify Students Table Creation
*[To be completed: Detailed test case]*

| Field | Details |
|-------|---------|
| Test ID | TC001 |
| Test Description | Verify Students table is created with correct structure |
| Prerequisites | Database access |
| Test Steps | 1. Execute table creation script<br>2. Verify table exists<br>3. Check column definitions<br>4. Validate constraints |
| Expected Result | Table created successfully with all specified columns and constraints |
| Actual Result | [To be filled during execution] |
| Status | [Pass/Fail] |
| Tested By | [Name] |
| Date | [Date] |

```sql
-- Test Query
DESCRIBE Students;
-- or
SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Students';
```

#### Test Case 2: Verify Courses Table Creation
*[To be completed: Similar structure]*

### 5.2 Constraint Tests

#### Test Case 3: Primary Key Constraint
*[To be completed: Test primary key constraints]*

```sql
-- Test: Insert duplicate primary key (should fail)
-- INSERT INTO Students (StudentID, FirstName, LastName) 
-- VALUES (1, 'John', 'Doe');
-- INSERT INTO Students (StudentID, FirstName, LastName) 
-- VALUES (1, 'Jane', 'Smith'); -- Should fail
```

#### Test Case 4: Foreign Key Constraint
*[To be completed: Test foreign key relationships]*

```sql
-- Test: Insert enrollment with invalid StudentID (should fail)
-- INSERT INTO Enrollments (StudentID, CourseID) 
-- VALUES (9999, 1); -- Should fail if StudentID doesn't exist
```

#### Test Case 5: Check Constraint
*[To be completed: Test check constraints]*

```sql
-- Test: Insert invalid data (should fail based on check constraints)
-- Examples:
-- Negative payment amount
-- Invalid date range
-- Invalid email format
```

#### Test Case 6: NOT NULL Constraint
*[To be completed: Test NOT NULL constraints]*

```sql
-- Test: Insert record with NULL in required field (should fail)
-- INSERT INTO Students (StudentID, FirstName, LastName) 
-- VALUES (2, NULL, 'Doe'); -- Should fail if FirstName is NOT NULL
```

### 5.3 CRUD Operation Tests

#### Test Case 7: Create (INSERT) Operations
*[To be completed: Test insert operations]*

```sql
-- Test: Insert valid student record
-- INSERT INTO Students (FirstName, LastName, Email, Phone) 
-- VALUES ('John', 'Doe', 'john.doe@email.com', '123-456-7890');

-- Verify insertion
-- SELECT * FROM Students WHERE Email = 'john.doe@email.com';
```

#### Test Case 8: Read (SELECT) Operations
*[To be completed: Test select queries]*

```sql
-- Test: Basic SELECT
-- SELECT * FROM Students;

-- Test: SELECT with WHERE clause
-- SELECT * FROM Students WHERE LastName = 'Doe';

-- Test: SELECT with JOIN
-- SELECT s.FirstName, s.LastName, c.CourseName
-- FROM Students s
-- JOIN Enrollments e ON s.StudentID = e.StudentID
-- JOIN Courses c ON e.CourseID = c.CourseID;
```

#### Test Case 9: Update (UPDATE) Operations
*[To be completed: Test update operations]*

```sql
-- Test: Update student information
-- UPDATE Students 
-- SET Email = 'newemail@email.com' 
-- WHERE StudentID = 1;

-- Verify update
-- SELECT * FROM Students WHERE StudentID = 1;
```

#### Test Case 10: Delete (DELETE) Operations
*[To be completed: Test delete operations]*

```sql
-- Test: Delete student record
-- DELETE FROM Students WHERE StudentID = 999;

-- Test: Cascade delete (if configured)
-- Verify related records are also deleted
```

### 5.4 Relationship Tests

#### Test Case 11: One-to-Many Relationship
*[To be completed: Test 1:N relationships]*

| Relationship | Tables | Test Scenario |
|--------------|--------|---------------|
| Student-Payments | Students → Payments | One student can have multiple payment records |
| Course-Enrollments | Courses → Enrollments | One course can have multiple enrollments |

#### Test Case 12: Many-to-Many Relationship
*[To be completed: Test M:N relationships]*

| Relationship | Junction Table | Test Scenario |
|--------------|----------------|---------------|
| Students-Courses | Enrollments | Student can enroll in multiple courses |
| Courses-Instructors | CourseInstructors | Course can have multiple instructors |

### 5.5 Business Logic Tests

#### Test Case 13: Enrollment Process
*[To be completed: Test complete enrollment workflow]*

**Scenario:** Enroll a student in a course

**Steps:**
1. Verify student exists
2. Verify course exists and has capacity
3. Check prerequisites (if any)
4. Insert enrollment record
5. Update course enrollment count
6. Generate confirmation

#### Test Case 14: Payment Processing
*[To be completed: Test payment workflow]*

#### Test Case 15: Attendance Recording
*[To be completed: Test attendance workflow]*

### 5.6 Stored Procedure Tests

#### Test Case 16: Test Stored Procedures
*[To be completed: Test each stored procedure]*

```sql
-- Example: Test enrollment stored procedure
-- CALL SP_EnrollStudent(studentId, courseId);
-- Verify results
```

### 5.7 View Tests

#### Test Case 17: Test Views
*[To be completed: Test each view]*

```sql
-- Example: Test active students view
-- SELECT * FROM VW_ActiveStudents;
-- Verify data accuracy
```

### 5.8 Trigger Tests

#### Test Case 18: Test Triggers
*[To be completed: Test each trigger]*

```sql
-- Example: Test audit trigger
-- UPDATE Students SET Email = 'test@email.com' WHERE StudentID = 1;
-- Verify audit log entry created
```

### 5.9 Performance Tests

#### Test Case 19: Query Performance
*[To be completed: Test query execution times]*

```sql
-- Test: Measure query execution time
-- EXPLAIN SELECT * FROM Students WHERE LastName = 'Smith';

-- Test: Large dataset queries
-- SELECT COUNT(*) FROM Enrollments;
-- Measure execution time
```

#### Test Case 20: Index Effectiveness
*[To be completed: Test index usage]*

```sql
-- Compare query performance with and without indexes
```

### 5.10 Security Tests

#### Test Case 21: User Permissions
*[To be completed: Test role-based access]*

**Test Scenarios:**
- Admin can perform all operations
- Staff has limited access
- Instructor can only view assigned courses
- ReadOnly user cannot modify data

#### Test Case 22: SQL Injection Prevention
*[To be completed: Test against SQL injection]*

### 5.11 Backup and Recovery Tests

#### Test Case 23: Database Backup
*[To be completed: Test backup procedures]*

**Steps:**
1. Perform full database backup
2. Verify backup file created
3. Check backup integrity

#### Test Case 24: Database Recovery
*[To be completed: Test restore procedures]*

**Steps:**
1. Create test database
2. Make changes to data
3. Restore from backup
4. Verify data restored correctly

---

## 6. Test Data

### 6.1 Test Data Requirements
*[To be completed: Define test data needs]*

**Data Categories:**
- Valid test data (positive tests)
- Invalid test data (negative tests)
- Boundary value data
- Large dataset for performance testing

### 6.2 Test Data Creation
*[To be completed: Test data generation strategy]*

```sql
-- Sample test data insertion
-- INSERT INTO Students (FirstName, LastName, Email, Phone) VALUES
-- ('Alice', 'Johnson', 'alice.j@email.com', '111-111-1111'),
-- ('Bob', 'Smith', 'bob.s@email.com', '222-222-2222'),
-- ('Carol', 'Williams', 'carol.w@email.com', '333-333-3333');

-- Insert test courses
-- INSERT INTO Courses (CourseName, Description, Duration, Fee) VALUES
-- ('Python Programming', 'Introduction to Python', 40, 500.00),
-- ('Web Development', 'HTML, CSS, JavaScript', 60, 750.00),
-- ('Database Design', 'SQL and Database Concepts', 50, 600.00);
```

### 6.3 Test Data Management
*[To be completed: Data cleanup and refresh procedures]*

---

## 7. Test Schedule

### 7.1 Testing Timeline
*[To be completed: Define testing phases and dates]*

| Phase | Start Date | End Date | Duration | Status |
|-------|-----------|----------|----------|--------|
| Test Planning | | | | |
| Test Environment Setup | | | | |
| Unit Testing | | | | |
| Integration Testing | | | | |
| System Testing | | | | |
| User Acceptance Testing | | | | |
| Test Closure | | | | |

### 7.2 Milestones
*[To be completed: Key milestones]*

---

## 8. Test Results

### 8.1 Test Execution Summary
*[To be completed during execution]*

| Test Category | Total Tests | Passed | Failed | Blocked | Pass Rate |
|---------------|-------------|--------|--------|---------|-----------|
| Table Structure | | | | | |
| Constraints | | | | | |
| CRUD Operations | | | | | |
| Relationships | | | | | |
| Business Logic | | | | | |
| Performance | | | | | |
| Security | | | | | |
| **TOTAL** | | | | | |

### 8.2 Detailed Test Results
*[To be completed: Link to detailed results]*

---

## 9. Defect Management

### 9.1 Defect Tracking
*[To be completed: Defect tracking process]*

**Defect Severity Levels:**
- **Critical**: System unusable, data loss
- **High**: Major functionality broken
- **Medium**: Feature doesn't work as expected
- **Low**: Minor issues, cosmetic problems

### 9.2 Defect Log
*[To be completed during testing]*

| Defect ID | Severity | Description | Status | Assigned To | Resolution |
|-----------|----------|-------------|--------|-------------|------------|
| | | | | | |

---

## 10. Sign-Off

### 10.1 Test Completion Criteria
*[To be completed: Define completion criteria]*

- [ ] All test cases executed
- [ ] 95% or higher pass rate achieved
- [ ] All critical and high severity defects resolved
- [ ] Test documentation complete
- [ ] Stakeholder approval obtained

### 10.2 Approval

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Test Lead | | | |
| Database Administrator | | | |
| Project Manager | | | |
| Stakeholder | | | |

---

## Appendix A: Test Scripts Location

All test SQL scripts are stored in: `/scripts/tests/`

---

## Appendix B: Testing Tools

*[To be completed: List of tools used]*

- SQL client tool
- Performance monitoring tools
- Backup/restore utilities

---

## Appendix C: Glossary

| Term | Definition |
|------|------------|
| Test Case | Specific condition to verify system behavior |
| Test Suite | Collection of test cases |
| Test Data | Data used for testing purposes |
| Pass Rate | Percentage of successful tests |
| Defect | Error or issue found during testing |

---

*Document Status: Template Created - Awaiting Test Execution*
*Last Updated: January 2026*
