# REFLECTION

## 1. When is GOTO useful, and when should it be avoided?

A1 and A4 do exactly the same thing, and comparing them shows the trade-off clearly.

In A1, the reader has to follow jumps up and down between labels (`negative`, `parity`, `show_result`) to see what happens to one number. In A4, the same logic reads top to bottom with a `CASE` and an `IF/ELSIF`, so it is shorter and easier to check. For ordinary branching, structured control flow is better than GOTO.

GOTO did make sense in two places, both "fail fast" exits:
- In A2, it skips a bad record and jumps to the end of the loop.
- In C1, every failed rule jumps to one `invalid_payroll` label that builds the error result.

In both cases, all the error paths end in one place instead of being repeated or nested. Even so, `CONTINUE` (in a loop) or `RETURN` (in a function) could do the same job. So I see GOTO as something to use rarely, and only when it makes the code simpler.

## 2. What did the illegal GOTO in A3 teach you?

`PLS-00375: illegal GOTO statement` means the GOTO is trying to jump into a place it is not allowed to enter. In A3, the label was inside an `IF` block and the GOTO was outside it.

Oracle allows jumps within the same sequence of statements, or out of an `IF`, a `LOOP` or a nested block. It does not allow jumps into one of these. It also does not allow jumps between `IF` branches, or from an exception handler back into the body. The rule makes sense: jumping into the middle of an `IF` would skip its condition entirely.

Moving the label outside the `IF` fixed the error, because the GOTO now jumps out of the `IF` instead of into it. I also learned that a label must be followed by an executable statement. That is why `<<next_employee>>` and `<<done>>` are followed by `NULL;`.

## 3. Functions and exception handling

Every function handles three kinds of exceptions:
- `NO_DATA_FOUND`, for an employee or department that doesn't exist;
- its own user-defined exceptions, such as `e_no_salary` or `e_bad_hire_date`;
- `OTHERS`, as a catch-all.

The functions return NULL instead of raising an error because they are called inside `SELECT` statements. If one row raised an error, the whole query would fail. Returning NULL lets the other rows still show.

An important point is that a function's exception handler must also `RETURN` something. Otherwise Oracle raises `ORA-06503: Function returned without value`.

I also learned that aggregates and DML don't raise `NO_DATA_FOUND`. `SELECT SUM(...)` always returns one row (with NULL), and an `UPDATE` that matches nothing just updates 0 rows. So I check existence first with `SELECT ... INTO`, or check `SQL%ROWCOUNT`.

## 4. Using functions in SQL

To call a function from SQL (B5), it must:
- return a SQL datatype like `NUMBER` or `VARCHAR2` (not `BOOLEAN`);
- not perform DML such as `INSERT` or `UPDATE`.

Once that is true, it can be used like a column: in the `SELECT` list, in `WHERE`, and in `GROUP BY`. The query that grouped staff by `fn_dept_name(dept_id)` showed that "No Department" becomes a group of its own, which is useful for spotting bad data.

One thing I noticed: when a function is called in a `WHERE` clause, it runs once per row. On a large table, that could be slow.

## 5. Challenges and what you would improve

My laptop is an Apple Silicon Mac, and Oracle 21c XE does not run under Rosetta: it fails with `ORA-00442`. I had to run it in a full x86 virtual machine (Colima with QEMU), which is slower but works.

In SQL Developer, I first worked in the wrong connection. I was logged in as `SYSTEM` in the root container, so my tables were not in my own schema, and my queries gave `ORA-00942`. Checking `USER` and `CON_NAME` fixed it.

Another bug was in the setup script. A `-- comment` placed after the `;` on the same line made SQL\*Plus silently drop three `INSERT` statements, so only 5 of the 8 staff rows were created. Moving the comments onto their own lines fixed it.

If I improved this project, I would:
- put all the functions in one package;
- store the tax brackets and salary limits in a table instead of hard-coding them;
- make the A2 salary review actually apply the raises, logging each change.
