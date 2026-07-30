-- ============================================================
-- Employee Payroll Management System
-- File: Views.sql
-- Purpose: Reusable views for reporting and application use
-- ============================================================

USE EmployeePayrollDB;

-- ------------------------------------------------------------
-- EmployeeDetailsView: full employee profile in one place
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW EmployeeDetailsView AS
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    e.Gender,
    e.Email,
    e.Phone,
    e.HireDate,
    d.DepartmentName,
    ds.Title AS Designation,
    e.Status
FROM Employee e
LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID
LEFT JOIN Designation ds ON e.DesignationID = ds.DesignationID;

-- ------------------------------------------------------------
-- PayrollView: payroll with employee and department context
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW PayrollView AS
SELECT
    p.PayrollID,
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    d.DepartmentName,
    p.PayMonth,
    p.PayYear,
    p.GrossSalary,
    p.TotalDeductions,
    p.NetSalary,
    p.PaymentStatus
FROM Payroll p
JOIN Employee e ON p.EmployeeID = e.EmployeeID
LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID;

-- ------------------------------------------------------------
-- DepartmentView: headcount and average salary per department
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW DepartmentView AS
SELECT
    d.DepartmentID,
    d.DepartmentName,
    d.Location,
    COUNT(DISTINCT e.EmployeeID) AS TotalEmployees,
    ROUND(AVG(s.BasicPay), 2) AS AverageBasicPay
FROM Department d
LEFT JOIN Employee e ON e.DepartmentID = d.DepartmentID
LEFT JOIN Salary s ON s.EmployeeID = e.EmployeeID
GROUP BY d.DepartmentID, d.DepartmentName, d.Location;

-- ------------------------------------------------------------
-- AttendanceView: attendance records with employee names
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW AttendanceView AS
SELECT
    a.AttendanceID,
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    a.AttendanceDate,
    a.Status,
    a.CheckIn,
    a.CheckOut
FROM Attendance a
JOIN Employee e ON a.EmployeeID = e.EmployeeID;

-- ------------------------------------------------------------
-- Usage examples
-- ------------------------------------------------------------
-- SELECT * FROM EmployeeDetailsView WHERE DepartmentName = 'Information Technology';
-- SELECT * FROM PayrollView WHERE PayMonth = 6 AND PayYear = 2026;
-- SELECT * FROM DepartmentView ORDER BY AverageBasicPay DESC;
-- SELECT * FROM AttendanceView WHERE Status = 'Absent';
