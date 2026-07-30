# Employee Payroll Management System (MySQL/MariaDB)

A complete, portfolio-ready SQL project that models an end-to-end **Employee
Payroll Management System** — from department/role setup, through attendance
and salary tracking, to automated payroll generation and audit logging.

Built and tested against **MariaDB 10.11 / MySQL 8.0**-compatible syntax.

---

## 📋 Description

This project simulates the database layer of an HR & Payroll application
used by a mid-sized company. It covers the full lifecycle of an employee
record — hiring, attendance, salary structure, bonuses, deductions, monthly
payroll generation, and bank/login details — along with the reporting,
auditing, and automation logic a real payroll system needs.

The project is organized as a sequence of standalone `.sql` scripts so each
concept (schema, constraints, queries, procedures, etc.) can be reviewed and
run independently.

---

## ✨ Features

- Employee, Department & Designation management
- Daily attendance tracking (Present / Absent / Leave / Half-Day)
- Configurable salary structure (Basic + HRA + Allowances)
- Bonus and deduction tracking
- Automated monthly payroll generation (gross → tax/deductions → net)
- Bank account & login/role management
- Full audit trail of salary and employee changes via triggers
- Reporting layer (views + report queries) for HR/Finance teams

---

## 🛠 Technologies Used

- **Database:** MySQL 8.0 / MariaDB 10.11
- **Tools:** MySQL Workbench / DBeaver / CLI client
- **Diagramming:** Graphviz (ER diagram)
- **Version Control:** Git & GitHub

---

## 🗄 Database Name

```
EmployeePayrollDB
```

## 📊 Tables (11)

| Table | Purpose |
|---|---|
| `Department` | Company departments |
| `Designation` | Job titles / grade levels |
| `Employee` | Core employee records |
| `Attendance` | Daily attendance records |
| `Salary` | Salary structure per employee |
| `Bonus` | One-off bonus payments |
| `Deduction` | Tax / loan / insurance deductions |
| `Payroll` | Computed monthly payroll |
| `BankAccount` | Employee bank details |
| `UserLogin` | Application login credentials |
| `AuditLog` | Trigger-generated change history |

---

## 🧠 SQL Concepts Used

- DDL: `CREATE`, `ALTER`, `DROP`
- Constraints: `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `CHECK`, `DEFAULT`
- CRUD operations (`INSERT`, `SELECT`, `UPDATE`, `DELETE`)
- Aggregate functions & `GROUP BY` / `HAVING`
- `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `SELF JOIN`, `CROSS JOIN`
- Scalar, correlated & derived-table subqueries
- Views
- Stored Procedures
- User-Defined Functions
- Triggers (`BEFORE`/`AFTER` `INSERT`/`UPDATE`/`DELETE`)
- Indexes
- Transactions (`COMMIT`, `ROLLBACK`, `SAVEPOINT`)
- Business reporting queries

---

## 📁 Project Structure

```
EmployeePayrollDB/
├── README.md                 # This file
├── ER_Diagram.png            # Entity-Relationship diagram
├── Database.sql              # Database creation
├── Tables.sql                # Table definitions
├── Constraints.sql            # PK / FK / UNIQUE / CHECK / DEFAULT
├── Insert_Data.sql           # Sample data (5 depts, 10 designations, 100 employees...)
├── CRUD_Queries.sql          # INSERT / UPDATE / DELETE / SELECT examples
├── Aggregate_Queries.sql     # COUNT, SUM, AVG, GROUP BY, HAVING
├── Join_Queries.sql          # All join types
├── Subqueries.sql            # Scalar / correlated / derived-table subqueries
├── Views.sql                 # Reporting views
├── Stored_Procedures.sql     # AddEmployee, UpdateSalary, GeneratePayroll...
├── Functions.sql             # CalculateTax, CalculateBonus, CalculateNetSalary...
├── Triggers.sql              # Audit logging & validation triggers
├── Indexes.sql               # Performance indexes
├── Transactions.sql          # COMMIT / ROLLBACK / SAVEPOINT examples
├── Reports.sql               # Business reports
└── Documentation.pdf         # Full written project documentation
```

---

## ▶️ How to Run the Project

Run the scripts **in this exact order** in MySQL Workbench, DBeaver, or the
`mysql` command-line client:

```bash
mysql -u root -p < Database.sql
mysql -u root -p < Tables.sql
mysql -u root -p < Constraints.sql
mysql -u root -p < Insert_Data.sql
mysql -u root -p < Views.sql
mysql -u root -p < Stored_Procedures.sql
mysql -u root -p < Functions.sql
mysql -u root -p < Triggers.sql
mysql -u root -p < Indexes.sql
```

Then explore the analytical/example files as you like:

```bash
mysql -u root -p < CRUD_Queries.sql
mysql -u root -p < Aggregate_Queries.sql
mysql -u root -p < Join_Queries.sql
mysql -u root -p < Subqueries.sql
mysql -u root -p < Transactions.sql
mysql -u root -p < Reports.sql
```

> All scripts in this repository were executed end-to-end against a live
> MariaDB 10.11 instance during development to confirm they run without
> errors.

---

## 🖼 Screenshots (ER Diagram)

See `ER_Diagram.png` in this repository for the full Entity-Relationship
diagram of the schema.

---

## 👤 Author

Published by **[Gundamadhav](https://github.com/Gundamadhav)** — see the
[Documentation.pdf](Documentation.pdf) for the complete project write-up.
