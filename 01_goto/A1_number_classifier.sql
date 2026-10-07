-- A1_number_classifier
-- Author: Patrick (20251SEN120)
-- Classifies each number in a list as NEGATIVE / ZERO / POSITIVE and as
-- EVEN / ODD (or "not a whole number"), using GOTO to jump between labelled
-- sections instead of nested IFs.
--
-- GOTO rules used here:
--   * Every label is followed by an executable statement.
--   * Jumps go OUT of IF blocks to labels in the same loop body (legal);
--     nothing jumps INTO an IF, a LOOP or another block (illegal).

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
      GOTO unknown;
    END IF;

    IF v_num < 0 THEN
      GOTO negative;
    ELSIF v_num = 0 THEN
      GOTO zero;
    END IF;
    GOTO positive;

    <<negative>>
    v_result := 'NEGATIVE';
    GOTO parity;

    <<zero>>
    v_result := 'ZERO';
    GOTO parity;

    <<positive>>
    v_result := 'POSITIVE';

    <<parity>>
    IF v_num <> TRUNC(v_num) THEN
      v_result := v_result || ', not a whole number';
    ELSIF MOD(v_num, 2) = 0 THEN
      v_result := v_result || ', EVEN';
    ELSE
      v_result := v_result || ', ODD';
    END IF;
    GOTO show_result;

    <<unknown>>
    v_result := 'UNKNOWN (NULL input)';

    <<show_result>>
    DBMS_OUTPUT.PUT_LINE(RPAD(NVL(TO_CHAR(v_num), 'NULL'), 8) || ' -> ' || v_result);
  END LOOP;
END;
/
