-- task 1
create or replace view dept_info as
select * from dept_info
    dep_name TEXT,
    location TEXT,
    num_emp NUMBER,
    num_proj NUMBER
    )
from dep_name left join dept_info
from location left join dept_info
from num_emp right join dept_info
from num_proj right join num_proj

         -- task2
create or replace view high_salary_emp as
select * from high_salary_emp
    emp_name TEXT,
    salary NUMBER,
    dep_name TEXT,
    salary_range (
        WHERE(
            salary > 60000,
            slary > 50000,
            salary < 50000
        )
        )
    )
from emp_name left joinm high_salary_emp
from salary right join high_salary_emp
from dep_name left join high_salary_emp
from salary_ranege right join high_salary emp

-- PART B
-- task 3

create or replace view dept_stats as
select * from dept_stats
    dept_id TEXT PRIMARY KEY,
    dept_name TEXT,
    emp_total SUM(num_emp),
    


-- tasK 4



