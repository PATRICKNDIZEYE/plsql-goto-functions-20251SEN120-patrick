-- A2_salary_review
-- Author: Patrick (20251SEN120)
-- Reviews every employee in STAFF and proposes a raise. Records that cannot
-- be reviewed are skipped with GOTO. This is a review report only: no data
-- is changed.
--
-- Raise rules:
--   salary >= 2,000,000        -> no raise (above cap)
--   5 or more years of service -> 10%
--   1 - 4 years of service     -> 5%
--   less than 1 year           -> no raise (still on probation)
-- Skipped: missing salary, missing or future hire date.

SET SERVEROUTPUT ON;

DECLARE
  c_salary_cap CONSTANT NUMBER := 2000000;

  v_years    NUMBER;
  v_rate     NUMBER;
  v_decision VARCHAR2(60);
  v_reason   VARCHAR2(60);
  v_reviewed PLS_INTEGER := 0;
  v_skipped  PLS_INTEGER := 0;
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('Employee', 18) || RPAD('Salary', 10)
                       || RPAD('Years', 7) || 'Decision');
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 75, '-'));

  FOR r IN (SELECT emp_id, full_name, salary, hire_date FROM staff ORDER BY emp_id) LOOP

    IF r.salary IS NULL THEN
      v_reason := 'no salary on record';
      GOTO skip_employee;
    END IF;

    IF r.hire_date IS NULL OR r.hire_date > SYSDATE THEN
      v_reason := 'missing or future hire date';
      GOTO skip_employee;
    END IF;

    v_years := TRUNC(MONTHS_BETWEEN(SYSDATE, r.hire_date) / 12);

    IF r.salary >= c_salary_cap THEN
      v_rate := 0;  v_decision := 'NO RAISE (above cap)';
    ELSIF v_years >= 5 THEN
      v_rate := 0.10;  v_decision := 'RAISE 10%';
    ELSIF v_years >= 1 THEN
      v_rate := 0.05;  v_decision := 'RAISE 5%';
    ELSE
      v_rate := 0;  v_decision := 'NO RAISE (probation)';
    END IF;

    IF v_rate > 0 THEN
      v_decision := v_decision || ' -> ' || r.salary * (1 + v_rate);
    END IF;

    DBMS_OUTPUT.PUT_LINE(RPAD(r.emp_id, 5) || RPAD(r.full_name, 18) || RPAD(r.salary, 10)
                         || RPAD(v_years, 7) || v_decision);
    v_reviewed := v_reviewed + 1;
    GOTO next_employee;

    <<skip_employee>>
    DBMS_OUTPUT.PUT_LINE(RPAD(r.emp_id, 5) || RPAD(r.full_name, 18) || RPAD(NVL(TO_CHAR(r.salary), '-'), 10)
                         || RPAD('-', 7) || 'SKIPPED: ' || v_reason);
    v_skipped := v_skipped + 1;

    <<next_employee>>
    NULL;  -- a label must be followed by an executable statement
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(RPAD('-', 75, '-'));
  DBMS_OUTPUT.PUT_LINE('Reviewed: ' || v_reviewed || '   Skipped: ' || v_skipped);
END;
/
