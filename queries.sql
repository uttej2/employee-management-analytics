-- ============================================================================
-- ADVANCED ANALYTICAL SQL QUERIES (8+ Production Queries)
-- Author: Bachu Uttej Siva Sai Kumar Reddy
-- ============================================================================

-- Query 1: Department-wise Headcount, Payroll Burn, and Salary Extremes (GROUP BY + HAVING)
SELECT 
    d.department_name,
    d.location,
    COUNT(e.emp_id) AS total_headcount,
    ROUND(AVG(e.salary), 2) AS avg_monthly_salary,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary,
    ROUND(SUM(e.salary), 2) AS total_dept_payroll
FROM departments d
INNER JOIN employees e ON d.dept_id = e.dept_id
WHERE e.status = 'ACTIVE'
GROUP BY d.department_name, d.location
HAVING COUNT(e.emp_id) >= 5
ORDER BY total_dept_payroll DESC;

-- Query 2: Top 3 Highest Earning Employees per Department (DENSE_RANK Window Function)
WITH RankedEmployees AS (
    SELECT 
        e.emp_id,
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        d.department_name,
        e.job_title,
        e.salary,
        DENSE_RANK() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC) AS salary_rank
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
    WHERE e.status = 'ACTIVE'
)
SELECT * 
FROM RankedEmployees
WHERE salary_rank <= 3
ORDER BY department_name, salary_rank;

-- Query 3: Cumulative Salary Distribution & Running Total by Hire Date
SELECT 
    e.hire_date,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.salary,
    SUM(e.salary) OVER (ORDER BY e.hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_payroll_total
FROM employees e
ORDER BY e.hire_date ASC;

-- Query 4: IT Controls Audit: Segregation of Duties (SoD) & Unauthorized Privilege Alterations
SELECT 
    a.log_id,
    a.timestamp,
    CONCAT(e.first_name, ' ', e.last_name) AS operator_name,
    a.user_role,
    a.action_performed,
    a.table_affected,
    a.security_flag,
    a.ip_address
FROM audit_logs a
LEFT JOIN employees e ON a.emp_id = e.emp_id
WHERE a.security_flag IN ('FLAGGED_SOD_VIOLATION', 'UNAUTHORIZED_ATTEMPT')
ORDER BY a.timestamp DESC;

-- Query 5: Salary Disparity Index (Difference between Employee Salary and Dept Average)
SELECT 
    e.emp_code,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.department_name,
    e.salary,
    ROUND(AVG(e.salary) OVER (PARTITION BY e.dept_id), 2) AS dept_avg_salary,
    ROUND(e.salary - AVG(e.salary) OVER (PARTITION BY e.dept_id), 2) AS variance_from_avg
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- Query 6: Annual Bonus Impact on Total Compensation
SELECT 
    e.job_title,
    COUNT(*) AS total_employees,
    ROUND(AVG(e.salary), 2) AS base_salary_avg,
    ROUND(AVG(e.salary * (1 + e.bonus_pct / 100)), 2) AS gross_comp_avg,
    ROUND(AVG(e.salary * (e.bonus_pct / 100)), 2) AS avg_bonus_payout
FROM employees e
GROUP BY e.job_title
ORDER BY gross_comp_avg DESC;

-- Query 7: Tenure Analysis: Employee Retention and Turnover Rate
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) < 1 THEN '0-1 Years (New Hire)'
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) BETWEEN 1 AND 3 THEN '1-3 Years (Intermediate)'
        ELSE '3+ Years (Senior/Tenured)'
    END AS tenure_bracket,
    COUNT(*) AS employee_count,
    ROUND(AVG(salary), 2) AS avg_salary_in_bracket
FROM employees
WHERE status = 'ACTIVE'
GROUP BY tenure_bracket;

-- Query 8: IT Access Control Matrix Verification (Staff with High Privileges)
SELECT 
    e.emp_code,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    d.department_name,
    e.job_title,
    e.access_level
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.access_level IN ('ADMIN', 'DIRECTOR') AND d.department_name NOT IN ('IT & Security', 'Executive Leadership');
