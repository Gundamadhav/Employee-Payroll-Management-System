-- ============================================================
-- Employee Payroll Management System
-- File: Reports.sql
-- Purpose: Business-facing reports built from the schema
-- ============================================================

USE EmployeePayrollDB;

-- ------------------------------------------------------------
-- 1. Monthly Payroll Report (June 2026)
-- ------------------------------------------------------------
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    d.DepartmentName,
    p.GrossSalary,
    p.TotalDeductions,
    p.NetSalary,
    p.PaymentStatus
FROM Payroll p
JOIN Employee e ON p.EmployeeID = e.EmployeeID
JOIN Department d ON e.DepartmentID = d.DepartmentID
WHERE p.PayMonth = 6 AND p.PayYear = 2026
ORDER BY d.DepartmentName, e.LastName;

-- ------------------------------------------------------------
-- 2. Department Salary Report (headcount + total/average pay)
-- ------------------------------------------------------------
SELECT
    d.DepartmentName,
    COUNT(DISTINCT e.EmployeeID) AS Headcount,
    SUM(s.BasicPay) AS TotalBasicPay,
    ROUND(AVG(s.BasicPay), 2) AS AverageBasicPay
FROM Department d
JOIN Employee e ON e.DepartmentID = d.DepartmentID
JOIN Salary s ON s.EmployeeID = e.EmployeeID
GROUP BY d.DepartmentName
ORDER BY TotalBasicPay DESC;

-- ------------------------------------------------------------
-- 3. Attendance Report (per employee, current month)
-- ------------------------------------------------------------
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    COUNT(CASE WHEN a.Status = 'Present' THEN 1 END) AS PresentDays,
    COUNT(CASE WHEN a.Status = 'Absent' THEN 1 END) AS AbsentDays,
    COUNT(CASE WHEN a.Status = 'Leave' THEN 1 END) AS LeaveDays,
    COUNT(CASE WHEN a.Status = 'Half-Day' THEN 1 END) AS HalfDays
FROM Employee e
JOIN Attendance a ON a.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, FullName
ORDER BY AbsentDays DESC;

-- ------------------------------------------------------------
-- 4. Highest Salary Report (top 10 earners)
-- ------------------------------------------------------------
SELECT e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
       d.DepartmentName, s.BasicPay
FROM Salary s
JOIN Employee e ON e.EmployeeID = s.EmployeeID
JOIN Department d ON d.DepartmentID = e.DepartmentID
ORDER BY s.BasicPay DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 5. Lowest Salary Report (bottom 10 earners)
-- ------------------------------------------------------------
SELECT e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
       d.DepartmentName, s.BasicPay
FROM Salary s
JOIN Employee e ON e.EmployeeID = s.EmployeeID
JOIN Department d ON d.DepartmentID = e.DepartmentID
ORDER BY s.BasicPay ASC
LIMIT 10;

-- ------------------------------------------------------------
-- 6. Employees on Leave (today)
-- ------------------------------------------------------------
SELECT e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) AS FullName, a.AttendanceDate
FROM Attendance a
JOIN Employee e ON a.EmployeeID = e.EmployeeID
WHERE a.Status = 'Leave'
ORDER BY a.AttendanceDate DESC;

-- ------------------------------------------------------------
-- 7. Bonus Report (total bonus paid, grouped by employee)
-- ------------------------------------------------------------
SELECT e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
       COUNT(b.BonusID) AS NumberOfBonuses, SUM(b.BonusAmount) AS TotalBonus
FROM Bonus b
JOIN Employee e ON e.EmployeeID = b.EmployeeID
GROUP BY e.EmployeeID, FullName
ORDER BY TotalBonus DESC;

-- ------------------------------------------------------------
-- 8. Tax Report (estimated tax per employee using CalculateTax())
-- ------------------------------------------------------------
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    p.GrossSalary,
    CalculateTax(p.GrossSalary) AS EstimatedTax
FROM Payroll p
JOIN Employee e ON e.EmployeeID = p.EmployeeID
WHERE p.PayMonth = 6 AND p.PayYear = 2026
ORDER BY EstimatedTax DESC;
