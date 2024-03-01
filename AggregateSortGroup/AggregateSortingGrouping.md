## SQL Exercises. Aggregate basic functions, Sorting and Grouping

This file contains fifteen solved SQL exercises focusing mainly on Aggregate basic functions, Sorting and Grouping. Most of the SQL code was executed in MySQL. 

***

**Question 16. Not boring movies.** Write a solution to report the movies with an odd-numbered ID and a description that is not "boring". Return the result table ordered by rating in descending order. The result format is in the following example.

Cinema table:

| id | movie      | description | rating |
|----|------------|-------------|--------|
| 1  | War        | great 3D    | 8.9    |
| 2  | Science    | fiction     | 8.5    |
| 3  | irish      | boring      | 6.2    |
| 4  | Ice song   | Fantacy     | 8.6    |
| 5  | House card | Interesting | 9.1    |

Solution 1
```sql
SELECT * FROM Cinema
WHERE MOD (id, 2) <> 0 AND description not like "%boring%"
order by rating desc
```

Solution 2
```sql
SELECT * FROM Cinema
WHERE MOD( id, 2) = 1 AND description <> 'boring' 
ORDER BY rating DESC;
```

Output: 

| id | movie      | description | rating |
|----|------------|-------------|--------|
| 5  | House card | Interesting | 9.1    |
| 1  | War        | great 3D    | 8.9    |

***
**Question 17. Average selling price.** Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places. Return the result table in any order.

Prices table:
| product_id | start_date | end_date   | price  |
|------------|------------|------------|--------|
| 1          | 2019-02-17 | 2019-02-28 | 5      |
| 1          | 2019-03-01 | 2019-03-22 | 20     |
| 2          | 2019-02-01 | 2019-02-20 | 15     |
| 2          | 2019-02-21 | 2019-03-31 | 30     |

(product_id, start_date, end_date) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates the price of the product_id in the period from start_date to end_date.
For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.

UnitsSold table:
| product_id | purchase_date | units |
|------------|---------------|-------|
| 1          | 2019-02-25    | 100   |
| 1          | 2019-03-01    | 15    |
| 2          | 2019-02-10    | 200   |
| 2          | 2019-03-22    | 30    |


This table may contain duplicate rows.
Each row of this table indicates the date, units, and product_id of each product sold. 

Solution

```sql
select p.product_id, round (sum(p.price*u.units)/sum(units), 2) as average_price
from Prices p
left join UnitsSold u 
on p.product_id = u.product_id and u.purchase_date between p.start_date and p.end_date
group by p.product_id
```

Output: 
| product_id | average_price |
|------------|---------------|
| 1          | 6.96          |
| 2          | 16.96         |

Average selling price = Total Price of Product / Number of products sold.

Average selling price for product 1 = ((100 * 5) + (15 * 20)) / 115 = 6.96

Average selling price for product 2 = ((200 * 15) + (30 * 30)) / 230 = 16.96
***

**Question 18. Project employees I.** Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits. Return the result table in any order.

Project table:
| project_id  | employee_id |
|-------------|-------------|
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |

Employee table:
| employee_id | name   | experience_years |
|-------------|--------|------------------|
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 1                |
| 4           | Doe    | 2                |


Solution
```sql
select P.project_id, round(sum(E.experience_years)/count(P.project_id), 2) as average_years
from Employee E
left join Project P on P.employee_id = E.employee_id
group by P.project_id
```

Output: 
| project_id  | average_years |
|-------------|---------------|
| 1           | 2.00          |
| 2           | 2.50          |

The average experience years for the first project is (3 + 2 + 1) / 3 = 2.00 and for the second project is (3 + 2) / 2 = 2.50
***

**Question 19. Percentage of users attended a contest.** Write a solution to find the percentage of the users registered in each contest rounded to two decimals. Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

Users table:

| user_id | user_name |
|---------|-----------|
| 6       | Alice     |
| 2       | Bob       |
| 7       | Alex      |


Register table:
| contest_id | user_id |
|------------|---------|
| 215        | 6       |
| 209        | 2       |
| 208        | 2       |
| 210        | 6       |
| 208        | 6       |
| 209        | 7       |
| 209        | 6       |
| 215        | 7       |
| 208        | 7       |
| 210        | 2       |
| 207        | 2       |
| 210        | 7       |


