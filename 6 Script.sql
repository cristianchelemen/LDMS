CREATE OR REPLACE PROCEDURE GetSalary (p_emp_id IN wid_emp.emp_id%TYPE, p_message OUT VARCHAR2)  IS
  CURSOR c_emp (cp_emp_id IN wid_emp.emp_id%TYPE) IS
    SELECT *
      FROM wid_emp
     WHERE (emp_id = cp_emp_id);
  --
  v_row   wid_emp%ROWTYPE;
  v_found BOOLEAN;
BEGIN
  OPEN c_emp (p_emp_id);
  FETCH c_emp INTO v_row;
  v_found := c_emp%Found;
  CLOSE c_emp;
  --
  p_message := CASE
                 WHEN v_found THEN 'The salary for ' || v_row.emp_name || ' (' || v_row.emp_id || ') is ' || TO_CHAR (v_row.salary)
                 ELSE 'The employee with ID ' || TO_CHAR (p_emp_id) || ' does not exist!'
               END;
EXCEPTION
  WHEN others THEN
    RAISE_APPLICATION_ERROR (-20018, 'Error ' || TO_CHAR (SQLCODE) || ' occured for employee with ID ' || TO_CHAR (p_emp_id) || ' - ' || SQLERRM);
END GetSalary;
/
