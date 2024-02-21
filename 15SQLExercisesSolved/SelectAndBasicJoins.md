## SQL Exercises. Select and basic Joins

This file contains fifteen solved SQL exercises focusing mainly on SELECT statements and JOINS. Most of the SQL code was executed in MySQL. 

***
**Question 1. Recyclable and low-fat products.** Write a solution to find the ids of products that are both low fat and recyclable. 

Products table:

| product_id  | low_fats | recyclable |
|-------------|----------|------------|
| 0           | Y        | N          |
| 1           | Y        | Y          |
| 2           | N        | Y          |
| 3           | Y        | Y          |
| 4           | N        | N          |

Solution
```sql
SELECT product_id FROM Products
WHERE low_fats LIKE '%Y%' AND recyclable LIKE '%Y%';
```

This one also works
```sql
SELECT product_id FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';
```
Output:
| product_id  |
|-------------|
| 1           |
| 3           |

***
**Question 2. Find customer referee.** Find the names of the customer that are not referred by the customer with id = 2. Return the result table in any order.

Customer table:
| id | name | referee_id |
|----|------|------------|
| 1  | Will | null       |
| 2  | Jane | null       |
| 3  | Alex | 2          |
| 4  | Bill | null       |
| 5  | Zack | 1          |
| 6  | Mark | 2          |


Solution
```sql
SELECT name FROM Customer
WHERE referee_id <> 2 OR referee_id IS NULL;
```
Output: 
| name |
|------|
| Will |
| Jane |
| Bill |
| Zack |

***
**Question 3. Big countries.** Write a solution to find the name, population, and area of the big countries. Return the result table in any order.

A country is big if:
- it has an area of at least three million (i.e., 3000000 km2), or
- it has a population of at least twenty-five million (i.e., 25000000).

World table:
| name        | continent | area    | population | gdp          |
|-------------|-----------|---------|------------|--------------|
| Afghanistan | Asia      | 652230  | 25500100   | 20343000000  |
| Albania     | Europe    | 28748   | 2831741    | 12960000000  |
| Algeria     | Africa    | 2381741 | 37100000   | 188681000000 |
| Andorra     | Europe    | 468     | 78115      | 3712000000   |
| Angola      | Africa    | 1246700 | 20609294   | 100990000000 |

Solution
```sql
SELECT name, population, area  FROM WORLD
WHERE area >= 3000000 OR population >= 25000000;
```

Output: 
| name        | population | area    |
|-------------|------------|---------|
| Afghanistan | 25500100   | 652230  |
| Algeria     | 37100000   | 2381741 |

***
**Question 4. Combine two tables** Write a solution to report the first name, last name, city, and state of each person in the Person table. If the address of a personId is not present in the Address table,
report null instead.

Person table:
| personId | lastName | firstName |
|----------|----------|-----------|
| 1        | Wang     | Allen     |
| 2        | Alice    | Bob       |

Address table:
| addressId | personId | city          | state      |
|-----------|----------|---------------|------------|
| 1         | 2        | New York City | New York   |
| 2         | 3        | Leetcode      | California |

Solution
```sql
SELECT P.firstname, P.lastname, A.city, A.state
FROM Person P
LEFT JOIN Address A ON P.personId = A.personId;
```
Output:
| firstName | lastName | city          | state    |
|-----------|----------|---------------|----------|
| Allen     | Wang     | Null          | Null     |
| Bob       | Alice    | New York City | New York |

***
**Question 5. Articles views I.** Write a solution to find all the authors that viewed at least one of their own articles.

Views table:

| article_id | author_id | viewer_id | view_date  |
|------------|-----------|-----------|------------|
| 1          | 3         | 5         | 2019-08-01 |
| 1          | 3         | 6         | 2019-08-02 |
| 2          | 7         | 7         | 2019-08-01 |
| 2          | 7         | 6         | 2019-08-02 |
| 4          | 7         | 1         | 2019-07-22 |
| 3          | 4         | 4         | 2019-07-21 |
| 3          | 4         | 4         | 2019-07-21 |

Solution
```sql
SELECT DISTINCT author_id AS id FROM Views 
WHERE author_id = viewer_id
ORDER BY author_id ASC;
```
Output: 
| id   |
|------|
| 4    |
| 7    |

***
**Question 6. Invalid Tweets.** Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.

Tweets table:

| tweet_id | content                          |
|----------|----------------------------------|
| 1        | Vote for Biden                   |
| 2        | Let us make America great again! |


Solution
```sql
SELECT tweet_id FROM Tweets 
WHERE LENGTH (content) > 15;
```

Output: 
| tweet_id |
|----------|
| 2        |

