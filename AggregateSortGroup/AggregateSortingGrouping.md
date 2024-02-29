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