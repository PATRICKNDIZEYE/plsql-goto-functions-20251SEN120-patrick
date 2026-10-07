-- test_validate_payroll
-- Author: Patrick (20251SEN120)
-- Tests C1 fn_validate_payroll: every employee in STAFF (valid and problem
-- rows), a non-existent employee, and use of the function inside a SELECT.

SET SERVEROUTPUT ON;
SET LINESIZE 200;
COLUMN full_name FORMAT A16
COLUMN status    FORMAT A110

PROMPT ===== 1. Validate every employee (PL/SQL loop) =====
DECLARE
  v_result VARCHAR2(400);
  v_valid  PLS_INTEGER := 0;
  v_bad    PLS_INTEGER := 0;
BEGIN
  FOR r IN (SELECT emp_id, full_name FROM staff ORDER BY emp_id) LOOP
    v_result := fn_validate_payroll(r.emp_id);
    DBMS_OUTPUT.PUT_LINE(r.emp_id || ' ' || RPAD(r.full_name, 16) || ' ' || v_result);
    IF v_result LIKE 'VALID%' THEN
      v_valid := v_valid + 1;
    ELSE
      v_bad := v_bad + 1;
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Valid: ' || v_valid || '   Invalid: ' || v_bad);   -- Valid: 5   Invalid: 3
END;
/

PROMPT ===== 2. Employee that does not exist =====
BEGIN
  DBMS_OUTPUT.PUT_LINE('999: ' || fn_validate_payroll(999));   -- INVALID | employee 999 does not exist
END;
/

PROMPT ===== 3. fn_validate_payroll used in SQL =====
SELECT emp_id, full_name, fn_validate_payroll(emp_id) AS status
FROM   staff
ORDER  BY emp_id;