***
### Basic Joins
**Question 7. Replace employee ID with the unique identifier.** Write a solution to show the unique ID of each user. If a user does not have a unique ID replace just show null. Return the result table in any order.

Employees table:
| id | name     |
|----|----------|
| 1  | Alice    |
| 7  | Bob      |
| 11 | Meir     |
| 90 | Winston  |
| 3  | Jonathan |

EmployeeUNI table:
| id | unique_id |
|----|-----------|
| 3  | 1         |
| 11 | 2         |
| 90 | 3         |

Solution
```sql
SELECT eu.unique_id, e.name
FROM Employees e 
LEFT JOIN EmployeeUNI eu ON eu.id = e.id;
```
Output:
| unique_id | name     |
|-----------|----------|
| null      | Alice    |
| null      | Bob      |
| 2         | Meir     |
| 3         | Winston  |
| 1         | Jonathan |

***
**Question 8. Product Sales Analysis I.** Write a solution to report the product_name, year, and price for each sale_id in the Sales table. Return the resulting table in any order.

Sales table:
| sale_id | product_id | year | quantity | price |
|---------|------------|------|----------|-------| 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |

Product table:
| product_id | product_name |
|------------|--------------|
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |

Solution:
```sql
SELECT P.product_name, S.year, S.price
FROM  Sales S 
LEFT JOIN Product P ON P.product_id = S.product_id
ORDER BY product_name ASC;
```

Output: 

| product_name | year  | price |
|--------------|-------|-------|
| Nokia        | 2008  | 5000  |
| Nokia        | 2009  | 5000  |
| Apple        | 2011  | 9000  |


***
**Question 9. Customer Who Visited but Did Not Make Any Transactions.** Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits. Return the result table sorted in any order. 

Visits

| visit_id | customer_id |
|----------|-------------|
| 1        | 23          |
| 2        | 9           |
| 4        | 30          |
| 5        | 54          |
| 6        | 96          |
| 7        | 54          |
| 8        | 54          |

Transactions
| transaction_id | visit_id | amount |
|----------------|----------|--------|
| 2              | 5        | 310    |
| 3              | 5        | 300    |
| 9              | 5        | 200    |
| 12             | 1        | 910    |
| 13             | 2        | 970    |

Solution:
```sql
SELECT DISTINCT (V.customer_id), COUNT(V.customer_id) AS count_no_trans
FROM Visits V
LEFT JOIN Transactions T ON V.visit_id = T.visit_id
WHERE T.transaction_id is NULL
GROUP BY V.customer_id 
ORDER BY count_no_trans DESC;
```

Output: 
| customer_id | count_no_trans |
|-------------|----------------|
| 54          | 2              |
| 30          | 1              |
| 96          | 1              |


***
**Question 10. Rising temperature.** Write a solution to find all dates' Id with higher temperatures compared to its previous dates (yesterday). Return the result table in any order.

Weather table:
| id | recordDate | temperature |
|----|------------|-------------|
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |

Solution:
Acá se hace un join a la misma tabla
```sql
SELECT w2.id
FROM Weather w1
JOIN Weather w2
ON DATEDIFF (w1.recordDate, w2.recordDate ) = -1
AND w2.temperature>w1.temperature,
```

Output: 
| id |
|----|
| 2  |
| 4  |


Explanation: 
- In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
- In 2015-01-04, the temperature was higher than the previous day (20 -> 30).

***
**Question 11. Average time of process per machine.** There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.

The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places. Return the result table in any order.

Activity table:
| machine_id | process_id | activity_type | timestamp |
|------------|------------|---------------|-----------|
| 0          | 0          | start         | 0.712     |
| 0          | 0          | end           | 1.520     |
| 0          | 1          | start         | 3.140     |
| 0          | 1          | end           | 4.120     |
| 1          | 0          | start         | 0.550     |
| 1          | 0          | end           | 1.550     |
| 1          | 1          | start         | 0.430     |
| 1          | 1          | end           | 1.420     |
| 2          | 0          | start         | 4.100     |
| 2          | 0          | end           | 4.512     |
| 2          | 1          | start         | 2.500     |
| 2          | 1          | end           | 5.000     |


The table shows the user activities for a factory website.
- (machine_id, process_id, activity_type) is the primary key (combination of columns with unique values) of this table.
- machine_id is the ID of a machine.
- process_id is the ID of a process running on the machine with ID machine_id.
- activity_type is an ENUM (category) of type ('start', 'end').
- timestamp is a float representing the current time in seconds.
- 'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the given timestamp.
- The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.


Solution:
Acá se hace un join a la misma tabla
```sql
select a1.machine_id , ROUND(AVG(a2.timestamp - a1.timestamp),3) as processing_time
from Activity a1
join Activity a2
on a1.process_id=a2.process_id
and a1.machine_id=a2.machine_id
and a1.timestamp<a2.timestamp
group by a1.machine_id;
```


