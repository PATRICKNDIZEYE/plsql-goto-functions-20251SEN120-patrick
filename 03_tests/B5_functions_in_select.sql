-- B5_functions_in_select
-- Author: Patrick (20251SEN120)
-- Uses the stored functions directly inside SQL statements: in the SELECT
-- list, in WHERE, in ORDER BY and with GROUP BY.
-- This works because each function returns a SQL datatype (NUMBER/VARCHAR2)
-- and performs no DML (INSERT/UPDATE/DELETE).

SET SERVEROUTPUT ON;
SET LINESIZE 200;
COLUMN full_name  FORMAT A16
COLUMN department FORMAT A18
COLUMN dept_99    FORMAT A20

PROMPT ===== 1. Payroll report: functions in the SELECT list =====
SELECT emp_id,
       full_name,
       fn_dept_name(dept_id)                 AS department,
       salary                                AS monthly,
       fn_annual_salary(emp_id)              AS annual,
       fn_calculate_tax(salary)              AS monthly_tax,
       salary - fn_calculate_tax(salary)     AS net_pay,
       fn_years_of_service(emp_id)           AS years
FROM   staff
ORDER  BY emp_id;

PROMPT ===== 2. Function in WHERE: employees with 5+ years of service =====
SELECT full_name, fn_years_of_service(emp_id) AS years
FROM   staff
WHERE  fn_years_of_service(emp_id) >= 5
ORDER  BY years DESC;

PROMPT ===== 3. Function with GROUP BY: annual payroll per department =====
SELECT fn_dept_name(dept_id)          AS department,
       COUNT(*)                       AS employees,
       SUM(fn_annual_salary(emp_id))  AS annual_payroll
FROM   staff
GROUP  BY fn_dept_name(dept_id)
ORDER  BY annual_payroll DESC NULLS LAST;

PROMPT ===== 4. Functions on literal values (no table needed) =====
SELECT fn_calculate_tax(55000)  AS tax_55k,
       fn_calculate_tax(95000)  AS tax_95k,
       fn_calculate_tax(450000) AS tax_450k,
       fn_dept_name(99)         AS dept_99
FROM   dual;
