erDiagram
STUDENTS ||--o{ ENROLLMENTS : "registers"
GROUPS ||--o{ ENROLLMENTS : "contains"
COURSES ||--o{ GROUPS : "categorized_into"
TEACHERS ||--o{ GROUPS : "teaches"
SCHEDULES ||--o{ GROUPS : "scheduled_at"
COURSE_CATEGORIES ||--o{ COURSES : "belongs_to"
SPECIALIZATIONS ||--o{ TEACHERS : "specializes_in"
ENROLLMENTS ||--o{ ATTENDANCE : "tracks"
ENROLLMENTS ||--o{ PAYMENTS : "billed_to"
PAYMENT_METHODS ||--o{ PAYMENTS : "paid_via"

    STUDENTS {
        int student_id PK
        string first_name
        string last_name
        date dob
        string email UK
        string phone
        timestamp registration_date
    }

    TEACHERS {
        int teacher_id PK
        string first_name
        string last_name
        int spec_id FK
        string email UK
        string phone
    }

    SPECIALIZATIONS {
        int spec_id PK
        string spec_name UK
    }

    COURSES {
        int course_id PK
        string course_name
        int category_id FK
        text description
        decimal course_fee
    }

    COURSE_CATEGORIES {
        int category_id PK
        string category_name UK
    }

    GROUPS {
        int group_id PK
        int course_id FK
        int teacher_id FK
        int schedule_id FK
        date start_date
        date end_date
    }

    SCHEDULES {
        int schedule_id PK
        string day_of_week
        time start_time
        time end_time
    }

    ENROLLMENTS {
        int enrollment_id PK
        int student_id FK
        int group_id FK
        date enrollment_date
    }

    ATTENDANCE {
        int attendance_id PK
        int enrollment_id FK
        date attendance_date
        enum status
    }

    PAYMENTS {
        int payment_id PK
        int enrollment_id FK
        int method_id FK
        decimal amount
        timestamp payment_date
    }

    PAYMENT_METHODS {
        int method_id PK
        string method_name UK
    }

```

```
