-- B2_fn_years_of_service
-- Author: Patrick (20251SEN120)
-- Returns the number of COMPLETE years an employee has worked (as of today).
-- Returns NULL (with a message) when the employee does not exist, has no
-- hire date, or has a hire date in the future.

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION fn_years_of_service (
  p_emp_id IN staff.emp_id%TYPE
) RETURN NUMBER
IS
  v_hire_date    staff.hire_date%TYPE;
  e_bad_hire_date EXCEPTION;
BEGIN
  SELECT hire_date INTO v_hire_date
  FROM   staff
  WHERE  emp_id = p_emp_id;

  IF v_hire_date IS NULL OR v_hire_date > SYSDATE THEN
    RAISE e_bad_hire_date;
  END IF;

  -- MONTHS_BETWEEN gives fractional months; /12 and TRUNC give whole years
  RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, v_hire_date) / 12);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('fn_years_of_service: employee ' || p_emp_id || ' does not exist.');
    RETURN NULL;
  WHEN e_bad_hire_date THEN
    DBMS_OUTPUT.PUT_LINE('fn_years_of_service: employee ' || p_emp_id
                         || ' has a missing or future hire date.');
    RETURN NULL;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('fn_years_of_service: unexpected error - ' || SQLERRM);
    RETURN NULL;
END fn_years_of_service;
/

SHOW ERRORS FUNCTION fn_years_of_service;
