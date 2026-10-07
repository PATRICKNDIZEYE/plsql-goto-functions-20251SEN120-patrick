-- B3_fn_calculate_tax
-- Author: Patrick (20251SEN120)
-- Calculates monthly PAYE income tax on a monthly gross salary (RWF) using
-- progressive brackets (Rwanda PAYE):
--        0 -  60,000   ->  0%
--   60,001 - 100,000   -> 10%
--  100,001 - 200,000   -> 20%
--          > 200,000   -> 30%
-- Each rate applies only to the part of the salary inside its bracket.
-- Returns NULL (with a message) for a NULL or negative salary.

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION fn_calculate_tax (
  p_monthly_salary IN NUMBER
) RETURN NUMBER
IS
  v_tax            NUMBER;
  e_invalid_salary EXCEPTION;
BEGIN
  IF p_monthly_salary IS NULL OR p_monthly_salary < 0 THEN
    RAISE e_invalid_salary;
  END IF;

  IF p_monthly_salary <= 60000 THEN
    v_tax := 0;
  ELSIF p_monthly_salary <= 100000 THEN
    v_tax := (p_monthly_salary - 60000) * 0.10;
  ELSIF p_monthly_salary <= 200000 THEN
    v_tax := 4000 + (p_monthly_salary - 100000) * 0.20;            -- 4,000 = full 10% bracket
  ELSE
    v_tax := 4000 + 20000 + (p_monthly_salary - 200000) * 0.30;    -- 20,000 = full 20% bracket
  END IF;

  RETURN ROUND(v_tax, 2);
EXCEPTION
  WHEN e_invalid_salary THEN
    DBMS_OUTPUT.PUT_LINE('fn_calculate_tax: salary must be a non-negative number (got '
                         || NVL(TO_CHAR(p_monthly_salary), 'NULL') || ').');
    RETURN NULL;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('fn_calculate_tax: unexpected error - ' || SQLERRM);
    RETURN NULL;
END fn_calculate_tax;
/

SHOW ERRORS FUNCTION fn_calculate_tax;
