-- test_functions
-- Author: Patrick (20251SEN120)
-- Tests B1-B4 with valid inputs and with every handled error case.
-- Expected results are shown in the comments.

SET SERVEROUTPUT ON;

PROMPT ===== B1 fn_annual_salary =====
BEGIN
  DBMS_OUTPUT.PUT_LINE('101 (valid)      : ' || fn_annual_salary(101));     -- 5400000
  DBMS_OUTPUT.PUT_LINE('104 (valid)      : ' || fn_annual_salary(104));     -- 660000
  DBMS_OUTPUT.PUT_LINE('105 (no salary)  : ' || NVL(TO_CHAR(fn_annual_salary(105)), 'NULL'));  -- message + NULL
  DBMS_OUTPUT.PUT_LINE('999 (not found)  : ' || NVL(TO_CHAR(fn_annual_salary(999)), 'NULL'));  -- message + NULL
END;
/

PROMPT ===== B2 fn_years_of_service =====
BEGIN
  DBMS_OUTPUT.PUT_LINE('107 (hired 2010) : ' || fn_years_of_service(107));  -- 15
  DBMS_OUTPUT.PUT_LINE('104 (hired 2024) : ' || fn_years_of_service(104));  -- 2
  DBMS_OUTPUT.PUT_LINE('108 (future)     : ' || NVL(TO_CHAR(fn_years_of_service(108)), 'NULL'));  -- message + NULL
  DBMS_OUTPUT.PUT_LINE('999 (not found)  : ' || NVL(TO_CHAR(fn_years_of_service(999)), 'NULL'));  -- message + NULL
END;
/

PROMPT ===== B3 fn_calculate_tax (one test per bracket + invalid input) =====
BEGIN
  DBMS_OUTPUT.PUT_LINE('50,000    (0%)       : ' || fn_calculate_tax(50000));    -- 0
  DBMS_OUTPUT.PUT_LINE('60,000    (boundary) : ' || fn_calculate_tax(60000));    -- 0
  DBMS_OUTPUT.PUT_LINE('95,000    (10%)      : ' || fn_calculate_tax(95000));    -- 3500
  DBMS_OUTPUT.PUT_LINE('150,000   (20%)      : ' || fn_calculate_tax(150000));   -- 14000
  DBMS_OUTPUT.PUT_LINE('450,000   (30%)      : ' || fn_calculate_tax(450000));   -- 99000
  DBMS_OUTPUT.PUT_LINE('-1,000    (invalid)  : ' || NVL(TO_CHAR(fn_calculate_tax(-1000)), 'NULL'));  -- message + NULL
  DBMS_OUTPUT.PUT_LINE('NULL      (invalid)  : ' || NVL(TO_CHAR(fn_calculate_tax(NULL)), 'NULL'));   -- message + NULL
END;
/

PROMPT ===== B4 fn_dept_name =====
BEGIN
  DBMS_OUTPUT.PUT_LINE('10   : ' || fn_dept_name(10));    -- Finance
  DBMS_OUTPUT.PUT_LINE('30   : ' || fn_dept_name(30));    -- Human Resources
  DBMS_OUTPUT.PUT_LINE('99   : ' || fn_dept_name(99));    -- Unknown Department
  DBMS_OUTPUT.PUT_LINE('NULL : ' || fn_dept_name(NULL));  -- No Department
END;
/
