CREATE OR REPLACE PROCEDURE chg_sal_perc (p_emp_id IN wid_emp.emp_id%TYPE, p_percentage IN NUMBER) IS
  -- Note #1: when the percent is negative number the salary will decrease otherwise it'll increase
  -- Note #2: Do not forget to commit the data!
  --
  v_salary wid_emp.salary%TYPE;
  --
  FUNCTION GetSalary (p_emp_id IN wid_emp.emp_id%TYPE) RETURN wid_emp.salary%TYPE IS
    CURSOR c_emp (cp_emp_id IN wid_emp.emp_id%TYPE) IS
      SELECT salary
        FROM wid_emp
       WHERE (emp_id = cp_emp_id);
    --
    v_return wid_emp.salary%TYPE;
  BEGIN
    OPEN c_emp (p_emp_id);
    FETCH c_emp INTO v_return;
    CLOSE c_emp;
    --
    RETURN (v_return);
  END GetSalary;
  --
  PROCEDURE UpdSalary (p_emp_id IN wid_emp.emp_id%TYPE, p_salary IN wid_emp.salary%TYPE) IS
  BEGIN
    UPDATE wid_emp
       SET salary = p_salary
     WHERE (emp_id = p_emp_id);
  END UpdSalary;
BEGIN
  IF (p_percentage IS NULL) THEN
    RAISE_APPLICATION_ERROR (-20011, 'Please define a proper percentage!');
  END IF;
  --
  v_salary := GetSalary (p_emp_id);
  --
  IF (v_salary IS NULL) THEN
    RAISE_APPLICATION_ERROR (-20012, 'Employee with ID ' || TO_CHAR (p_emp_id) || ' does not exist!'); -- salary is a mandatory field
  END IF;
  --
  v_salary := v_salary * CASE 
                           WHEN (p_percentage <= -100) THEN 0
                           ELSE 1 + p_percentage / 100
                         END;
  --
  UpdSalary (p_emp_id, v_salary);
EXCEPTION
  WHEN others THEN
    RAISE_APPLICATION_ERROR (-20013, 'Record cannot be updated. Error ' || TO_CHAR (SQLCODE) || ' occured for employee with ID ' || TO_CHAR (p_emp_id) || ' - ' || SQLERRM);
END chg_sal_perc;
/
