-- ============================================================
-- Employee Payroll Management System
-- File: Stored_Procedures.sql
-- Purpose: Encapsulate common business operations
-- ============================================================

USE EmployeePayrollDB;

DELIMITER $$

-- ------------------------------------------------------------
-- AddEmployee: inserts a new employee plus their initial salary
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS AddEmployee $$
CREATE PROCEDURE AddEmployee (
    IN p_FirstName    VARCHAR(50),
    IN p_LastName     VARCHAR(50),
    IN p_Gender       VARCHAR(10),
    IN p_DOB          DATE,
    IN p_Email        VARCHAR(100),
    IN p_Phone        VARCHAR(20),
    IN p_Address      VARCHAR(255),
    IN p_HireDate     DATE,
    IN p_DepartmentID INT,
    IN p_DesignationID INT,
    IN p_ManagerID    INT,
    IN p_BasicPay     DECIMAL(12,2)
)
BEGIN
    DECLARE new_id INT;

    INSERT INTO Employee
        (FirstName, LastName, Gender, DOB, Email, Phone, Address,
         HireDate, DepartmentID, DesignationID, ManagerID, Status)
    VALUES
        (p_FirstName, p_LastName, p_Gender, p_DOB, p_Email, p_Phone, p_Address,
         p_HireDate, p_DepartmentID, p_DesignationID, p_ManagerID, 'Active');

    SET new_id = LAST_INSERT_ID();

    INSERT INTO Salary (EmployeeID, BasicPay, HRA, ConveyanceAllowance, EffectiveDate)
    VALUES (new_id, p_BasicPay, ROUND(p_BasicPay * 0.2, 2), 1500.00, p_HireDate);

    SELECT new_id AS NewEmployeeID;
END $$

-- ------------------------------------------------------------
-- UpdateSalary: revises an employee's basic pay
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS UpdateSalary $$
CREATE PROCEDURE UpdateSalary (
    IN p_EmployeeID INT,
    IN p_NewBasicPay DECIMAL(12,2)
)
BEGIN
    UPDATE Salary
    SET BasicPay = p_NewBasicPay,
        HRA = ROUND(p_NewBasicPay * 0.2, 2),
        EffectiveDate = CURDATE()
    WHERE EmployeeID = p_EmployeeID
    ORDER BY EffectiveDate DESC
    LIMIT 1;
END $$

-- ------------------------------------------------------------
-- GeneratePayroll: computes and stores payroll for one employee
-- for a given month/year based on Salary, Bonus and Deduction
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS GeneratePayroll $$
CREATE PROCEDURE GeneratePayroll (
    IN p_EmployeeID INT,
    IN p_Month INT,
    IN p_Year INT
)
BEGIN
    DECLARE v_Basic DECIMAL(12,2);
    DECLARE v_HRA DECIMAL(12,2);
    DECLARE v_Conveyance DECIMAL(12,2);
    DECLARE v_Bonus DECIMAL(12,2);
    DECLARE v_Deduction DECIMAL(12,2);
    DECLARE v_Gross DECIMAL(12,2);
    DECLARE v_Net DECIMAL(12,2);

    SELECT BasicPay, HRA, ConveyanceAllowance
    INTO v_Basic, v_HRA, v_Conveyance
    FROM Salary
    WHERE EmployeeID = p_EmployeeID
    ORDER BY EffectiveDate DESC
    LIMIT 1;

    SELECT COALESCE(SUM(BonusAmount), 0) INTO v_Bonus
    FROM Bonus
    WHERE EmployeeID = p_EmployeeID
      AND MONTH(BonusDate) = p_Month AND YEAR(BonusDate) = p_Year;

    SELECT COALESCE(SUM(Amount), 0) INTO v_Deduction
    FROM Deduction
    WHERE EmployeeID = p_EmployeeID
      AND MONTH(DeductionDate) = p_Month AND YEAR(DeductionDate) = p_Year;

    SET v_Gross = v_Basic + v_HRA + v_Conveyance + v_Bonus;
    SET v_Net = v_Gross - v_Deduction;

    INSERT INTO Payroll (EmployeeID, PayMonth, PayYear, GrossSalary, TotalDeductions, NetSalary, PaymentStatus, PayrollDate)
    VALUES (p_EmployeeID, p_Month, p_Year, v_Gross, v_Deduction, v_Net, 'Pending', CURDATE())
    ON DUPLICATE KEY UPDATE
        GrossSalary = v_Gross,
        TotalDeductions = v_Deduction,
        NetSalary = v_Net,
        PayrollDate = CURDATE();
END $$

-- ------------------------------------------------------------
-- DeleteEmployee: safely removes an employee (soft delete)
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS DeleteEmployee $$
CREATE PROCEDURE DeleteEmployee (
    IN p_EmployeeID INT
)
BEGIN
    UPDATE Employee
    SET Status = 'Terminated'
    WHERE EmployeeID = p_EmployeeID;
END $$

-- ------------------------------------------------------------
-- EmployeeAttendance: monthly attendance summary for one employee
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS EmployeeAttendance $$
CREATE PROCEDURE EmployeeAttendance (
    IN p_EmployeeID INT,
    IN p_Month INT,
    IN p_Year INT
)
BEGIN
    SELECT
        e.EmployeeID,
        CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
        COUNT(CASE WHEN a.Status = 'Present' THEN 1 END) AS PresentDays,
        COUNT(CASE WHEN a.Status = 'Absent' THEN 1 END) AS AbsentDays,
        COUNT(CASE WHEN a.Status = 'Leave' THEN 1 END) AS LeaveDays,
        COUNT(CASE WHEN a.Status = 'Half-Day' THEN 1 END) AS HalfDays
    FROM Employee e
    JOIN Attendance a ON a.EmployeeID = e.EmployeeID
    WHERE e.EmployeeID = p_EmployeeID
      AND MONTH(a.AttendanceDate) = p_Month
      AND YEAR(a.AttendanceDate) = p_Year
    GROUP BY e.EmployeeID, FullName;
END $$

DELIMITER ;

-- ------------------------------------------------------------
-- Usage examples
-- ------------------------------------------------------------
-- CALL AddEmployee('Neha','Iyer','Female','1997-05-20','neha.iyer@epms.com',
--                   '9988776655','21 Anna Salai, Chennai','2026-07-15',3,1,10,55000);
-- CALL UpdateSalary(1, 62000);
-- CALL GeneratePayroll(1, 6, 2026);
-- CALL DeleteEmployee(101);
-- CALL EmployeeAttendance(1, 7, 2026);
