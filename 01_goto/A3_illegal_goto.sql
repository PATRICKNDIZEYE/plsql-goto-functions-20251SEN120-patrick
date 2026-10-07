-- A3_illegal_goto
-- Author: Patrick (20251SEN120)
-- Part 1 shows an ILLEGAL GOTO that fails to compile with PLS-00375.
-- Part 2 shows the corrected version.
--
-- Why it is illegal: a GOTO cannot jump INTO an IF statement, a LOOP or a
-- nested block from outside it. Oracle only allows jumps within the same
-- sequence of statements or OUT to an enclosing one.

SET SERVEROUTPUT ON;

PROMPT ===== Part 1: ILLEGAL GOTO (expected error PLS-00375) =====
DECLARE
  v_salary NUMBER := 450000;
BEGIN
  GOTO apply_bonus;              -- illegal: the label is inside the IF below

  IF v_salary > 100000 THEN
    <<apply_bonus>>
    DBMS_OUTPUT.PUT_LINE('Bonus applied: ' || v_salary * 0.10);
  END IF;
END;
/

PROMPT ===== Part 2: FIXED (label moved out of the IF) =====
DECLARE
  v_salary NUMBER := 450000;
BEGIN
  IF v_salary > 100000 THEN
    GOTO apply_bonus;            -- legal: jumping OUT of the IF
  END IF;

  DBMS_OUTPUT.PUT_LINE('No bonus: salary ' || v_salary || ' is too low.');
  GOTO done;

  <<apply_bonus>>
  DBMS_OUTPUT.PUT_LINE('Bonus applied: ' || v_salary * 0.10);

  <<done>>
  NULL;
END;
/
