-- 1 rows on each table
select count(*) from departments;
select count(*) from dept_emp;
select count(*) from dept_manager;
select count(*) from employees;
select count(*) from salaries;
select count(*) from titles;


-- 2 employees with the name "mark"
select count(employees.first_name) from employees
where first_name = "mark";


-- 3 first name "Eric" and last name starting with "A"
select count(employees.first_name) from employees
where first_name = "eric" AND last_name like "A%";


-- 4 all employees since 1985
select first_name, last_name from employees
where employees.emp_no in (select distinct salaries.emp_no from salaries
                           where salaries.to_date > CURRENT_DATE)
and (date(hire_date) between "1985-01-01" and "1985-12-31");


-- 5 hired between 1990 and 1997
select first_name, last_name from employees
where (date(hire_date) between "1990-01-01" and "1997-12-31");


-- 6 salary higher than 70k
-- 6.1 show all data
select em.first_name, em.last_name, sa.salary from employees em
join salaries sa on em.emp_no = sa.emp_no
where sa.salary > 70000
group by first_name;

-- 6.2 better way
select em.first_name, em.last_name from employees em
where em.emp_no in (select distinct emp_no from salaries sa
                    where sa.salary > 70000);


-- 7 employees in research and since 1992
select em.first_name, em.last_name from employees em
where em.emp_no in (select distinct de.emp_no from dept_emp de
                    where de.dept_no IN (
                        select dep.dept_no from departments dep
                        where dep.dept_name = "Research")
                   )
AND em.hire_date >= "1992-01-01"
and em.emp_no in (select distinct salaries.emp_no from salaries
                           where salaries.to_date > CURRENT_DATE);


-- 8 employees in finance since 1985 and salary > 75000
select em.first_name, em.last_name from employees em
where (em.emp_no in (select distinct de.emp_no from dept_emp de
                    where de.dept_no IN (
                        select dep.dept_no from departments dep
                        where dep.dept_name = "Finance")
                   ))
AND (em.emp_no in (select distinct emp_no from salaries sa
                    where sa.salary > 75000 and sa.to_date > CURRENT_DATE))
AND em.hire_date >= "1985-01-01";


-- 9 employees, who are working for us at this moment: first and last name, date of birth, gender, hire_date, title and salary.
select em.first_name, em. last_name, em.birth_date, em.gender, em.hire_date, ti.title, sa.salary from employees em
join titles ti on em.emp_no = ti.emp_no
join salaries sa on em.emp_no = sa.emp_no
where sa.to_date > CURRENT_DATE
GROUP by first_name;


-- 10 table with managers, who are working for us at this moment: first and last name, date of birth, gender, hire_date, title, department name and salary.
select em.first_name, em.last_name, em.birth_date, em.gender, em.hire_date, ti.title, dep.dept_name, sa.salary from employees em
join titles ti on em.emp_no = ti.emp_no
join salaries sa on em.emp_no = sa.emp_no
join dept_emp deem on em.emp_no = deem.emp_no
join departments dep on deem.dept_no = dep.dept_no
where em.emp_no in (select distinct dept_manager.emp_no from dept_manager
                           where dept_manager.to_date > CURRENT_DATE)
group by first_name asc;


-- bonus
select em.*, ti.title, ti.from_date, ti.to_date, dep.dept_no, dep.dept_name, sa.salary from employees em
left join titles ti on em.emp_no = ti.emp_no
left join salaries sa on em.emp_no = sa.emp_no
left join dept_emp deem on em.emp_no = deem.emp_no
left join departments dep on deem.dept_no = dep.dept_no
left join dept_manager dema on em.emp_no = dema.emp_no
order by em.emp_no asc;


-- show how many current employees the company has
select count(*) from employees
where employees.emp_no in (select distinct salaries.emp_no from salaries
                           where salaries.to_date > CURRENT_DATE);


-- show how many current managers there are
select count(*) from employees
where employees.emp_no in (select distinct dept_manager.emp_no from dept_manager
                           where dept_manager.to_date > CURRENT_DATE);


-- show how many people stopped working for the comp
select count(*) from employees
where employees.emp_no not in (select distinct salaries.emp_no from salaries
                           where salaries.to_date > CURRENT_DATE);


-- how many ppl work in each department
select departments.dept_name, count(*) from employees
join dept_emp on employees.emp_no = dept_emp.emp_no
join departments on dept_emp.dept_no = departments.dept_no
where employees.emp_no in (select distinct salaries.emp_no from salaries
                           where salaries.to_date > CURRENT_DATE)
group by dept_name asc;


--
select employees.first_name, employees.last_name, sum(salaries.salary) from employees
join salaries on employees.emp_no = salaries.emp_no
order by employees.first_name, employees.last_name asc;