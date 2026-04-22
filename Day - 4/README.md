\# SQL Practice: Most Visited Floor and Resource Usage Analysis



\## 📌 Problem Statement



Given an `entries` table that tracks employee visits to different floors along with resources used, write a query to:



1\. Find the \*\*most visited floor\*\* for each person

2\. Calculate the \*\*total number of visits\*\* per person

3\. List all \*\*unique resources used\*\* by each person



\---



\## 🧱 Table Structure



```sql

CREATE TABLE entries ( 

&#x20;   name VARCHAR(20),

&#x20;   address VARCHAR(20),

&#x20;   email VARCHAR(20),

&#x20;   floor INT,

&#x20;   resources VARCHAR(10)

);

```



\---



\## 📥 Sample Data



```sql

INSERT INTO entries VALUES 

('A','Bangalore','A@gmail.com',1,'CPU'),

('A','Bangalore','A1@gmail.com',1,'CPU'),

('A','Bangalore','A2@gmail.com',2,'DESKTOP'),

('B','Bangalore','B@gmail.com',2,'DESKTOP'),

('B','Bangalore','B1@gmail.com',2,'DESKTOP'),

('B','Bangalore','B2@gmail.com',1,'MONITOR');

```



\---



\## 🔍 Approach



We solve this using \*\*multiple CTEs\*\*, each handling a specific step.



\---



\## ✅ SQL Query (With Comments)



```sql

WITH a AS (

&#x20;   -- Step 1: Count number of visits per person per floor

&#x20;   SELECT 

&#x20;       name, 

&#x20;       floor, 

&#x20;       COUNT(\*) AS ct

&#x20;   FROM entries

&#x20;   GROUP BY name, floor

),



b AS (

&#x20;   -- Step 2:

&#x20;   -- 1. Rank floors per person based on visit count (highest first)

&#x20;   -- 2. Calculate total visits per person

&#x20;   SELECT 

&#x20;       \*,

&#x20;       DENSE\_RANK() OVER (

&#x20;           PARTITION BY name 

&#x20;           ORDER BY ct DESC

&#x20;       ) AS r,

&#x20;       SUM(ct) OVER (

&#x20;           PARTITION BY name

&#x20;       ) AS total\_visit

&#x20;   FROM a

),



c AS (

&#x20;   -- Step 3: Keep only the most visited floor(s)

&#x20;   -- (handles ties using DENSE\_RANK)

&#x20;   SELECT 

&#x20;       name, 

&#x20;       floor, 

&#x20;       total\_visit

&#x20;   FROM b

&#x20;   WHERE r = 1

),



d AS (

&#x20;   -- Step 4: Aggregate all unique resources used per person

&#x20;   SELECT 

&#x20;       name, 

&#x20;       STRING\_AGG(DISTINCT resources, ',') AS resources\_used

&#x20;   FROM entries

&#x20;   GROUP BY name

)



\-- Final Step: Combine results

SELECT 

&#x20;   c.name, 

&#x20;   c.floor AS most\_visited\_floor, 

&#x20;   c.total\_visit AS total\_visits, 

&#x20;   d.resources\_used

FROM c

LEFT JOIN d

&#x20;   ON c.name = d.name;

```



\---



\## 📊 Explanation



\### 🔹 Step 1: Visit Count per Floor



We group by `name` and `floor` to count how many times each person visited each floor.



\---



\### 🔹 Step 2: Ranking + Total Visits



We use window functions:



\* `DENSE\_RANK()`

&#x20; → Finds most visited floor per person

\* `SUM() OVER()`

&#x20; → Calculates total visits per person



\---



\### 🔹 Step 3: Filter Top Floors



We select only rows where:



```sql

r = 1

```



This ensures:



\* Only the \*\*most visited floor(s)\*\* are returned

\* Handles ties correctly



\---



\### 🔹 Step 4: Resource Aggregation



We use:



```sql

STRING\_AGG(DISTINCT resources, ',')

```



This:



\* Removes duplicates

\* Combines all resources into a single string



\---



\## 📈 Sample Output



| name | most\_visited\_floor | total\_visits | resources\_used  |

| ---- | ------------------ | ------------ | --------------- |

| A    | 1                  | 3            | CPU,DESKTOP     |

| B    | 2                  | 3            | DESKTOP,MONITOR |



\---



\## 💡 Key Concepts Used



\* Common Table Expressions (CTEs)

\* Window Functions (`DENSE\_RANK`, `SUM OVER`)

\* Aggregation (`COUNT`, `STRING\_AGG`)

\* Handling ties in ranking

\* Multi-step query structuring



\---



\## 🎯 Why This Matters



This pattern is widely used in:



\* User behavior analytics

\* Office/resource tracking systems

\* Data warehouse transformations

\* SQL interviews (very high value 🔥)



\---



\## 🚀 How to Run



1\. Create the table

2\. Insert sample data

3\. Execute the query



\---



\## 📁 Suggested Repo Structure



```

sql-practice/

│

├── entries\_analysis.sql

└── README.md

```



\---



\## 🧠 Learning Outcome



After this problem, you should understand:



\* How to break complex problems into steps using CTEs

\* How to use window functions for ranking and totals

\* How to combine multiple transformations into a final result



\---