Solution
```sql
select contest_id, round(count(contest_id)/(select count(distinct user_id) from Users) *100 , 2) as percentage
from Register
group by contest_id
order by percentage desc, contest_id
```

Output: 
| contest_id | percentage |
|------------|------------|
| 208        | 100.0      |
| 209        | 100.0      |
| 210        | 100.0      |
| 215        | 66.67      |
| 207        | 33.33      |

All the users registered in contests 208, 209, and 210. The percentage is 100% and we sort them in the answer table by contest_id in ascending order.
Alice and Alex registered in contest 215 and the percentage is ((2/3) * 100) = 66.67%
Bob registered in contest 207 and the percentage is ((1/3) * 100) = 33.33%
***

**Question 20. Queries quality and percentage.** Write a solution to find each query_name, the quality and poor_query_percentage. Both quality and poor_query_percentage should be rounded to 2 decimal places. Return the result table in any order.

We define query quality as: The average of the ratio between query rating and its position.

We also define poor query percentage as: The percentage of all queries with rating less than 3.


Queries table:

| query_name | result            | position | rating |
|------------|-------------------|----------|--------|
| Dog        | Golden Retriever  | 1        | 5      |
| Dog        | German Shepherd   | 2        | 5      |
| Dog        | Mule              | 200      | 1      |
| Cat        | Shirazi           | 5        | 2      |
| Cat        | Siamese           | 3        | 3      |
| Cat        | Sphynx            | 7        | 4      |


Solution
```sql
select query_name, round(avg(rating/position), 2) as quality,
round(SUM(IF(rating < 3, 1, 0)) / COUNT(*) * 100, 2) as poor_query_percentage  
from Queries
group by query_name
```

Output: 
| query_name | quality | poor_query_percentage |
|------------|---------|-----------------------|
| Dog        | 2.50    | 33.33                 |
| Cat        | 0.66    | 33.33                 |


Dog queries quality is ((5 / 1) + (5 / 2) + (1 / 200)) / 3 = 2.50
Dog queries poor_ query_percentage is (1 / 3) * 100 = 33.33

Cat queries quality equals ((2 / 5) + (3 / 3) + (4 / 7)) / 3 = 0.66
Cat queries poor_ query_percentage is (1 / 3) * 100 = 33.33

***
**Question 21. Monthly transactions I.** Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount. Return the result table in any order.

Transactions table:
| id   | country | state    | amount | trans_date |
|------|---------|----------|--------|------------|
| 121  | US      | approved | 1000   | 2018-12-18 |
| 122  | US      | declined | 2000   | 2018-12-19 |
| 123  | US      | approved | 2000   | 2019-01-01 |
| 124  | DE      | approved | 2000   | 2019-01-07 |

Solution  1
```sql
select substr(trans_date,1,7) as month, country, count(*) as trans_count,
sum(if (state="approved",1,0)) as approved_count,
sum(amount) as trans_total_amount,
sum(if (state="approved",amount,0)) as approved_total_amount
from Transactions
group by month, country
```

Solution 2:
```sql
select substr(trans_date,1,7) as month, country, count(id) as trans_count,
sum(case when state = 'approved' then 1 else 0 END) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state = 'approved' then amount else 0 END) as approved_total_amount
from Transactions
group by month, country
```

Output: 

| month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
|----------|---------|-------------|----------------|--------------------|-----------------------|
| 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |

***
**Question 22. Immediate food delivery II.** If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.

The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.

Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

Delivery table:

| delivery_id | customer_id | order_date | customer_pref_delivery_date |
|-------------|-------------|------------|-----------------------------|
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 2           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-12                  |
| 4           | 3           | 2019-08-24 | 2019-08-24                  |
| 5           | 3           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
| 7           | 4           | 2019-08-09 | 2019-08-09                  |


delivery_id is the column of unique values of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).


Solución bacana

```sql
Select 
    round(avg(order_date = customer_pref_delivery_date)*100, 2) as immediate_percentage
from Delivery
where (customer_id, order_date) in (
  Select customer_id, min(order_date) 
  from Delivery
  group by customer_id)
```

Output: 

| immediate_percentage |
|----------------------|
| 50.00                |

