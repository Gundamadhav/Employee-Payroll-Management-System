-- ============================================================
-- Employee Payroll Management System
-- File: Triggers.sql
-- Purpose: Automatic auditing and data-integrity enforcement
-- ============================================================

USE EmployeePayrollDB;

DELIMITER $$

-- ------------------------------------------------------------
-- AFTER INSERT on Employee: log new hire into AuditLog
-- ------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_Employee_AfterInsert $$
CREATE TRIGGER trg_Employee_AfterInsert
AFTER INSERT ON Employee
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (TableName, OperationType, RecordID, OldValue, NewValue, ChangedBy, ChangedAt)
    VALUES ('Employee', 'INSERT', NEW.EmployeeID, NULL,
            CONCAT('Hired: ', NEW.FirstName, ' ', NEW.LastName), USER(), NOW());
END $$

-- ------------------------------------------------------------
-- BEFORE UPDATE on Employee: prevent Status being set to NULL
-- ------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_Employee_BeforeUpdate $$
CREATE TRIGGER trg_Employee_BeforeUpdate
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.Status IS NULL THEN
        SET NEW.Status = OLD.Status;
    END IF;
END $$

-- ------------------------------------------------------------
-- AFTER UPDATE on Salary: whenever pay changes, write to AuditLog
-- ------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_Salary_AfterUpdate $$
CREATE TRIGGER trg_Salary_AfterUpdate
AFTER UPDATE ON Salary
FOR EACH ROW
BEGIN
    IF NEW.BasicPay <> OLD.BasicPay THEN
        INSERT INTO AuditLog (TableName, OperationType, RecordID, OldValue, NewValue, ChangedBy, ChangedAt)
        VALUES ('Salary', 'UPDATE', NEW.SalaryID,
                CONCAT('BasicPay: ', OLD.BasicPay),
                CONCAT('BasicPay: ', NEW.BasicPay),
                USER(), NOW());
    END IF;
END $$

-- ------------------------------------------------------------
-- BEFORE DELETE on Employee: archive the record before removal
-- ------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_Employee_BeforeDelete $$
CREATE TRIGGER trg_Employee_BeforeDelete
BEFORE DELETE ON Employee
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (TableName, OperationType, RecordID, OldValue, NewValue, ChangedBy, ChangedAt)
    VALUES ('Employee', 'DELETE', OLD.EmployeeID,
            CONCAT(OLD.FirstName, ' ', OLD.LastName, ' - ', OLD.Email),
            NULL, USER(), NOW());
END $$

-- ------------------------------------------------------------
-- BEFORE INSERT on Attendance: block future-dated attendance
-- ------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_Attendance_BeforeInsert $$
CREATE TRIGGER trg_Attendance_BeforeInsert
BEFORE INSERT ON Attendance
FOR EACH ROW
BEGIN
    IF NEW.AttendanceDate > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attendance date cannot be in the future.';
    END IF;
END $$

DELIMITER ;
