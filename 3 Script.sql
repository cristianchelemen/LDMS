CREATE OR REPLACE PACKAGE create_row IS
  -- Note: Do not forget to commit the data!
  --
  TYPE tTabNT IS TABLE OF wid_emp%ROWTYPE;
  TYPE tTabAA IS TABLE OF wid_emp%ROWTYPE INDEX BY BINARY_INTEGER;
  --
  g_check_mgr   BOOLEAN := FALSE;
  g_check_dept  BOOLEAN := FALSE;
  g_check_nulls BOOLEAN := FALSE;
  --
  PROCEDURE Ins (p_row IN wid_emp%ROWTYPE);
  --
  PROCEDURE Ins (p_emp_id     IN wid_emp.emp_id%TYPE
                ,p_emp_name   IN wid_emp.emp_name%TYPE
                ,p_job_title  IN wid_emp.job_title%TYPE
                ,p_mgr_id     IN wid_emp.mgr_id%TYPE
                ,p_date_hired IN wid_emp.date_hired%TYPE
                ,p_salary     IN wid_emp.salary%TYPE
                ,p_dept_id    IN wid_emp.dept_id%TYPE
                );
  --
  PROCEDURE Ins (p_tab IN tTabNT);
  --
  PROCEDURE Ins (p_tab IN tTabAA);
