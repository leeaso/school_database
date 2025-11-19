CREATE VIEW employee_details AS
SELECT e.emp_name, e.salary, d.dept_name, d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

CREATE VIEW dept_statistics AS
SELECT 
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    COALESCE(AVG(e.salary),0) AS avg_salary,
    MAX(e.salary) AS max_salary,
    MIN(e.salary) AS min_salary
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

CREATE VIEW project_overview AS
SELECT 
    p.project_name,
    p.budget,
    d.dept_name,
    d.location,
    COUNT(e.emp_id) AS team_size
FROM projects p
JOIN departments d ON p.dept_id = d.dept_id
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY p.project_id, d.dept_id;

CREATE VIEW high_earners AS
SELECT e.emp_name, e.salary, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary > 55000;

CREATE OR REPLACE VIEW employee_details AS
SELECT 
    e.emp_name,
    e.salary,
    d.dept_name,
    d.location,
    CASE 
        WHEN e.salary > 60000 THEN 'High'
        WHEN e.salary > 50000 THEN 'Medium'
        ELSE 'Standard'
    END AS salary_grade
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

ALTER VIEW high_earners RENAME TO top_performers;

CREATE VIEW temp_view AS
SELECT * FROM employees WHERE salary < 50000;
DROP VIEW temp_view;

CREATE VIEW employee_salaries AS
SELECT emp_id, emp_name, dept_id, salary FROM employees;

UPDATE employee_salaries SET salary = 52000 WHERE emp_name = 'John Smith';

INSERT INTO employee_salaries (emp_id, emp_name, dept_id, salary)
VALUES (6, 'Alice Johnson', 102, 58000);

CREATE VIEW it_employees AS
SELECT emp_id, emp_name, dept_id, salary
FROM employees
WHERE dept_id = 101
WITH LOCAL CHECK OPTION;

CREATE MATERIALIZED VIEW dept_summary_mv AS
SELECT 
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS total_employees,
    COALESCE(SUM(e.salary),0) AS total_salaries,
    COUNT(p.project_id) AS total_projects,
    COALESCE(SUM(p.budget),0) AS total_project_budget
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN projects p ON d.dept_id = p.dept_id
GROUP BY d.dept_id, d.dept_name
WITH DATA;

INSERT INTO employees VALUES (8, 'Charlie Brown', 101, 54000);
REFRESH MATERIALIZED VIEW dept_summary_mv;

CREATE UNIQUE INDEX ON dept_summary_mv (dept_id);
REFRESH MATERIALIZED VIEW CONCURRENTLY dept_summary_mv;

CREATE MATERIALIZED VIEW project_stats_mv AS
SELECT p.project_name, p.budget, d.dept_name, COUNT(e.emp_id) AS employee_count
FROM projects p
JOIN departments d ON p.dept_id = d.dept_id
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY p.project_id, d.dept_id
WITH NO DATA;
REFRESH MATERIALIZED VIEW project_stats_mv;