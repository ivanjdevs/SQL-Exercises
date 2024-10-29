## SQL Exercises. String functions.Regex 

This file contains a some SQL exercises focusing mainly on string functions. Most of the SQL code was executed in MySQL.

***

**Question 38. Fix names in a table.** Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase. Return the result table ordered by user_id.

Input: 
Users table:

| user_id | name  |
|---------|-------|
| 1       | aLice |
| 2       | bOB   |


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
 - To get the remaining string we can use SUBSTR(name,2) // length is not required here
- CONCAT(A,B) where we concat two strings A+B


Output: 

| user_id | name  |
|---------|-------|
| 1       | Alice |
| 2       | Bob   |
