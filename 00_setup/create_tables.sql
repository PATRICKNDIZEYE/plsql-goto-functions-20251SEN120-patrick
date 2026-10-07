-- create_tables.sql
-- Author: Patrick (20251SEN120)
-- Creates and populates the DEPARTMENTS and STAFF tables used by every script
-- in this repository. Safe to re-run: existing tables are dropped first.

SET SERVEROUTPUT ON;

BEGIN
  FOR t IN (SELECT table_name FROM user_tables
            WHERE table_name IN ('STAFF', 'DEPARTMENTS')
            ORDER BY DECODE(table_name, 'STAFF', 1, 2)) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
  END LOOP;
END;
/

CREATE TABLE departments (
  dept_id   NUMBER(4)    PRIMARY KEY,
  dept_name VARCHAR2(50) NOT NULL,
  location  VARCHAR2(50)
);

-- salary is the MONTHLY gross salary in RWF.
-- No CHECK constraints on salary / dept / hire_date on purpose: some rows hold
-- bad data so the validation logic (A2, C1) has real cases to catch.
CREATE TABLE staff (
  emp_id    NUMBER(6)    PRIMARY KEY,
  full_name VARCHAR2(80) NOT NULL,
  job_title VARCHAR2(50),
  dept_id   NUMBER(4)    REFERENCES departments (dept_id),
  salary    NUMBER(12,2),
  hire_date DATE
);

INSERT INTO departments VALUES (10, 'Finance',         'Kigali');
INSERT INTO departments VALUES (20, 'IT',              'Kigali');
INSERT INTO departments VALUES (30, 'Human Resources', 'Musanze');
INSERT INTO departments VALUES (40, 'Sales',           'Huye');

-- Valid employees
INSERT INTO staff VALUES (101, 'Alice Uwase',     'Accountant', 10,  450000, DATE '2015-03-01');
INSERT INTO staff VALUES (102, 'Bob Mugisha',     'Developer',  20,  850000, DATE '2019-07-15');
INSERT INTO staff VALUES (103, 'Claire Ingabire', 'HR Officer', 30,   95000, DATE '2022-01-10');
INSERT INTO staff VALUES (104, 'David Habimana',  'Sales Rep',  40,   55000, DATE '2024-09-01');
INSERT INTO staff VALUES (107, 'Grace Uwimana',   'Manager',    10, 2500000, DATE '2010-11-30');
-- Problem rows (used to test validation):
--   105 has no salary, 106 has no department, 108 has a future hire date
INSERT INTO staff VALUES (105, 'Eric Nkurunziza', 'Intern',     20,    NULL, DATE '2026-02-01');
INSERT INTO staff VALUES (106, 'Fiona Mukamana',  'Analyst',  NULL,  300000, DATE '2021-05-20');
INSERT INTO staff VALUES (108, 'Henry Kamanzi',   'Developer',  20,  600000, DATE '2027-01-15');

COMMIT;

SELECT * FROM departments ORDER BY dept_id;
SELECT * FROM staff ORDER BY emp_id;
