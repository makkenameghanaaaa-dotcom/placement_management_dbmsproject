CREATE DATABASE placement_management;
USE placement_management;
SELECT DATABASE();

CREATE TABLE student (
    reg_no VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    branch VARCHAR(50) NOT NULL,
    cgpa DECIMAL(3,2) NOT NULL,
    graduation_year YEAR NOT NULL,
    resume_url VARCHAR(255)
);

CREATE TABLE company (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE job_role (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE job_posting (
    company_role_id INT PRIMARY KEY AUTO_INCREMENT,

    company_id INT NOT NULL,
    role_id INT NOT NULL,

    salary DECIMAL(10,2) NOT NULL,
    application_deadline DATE NOT NULL,
    minimum_cgpa DECIMAL(3,2) NOT NULL,

    FOREIGN KEY (company_id)
        REFERENCES company(company_id),

    FOREIGN KEY (role_id)
        REFERENCES job_role(role_id),

    UNIQUE (company_id, role_id, application_deadline),

    CHECK (minimum_cgpa BETWEEN 0 AND 10),
    CHECK (salary >= 0)
);

CREATE TABLE job_posting_branch (
    company_role_id INT NOT NULL,
    branch VARCHAR(50) NOT NULL,

    PRIMARY KEY (company_role_id, branch),

    FOREIGN KEY (company_role_id)
        REFERENCES job_posting(company_role_id)
        ON DELETE CASCADE
);

CREATE TABLE application (
    application_id INT PRIMARY KEY AUTO_INCREMENT,

    reg_no VARCHAR(20) NOT NULL,
    company_role_id INT NOT NULL,

    applied_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'APPLIED',

    FOREIGN KEY (reg_no)
        REFERENCES student(reg_no),

    FOREIGN KEY (company_role_id)
        REFERENCES job_posting(company_role_id),

    UNIQUE (reg_no, company_role_id),

    CHECK (status IN ('APPLIED', 'SHORTLISTED', 'REJECTED'))
);

CREATE TABLE oa (
    oa_id INT PRIMARY KEY AUTO_INCREMENT,

    company_role_id INT NOT NULL,
    scheduled_date DATE NOT NULL,
    duration_minutes INT NOT NULL,

    FOREIGN KEY (company_role_id)
        REFERENCES job_posting(company_role_id),

    CHECK (duration_minutes > 0)
);

CREATE TABLE oa_schedule (
    oa_schedule_id INT PRIMARY KEY AUTO_INCREMENT,

    oa_id INT NOT NULL,
    application_id INT NOT NULL,

    scheduled_at DATETIME NOT NULL,

    score DECIMAL(5,2),
    result VARCHAR(10),

    FOREIGN KEY (oa_id)
        REFERENCES oa(oa_id),

    FOREIGN KEY (application_id)
        REFERENCES application(application_id),

    UNIQUE (oa_id, application_id),

    CHECK (result IN ('PASS', 'FAIL') OR result IS NULL),
    CHECK (score IS NULL OR score >= 0)
);

CREATE TABLE interview (
    interview_id INT PRIMARY KEY AUTO_INCREMENT,

    company_role_id INT NOT NULL,
    round_name VARCHAR(50) NOT NULL,

    FOREIGN KEY (company_role_id)
        REFERENCES job_posting(company_role_id)
);

CREATE TABLE interview_schedule (
    interview_schedule_id INT PRIMARY KEY AUTO_INCREMENT,

    interview_id INT NOT NULL,
    application_id INT NOT NULL,

    scheduled_at DATETIME NOT NULL,
    result VARCHAR(20),

    FOREIGN KEY (interview_id)
        REFERENCES interview(interview_id),

    FOREIGN KEY (application_id)
        REFERENCES application(application_id),

    UNIQUE (interview_id, application_id),

    CHECK (
        result IN ('PASS', 'FAIL', 'SELECTED')
        OR result IS NULL
    )
);

CREATE TABLE offer (
    offer_id INT PRIMARY KEY AUTO_INCREMENT,

    application_id INT NOT NULL UNIQUE,

    offer_date DATE NOT NULL,
    ctc DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'OFFERED',

    FOREIGN KEY (application_id)
        REFERENCES application(application_id),

    CHECK (ctc >= 0),
    CHECK (status IN ('OFFERED', 'ACCEPTED', 'DECLINED'))
);

