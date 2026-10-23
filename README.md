# 👥 Employee Data Management & Analytics System

> **Normalized 3NF Relational Database Architecture, Python CRUD Operations, and Advanced SQL Analytics** with IT Access Controls adherence (CIA Triad).

[![MySQL 8.0+](https://img.shields.io/badge/MySQL-8.0+-4479A1?style=flat-square&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Python 3.10+](https://img.shields.io/badge/Python-3.10+-3776AB?style=flat-square&logo=python&logoColor=white)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)

---

## 📌 Executive Summary

Organizations with growing workforces encounter data redundancy, slow ad-hoc reporting, and IT compliance vulnerabilities. 

This project demonstrates a robust workforce management system:
1. **3NF Relational Database Design**: Eliminates data anomalies, duplicate storage, and partial dependencies across departments and employee records.
2. **8+ Production SQL Analytics**: Harnesses window functions (`DENSE_RANK`), running totals, variance from departmental averages, and tenure brackets.
3. **IT Audit & Security Controls**: Integrates immutable `audit_logs` tracking user actions, off-hours batch jobs, and Segregation of Duties (SoD) violations aligning with the **CIA Triad** (Confidentiality, Integrity, Availability).
4. **Automated Reporting**: Replaces manual spreadsheets with automated SQL pipelines and a 4-pivot MS Excel dashboard saving **40+ minutes per report cycle**.

---

## 🏗️ 3NF Database Architecture

```plaintext
departments (1) ────< employees (N) ────< audit_logs (N)
   ├── dept_id (PK)      ├── emp_id (PK)       ├── log_id (PK)
   ├── dept_code         ├── emp_code (UQ)     ├── timestamp
   ├── department_name   ├── dept_id (FK)      ├── emp_id (FK)
   ├── location          ├── salary            ├── action_performed
   └── cost_center       ├── access_level      ├── security_flag
                         └── status            └── ip_address
```

---

## 📊 Sample Analytical Queries Included

- **Query 1**: Department-wise Headcount & Payroll Burn Rate (`GROUP BY`, `HAVING`)
- **Query 2**: Top 3 Highest Earning Employees per Department (`DENSE_RANK() OVER (PARTITION BY)`)
- **Query 3**: Running Total Payroll Growth (`SUM() OVER (ROWS UNBOUNDED PRECEDING)`)
- **Query 4**: Segregation of Duties (SoD) & Unauthorized Privilege Alterations Audit
- **Query 5**: Salary Disparity Variance from Departmental Medians
- **Query 6**: Gross vs. Base Compensation & Incentive Payout Ratio
- **Query 7**: Tenure Bracket vs. Retention Turnover Analysis
- **Query 8**: IT Access Matrix Privilege Review for Non-IT Administrators

---

## 🚀 Quick Setup & Execution

1. **Deploy Database Schema**:
   ```bash
   mysql -u root -p < schema.sql
   ```
2. **Execute Analytical Queries**:
   ```bash
   mysql -u root -p employee_analytics_db < queries.sql
   ```

---

## 👤 Author
**Bachu Uttej Siva Sai Kumar Reddy**
- **GitHub**: [@uttej2](https://github.com/uttej2)
- **Portfolio**: [https://uttej2.github.io](https://uttej2.github.io)
- **LinkedIn**: [Connect on LinkedIn](https://linkedin.com/in/uttej-sai)
