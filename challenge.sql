
--------List of retiring employees---------
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

---------List of current retiring employees-----------
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

----------List of Retiring Employees including their titles
SELECT  cemp.emp_no,
        cemp.first_name,
        cemp.last_name,
        ti.title,
		ti.from_date,
		s.salary,
		--cemp.to_date
INTO Retiring_Title_1
FROM current_emp AS cemp
    INNER JOIN titles AS ti
        ON (cemp.emp_no = ti.emp_no)
    INNER JOIN salaries AS s
        ON (cemp.emp_no = s.emp_no);
------------- Create a clean table of Recent Retiring Employees, their titles, with no duplicates
create table cleanTable_Retiredtitles as (
with identifiedDuplicates as 
(
	select emp_no,first_name,last_name,title,from_date,salary, row_number() over
		( 
			partition by emp_no,first_name,last_name
			order by from_date DESC
		) as rnum
	from retiring_title_1
)
select * from identifiedDuplicates where rnum = 1
);
----------Number of employees retiring per title-----
Select count(title),title
From cleanTable_Retiredtitles
Group by title;
-----------Mentor Table------
SELECT  e.emp_no,
		e.first_name,
        e.last_name,
        ti.title,
		ti.from_date,
		ti.to_date,
		e.birth_date
INTO Mentors
FROM employees AS e
    INNER JOIN titles AS ti
        ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') AND ----born in 1965
       (ti.to_date = ('9999-01-01'));-----current employees
 -------Number of mentors per title----
Select count(title),title
From mentors
Group by title; 
