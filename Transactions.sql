-- ============================================================
-- Employee Payroll Management System
-- File: Transactions.sql
-- Purpose: Demonstrate START TRANSACTION, COMMIT, ROLLBACK,
--          and SAVEPOINT for multi-step operations
-- ============================================================

USE EmployeePayrollDB;

-- ------------------------------------------------------------
-- Example 1: Salary revision + payroll regeneration as one unit
-- If either step fails, neither change is kept.
-- ------------------------------------------------------------
START TRANSACTION;

UPDATE Salary
SET BasicPay = BasicPay * 1.10
WHERE EmployeeID = 1;

CALL GeneratePayroll(1, 7, 2026);

-- If everything looks correct:
COMMIT;

-- If something went wrong instead, you would run:
-- ROLLBACK;

-- ------------------------------------------------------------
-- Example 2: Using SAVEPOINT to partially roll back a batch
-- ------------------------------------------------------------
START TRANSACTION;

INSERT INTO Bonus (EmployeeID, BonusAmount, Reason, BonusDate)
VALUES (2, 5000, 'Quarterly Performance Bonus', CURDATE());

SAVEPOINT after_bonus;

UPDATE Payroll
SET PaymentStatus = 'Paid'
WHERE EmployeeID = 2 AND PayMonth = 6 AND PayYear = 2026;

-- Suppose the payroll update was found to be incorrect afterwards:
ROLLBACK TO SAVEPOINT after_bonus;

-- The bonus insert is kept, the payroll status change is undone.
COMMIT;

-- ------------------------------------------------------------
-- Example 3: Employee termination as an all-or-nothing operation
-- (status change + login deactivation together)
-- ------------------------------------------------------------
START TRANSACTION;

UPDATE Employee
SET Status = 'Terminated'
WHERE EmployeeID = 101;

DELETE FROM UserLogin
WHERE EmployeeID = 101;

COMMIT;
