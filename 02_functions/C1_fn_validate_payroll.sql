-- C1_fn_validate_payroll
-- Author: Patrick (20251SEN120)
-- Combined task: validates one employee's payroll record using GOTO for the
-- "fail fast" path and the B-functions for the calculations.
--
-- Rules, checked in order (first failure wins):
--   1. Employee must exist
--   2. Salary must be present and between 50,000 and 5,000,000 RWF / month
--   3. Employee must belong to an existing department     (uses fn_dept_name)
--   4. Hire date must be present and not in the future   (uses fn_years_of_service)
-- Returns 'VALID | ...' with annual salary, monthly tax and net pay,
-- or 'INVALID | <reason>'.
-- Depends on: fn_dept_name, fn_years_of_service, fn_annual_salary, fn_calculate_tax

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION fn_validate_payroll (
  p_emp_id IN staff.emp_id%TYPE
) RETURN VARCHAR2
IS
  c_min_salary CONSTANT NUMBER := 50000;
  c_max_salary CONSTANT NUMBER := 5000000;

  v_emp     staff%ROWTYPE;
  v_dept    departments.dept_name%TYPE;
  v_years   NUMBER;
  v_tax     NUMBER;
  v_reason  VARCHAR2(200);
BEGIN
  -- Rule 1: employee exists (NO_DATA_FOUND is handled below)
  SELECT * INTO v_emp FROM staff WHERE emp_id = p_emp_id;

  -- Rule 2: salary present and in range
  IF v_emp.salary IS NULL THEN
    v_reason := 'salary is missing';
    GOTO invalid_payroll;
  END IF;

  IF v_emp.salary NOT BETWEEN c_min_salary AND c_max_salary THEN
    v_reason := 'salary ' || v_emp.salary || ' is outside the allowed range '
                || c_min_salary || ' - ' || c_max_salary;
    GOTO invalid_payroll;
  END IF;

  -- Rule 3: valid department
  v_dept := fn_dept_name(v_emp.dept_id);
  IF v_dept IN ('No Department', 'Unknown Department') THEN
    v_reason := 'department is not valid (' || v_dept || ')';
    GOTO invalid_payroll;
  END IF;

  -- Rule 4: hire date present and not in the future
  v_years := fn_years_of_service(p_emp_id);
  IF v_years IS NULL THEN
    v_reason := 'hire date is missing or in the future';
    GOTO invalid_payroll;
  END IF;

  -- All rules passed
  v_tax := fn_calculate_tax(v_emp.salary);
  RETURN 'VALID | ' || v_dept
         || ' | annual: ' || fn_annual_salary(p_emp_id)
         || ' | monthly tax: ' || v_tax
         || ' | net pay: ' || (v_emp.salary - v_tax)
         || ' | years: ' || v_years;

  -- Every failed rule jumps here
  <<invalid_payroll>>
  RETURN 'INVALID | ' || v_reason;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'INVALID | employee ' || p_emp_id || ' does not exist';
  WHEN OTHERS THEN
    RETURN 'ERROR | ' || SQLERRM;
END fn_validate_payroll;
/

SHOW ERRORS FUNCTION fn_validate_payroll;