- The customer id 1 has a first order with delivery id 1 and it is scheduled.
- The customer id 2 has a first order with delivery id 2 and it is immediate.
- The customer id 3 has a first order with delivery id 5 and it is scheduled.
- The customer id 4 has a first order with delivery id 7 and it is immediate.

Hence, half the customers have immediate first orders.

***
**Question 23. Game play analysis IV.** Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.


Activity table:

| player_id | device_id | event_date | games_played |
|-----------|-----------|------------|--------------|
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |


Approach

1.We want to calculate the fraction of players who logged in again on the day after their first login. To do this, we need to count two things: the number of players who logged in on consecutive days and the total number of players.

2. To count the number of players who logged in on consecutive days, we need to find the first login date for each player and check if there is a login on the day after their first login.

3. We use a subquery to calculate the total number of distinct players in the Activity table. This gives us the denominator for calculating the fraction.

4. In the main query, we filter the rows where the player's ID and the date of the event (after subtracting 1 day) match the player's first login date. This ensures that we only consider players who logged in on consecutive days.

5. We then count the distinct player IDs in the filtered rows to get the numerator for calculating the fraction.

6. Finally, we divide the numerator by the denominator and round the result to 2 decimal places using the ROUND function.


Solution

```sql
SELECT
  ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM
  Activity
WHERE
  (player_id, DATE_SUB(event_date, INTERVAL 1 DAY))
  IN (
    SELECT player_id, MIN(event_date) AS first_login FROM Activity GROUP BY player_id)
```

Output: 

| fraction  |
|-----------|
| 0.33      |

Explanation: 
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33

***

**SORTING AND GROUPING**

**Question 24. Number of unique subjects taught by each teacher.** Write a solution to calculate the number of unique subjects each teacher teaches in the university. Return the result table in any order.


Teacher table:
| teacher_id | subject_id | dept_id |
|------------|------------|---------|
| 1          | 2          | 3       |
| 1          | 2          | 4       |
| 1          | 3          | 3       |
| 2          | 1          | 1       |
| 2          | 2          | 1       |
| 2          | 3          | 1       |
| 2          | 4          | 1       |


Solution
```sql
SELECT teacher_id, COUNT(DISTINCT subject_id) as cnt
FROM Teacher
GROUP BY teacher_id;
```

Output:  

| teacher_id | cnt |
|------------|-----|
| 1          | 2   |
| 2          | 4   |

Explanation: 
Teacher 1:
  - They teach subject 2 in departments 3 and 4.
  - They teach subject 3 in department 3.
Teacher 2:
  - They teach subject 1 in department 1.
  - They teach subject 2 in department 1.
  - They teach subject 3 in department 1.
  - They teach subject 4 in department 1.

***
**Question 25. User activity for the past 30 days I.** Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on someday if they made at least one activity on that day. Return the result table in any order.


Input: 
Activity table:
| user_id | session_id | activity_date | activity_type |
|---------|------------|---------------|---------------|
| 1       | 1          | 2019-07-20    | open_session  |
| 1       | 1          | 2019-07-20    | scroll_down   |
| 1       | 1          | 2019-07-20    | end_session   |
| 2       | 4          | 2019-07-20    | open_session  |
| 2       | 4          | 2019-07-21    | send_message  |
| 2       | 4          | 2019-07-21    | end_session   |
| 3       | 2          | 2019-07-21    | open_session  |
| 3       | 2          | 2019-07-21    | send_message  |
| 3       | 2          | 2019-07-21    | end_session   |
| 4       | 3          | 2019-06-25    | open_session  |
| 4       | 3          | 2019-06-25    | end_session   |

- This table may have duplicate rows.
- The activity_type column is an ENUM (category) of type ('open_session', 'end_session', 'scroll_down', 'send_message').
- The table shows the user activities for a social media website. 
- Note that each session belongs to exactly one user.

Solution
```sql
SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date;
```

Se coloca la primera fecha desde el 28 de junio ya que de allí hasta el 27 de julio hay 30 días, que es como pide el ejercicio.

Another way:

```sql
SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE (activity_date > "2019-06-27" AND activity_date <= "2019-07-27");
```


Output: 
| day        | active_users |
|------------|--------------| 
| 2019-07-20 | 2            |
| 2019-07-21 | 2            |
 
Explanation: Note that we do not care about days with zero active users.
