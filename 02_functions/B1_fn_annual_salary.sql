-- B1_fn_annual_salary
-- Author: Patrick (20251SEN120)
-- Returns an employee's annual salary (monthly salary x 12).
-- Returns NULL (with a message) when the employee does not exist or has no
-- valid salary, so it is safe to call from a SELECT.

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION fn_annual_salary (
  p_emp_id IN staff.emp_id%TYPE
) RETURN NUMBER
IS
  v_monthly   staff.salary%TYPE;
  e_no_salary EXCEPTION;
BEGIN
  SELECT salary INTO v_monthly
  FROM   staff
  WHERE  emp_id = p_emp_id;          -- NO_DATA_FOUND if the employee doesn't exist

  IF v_monthly IS NULL OR v_monthly <= 0 THEN
    RAISE e_no_salary;
  END IF;

  RETURN v_monthly * 12;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('fn_annual_salary: employee ' || p_emp_id || ' does not exist.');
    RETURN NULL;
  WHEN e_no_salary THEN
    DBMS_OUTPUT.PUT_LINE('fn_annual_salary: employee ' || p_emp_id || ' has no valid salary.');
    RETURN NULL;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('fn_annual_salary: unexpected error - ' || SQLERRM);
    RETURN NULL;
END fn_annual_salary;
/

SHOW ERRORS FUNCTION fn_annual_salary;
