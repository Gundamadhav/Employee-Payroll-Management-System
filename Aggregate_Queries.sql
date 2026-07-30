-- ============================================================
-- Employee Payroll Management System
-- File: Aggregate_Queries.sql
-- Purpose: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING examples
-- ============================================================

USE EmployeePayrollDB;

-- Total number of employees
SELECT COUNT(*) AS TotalEmployees
FROM Employee;

-- Total active employees per department
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS EmployeeCount
FROM Department d
LEFT JOIN Employee e ON e.DepartmentID = d.DepartmentID AND e.Status = 'Active'
GROUP BY d.DepartmentName
ORDER BY EmployeeCount DESC;

-- Average basic salary across the company
SELECT ROUND(AVG(BasicPay), 2) AS AverageBasicPay
FROM Salary;

-- Average salary per department
SELECT d.DepartmentName, ROUND(AVG(s.BasicPay), 2) AS AvgBasicPay
FROM Salary s
JOIN Employee e ON e.EmployeeID = s.EmployeeID
JOIN Department d ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AvgBasicPay DESC;

-- Highest and lowest basic salary in the company
SELECT MAX(BasicPay) AS HighestSalary, MIN(BasicPay) AS LowestSalary
FROM Salary;

-- Highest paid employee per department
SELECT d.DepartmentName, e.FirstName, e.LastName, s.BasicPay
FROM Salary s
JOIN Employee e ON e.EmployeeID = s.EmployeeID
JOIN Department d ON d.DepartmentID = e.DepartmentID
WHERE s.BasicPay = (
    SELECT MAX(s2.BasicPay)
    FROM Salary s2
    JOIN Employee e2 ON e2.EmployeeID = s2.EmployeeID
    WHERE e2.DepartmentID = e.DepartmentID
)
ORDER BY d.DepartmentName;

-- Total payroll (net salary) paid out per month/year
SELECT PayMonth, PayYear, SUM(NetSalary) AS TotalNetPayout, COUNT(*) AS EmployeesPaid
FROM Payroll
WHERE PaymentStatus = 'Paid'
GROUP BY PayMonth, PayYear
ORDER BY PayYear, PayMonth;

-- Departments where total monthly payroll exceeds a threshold (HAVING)
SELECT d.DepartmentName, SUM(p.NetSalary) AS TotalPayroll
FROM Payroll p
JOIN Employee e ON e.EmployeeID = p.EmployeeID
JOIN Department d ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
HAVING SUM(p.NetSalary) > 500000
ORDER BY TotalPayroll DESC;

-- Attendance summary per employee (present days count)
SELECT e.EmployeeID, e.FirstName, e.LastName,
       COUNT(CASE WHEN a.Status = 'Present' THEN 1 END) AS PresentDays,
       COUNT(CASE WHEN a.Status = 'Absent' THEN 1 END) AS AbsentDays,
       COUNT(CASE WHEN a.Status = 'Leave' THEN 1 END) AS LeaveDays
FROM Employee e
JOIN Attendance a ON a.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY PresentDays DESC;

-- Total bonus paid out, grouped by reason
SELECT Reason, COUNT(*) AS NumberOfBonuses, SUM(BonusAmount) AS TotalBonusPaid
FROM Bonus
GROUP BY Reason
ORDER BY TotalBonusPaid DESC;
