# SQL Practice - Day 08

## Problem Statement

Given two tables:

* Person: contains user details and their scores
* Friend: represents friendship relationships

Write a SQL query to:

* Calculate the total score of all friends for each person
* Return only those persons whose total friend score is greater than 100

---

## Database Schema

### Person Table

```sql
CREATE TABLE person (
    PersonID INT,
    Name VARCHAR(50),
    Score INT
);
```

### Friend Table

```sql
CREATE TABLE friend (
    pid INT,
    fid INT
);
```

---

## Sample Data

### Person

```sql
INSERT INTO person VALUES
(1,'Alice',88),
(2,'Bob',11),
(3,'Devis',27),
(4,'Tara',45),
(5,'John',63);
```

### Friend

```sql
INSERT INTO friend VALUES
(1,2),
(1,3),
(2,1),
(2,3),
(3,5),
(4,2),
(4,3),
(4,5);
```

---

## Approach

1. Join Friend with Person using fid to get friend scores
2. Use a CTE to store this intermediate result
3. Join again using pid to get person name
4. Aggregate using SUM(score)
5. Filter using HAVING > 100

---

## SQL Solution

```sql
WITH a AS (
    SELECT 
        f.pid,
        f.fid,
        p.name,
        p.score
    FROM friend f
    LEFT JOIN person p
        ON f.fid = p.PersonID
)

SELECT 
    a.pid,
    p.name,
    SUM(a.score) AS total_sum
FROM a
LEFT JOIN person p
    ON a.pid = p.PersonID
GROUP BY 
    a.pid, 
    p.name
HAVING 
    SUM(a.score) > 100;
```

---

## Output

| pid | name | total_sum |
| --- | ---- | --------- |
| 4   | Tara | 101       |

---

## Key Learnings

* Use of CTE for readability
* Self join pattern using relationship table
* GROUP BY with aggregation
* HAVING for filtering aggregated results

---

## Author

Pavan Kumar
