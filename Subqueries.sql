-- ============================================================
-- Employee Payroll Management System
-- File: Subqueries.sql
-- Purpose: Scalar, correlated, and IN/NOT IN subquery examples
-- ============================================================

USE EmployeePayrollDB;

-- ------------------------------------------------------------
-- Employee(s) with the single highest basic salary company-wide
-- ------------------------------------------------------------
SELECT e.EmployeeID, e.FirstName, e.LastName, s.BasicPay
FROM Employee e
JOIN Salary s ON e.EmployeeID = s.EmployeeID
WHERE s.BasicPay = (SELECT MAX(BasicPay) FROM Salary);

-- ------------------------------------------------------------
-- Employees earning above their own department's average
-- (correlated subquery)
-- ------------------------------------------------------------
SELECT e.EmployeeID, e.FirstName, e.LastName, e.DepartmentID, s.BasicPay
FROM Employee e
JOIN Salary s ON e.EmployeeID = s.EmployeeID
WHERE s.BasicPay > (
    SELECT AVG(s2.BasicPay)
    FROM Salary s2
    JOIN Employee e2 ON e2.EmployeeID = s2.EmployeeID
    WHERE e2.DepartmentID = e.DepartmentID
)
ORDER BY e.DepartmentID, s.BasicPay DESC;

-- ------------------------------------------------------------
-- Employees who have no attendance records at all (NOT IN)
-- ------------------------------------------------------------
SELECT EmployeeID, FirstName, LastName
FROM Employee
WHERE EmployeeID NOT IN (SELECT DISTINCT EmployeeID FROM Attendance);

-- ------------------------------------------------------------
-- Employees who were absent more than 2 times in the sample window
-- ------------------------------------------------------------
SELECT EmployeeID, FirstName, LastName
FROM Employee
WHERE EmployeeID IN (
    SELECT EmployeeID
    FROM Attendance
    WHERE Status = 'Absent'
    GROUP BY EmployeeID
    HAVING COUNT(*) > 2
);

-- ------------------------------------------------------------
-- Employees who have received at least one bonus (IN)
-- ------------------------------------------------------------
SELECT EmployeeID, FirstName, LastName
FROM Employee
WHERE EmployeeID IN (SELECT DISTINCT EmployeeID FROM Bonus);

-- ------------------------------------------------------------
-- Departments with an average salary greater than the company average
-- (subquery in FROM clause / derived table)
-- ------------------------------------------------------------
SELECT DepartmentName, DeptAvgSalary
FROM (
    SELECT d.DepartmentName, AVG(s.BasicPay) AS DeptAvgSalary
    FROM Department d
    JOIN Employee e ON e.DepartmentID = d.DepartmentID
    JOIN Salary s ON s.EmployeeID = e.EmployeeID
    GROUP BY d.DepartmentName
) AS DeptAverages
WHERE DeptAvgSalary > (SELECT AVG(BasicPay) FROM Salary);

-- ------------------------------------------------------------
-- Second highest basic salary in the company
-- ------------------------------------------------------------
SELECT MAX(BasicPay) AS SecondHighestSalary
FROM Salary
WHERE BasicPay < (SELECT MAX(BasicPay) FROM Salary);
