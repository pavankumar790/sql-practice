\# SQL Practice: Pivot and Unpivot Employee Compensation Data



\## 📌 Problem Statement



Given a table where employee compensation details are stored in \*\*row format\*\* (salary, bonus, hike % as separate rows), transform the data into:



1\. \*\*Pivoted format\*\* (columns for salary, bonus, hike %)

2\. Then convert it back into \*\*row format (unpivoted)\*\*



\---



\## 🧱 Table Structure



```sql

CREATE TABLE emp\_compensation (

&#x20;   emp\_id INT,

&#x20;   salary\_component\_type VARCHAR(20),

&#x20;   val INT

);

```



\---



\## 📥 Sample Data



```sql

INSERT INTO emp\_compensation VALUES 

(1,'salary',10000),

(1,'bonus',5000),

(1,'hike\_percent',10),

(2,'salary',15000),

(2,'bonus',7000),

(2,'hike\_percent',8),

(3,'salary',12000),

(3,'bonus',6000),

(3,'hike\_percent',7);

```



\---



\## 🔍 Approach



\### Step 1: Pivot the Data



Convert rows into columns using `CASE WHEN` + `SUM`.



\### Step 2: Unpivot the Data



Convert columns back into rows using `UNION ALL`.



\---



\## ✅ SQL Query (With Comments)



```sql

\-- Step 1: Pivot the data (rows → columns)

WITH a AS (

&#x20;   SELECT 

&#x20;       emp\_id,



&#x20;       -- Extract salary values into a column

&#x20;       SUM(CASE 

&#x20;           WHEN salary\_component\_type = 'salary' 

&#x20;           THEN val 

&#x20;           ELSE NULL 

&#x20;       END) AS sal,



&#x20;       -- Extract bonus values into a column

&#x20;       SUM(CASE 

&#x20;           WHEN salary\_component\_type = 'bonus' 

&#x20;           THEN val 

&#x20;           ELSE NULL 

&#x20;       END) AS bonus,



&#x20;       -- Extract hike percentage into a column

&#x20;       SUM(CASE 

&#x20;           WHEN salary\_component\_type = 'hike\_percent' 

&#x20;           THEN val 

&#x20;           ELSE NULL 

&#x20;       END) AS hike\_percent



&#x20;   FROM emp\_compensation

&#x20;   GROUP BY emp\_id

)



\-- Step 2: Unpivot the data (columns → rows)



\-- Salary rows

SELECT 

&#x20;   emp\_id, 

&#x20;   sal AS val, 

&#x20;   'salary' AS type

FROM a



UNION ALL



\-- Bonus rows

SELECT 

&#x20;   emp\_id, 

&#x20;   bonus AS val, 

&#x20;   'bonus' AS type

FROM a



UNION ALL



\-- Hike percentage rows

SELECT 

&#x20;   emp\_id, 

&#x20;   hike\_percent AS val, 

&#x20;   'hike\_percent' AS type

FROM a



\-- Final ordering

ORDER BY emp\_id;

```



\---



\## 📊 Explanation



\### 🔹 Pivot Logic



We use:



```sql

SUM(CASE WHEN condition THEN value END)

```



This works because:



\* It filters values for each type

\* Aggregates them into one row per employee



Result after pivot:



| emp\_id | sal   | bonus | hike\_percent |

| ------ | ----- | ----- | ------------ |

| 1      | 10000 | 5000  | 10           |



\---



\### 🔹 Unpivot Logic



We use `UNION ALL` to convert columns back into rows:



| emp\_id | val   | type         |

| ------ | ----- | ------------ |

| 1      | 10000 | salary       |

| 1      | 5000  | bonus        |

| 1      | 10    | hike\_percent |



\---



\## 💡 Key Concepts Used



\* `CASE WHEN`

\* Aggregation with `SUM`

\* Common Table Expression (CTE)

\* `UNION ALL`

\* Pivoting \& Unpivoting



\---



\## 🎯 Why This Matters



This pattern is widely used in:



\* ETL pipelines

\* Data cleaning

\* Reporting transformations



\---



\## 🚀 How to Run



1\. Create table

2\. Insert data

3\. Run query



\---



\## 📁 Suggested Repo Structure



```

sql-practice/

│

├── emp\_compensation\_transformation.sql

└── README.md

```



\---



\## 🧠 Learning Outcome



After this problem, you should understand:



\* How to reshape data (rows ↔ columns)

\* How to simulate pivot/unpivot in SQL

\* How to structure multi-step queries using CTE





