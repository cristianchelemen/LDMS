DEFINE OFF;
--
DECLARE
  CURSOR c_dept IS
    SELECT 1 AS dept_id, 'Management'             AS dept_name, 'London'    AS loc FROM DUAL UNION ALL
    SELECT 2 AS dept_id, 'Engineering'            AS dept_name, 'Cardiff'   AS loc FROM DUAL UNION ALL
    SELECT 3 AS dept_id, 'Research & Development' AS dept_name, 'Edinburgh' AS loc FROM DUAL UNION ALL
    SELECT 4 AS dept_id, 'Sales'                  AS dept_name, 'Belfast'   AS loc FROM DUAL;
  --
  CURSOR c_emp IS
    SELECT 90001 AS emp_id, 'John Smith'    AS emp_name, 'CEO'         AS job_title, NULL  AS mgr_id, TO_DATE ('01/01/95', 'dd/mm/rr') AS date_hired, 100000 AS salary, 1 AS dept_id FROM DUAL UNION ALL
    SELECT 90002 AS emp_id, 'Jimmy Willis'  AS emp_name, 'Manager'     AS job_title, 90001 AS mgr_id, TO_DATE ('23/09/03', 'dd/mm/rr') AS date_hired,  52500 AS salary, 4 AS dept_id FROM DUAL UNION ALL
    SELECT 90003 AS emp_id, 'Roxy Jones'    AS emp_name, 'Salesperson' AS job_title, 90002 AS mgr_id, TO_DATE ('11/02/17', 'dd/mm/rr') AS date_hired,  35000 AS salary, 4 AS dept_id FROM DUAL UNION ALL
    SELECT 90004 AS emp_id, 'Selwyn Field'  AS emp_name, 'Salesperson' AS job_title, 90003 AS mgr_id, TO_DATE ('20/05/15', 'dd/mm/rr') AS date_hired,  32000 AS salary, 4 AS dept_id FROM DUAL UNION ALL
    SELECT 90005 AS emp_id, 'David Hallett' AS emp_name, 'Engineer'    AS job_title, 90006 AS mgr_id, TO_DATE ('17/04/18', 'dd/mm/rr') AS date_hired,  40000 AS salary, 2 AS dept_id FROM DUAL UNION ALL
    SELECT 90006 AS emp_id, 'Sarah Phelps'  AS emp_name, 'Manager'     AS job_title, 90001 AS mgr_id, TO_DATE ('21/03/15', 'dd/mm/rr') AS date_hired,  45000 AS salary, 2 AS dept_id FROM DUAL UNION ALL
    SELECT 90007 AS emp_id, 'Louise Harper' AS emp_name, 'Engineer'    AS job_title, 90006 AS mgr_id, TO_DATE ('01/01/13', 'dd/mm/rr') AS date_hired,  47000 AS salary, 2 AS dept_id FROM DUAL UNION ALL
    SELECT 90008 AS emp_id, 'Tina Hart'     AS emp_name, 'Engineer'    AS job_title, 90009 AS mgr_id, TO_DATE ('28/07/14', 'dd/mm/rr') AS date_hired,  45000 AS salary, 3 AS dept_id FROM DUAL UNION ALL
    SELECT 90009 AS emp_id, 'Gus Jones'     AS emp_name, 'Manager'     AS job_title, 90001 AS mgr_id, TO_DATE ('15/05/18', 'dd/mm/rr') AS date_hired,  50000 AS salary, 3 AS dept_id FROM DUAL UNION ALL
    SELECT 90010 AS emp_id, 'Mildred Hall'  AS emp_name, 'Secretary'   AS job_title, 90001 AS mgr_id, TO_DATE ('12/10/96', 'dd/mm/rr') AS date_hired,  35000 AS salary, 1 AS dept_id FROM DUAL;
BEGIN
  DELETE FROM wid_emp;
  DELETE FROM wid_dept;
  --
  FOR c IN c_dept LOOP
    INSERT INTO wid_dept VALUES c;
  END LOOP;
  --
  FOR c IN c_emp LOOP
    INSERT INTO wid_emp VALUES c;
  END LOOP;
  --
  COMMIT;
END;
/
