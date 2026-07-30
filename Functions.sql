-- ============================================================
-- Employee Payroll Management System
-- File: Functions.sql
-- Purpose: Reusable scalar functions for payroll calculations
-- ============================================================

USE EmployeePayrollDB;

DELIMITER $$

-- ------------------------------------------------------------
-- CalculateTax: simple slab-based tax calculation on gross salary
-- ------------------------------------------------------------
DROP FUNCTION IF EXISTS CalculateTax $$
CREATE FUNCTION CalculateTax (p_GrossSalary DECIMAL(12,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE v_Tax DECIMAL(12,2);

    IF p_GrossSalary <= 30000 THEN
        SET v_Tax = 0;
    ELSEIF p_GrossSalary <= 60000 THEN
        SET v_Tax = (p_GrossSalary - 30000) * 0.05;
    ELSEIF p_GrossSalary <= 100000 THEN
        SET v_Tax = 1500 + (p_GrossSalary - 60000) * 0.10;
    ELSE
        SET v_Tax = 5500 + (p_GrossSalary - 100000) * 0.20;
    END IF;

    RETURN ROUND(v_Tax, 2);
END $$

-- ------------------------------------------------------------
-- CalculateBonus: bonus as a percentage of basic pay
-- ------------------------------------------------------------
DROP FUNCTION IF EXISTS CalculateBonus $$
CREATE FUNCTION CalculateBonus (p_BasicPay DECIMAL(12,2), p_Percentage DECIMAL(5,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(p_BasicPay * (p_Percentage / 100), 2);
END $$

-- ------------------------------------------------------------
-- CalculateNetSalary: gross minus tax minus other deductions
-- ------------------------------------------------------------
DROP FUNCTION IF EXISTS CalculateNetSalary $$
CREATE FUNCTION CalculateNetSalary (p_GrossSalary DECIMAL(12,2), p_OtherDeductions DECIMAL(12,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE v_Tax DECIMAL(12,2);
    SET v_Tax = CalculateTax(p_GrossSalary);
    RETURN ROUND(p_GrossSalary - v_Tax - p_OtherDeductions, 2);
END $$

-- ------------------------------------------------------------
-- WorkingDays: number of weekdays (Mon-Fri) between two dates
-- ------------------------------------------------------------
DROP FUNCTION IF EXISTS WorkingDays $$
CREATE FUNCTION WorkingDays (p_StartDate DATE, p_EndDate DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_Count INT DEFAULT 0;
    DECLARE v_CurrentDate DATE;

    SET v_CurrentDate = p_StartDate;

    WHILE v_CurrentDate <= p_EndDate DO
        IF WEEKDAY(v_CurrentDate) < 5 THEN
            SET v_Count = v_Count + 1;
        END IF;
        SET v_CurrentDate = DATE_ADD(v_CurrentDate, INTERVAL 1 DAY);
    END WHILE;

    RETURN v_Count;
END $$

DELIMITER ;

-- ------------------------------------------------------------
-- Usage examples
-- ------------------------------------------------------------
-- SELECT CalculateTax(75000);
-- SELECT CalculateBonus(50000, 10);
-- SELECT CalculateNetSalary(75000, 2000);
-- SELECT WorkingDays('2026-07-01', '2026-07-31');