END create_row;
/
--
CREATE OR REPLACE PACKAGE BODY create_row IS
  FUNCTION check_mgr (p_emp_id IN wid_emp.emp_id%TYPE) RETURN BOOLEAN IS
    CURSOR c_emp (cp_emp_id IN wid_emp.emp_id%TYPE) IS
      SELECT emp_id
        FROM wid_emp
       WHERE (emp_id = cp_emp_id);
    --
    v_row    c_emp%ROWTYPE;
    v_return BOOLEAN;
  BEGIN
    OPEN c_emp (p_emp_id);
    FETCH c_emp INTO v_row;
    v_return := c_emp%Found;
    CLOSE c_emp;
    --
    RETURN (v_return);
  END check_mgr;
  --
  FUNCTION check_dept (p_dept_id IN wid_dept.dept_id%TYPE) RETURN BOOLEAN IS
    CURSOR c_dept (cp_dept_id IN wid_dept.dept_id%TYPE) IS
      SELECT dept_id
        FROM wid_dept
       WHERE (dept_id = cp_dept_id);
    --
    v_row    c_dept%ROWTYPE;
    v_return BOOLEAN;
  BEGIN
    OPEN c_dept (p_dept_id);
    FETCH c_dept INTO v_row;
    v_return := c_dept%Found;
    CLOSE c_dept;
    --
    RETURN (v_return);
  END check_dept;
  --
  PROCEDURE Ins (p_row IN wid_emp%ROWTYPE) IS
  BEGIN
    IF g_check_nulls THEN
      IF (p_row.emp_id IS NULL) THEN
        RAISE_APPLICATION_ERROR (-20001, 'Record cannot be inserted. Employee ID does not exist!');
      END IF;
      --
      IF (p_row.emp_name IS NULL) THEN
        RAISE_APPLICATION_ERROR (-20002, 'Record cannot be inserted. Employee name does not exist!');
      END IF;
      --
      IF (p_row.job_title IS NULL) THEN
        RAISE_APPLICATION_ERROR (-20003, 'Record cannot be inserted. Job title does not exist!');
      END IF;
      --
      IF (p_row.date_hired IS NULL) THEN
        RAISE_APPLICATION_ERROR (-20004, 'Record cannot be inserted. Hiring date does not exist!');
      END IF;
      --
      IF (p_row.salary IS NULL) THEN
        RAISE_APPLICATION_ERROR (-20005, 'Record cannot be inserted. Salary does not exist!');
      END IF;
    END IF;
    --
    IF g_check_dept THEN
      IF NOT check_dept (p_row.dept_id) THEN
        RAISE_APPLICATION_ERROR (-20006, 'Record cannot be inserted. Department with ID ' || TO_CHAR (p_row.dept_id) || ' does not exist!');
      END IF;
    END IF;
    --
    IF g_check_mgr THEN
      IF NOT check_mgr (p_row.mgr_id) THEN
        RAISE_APPLICATION_ERROR (-20007, 'Record cannot be inserted. Manager with ID ' || TO_CHAR (p_row.mgr_id) || ' does not exist!');
      END IF;
    END IF;
    --
    INSERT INTO wid_emp VALUES p_row;
  EXCEPTION
    WHEN dup_val_on_index THEN
      RAISE_APPLICATION_ERROR (-20008, 'Record cannot be inserted. Employee with ID ' || TO_CHAR (p_row.emp_id) || ' already exists!');
    WHEN others THEN
      RAISE_APPLICATION_ERROR (-20009, 'Record cannot be inserted. Error ' || TO_CHAR (SQLCODE) || ' occured for employee with ID ' || TO_CHAR (p_row.emp_id) || ' - ' || SQLERRM);
  END Ins;
  --
  PROCEDURE Ins (p_emp_id     IN wid_emp.emp_id%TYPE
                ,p_emp_name   IN wid_emp.emp_name%TYPE
                ,p_job_title  IN wid_emp.job_title%TYPE
                ,p_mgr_id     IN wid_emp.mgr_id%TYPE
                ,p_date_hired IN wid_emp.date_hired%TYPE
                ,p_salary     IN wid_emp.salary%TYPE
                ,p_dept_id    IN wid_emp.dept_id%TYPE
                ) IS
    --
    v_row wid_emp%ROWTYPE;
  BEGIN
    v_row.emp_id     := p_emp_id    ;
    v_row.emp_name   := p_emp_name  ;
    v_row.job_title  := p_job_title ;
    v_row.mgr_id     := p_mgr_id    ;
    v_row.date_hired := p_date_hired;
    v_row.salary     := p_salary    ;
    v_row.dept_id    := p_dept_id   ;
    --
    Ins (v_row);
  EXCEPTION
    WHEN others THEN
      RAISE_APPLICATION_ERROR (-20010, 'Record cannot be inserted. Error ' || TO_CHAR (SQLCODE) || ' occured for employee with ID ' || TO_CHAR (p_emp_id) || ' - ' || SQLERRM);
  END Ins;
  --
  PROCEDURE Ins (p_tab IN tTabNT) IS
    v_count  INTEGER;
    ex_error EXCEPTION;
    --
    PRAGMA EXCEPTION_INIT (ex_error, -24381);
  BEGIN
    FORALL i IN p_tab.FIRST .. p_tab.LAST SAVE EXCEPTIONS
      INSERT INTO wid_emp VALUES p_tab (i);
  EXCEPTION
    WHEN ex_error THEN
      v_count := SQL%BULK_EXCEPTIONS.COUNT;
      --
      dbms_output.Put_Line ('Number of errors: ' || v_count);
      --
      FOR i IN 1 .. v_count LOOP
        dbms_output.Put_Line ('Error: #' || i || ' at index: ' || SQL%BULK_EXCEPTIONS (i).error_index || ' with message: ' || SQLERRM (-SQL%BULK_EXCEPTIONS (i).ERROR_CODE));
      END LOOP;
  END Ins;
  --
  PROCEDURE Ins (p_tab IN tTabAA) IS
    v_count  INTEGER;
    ex_error EXCEPTION;
    --
    PRAGMA EXCEPTION_INIT (ex_error, -24381);
  BEGIN
    FORALL i IN p_tab.FIRST .. p_tab.LAST SAVE EXCEPTIONS
      INSERT INTO wid_emp VALUES p_tab (i);
  EXCEPTION
    WHEN ex_error THEN
      v_count := SQL%BULK_EXCEPTIONS.COUNT;
      --
      dbms_output.Put_Line ('Number of errors: ' || v_count);
      --
      FOR i IN 1 .. v_count LOOP
        dbms_output.Put_Line ('Error: #' || i || ' at index: ' || SQL%BULK_EXCEPTIONS (i).error_index || ' with message: ' || SQLERRM (-SQL%BULK_EXCEPTIONS (i).ERROR_CODE));
      END LOOP;
  END Ins;
END create_row;
/
