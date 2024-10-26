## SQL Exercises. Intermediate Select and Join exercises

This file contains a few solved SQL exercises focusing mainly on Select and Join instructions. Most of the SQL code was executed in MySQL.

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

Solution 2
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

Solution 1:
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

Solution 2:
```sql
with conteo as (
select employee_id, count(department_id) as cant
from employee
group by employee_id)
select c.employee_id, e.department_id
from conteo c
left join employee e on c.employee_id = e.employee_id
where (c.cant > 1 and e.primary_flag='Y') or cant=1 
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


***

**Question 33. Triangle judgement.** Report for every theree line segments whether they can form a triangle. Retunr the reault table in any orde..


| Column Name | Type |
|-------------|------|
| x           | int  |
| y           | int  |
| z           | int  |

In SQL, (x, y, z) is the primary key column for this table.
Each row of this table contains the lengths of three line segments.

Input: 
Triangle table:

| x  | y  | z  |
|----|----|----|
| 13 | 15 | 30 |
| 10 | 20 | 15 |


Solution:
```sql
Usamos la formula del semiperímetro.
select x,y,z, case 
when ((x+y+z)/2)> x and ((x+y+z)/2)>y and ((x+y+z)/2)>z then 'Yes'
else 'No'
end as 'triangle'
from triangle;
```

Output:
| x  | y  | z  | triangle |
|----|----|----|----------|
| 13 | 15 | 30 | No       |
| 10 | 20 | 15 | Yes      |

***
**Question 34. Consecutive numbers.** Find all numbers that appear at least three times consecutively. Return the result table in any order.

Logs table:

| id | num |
|----|-----|
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |


Solution:
```sql
with aux1 as (select *, rank() over (partition by num order by id) as rankeo
from logs),
aux2 as (
    select *, cast(id as signed) - cast(rankeo as signed) as resta
    from aux1   
)
select distinct num as ConsecutiveNums 
from aux2
group by num, resta
having count(resta)>=3
```
Output:
| ConsecutiveNums |
|-----------------|
| 1               |

***
**Question 35. Product price at a given date.** Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10. Return the table in any order.


Products table:
| product_id | new_price | change_date |
|------------|-----------|-------------|
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |


Solution:
```sql
select product_id, new_price as price
from products
where (product_id, change_date) in 
(
select product_id, max(change_date)
from products
where change_date <='2019-08-16'
group by product_id ) 
union
select product_id, 10 as price
from products
where product_id  not in
(select distinct product_id 
from products
where change_date<='2019-08-16')
```

Output: 
| product_id | price |
|------------|-------|
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |


***
**Question 36. Product price at a given date.** There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.

Write a solution to find the person_name of the last person that can fit on the bus without exceeding the weight limit. The test cases are generated such that the first person does not exceed the weight limit.

Input: 
Queue table:
| person_id | person_name | weight | turn |
|-----------|-------------|--------|------|
| 5         | Alice       | 250    | 1    |
| 4         | Bob         | 175    | 5    |
| 3         | Alex        | 350    | 2    |
| 6         | John Cena   | 400    | 3    |
| 1         | Winston     | 500    | 6    |
| 2         | Marie       | 200    | 4    |


Solution:
```sql
select  q1.person_name
from queue q1
left join queue q2 on q1.turn >= q2.turn
group by q1.turn
having sum(q2.weight)<=1000
ORDER BY SUM(q2.weight) DESC
limit 1;
```

Output: 
| person_name |
|-------------|
| John Cena   |


Explanation: The folowing table is ordered by the turn for simplicity.

| Turn | ID | Name      | Weight | Total Weight |                            
|------|----|-----------|--------|--------------|                             
| 1    | 5  | Alice     | 250    | 250          |
| 2    | 3  | Alex      | 350    | 600          |
| 3    | 6  | John Cena | 400    | 1000 (last person to board) | 
| 4    | 2  | Marie     | 200    | 1200 (cannot board)        | 
| 5    | 4  | Bob       | 175    | ___          |
| 6    | 1  | Winston   | 500    | ___          |


***
**Question 37. Count salary categories.** Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:

- "Low Salary": All the salaries strictly less than $20000.
- "Average Salary": All the salaries in the inclusive range [$20000, $50000].
- "High Salary": All the salaries strictly greater than $50000.
- The result table must contain all three categories. If there are no accounts in a category, return 0.

Return the result table in any order.

Input: 
Accounts table:

| account_id | income |
|------------|--------|
| 3          | 108939 |
| 2          | 12747  |
| 8          | 87709  |
| 6          | 91796  |


Solution:
```sql
select 'Low Salary' as category,
sum(income <20000) as accounts_count
from accounts
union
select 'Average Salary' as category,
sum(income  >=20000 and income <= 50000) as accounts_count
from accounts
union
select 'High Salary' as category,
sum(income > 50000) as account_count
from accounts
order by accounts_count desc
```

Output: 

| category       | accounts_count |
|----------------|----------------|
| Low Salary     | 1              |
| Average Salary | 0              |
| High Salary    | 3              |

Explanation: 
- Low Salary: Account 2.
- Average Salary: No accounts.
- High Salary: Accounts 3, 6, and 8.