Output: 
| machine_id | processing_time |
|------------|-----------------|
| 0          | 0.894           |
| 1          | 0.995           |
| 2          | 1.456           |


***
**Question 12 Employee bonus.** Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.

Employee table:
| empId | name   | supervisor | salary |
|-------|--------|------------|--------|
| 3     | Brad   | null       | 4000   |
| 1     | John   | 3          | 1000   |
| 2     | Dan    | 3          | 2000   |
| 4     | Thomas | 3          | 4000   |

Bonus table:
| empId | bonus |
|-------|-------|
| 2     | 500   |
| 4     | 2000  |


Solution:
```sql
SELECT E.name, B.bonus 
FROM Employee E
LEFT JOIN Bonus B
ON E.empId = B.empId 
WHERE (B.bonus < 1000 OR B.bonus IS NULL)
```

Output: 
| name | bonus |
|------|-------|
| Brad | null  |
| John | null  |
| Dan  | 500   |

***
**Question 13. Students and examinations.** Write a solution to find the number of times each student attended each exam. Return the result table ordered by student_id and subject_name.

Students table:
| student_id | student_name |
|------------|--------------|
| 1          | Alice        |
| 2          | Bob          |
| 13         | John         |
| 6          | Alex         |

Subjects table:
| subject_name |
|--------------|
| Math         |
| Physics      |
| Programming  |

Examinations table:
| student_id | subject_name |
|------------|--------------|
| 1          | Math         |
| 1          | Physics      |
| 1          | Programming  |
| 2          | Programming  |
| 1          | Physics      |
| 1          | Math         |
| 13         | Math         |
| 13         | Programming  |
| 13         | Physics      |
| 2          | Math         |
| 1          | Math         |

Solution:
```sql
select s.student_id, student_name, su.subject_name, count(e.subject_name) as attended_exams 
from Students s 
join Subjects su 
left join Examinations e 
on s.student_id = e.student_id and su.subject_name = e.subject_name 
group by s.student_id, su.subject_name 
order by s.student_id
```

Output: 
| student_id | student_name | subject_name | attended_exams |
|------------|--------------|--------------|----------------|
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |


***
**Question 14. Managers with at least 5 direct reports.** Write a solution to find managers with at least five direct reports. Return the result table in any order. 

Employee table:

| id  | name  | department | managerId |
|-----|-------|------------|-----------|
| 101 | John  | A          | null      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |

Solution 1:
```sql
WITH aux AS (
SELECT managerId, COUNT (managerId) FROM Employee
group by managerId
having COUNT (managerId)>=5
)
select name from Employee
where id in (select managerId from aux)
```

Solution 2:
```sql
SELECT e1.name
FROM employee e1
LEFT JOIN employee e2 ON e1.id=e2.managerId
GROUP BY e1.id
HAVING COUNT (e2.name) >= 5
```

Output: 
| name |
|------|
| John |


***
**Question 15. Confirmation rate.** Write a solution to find the confirmation rate of each user. Return the result table in any order.

The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.


Signups table:
| user_id | time_stamp          |
|---------|---------------------|
| 3       | 2020-03-21 10:16:13 |
| 7       | 2020-01-04 13:57:59 |
| 2       | 2020-07-29 23:09:44 |
| 6       | 2020-12-09 10:39:37 |

Confirmations table:
| user_id | time_stamp          | action    |
|---------|---------------------|-----------|
| 3       | 2021-01-06 03:30:46 | timeout   |
| 3       | 2021-07-14 14:00:00 | timeout   |
| 7       | 2021-06-12 11:57:29 | confirmed |
| 7       | 2021-06-13 12:58:28 | confirmed |
| 7       | 2021-06-14 13:59:27 | confirmed |
| 2       | 2021-01-22 00:00:00 | confirmed |
| 2       | 2021-02-28 23:59:59 | timeout   |

Solution:
```sql
select s.user_id, avg(if(c.action="confirmed",1,0)) as confirmation_rate
from Signups as s 
left join Confirmations as c on s.user_id= c.user_id 
group by user_id;
```

Output: 
| user_id | confirmation_rate |
|---------|-------------------|
| 6       | 0.00              |
| 3       | 0.00              |
| 7       | 1.00              |
| 2       | 0.50              |


Explanation: 
- User 6 did not request any confirmation messages. The confirmation rate is 0.
- User 3 made 2 requests and both timed out. The confirmation rate is 0.
- User 7 made 3 requests and all were confirmed. The confirmation rate is 1.
- User 2 made 2 requests where one was confirmed and the other timed out. The confirmation rate is 1 / 2 = 0.5.
