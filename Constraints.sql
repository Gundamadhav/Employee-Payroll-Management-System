-- ============================================================
-- Employee Payroll Management System
-- File: Constraints.sql
-- Purpose: Add NOT NULL, UNIQUE, DEFAULT, CHECK and FOREIGN KEY
--          constraints on top of the tables created in Tables.sql
-- Run AFTER Tables.sql
-- ============================================================

USE EmployeePayrollDB;

-- ------------------------------------------------------------
-- Department
-- ------------------------------------------------------------
ALTER TABLE Department
    MODIFY DepartmentName VARCHAR(100) NOT NULL,
    MODIFY CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    ADD CONSTRAINT UQ_Department_Name UNIQUE (DepartmentName);

-- ------------------------------------------------------------
-- Designation
-- ------------------------------------------------------------
ALTER TABLE Designation
    MODIFY Title VARCHAR(100) NOT NULL,
    MODIFY BaseSalary DECIMAL(12,2) DEFAULT 0,
    ADD CONSTRAINT CHK_Designation_BaseSalary CHECK (BaseSalary >= 0);

-- ------------------------------------------------------------
-- Employee
-- ------------------------------------------------------------
ALTER TABLE Employee
    MODIFY FirstName VARCHAR(50) NOT NULL,
    MODIFY LastName VARCHAR(50) NOT NULL,
    MODIFY Email VARCHAR(100) NOT NULL,
    MODIFY HireDate DATE NOT NULL,
    MODIFY Status VARCHAR(20) DEFAULT 'Active',
    ADD CONSTRAINT UQ_Employee_Email UNIQUE (Email),
    ADD CONSTRAINT CHK_Employee_Gender CHECK (Gender IN ('Male', 'Female', 'Other')),
    ADD CONSTRAINT CHK_Employee_Status CHECK (Status IN ('Active', 'Inactive', 'Terminated')),
    ADD CONSTRAINT FK_Employee_Department FOREIGN KEY (DepartmentID)
        REFERENCES Department(DepartmentID) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT FK_Employee_Designation FOREIGN KEY (DesignationID)
        REFERENCES Designation(DesignationID) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT FK_Employee_Manager FOREIGN KEY (ManagerID)
        REFERENCES Employee(EmployeeID) ON DELETE SET NULL ON UPDATE CASCADE;

-- ------------------------------------------------------------
-- Attendance
-- ------------------------------------------------------------
ALTER TABLE Attendance
    MODIFY AttendanceDate DATE NOT NULL,
    MODIFY Status VARCHAR(20) DEFAULT 'Present',
    ADD CONSTRAINT CHK_Attendance_Status CHECK (Status IN ('Present', 'Absent', 'Leave', 'Half-Day')),
    ADD CONSTRAINT UQ_Attendance_Emp_Date UNIQUE (EmployeeID, AttendanceDate),
    ADD CONSTRAINT FK_Attendance_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID) ON DELETE CASCADE ON UPDATE CASCADE;

-- ------------------------------------------------------------
-- Salary
-- ------------------------------------------------------------
ALTER TABLE Salary
    MODIFY BasicPay DECIMAL(12,2) NOT NULL,
    MODIFY EffectiveDate DATE NOT NULL,
    ADD CONSTRAINT CHK_Salary_BasicPay CHECK (BasicPay >= 0),
    ADD CONSTRAINT FK_Salary_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID) ON DELETE CASCADE ON UPDATE CASCADE;

-- ------------------------------------------------------------
-- Bonus
-- ------------------------------------------------------------
ALTER TABLE Bonus
    MODIFY BonusAmount DECIMAL(12,2) NOT NULL DEFAULT 0,
    ADD CONSTRAINT CHK_Bonus_Amount CHECK (BonusAmount >= 0),
    ADD CONSTRAINT FK_Bonus_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID) ON DELETE CASCADE ON UPDATE CASCADE;

-- ------------------------------------------------------------
-- Deduction
-- ------------------------------------------------------------
ALTER TABLE Deduction
    MODIFY Amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    ADD CONSTRAINT CHK_Deduction_Amount CHECK (Amount >= 0),
    ADD CONSTRAINT FK_Deduction_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID) ON DELETE CASCADE ON UPDATE CASCADE;

-- ------------------------------------------------------------
-- Payroll
-- ------------------------------------------------------------
ALTER TABLE Payroll
    MODIFY PayMonth INT NOT NULL,
    MODIFY PayYear INT NOT NULL,
    MODIFY PaymentStatus VARCHAR(20) DEFAULT 'Pending',
    ADD CONSTRAINT CHK_Payroll_Month CHECK (PayMonth BETWEEN 1 AND 12),
    ADD CONSTRAINT CHK_Payroll_Status CHECK (PaymentStatus IN ('Pending', 'Paid')),
    ADD CONSTRAINT UQ_Payroll_Emp_Month_Year UNIQUE (EmployeeID, PayMonth, PayYear),
    ADD CONSTRAINT FK_Payroll_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID) ON DELETE CASCADE ON UPDATE CASCADE;

-- ------------------------------------------------------------
-- BankAccount
-- ------------------------------------------------------------
ALTER TABLE BankAccount
    MODIFY AccountNumber VARCHAR(30) NOT NULL,
    ADD CONSTRAINT UQ_BankAccount_Number UNIQUE (AccountNumber),
    ADD CONSTRAINT FK_BankAccount_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID) ON DELETE CASCADE ON UPDATE CASCADE;

-- ------------------------------------------------------------
-- UserLogin
-- ------------------------------------------------------------
ALTER TABLE UserLogin
    MODIFY Username VARCHAR(50) NOT NULL,
    MODIFY PasswordHash VARCHAR(255) NOT NULL,
    MODIFY Role VARCHAR(20) DEFAULT 'Employee',
    ADD CONSTRAINT UQ_UserLogin_Username UNIQUE (Username),
    ADD CONSTRAINT CHK_UserLogin_Role CHECK (Role IN ('Admin', 'HR', 'Employee')),
    ADD CONSTRAINT FK_UserLogin_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID) ON DELETE CASCADE ON UPDATE CASCADE;
