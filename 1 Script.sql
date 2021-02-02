--DROP TABLE wid_emp;
--DROP TABLE wid_dept;
--
CREATE TABLE wid_dept (dept_id   NUMBER   (5, 0)  
                      ,dept_name VARCHAR2 (50)   NOT NULL
                      ,loc       VARCHAR2 (50)   NOT NULL
                      --
                      ,CONSTRAINT dept_pk PRIMARY KEY (dept_id));
--
COMMENT ON TABLE wid_dept IS 'Departments';
--
COMMENT ON COLUMN wid_dept.dept_id   IS 'The unique identifier for the department';
COMMENT ON COLUMN wid_dept.dept_name IS 'The name of the department'              ;
COMMENT ON COLUMN wid_dept.loc       IS 'The physical location of the department' ;
--
CREATE TABLE wid_emp (emp_id     NUMBER   (10, 0)
                     ,emp_name   VARCHAR2 (50)    NOT NULL
                     ,job_title  VARCHAR2 (50)    NOT NULL
                     ,mgr_id     NUMBER   (10, 0)
                     ,date_hired DATE             NOT NULL
                     ,salary     NUMBER   (10, 0) NOT NULL
                     ,dept_id    NUMBER   (5, 0)  NOT NULL
                     --
                     ,CONSTRAINT emp_pk  PRIMARY KEY (emp_id) 
                     ,CONSTRAINT dept_fk FOREIGN KEY (dept_id) REFERENCES wid_dept (dept_id));
--
COMMENT ON TABLE wid_emp IS 'Employees';
--
COMMENT ON COLUMN wid_emp.emp_id     IS 'The unique identifier for the employee';
COMMENT ON COLUMN wid_emp.emp_name   IS 'The name of the employee';
COMMENT ON COLUMN wid_emp.job_title  IS 'The job role undertaken by the employee. Some employees may undertaken the same job role';
COMMENT ON COLUMN wid_emp.mgr_id     IS 'Line manager of the employee';
COMMENT ON COLUMN wid_emp.date_hired IS 'The date the employee was hired';
COMMENT ON COLUMN wid_emp.salary     IS 'Current salary of the employee';
COMMENT ON COLUMN wid_emp.dept_id    IS 'Each employee must belong to a department';
