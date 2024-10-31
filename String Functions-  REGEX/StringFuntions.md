## SQL Exercises. String functions.

This file contains a some SQL exercises focusing mainly on string functions. Most of the SQL code was executed in MySQL.

***
**Question 38. Fix names in a table.** Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase. Return the result table ordered by user_id.

Users table:

| user_id | name  |
|---------|-------|
| 1       | aLice |
| 2       | bOB   |

Solution:
```sql
select user_id, CONCAT(UPPER(SUBSTRING(name, 1, 1)), LOWER(SUBSTRING(name, 2))) as name
from Users
order by user_id;
```

Explanation of the string functions:

- UPPER(A) where A is string
- LOWER(A) where A is string
- SUBSTR(A,index,length) where A is string; index is nn integer indicating a string position within the string A; and length is an integer indicating a number of characters to be returned (optional).
  - So to get first letter we can use SUBSTR(name,1,1)
  - To get the remaining string we can use SUBSTR(name,2). Length is not required here.
- CONCAT(A,B) where we concat two strings A+B

Output: 
| user_id | name  |
|---------|-------|
| 1       | Alice |
| 2       | Bob   |

***
**Question 39. Patients with a condition.** Write a solution to find the patient_id, patient_name and conditions of the patients who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix.

Patients table:
| patient_id | patient_name | conditions   |
|------------|--------------|--------------|
| 1          | Daniel       | YFEV COUGH   |
| 2          | Alice        |              |
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 |
| 5          | Alain        | DIAB201      |


Solution:
```sql
select patient_id, patient_name, conditions from patients
where conditions like 'DIAB1%' or conditions like '% DIAB1%'
```

Output: 
| patient_id | patient_name | conditions   |
|------------|--------------|--------------|
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 | 

- Explanation: Bob and George both have a condition that starts with DIAB1.

***
**Question 40. Delete duplicate emails.** Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id. Note that you are supposed to  write a DELETE statement and not a SELECT one. 

Person table:

| id | email            |
|----|------------------|
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |


Solution:
```sql
DELETE FROM Person 
WHERE id IN (
    SELECT a.id
    FROM (
        SELECT id, email,
               ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS rn
        FROM Person
    ) a
    WHERE a.rn > 1
);
```

Output: 
| id | email            |
|----|------------------|
| 1  | john@example.com |
| 2  | bob@example.com  |

Explanation: john@example.com is repeated two times. We keep the row with the smallest Id = 1.


***
**Question 41. Second highest salaries.** Write a solution to find the second highest distinct salary from the employee table. If there is no second highest salary, return null.

Employee table:

| id | salary |
|----|--------|
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |

Solution:
```sql
select (
select distinct Salary
from Employee order by salary desc 
limit 1 offset 1)
as SecondHighestSalary;
```
Output: 
| SecondHighestSalary |
|---------------------|
| 200                 |

Example 2:
 
Employee table:

| id | salary |
|----|--------|
| 1  | 100    |

Output: 

| SecondHighestSalary |
|---------------------|
| null                |

***
**Question 42. Group sold products by date.** Write a solution to find for each date the number of different products sold and their names. The sold products names for each date should be sorted lexicographically. Return the result table ordered by sell_date.
 
Activities table:

| sell_date  | product    |
|------------|------------|
| 2020-05-30 | Headphone  |
| 2020-06-01 | Pencil     |
| 2020-06-02 | Mask       |
| 2020-05-30 | Basketball |
| 2020-06-01 | Bible      |
| 2020-06-02 | Mask       |
| 2020-05-30 | T-Shirt    |

Solution:
```sql
select sell_date, count(distinct product) as num_sold, group_concat(distinct product order by product) as products
from Activities
group by sell_date
order by sell_date
```

Output: 
| sell_date  | num_sold | products                     |
|------------|----------|------------------------------|
| 2020-05-30 | 3        | Basketball,Headphone,T-shirt |
| 2020-06-01 | 2        | Bible,Pencil                 |
| 2020-06-02 | 1        | Mask                         |


***
**Question 43. List products ordered in a period.** Write a solution to get the names of products at least 100 units ordered in February 2020 and their count. Return the result table in any order.

Products table:
| product_id  | product_name          | product_category |
|-------------|-----------------------|------------------|
| 1           | Leetcode Solutions    | Book             |
| 2           | Jewels of Stringology | Book             |
| 3           | HP                    | Laptop           |
| 4           | Lenovo                | Laptop           |
| 5           | Leetcode Kit          | T-shirt          |


Orders table:
| product_id   | order_date   | unit     |
|--------------|--------------|----------|
| 1            | 2020-02-05   | 60       |
| 1            | 2020-02-10   | 70       |
| 2            | 2020-01-18   | 30       |
| 2            | 2020-02-11   | 80       |
| 3            | 2020-02-17   | 2        |
| 3            | 2020-02-24   | 3        |
| 4            | 2020-03-01   | 20       |
| 4            | 2020-03-04   | 30       |
| 4            | 2020-03-04   | 60       |
| 5            | 2020-02-25   | 50       |
| 5            | 2020-02-27   | 50       |
| 5            | 2020-03-01   | 50       |

Solution:
```sql
select p.product_name, sum(o.unit) as unit
from products p
left join orders o on p.product_id=o.product_id
where (select substr(o.order_date,1,7)) = '2020-02' 
group by p.product_name
having sum(o.unit) >=100;
```

Output: 
| product_name       | unit    |
|--------------------|---------|
| Leetcode Solutions | 130     |
| Leetcode Kit       | 100     |


***
**Question 44. Find users with valid e-mails.** Write a solution to find the users who have valid emails. A valid e-mail has a prefix name and a domain where:

- The prefix name is a string that may contain letters (upper or lower case), digits, underscore '_', period '.' and/or dash '-'. The prefix name must start with a letter.
- The domain name is @leetcode.com

Return the table in any order.

Users table:
| user_id | name      | mail                    |
|---------|-----------|-------------------------|
| 1       | Winston   | winston@leetcode.com    |
| 2       | Jonathan  | jonathanisgreat         |
| 3       | Annabelle | bella-@leetcode.com     |
| 4       | Sally     | sally.come@leetcode.com |
| 5       | Marwan    | quarz#2020@leetcode.com |
| 6       | David     | david69@gmail.com       |
| 7       | Shapiro   | .shapo@leetcode.com     |

Solution
```sql
select * from users
where mail regexp '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode[.]com$'
```

Output: 
| user_id | name      | mail                    |
|---------|-----------|-------------------------|
| 1       | Winston   | winston@leetcode.com    |
| 3       | Annabelle | bella-@leetcode.com     |
| 4       | Sally     | sally.come@leetcode.com |

Explanation: 
- The mail of user 2 does not have a domain.
- The mail of user 5 has the # sign which is not allowed.
- The mail of user 6 does not have the leetcode domain.
- The mail of user 7 starts with a period.




































