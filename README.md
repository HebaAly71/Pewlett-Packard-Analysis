# Pewlett-Packard-Technical Report
### Project Summary:
##### Pewlett Packard is building a database for its employees. Six main tables were created using PostgresSQL using the csv files provided that has all of the data to build these tables.  Please note that the file ***schema.sql*** has the code to create these tables along with their columns, primary keys and foreign keys.  Also note that the file ***EmployeeDB.png*** has the diagram that explains the relations between each table with respect to its primary and foreign keys.
 1. Employees Table
 2. Departments Table
 3. Titles Table
 4. Dept_Emp Table
 5. Dept_Manager Table
 6. Salaries_Table
 ##### Then we are asked to find the number of current employees who are retiring and find the employees that can be mentors for supervisory roles. All employees who are born in 1952 and are hired between years 1985 and 1988 are going to retire. While all employees who are born in 1965 are considered to be mentors. 
 
 ##### First of all a table of all the current employees who are retiring is created by querying and joining the employees table and dept_emp table  and getting all the employees who fulfill the criteria stated above for retiring. This query is saved in  ***current_emp*** table.  This query simply outputs a table that has data for all the current employees who are retiring (emp_no, first_name, last_name etc..). This table is saved in ***current_emp.csv***. Below is the code used to create this table.
 
	> --------List of retiring employees--------- 

	> SELECT emp_no, first_name, last_name

	> INTO retirement_info

	> FROM employees

	> WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')

	> AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

	> ---------List of current retiring employees-----------

	> SELECT ri.emp_no,

	> ri.first_name,
	
	> ri.last_name,
	
	> de.to_date
	
	> INTO current_emp
	
	> FROM retirement_info as ri
	
	> LEFT JOIN dept_emp as de
	
	> ON ri.emp_no = de.emp_no
	
	> WHERE de.to_date = ('9999-01-01');
 
 ##### Secondly, a table that has the current retiring employees along with their title and salary is created by querying the current_emp table and inner joining with titles and salaries table. This query is saved in  ***Retiring_Title_1*** table.  This query simply outputs a table that has all the current retiring employees data along with their titles and salaries. Below is the code used to create this table:
 	> ----------List of Retiring Employees including their titles
	
	SELECT  cemp.emp_no,
	
        cemp.first_name,
	
        cemp.last_name,
	
        ti.title,
	
		ti.from_date,
		
		s.salary,
		
		cemp.to_date
		
	INTO Retiring_Title_1
	
	FROM current_emp AS cemp
	
    	INNER JOIN titles AS ti
	
      	  ON (cemp.emp_no = ti.emp_no)
	  
    	INNER JOIN salaries AS s
	
        	ON (cemp.emp_no = s.emp_no);

##### There is only one problem with this table that one employee can have two different titiles in two different dates (from_date).  That means that we can have duplicates, so what we actually need is the most recent title for each retiring employee.  As we see in the table below, which is prt of the Retiring_Title_1 table, both Christian Koblick and Sumant Peac names occur more than once with different titles and from_dates.

	> emp_no	first_name	last_name	title	     from_date	salary	to_date

	> 10001	         Georgi	         Facello    Senior Engineer	6/26/86	60117	1/1/99

	> 10004	       Chirstian	Koblick	      Engineer	        12/1/86	40054	1/1/99

	> 10004	       Chirstian	Koblick	   Senior Engineer	12/1/95	40054	1/1/99

	> 10009	         Sumant	         Peac	  Assistant Engineer	2/18/85	60929	1/1/99

	> 10009	         Sumant	         Peac	   Engineer	        2/18/90	60929	1/1/99

	> 10009	         Sumant	         Peac	 Senior Engineer	2/18/95	60929	1/1/99

##### This means that we need to do another query and create another table that has no duplicates.  So another query is done where a new table called ***cleanTable_Retiredtitles*** is created by partitioning the ***retiring_title_1*** table by 'emp_no', 'first_name', 'last_name' and ordering the from_date column in a descending order. The result is a table with all the current retiring employees data along with their most recent title(no duplicates). This cleaned retiring employee with recent title table is saved in ***cleantable_retiring_emp_titles.csv***. Below is the code used to get the duplicates and delete them and also save them to a new table.
	> create table cleanTable_Retiredtitles as (
	
	with identifiedDuplicates as
	
	(
	
	select emp_no,first_name,last_name,title,from_date,salary,to_date, row_number() over
	
		( 
		
			partition by emp_no,first_name,last_name
			
			order by from_date DESC
			
		) as rnum
		
	from retiring_title_1
	
	)
	
		select * from identifiedDuplicates where rnum = 1
	);

 
##### Another query is then done on the clean retiring employees table were we find the number of current retiring employees per title.  This will help the department managers plan how many potential mentors will they need. As it is seen from the result of the query that the most of the retiring employees has a senior engineering title, while the least number is 2 and they have a Manager title.

	> count	title
	
	> 2711	Engineer
	
	> 13651	Senior Engineer
	
	> 2	Manager
	
	> 251	Assistant Engineer
	
	> 2022	Staff
	
	> 12872	Senior Staff
	
	> 1609	Technique Leader
 
 ##### Last but not least we need to find all the employees who can be potential mentors.  This table is created by querying the employees table for all the employees that were born in 1965 and then joining it to the titles table in order to include their titles, from_date and to_date. The output is a table that contains all current employees that are born in 1965 along with all the data needed such as their names, title, and from and to dates. This is table is saved to ***mentors.csv*** file. Below is the code used to create this table:
 
	> SELECT  e.emp_no,
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
