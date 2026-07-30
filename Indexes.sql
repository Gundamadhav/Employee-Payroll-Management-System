-- ============================================================
-- Employee Payroll Management System
-- File: Indexes.sql
-- Purpose: Speed up frequently searched/filtered columns
-- ============================================================

USE EmployeePayrollDB;

-- Employee lookups
CREATE INDEX idx_Employee_DepartmentID ON Employee (DepartmentID);
CREATE INDEX idx_Employee_DesignationID ON Employee (DesignationID);
CREATE INDEX idx_Employee_Email ON Employee (Email);
CREATE INDEX idx_Employee_Status ON Employee (Status);

-- Attendance lookups (frequently filtered by employee + date range)
CREATE INDEX idx_Attendance_EmployeeID ON Attendance (EmployeeID);
CREATE INDEX idx_Attendance_Date ON Attendance (AttendanceDate);

-- Salary lookups
CREATE INDEX idx_Salary_EmployeeID ON Salary (EmployeeID);

-- Payroll lookups (reporting by month/year is very common)
CREATE INDEX idx_Payroll_EmployeeID ON Payroll (EmployeeID);
CREATE INDEX idx_Payroll_PayrollDate ON Payroll (PayrollDate);
CREATE INDEX idx_Payroll_MonthYear ON Payroll (PayMonth, PayYear);

-- Bonus / Deduction lookups
CREATE INDEX idx_Bonus_EmployeeID ON Bonus (EmployeeID);
CREATE INDEX idx_Deduction_EmployeeID ON Deduction (EmployeeID);

-- ------------------------------------------------------------
-- Verify indexes on a table (example)
-- ------------------------------------------------------------
-- SHOW INDEX FROM Employee;
-- SHOW INDEX FROM Payroll;
