-- B4_fn_dept_name
-- Author: Patrick (20251SEN120)
-- Returns the department name for a department ID.
--   NULL ID          -> 'No Department'
--   ID not in table  -> 'Unknown Department'   (NO_DATA_FOUND handled)

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION fn_dept_name (
  p_dept_id IN departments.dept_id%TYPE
) RETURN VARCHAR2
IS
  v_name departments.dept_name%TYPE;
BEGIN
  IF p_dept_id IS NULL THEN
    RETURN 'No Department';
  END IF;

  SELECT dept_name INTO v_name
  FROM   departments
  WHERE  dept_id = p_dept_id;

  RETURN v_name;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'Unknown Department';
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('fn_dept_name: unexpected error - ' || SQLERRM);
    RETURN NULL;
END fn_dept_name;
/

SHOW ERRORS FUNCTION fn_dept_name;
