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
  - To get the remaining string we can use SUBSTR(name,2). Length is not required here.
- CONCAT(A,B) where we concat two strings A+B


Output: 

| user_id | name  |
|---------|-------|
| 1       | Alice |
| 2       | Bob   |

***
**Question 39. Patients with a condition.** Write a solution to find the patient_id, patient_name and conditions of the patients who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix.

Input: 
Patients table:
| patient_id | patient_name | conditions   |
|------------|--------------|--------------|
| 1          | Daniel       | YFEV COUGH   |
| 2          | Alice        |              |
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 |
| 5          | Alain        | DIAB201      |


Solution 1:
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


Input: 
Person table:
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+

Output: 
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
Explanation: john@example.com is repeated two times. We keep the row with the smallest Id = 1.





