-- ============================================================================
-- EMPLOYEE DATA MANAGEMENT & ANALYTICS SYSTEM
-- Schema: Normalized 3rd Normal Form (3NF) Relational Architecture
-- Engine: MySQL 8.0+
-- Author: Bachu Uttej Siva Sai Kumar Reddy
-- ============================================================================

CREATE DATABASE IF NOT EXISTS employee_analytics_db;
USE employee_analytics_db;

-- 1. Departments Table (1NF / 2NF / 3NF)
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_code VARCHAR(10) NOT NULL UNIQUE,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(50) NOT NULL,
    cost_center VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Employees Table (3NF)
CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_code VARCHAR(15) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    dept_id INT NOT NULL,
    job_title VARCHAR(80) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    bonus_pct DECIMAL(4, 2) DEFAULT 0.00,
    status ENUM('ACTIVE', 'ON_LEAVE', 'TERMINATED') DEFAULT 'ACTIVE',
    access_level ENUM('STAFF', 'MANAGER', 'DIRECTOR', 'ADMIN') DEFAULT 'STAFF',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_employee_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE RESTRICT
);

-- 3. Audit Logs Table (IT Controls & Access Logging)
CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    emp_id INT,
    user_role VARCHAR(50) NOT NULL,
    action_performed VARCHAR(150) NOT NULL,
    table_affected VARCHAR(50) NOT NULL,
    record_id INT,
    security_flag ENUM('NORMAL', 'FLAGGED_SOD_VIOLATION', 'OFF_HOURS_ACCESS', 'UNAUTHORIZED_ATTEMPT') DEFAULT 'NORMAL',
    ip_address VARCHAR(45) NOT NULL,
    CONSTRAINT fk_audit_emp FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE SET NULL
);

-- Indexes for Query Performance
CREATE INDEX idx_emp_dept ON employees(dept_id);
CREATE INDEX idx_emp_salary ON employees(salary);
CREATE INDEX idx_emp_status ON employees(status);
CREATE INDEX idx_audit_security ON audit_logs(security_flag);
