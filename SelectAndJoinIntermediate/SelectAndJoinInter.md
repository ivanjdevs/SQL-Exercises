## SQL Exercises. Intermediate Select and Join exercises

This file contains fifteen solved SQL exercises focusing mainly on Select and Join instructions. Most of the SQL code was executed in MySQL.

***

**Question 31. The numbers of employees which report to each employee.** For this priblem, we will consider a manager an employee wgo has at leat 1 other employee reporting to them. 

Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.
Return the result table ordered by employee_id.

Employees table
| employee_id | name    | reports_to | age |
|-------------|---------|------------|-----|
| 9           | Hercy   | null       | 43  |
| 6           | Alice   | 9          | 41  |
| 4           | Bob     | 9          | 36  |
| 2           | Winston | null       | 37  |

-employee_id is the column with unique values for this table.
-This table contains information about the employees and the id of the manager they report to. Some employees do not report to anyone (reports_to is null).

Solution 1
```sql
with conteo as (
select reports_to, count(reports_to) as reports_count, round(avg(age)*1.00) as average_age
from employees
group by reports_to 
having reports_to is not null)
select e.employee_id, e.name, c.reports_count, c.average_age
from employees e
inner join conteo c on e.employee_id = c.reports_to
order by e.employee_id
```

Solution 1
```sql
select e2.employee_id,e2.name, count(e2.employee_id) as reports_count, round(avg(e1.age *1.00),0) as average_age
from employees e1
inner join employees e2 on e1.reports_to = e2.employee_id
group by e2.employee_id,e2.name
order by e2.employee_id asc
```
Output

| employee_id | name  | reports_count | average_age |
|-------------|-------|---------------|-------------|
| 9           | Hercy | 2             | 39          |

***

**Question 32. Primary department for each employee.** Employees can belong to multiple departments. When the employee joins other departments, they need to decide which department is their primary department. Note that when an employee belongs to only one department, their primary column is 'N'.

Write a solution to report all the employees with their primary department. For employees who belong to one department, report their only department.

Employee table:

| employee_id | department_id | primary_flag |
|-------------|---------------|--------------|
| 1           | 1             | N            |
| 2           | 1             | Y            |
| 2           | 2             | N            |
| 3           | 3             | N            |
| 4           | 2             | N            |
| 4           | 3             | Y            |
| 4           | 4             | N            |

Solution:
```sql
SELECT employee_id, department_id
FROM Employee
WHERE primary_flag = 'Y' OR employee_id in (
    SELECT employee_id
    FROM Employee
    GROUP BY employee_id
    HAVING COUNT(*) = 1
)
GROUP BY employee_id
```

Output: 
| employee_id | department_id |
|-------------|---------------|
| 1           | 1             |
| 2           | 1             |
| 3           | 3             |
| 4           | 3             |

Explanation: 
- The Primary department for employee 1 is 1.
- The Primary department for employee 2 is 1.
- The Primary department for employee 3 is 3.
- The Primary department for employee 4 is 3.





