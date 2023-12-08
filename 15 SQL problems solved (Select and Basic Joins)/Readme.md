## SQL Exercises. Select and basic Joins

This file contains fifteen solved SQL exercises focusing mainly on SELECT statements and JOINS. Most of the SQL code was executed in MySQL. 

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

### Basic Joins
**Question 7. Replace employee ID with the unique identifier.** Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null. Return the result table in any order.

