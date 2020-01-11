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
 
 ##### First of all a table of all the current employees who are retiring is created by querying and joining the employees table and dept_emp table  and getting all the employees who fulfill the criteria stated above for retiring. This query is saved in  ***current_emp*** table.  This query simply outputs a table that has data for all the current employees who are retiring (emp_no, first_name, last_name etc..). This table is saved in 
 ##### Secondly, a table that has the current retiring employees along with their title and salary is created by querying the current_emp table and inner joining with titles and salaries table. This query is saved in  ***Retiring_Title_1*** table.  This query simply outputs a table that has all the current retiring employees data along with their titles and salaries.  There is only one problem with this table that one employee can have two different titiles in two different dates (from_date).  That means that we can have duplicates, so what we actually need is the most recent title for each retiring employee.  This means that we need to do another query and create another table that has no duplicates.  So another query is done where a new table called ***cleanTable_Retiredtitles*** is created by partitioning the ***retiring_title_1*** table by 'emp_no', 'first_name', 'last_name' and ordering the from_date column in a descending order. The result is a table with all the current retiring employees data along with their most recent title(no duplicates).
