-- ============================================================
-- Employee Payroll Management System
-- File: CRUD_Queries.sql
-- Purpose: Demonstrate basic CREATE, READ, UPDATE, DELETE
--          operations on the schema
-- ============================================================

USE EmployeePayrollDB;

-- ------------------------------------------------------------
-- CREATE (INSERT)
-- ------------------------------------------------------------

-- Add a new department
INSERT INTO Department (DepartmentName, Location, CreatedAt)
VALUES ('Research & Development', 'Building D, 1st Floor', NOW());

-- Add a new employee
INSERT INTO Employee
    (FirstName, LastName, Gender, DOB, Email, Phone, Address, HireDate, DepartmentID, DesignationID, ManagerID, Status)
VALUES
    ('Arun', 'Kapoor', 'Male', '1995-03-14', 'arun.kapoor@epms.com', '9876543210',
     '12 MG Road, Chennai', '2026-07-01', 1, 1, 5, 'Active');

-- ------------------------------------------------------------
-- READ (SELECT / WHERE / ORDER BY)
-- ------------------------------------------------------------

-- All active employees, most recently hired first
SELECT EmployeeID, FirstName, LastName, HireDate, Status
FROM Employee
WHERE Status = 'Active'
ORDER BY HireDate DESC;

-- Search for an employee by partial name
SELECT EmployeeID, FirstName, LastName, Email
FROM Employee
WHERE FirstName LIKE 'A%'
ORDER BY FirstName;

-- Employees hired in a given date range
SELECT EmployeeID, FirstName, LastName, HireDate
FROM Employee
WHERE HireDate BETWEEN '2020-01-01' AND '2023-12-31'
ORDER BY HireDate;

-- ------------------------------------------------------------
-- UPDATE
-- ------------------------------------------------------------

-- Update an employee's contact details
UPDATE Employee
SET Phone = '9123456780', Address = '45 Ring Road, Bangalore'
WHERE EmployeeID = 1;

-- Give every employee in a department a designation change
UPDATE Employee
SET DesignationID = 3
WHERE DepartmentID = 3 AND DesignationID = 1;

-- Mark payroll as Paid for a given month/year
UPDATE Payroll
SET PaymentStatus = 'Paid'
WHERE PayMonth = 6 AND PayYear = 2026 AND PaymentStatus = 'Pending';

-- ------------------------------------------------------------
-- DELETE
-- ------------------------------------------------------------

-- Remove a single bonus record
DELETE FROM Bonus
WHERE BonusID = 1;

-- Remove attendance records older than a cut-off date
DELETE FROM Attendance
WHERE AttendanceDate < '2024-01-01';

-- Soft-delete pattern (preferred over hard DELETE for employees)
UPDATE Employee
SET Status = 'Terminated'
WHERE EmployeeID = 101;
