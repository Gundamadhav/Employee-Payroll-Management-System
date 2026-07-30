-- ============================================================
-- Employee Payroll Management System
-- File: Join_Queries.sql
-- Purpose: INNER, LEFT, RIGHT, SELF and CROSS JOIN examples
-- ============================================================

USE EmployeePayrollDB;

-- ------------------------------------------------------------
-- INNER JOIN: Employee + Department
-- ------------------------------------------------------------
SELECT e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName
FROM Employee e
INNER JOIN Department d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID;

-- ------------------------------------------------------------
-- INNER JOIN: Employee + Designation + Department (3-way)
-- ------------------------------------------------------------
SELECT e.EmployeeID, e.FirstName, e.LastName,
       d.DepartmentName, ds.Title AS Designation
FROM Employee e
INNER JOIN Department d ON e.DepartmentID = d.DepartmentID
INNER JOIN Designation ds ON e.DesignationID = ds.DesignationID
ORDER BY d.DepartmentName, ds.Title;

-- ------------------------------------------------------------
-- INNER JOIN: Employee + Payroll (June 2026)
-- ------------------------------------------------------------
SELECT e.EmployeeID, e.FirstName, e.LastName,
       p.PayMonth, p.PayYear, p.GrossSalary, p.NetSalary, p.PaymentStatus
FROM Employee e
INNER JOIN Payroll p ON e.EmployeeID = p.EmployeeID
WHERE p.PayMonth = 6 AND p.PayYear = 2026
ORDER BY p.NetSalary DESC;

-- ------------------------------------------------------------
-- LEFT JOIN: Every employee with their attendance (even if none)
-- ------------------------------------------------------------
SELECT e.EmployeeID, e.FirstName, e.LastName, a.AttendanceDate, a.Status
FROM Employee e
LEFT JOIN Attendance a ON e.EmployeeID = a.EmployeeID
ORDER BY e.EmployeeID, a.AttendanceDate;

-- ------------------------------------------------------------
-- LEFT JOIN: Employees who have never received a bonus
-- ------------------------------------------------------------
SELECT e.EmployeeID, e.FirstName, e.LastName, b.BonusID
FROM Employee e
LEFT JOIN Bonus b ON e.EmployeeID = b.EmployeeID
WHERE b.BonusID IS NULL;

-- ------------------------------------------------------------
-- RIGHT JOIN: Every department shown, even with zero employees
-- ------------------------------------------------------------
SELECT d.DepartmentName, e.FirstName, e.LastName
FROM Employee e
RIGHT JOIN Department d ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentName;

-- ------------------------------------------------------------
-- SELF JOIN: Employees and their managers
-- ------------------------------------------------------------
SELECT emp.EmployeeID, emp.FirstName AS EmployeeFirstName, emp.LastName AS EmployeeLastName,
       mgr.FirstName AS ManagerFirstName, mgr.LastName AS ManagerLastName
FROM Employee emp
LEFT JOIN Employee mgr ON emp.ManagerID = mgr.EmployeeID
ORDER BY mgr.FirstName;

-- ------------------------------------------------------------
-- CROSS JOIN: Every department paired with every designation
-- (useful for building a full department/role planning matrix)
-- ------------------------------------------------------------
SELECT d.DepartmentName, ds.Title AS Designation
FROM Department d
CROSS JOIN Designation ds
ORDER BY d.DepartmentName, ds.Title;
