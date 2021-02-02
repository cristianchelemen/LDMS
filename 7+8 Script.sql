CREATE OR REPLACE PACKAGE emp_pipeline IS
  CURSOR c_emp (cp_dept_id IN wid_emp.dept_id%TYPE) IS
    SELECT emp_id, emp_name, salary, SUM (salary) OVER (PARTITION BY dept_id) AS total_salary
          ,(SELECT dept_name from wid_dept WHERE (wid_dept.dept_id = wid_emp.dept_id)) AS dept_name
      FROM wid_emp
     WHERE (dept_id = cp_dept_id);
  --
  TYPE t_tab IS TABLE OF c_emp%ROWTYPE;
  TYPE t_vc2 IS TABLE OF VARCHAR2 (32767);
  --
  FUNCTION GetData   (p_dept_id IN wid_emp.dept_id%TYPE) RETURN t_tab PIPELINED;
  FUNCTION GetDataV  (p_dept_id IN wid_emp.dept_id%TYPE) RETURN t_vc2 PIPELINED;
  FUNCTION GetSalary (p_dept_id IN wid_emp.dept_id%TYPE) RETURN t_vc2 PIPELINED;
END emp_pipeline;
/
CREATE OR REPLACE PACKAGE BODY emp_pipeline IS
  FUNCTION GetData   (p_dept_id IN wid_emp.dept_id%TYPE) RETURN t_tab PIPELINED IS
  BEGIN
    FOR c IN c_emp (p_dept_id) LOOP
      PIPE ROW (c);
    END LOOP;
    --
    RETURN;
  END GetData;
  --
  FUNCTION GetDataV  (p_dept_id IN wid_emp.dept_id%TYPE) RETURN t_vc2 PIPELINED IS
  BEGIN
    FOR c IN c_emp (p_dept_id) LOOP
      IF (c_emp%ROWCOUNT = 1) THEN
        PIPE ROW (LPAD ('-', 90, '-'));
        PIPE ROW ('| ' || LPAD ('Employee ID', 15, ' ') || ' | ' || RPAD ('Employee Name', 50, ' ') || ' | ' || LPAD ('Salary', 15, ' ') || ' |');
        PIPE ROW (LPAD ('-', 90, '-'));
      END IF;
      --
      PIPE ROW ('| ' || LPAD (c.emp_id, 15, ' ') || ' | ' || RPAD (c.emp_name, 50, ' ') || ' | ' || LPAD (TO_CHAR (c.salary, 'fmL999G999G999G999'), 15, ' ') || ' |');
    END LOOP;
    --
    PIPE ROW (LPAD ('-', 90, '-'));
    --
    RETURN;
  END GetDataV;
  --
  FUNCTION GetSalary (p_dept_id IN wid_emp.dept_id%TYPE) RETURN t_vc2 PIPELINED IS
  BEGIN
    FOR c IN c_emp (p_dept_id) LOOP
      PIPE ROW (LPAD ('-', 90, '-'));
      PIPE ROW ('| ' || RPAD ('Total of Employee Salary for "' || c.dept_name || '" department (ID ' || TO_CHAR (p_dept_id) || ') is ' || TO_CHAR (c.total_salary, 'fmL9G999G999G999'), 86, ' ') || ' |');
      PIPE ROW (LPAD ('-', 90, '-'));
      EXIT;
    END LOOP;
    --
    RETURN;
  END GetSalary;
END emp_pipeline;
/
