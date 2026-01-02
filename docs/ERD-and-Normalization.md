# ERD & Normalization Documentation

## Entity Relationship Diagram (ERD)

### Purpose
This document contains the Entity Relationship Diagrams for the Education Center Database System and details the normalization process applied to ensure data integrity and eliminate redundancy.

---

## 1. Conceptual ERD

### Overview
*[To be completed: High-level overview of entities and their relationships]*

### Key Entities
*[To be completed: List of main entities to be included in the database]*

#### Example Entities:
- Students
- Courses
- Instructors
- Enrollments
- Payments
- Attendance
- Schedules
- Rooms

---

## 2. Logical ERD

### Entity Definitions
*[To be completed: Detailed description of each entity with attributes]*

#### Example Entity Structure:

**Students**
- StudentID (PK)
- FirstName
- LastName
- DateOfBirth
- Email
- Phone
- Address
- EnrollmentDate

**Courses**
- CourseID (PK)
- CourseName
- Description
- Duration
- Fee
- Category

*[Continue with other entities]*

---

## 3. Physical ERD

### Database Schema Diagram
*[To be completed: Insert ERD diagram image or create using draw.io, Lucidchart, or dbdiagram.io]*

### Relationship Types
*[To be completed: Detail the cardinality of relationships]*

| Entity 1 | Relationship | Entity 2 | Type |
|----------|--------------|----------|------|
| Students | enrolls in | Courses | Many-to-Many |
| Courses | taught by | Instructors | Many-to-Many |
| Students | makes | Payments | One-to-Many |
| Students | has | Attendance | One-to-Many |

---

## 4. Normalization Process

### Unnormalized Form (UNF)
*[To be completed: Show initial data structure with repeating groups]*

#### Example UNF:
```
Student(StudentID, StudentName, CourseID, CourseName, InstructorName, 
        Payment1Date, Payment1Amount, Payment2Date, Payment2Amount, ...)
```

### First Normal Form (1NF)
*[To be completed: Eliminate repeating groups]*

**Rules Applied:**
- Remove repeating groups
- Ensure atomic values
- Identify primary keys

#### Example 1NF:
```
Student(StudentID, StudentName)
Course(CourseID, CourseName, InstructorName)
Payment(PaymentID, StudentID, PaymentDate, PaymentAmount)
```

### Second Normal Form (2NF)
*[To be completed: Remove partial dependencies]*

**Rules Applied:**
- Must be in 1NF
- Remove partial dependencies on composite keys
- Create separate tables for subsets of data

#### Example 2NF:
```
Student(StudentID, StudentName)
Course(CourseID, CourseName)
Instructor(InstructorID, InstructorName)
CourseInstructor(CourseID, InstructorID)
Payment(PaymentID, StudentID, PaymentDate, PaymentAmount)
```

### Third Normal Form (3NF)
*[To be completed: Remove transitive dependencies]*

**Rules Applied:**
- Must be in 2NF
- Remove transitive dependencies
- Ensure all non-key attributes depend only on the primary key

#### Example 3NF:
*[Final normalized table structure to be documented here]*

---

## 5. Data Dictionary

### Table Specifications

#### Students Table
*[To be completed: Complete data dictionary for each table]*

| Column Name | Data Type | Length | Null | Key | Default | Description |
|-------------|-----------|--------|------|-----|---------|-------------|
| StudentID | INT | - | NO | PK | Auto | Unique student identifier |
| FirstName | VARCHAR | 50 | NO | - | - | Student's first name |
| LastName | VARCHAR | 50 | NO | - | - | Student's last name |

*[Continue for all tables]*

---

## 6. Integrity Constraints

### Primary Keys
*[To be completed: List all primary keys]*

### Foreign Keys
*[To be completed: List all foreign key relationships]*

### Check Constraints
*[To be completed: List business rules implemented as constraints]*

### Unique Constraints
*[To be completed: List unique constraints beyond primary keys]*

---

## 7. Design Decisions & Rationale

### Key Design Choices
*[To be completed: Explain important design decisions]*

#### Examples:
1. **Enrollment as Junction Table**: Chosen to implement many-to-many relationship between Students and Courses
2. **Separate Payment Table**: Allows multiple payment records per student
3. **Attendance Tracking**: Linked to specific class sessions

---

## 8. Assumptions

*[To be completed: List assumptions made during database design]*

### Examples:
- Each course can have multiple instructors over time
- Students can enroll in multiple courses simultaneously
- Payments are tracked separately from enrollments
- Each class session requires attendance tracking

---

## Notes
- ERD diagrams can be created using tools like:
  - draw.io (free, web-based)
  - Lucidchart
  - dbdiagram.io
  - MySQL Workbench
  - Microsoft Visio

---

*Document Status: Template Created - Awaiting Implementation*
*Last Updated: January 2026*
