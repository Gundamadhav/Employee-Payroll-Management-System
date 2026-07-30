-- ============================================================
-- Employee Payroll Management System
-- File: Tables.sql
-- Purpose: Create all core tables (columns + primary keys only).
--          Foreign keys / unique / check constraints are added
--          separately in Constraints.sql
-- Run AFTER Database.sql
-- ============================================================

USE EmployeePayrollDB;

-- ------------------------------------------------------------
-- 1. Department
-- ------------------------------------------------------------
CREATE TABLE Department (
    DepartmentID     INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName   VARCHAR(100),
    Location         VARCHAR(100),
    CreatedAt        DATETIME
);

-- ------------------------------------------------------------
-- 2. Designation
-- ------------------------------------------------------------
CREATE TABLE Designation (
    DesignationID    INT AUTO_INCREMENT PRIMARY KEY,
    Title            VARCHAR(100),
    GradeLevel       VARCHAR(20),
    BaseSalary       DECIMAL(12,2)
);

-- ------------------------------------------------------------
-- 3. Employee
-- ------------------------------------------------------------
CREATE TABLE Employee (
    EmployeeID       INT AUTO_INCREMENT PRIMARY KEY,
    FirstName        VARCHAR(50),
    LastName         VARCHAR(50),
    Gender           VARCHAR(10),
    DOB              DATE,
    Email            VARCHAR(100),
    Phone            VARCHAR(20),
    Address          VARCHAR(255),
    HireDate         DATE,
    DepartmentID     INT,
    DesignationID    INT,
    ManagerID        INT,
    Status           VARCHAR(20)
);

-- ------------------------------------------------------------
-- 4. Attendance
-- ------------------------------------------------------------
CREATE TABLE Attendance (
    AttendanceID     INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID       INT,
    AttendanceDate   DATE,
    Status           VARCHAR(20),      -- Present / Absent / Leave / Half-Day
    CheckIn          TIME,
    CheckOut         TIME
);

-- ------------------------------------------------------------
-- 5. Salary  (structure/base pay assigned to an employee)
-- ------------------------------------------------------------
CREATE TABLE Salary (
    SalaryID         INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID       INT,
    BasicPay         DECIMAL(12,2),
    HRA              DECIMAL(12,2),
    ConveyanceAllowance DECIMAL(12,2),
    EffectiveDate    DATE
);

-- ------------------------------------------------------------
-- 6. Bonus
-- ------------------------------------------------------------
CREATE TABLE Bonus (
    BonusID          INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID       INT,
    BonusAmount      DECIMAL(12,2),
    Reason           VARCHAR(150),
    BonusDate        DATE
);

-- ------------------------------------------------------------
-- 7. Deduction
-- ------------------------------------------------------------
CREATE TABLE Deduction (
    DeductionID      INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID       INT,
    DeductionType    VARCHAR(100),      -- Tax / Loan / Insurance / Other
    Amount           DECIMAL(12,2),
    DeductionDate    DATE
);

-- ------------------------------------------------------------
-- 8. Payroll  (final computed pay for a given month)
-- ------------------------------------------------------------
CREATE TABLE Payroll (
    PayrollID        INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID       INT,
    PayMonth         INT,
    PayYear          INT,
    GrossSalary      DECIMAL(12,2),
    TotalDeductions  DECIMAL(12,2),
    NetSalary        DECIMAL(12,2),
    PaymentStatus    VARCHAR(20),       -- Pending / Paid
    PayrollDate      DATE
);

-- ------------------------------------------------------------
-- 9. BankAccount
-- ------------------------------------------------------------
CREATE TABLE BankAccount (
    BankAccountID    INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID       INT,
    BankName         VARCHAR(100),
    AccountNumber    VARCHAR(30),
    IFSCCode         VARCHAR(20),
    Branch           VARCHAR(100)
);

-- ------------------------------------------------------------
-- 10. UserLogin  (application login credentials, e.g. HR/admin)
-- ------------------------------------------------------------
CREATE TABLE UserLogin (
    UserID           INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID       INT,
    Username         VARCHAR(50),
    PasswordHash     VARCHAR(255),
    Role             VARCHAR(20),       -- Admin / HR / Employee
    LastLogin        DATETIME
);

-- ------------------------------------------------------------
-- 11. AuditLog  (used by triggers to track salary/data changes)
-- ------------------------------------------------------------
CREATE TABLE AuditLog (
    AuditID          INT AUTO_INCREMENT PRIMARY KEY,
    TableName        VARCHAR(50),
    OperationType    VARCHAR(20),       -- INSERT / UPDATE / DELETE
    RecordID         INT,
    OldValue         VARCHAR(255),
    NewValue         VARCHAR(255),
    ChangedBy        VARCHAR(50),
    ChangedAt        DATETIME
);
