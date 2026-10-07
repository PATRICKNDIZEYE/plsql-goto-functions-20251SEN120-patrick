-- A4_rewrite_no_goto
-- Author: Patrick (20251SEN120)
-- Same number classifier as A1, rewritten with structured control flow
-- (CASE + IF/ELSIF + CONTINUE) instead of GOTO. Output is identical to A1.
--
-- Why this is better: the flow reads top to bottom, each branch is visible in
-- one place, and there are no labels to keep track of.

SET SERVEROUTPUT ON;

DECLARE
  TYPE t_numbers IS TABLE OF NUMBER;
  v_numbers t_numbers := t_numbers(-15, 0, 7, 42, 3.5, NULL);
  v_num     NUMBER;
  v_result  VARCHAR2(100);
BEGIN
  DBMS_OUTPUT.PUT_LINE('Number   -> Classification');
  DBMS_OUTPUT.PUT_LINE('-----------------------------------------');

  FOR i IN 1 .. v_numbers.COUNT LOOP
    v_num := v_numbers(i);

    IF v_num IS NULL THEN
      DBMS_OUTPUT.PUT_LINE(RPAD('NULL', 8) || ' -> UNKNOWN (NULL input)');
      CONTINUE;                  -- replaces GOTO unknown / show_result
    END IF;

    v_result := CASE
                  WHEN v_num < 0 THEN 'NEGATIVE'
                  WHEN v_num = 0 THEN 'ZERO'
                  ELSE 'POSITIVE'
                END;

    IF v_num <> TRUNC(v_num) THEN
      v_result := v_result || ', not a whole number';
    ELSIF MOD(v_num, 2) = 0 THEN
      v_result := v_result || ', EVEN';
    ELSE
      v_result := v_result || ', ODD';
    END IF;

    DBMS_OUTPUT.PUT_LINE(RPAD(TO_CHAR(v_num), 8) || ' -> ' || v_result);
  END LOOP;
END;
/
