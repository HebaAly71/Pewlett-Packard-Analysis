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
 
 ##### First of all a table of all the current employees who are retiring is created by querying and joining the employees table and dept_emp table  and getting all the employees who fulfill the criteria stated above for retiring. This query is saved in  ***current_emp*** table.  This query simply outputs a table that has data for all the current employees who are retiring (emp_no, first_name, last_name etc..). This table is saved in ***current_emp.csv***.
 
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
 
 ##### Secondly, a table that has the current retiring employees along with their title and salary is created by querying the current_emp table and inner joining with titles and salaries table. This query is saved in  ***Retiring_Title_1*** table.  This query simply outputs a table that has all the current retiring employees data along with their titles and salaries.  There is only one problem with this table that one employee can have two different titiles in two different dates (from_date).  That means that we can have duplicates, so what we actually need is the most recent title for each retiring employee.  This means that we need to do another query and create another table that has no duplicates.  So another query is done where a new table called ***cleanTable_Retiredtitles*** is created by partitioning the ***retiring_title_1*** table by 'emp_no', 'first_name', 'last_name' and ordering the from_date column in a descending order. The result is a table with all the current retiring employees data along with their most recent title(no duplicates). This cleaned retiring employee with recent title table is saved in ***cleantable_retiring_emp_titles.csv***.  
##### Another query is then done on the clean retring employees table were we find the number of current retiring employees per title.  This will help the department managers plan how many potential mentors will they need.
 
 ##### Last but not least we need to find all the employees who can be potential mentors.  This table is created by querying the employees table for all the employees that were born in 1965 and then joining it to the titles table in order to include their titles, from_date and to_date. The output is a table that contains all current employees that are born in 1965 along with all the data needed such as their names, title, and from and to dates. This is table is saved to ***mentors.csv*** file.
