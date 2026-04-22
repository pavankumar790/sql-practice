\# SQL Practice: First Visit vs Repeat Visit Analysis



\## 📌 Problem Statement



Given a `customer\_orders` table, write a query to calculate for each day:



1\. Number of \*\*first-time customers\*\* (first visit)

2\. Number of \*\*repeat customers\*\* (customers who have ordered before)



\---



\## 🧱 Table Structure



```sql id="0b1t7q"

CREATE TABLE customer\_orders (

&#x20;   order\_id INT,

&#x20;   customer\_id INT,

&#x20;   order\_date DATE,

&#x20;   order\_amount INT

);

```



\---



\## 📥 Sample Data



```sql id="d4k3cz"

INSERT INTO customer\_orders VALUES

(1,100,CAST('2022-01-01' AS DATE),2000),

(2,200,CAST('2022-01-01' AS DATE),2500),

(3,300,CAST('2022-01-01' AS DATE),2100),

(4,100,CAST('2022-01-02' AS DATE),2000),

(5,400,CAST('2022-01-02' AS DATE),2200),

(6,500,CAST('2022-01-02' AS DATE),2700),

(7,100,CAST('2022-01-03' AS DATE),3000),

(8,400,CAST('2022-01-03' AS DATE),1000),

(9,600,CAST('2022-01-03' AS DATE),3000);

```



\---



\## 🔍 Approach



We solve this in two steps:



\### Step 1: Identify First Visit Date per Customer



\### Step 2: Classify each order as First Visit or Repeat Visit



\---



\## ✅ SQL Query (With Comments)



```sql id="w7tsqv"

WITH first\_visit AS (

&#x20;   -- Step 1: Get the first order date for each customer

&#x20;   SELECT 

&#x20;       customer\_id, 

&#x20;       MIN(order\_date) AS first\_visit\_date

&#x20;   FROM customer\_orders

&#x20;   GROUP BY customer\_id

)



\-- Step 2: Classify each order and aggregate per day

SELECT 

&#x20;   co.order\_date,



&#x20;   -- Count first-time visits

&#x20;   SUM(CASE 

&#x20;       WHEN co.order\_date = fv.first\_visit\_date 

&#x20;       THEN 1 

&#x20;       ELSE 0 

&#x20;   END) AS first\_visit\_flag,



&#x20;   -- Count repeat visits

&#x20;   SUM(CASE 

&#x20;       WHEN co.order\_date != fv.first\_visit\_date 

&#x20;       THEN 1 

&#x20;       ELSE 0 

&#x20;   END) AS repeat\_visit\_flag



FROM customer\_orders co



\-- Join with first visit table

INNER JOIN first\_visit fv 

&#x20;   ON co.customer\_id = fv.customer\_id



\-- Aggregate by date

GROUP BY co.order\_date



\-- Optional: order results

ORDER BY co.order\_date;

```



\---



\## 📊 Explanation



\### 🔹 Step 1: First Visit Identification



```sql id="3u6v55"

MIN(order\_date)

```



\* Finds the earliest order date per customer

\* Defines the \*\*first visit\*\*



\---



\### 🔹 Step 2: Classification Logic



We use conditional aggregation:



```sql id="g0otvc"

CASE WHEN co.order\_date = fv.first\_visit\_date THEN 1 END

```



\* If order date = first visit → \*\*new customer\*\*

\* Otherwise → \*\*repeat customer\*\*



\---



\### 🔹 Step 3: Daily Aggregation



We group by:



```sql id="5c4p4z"

co.order\_date

```



To get daily counts of:



\* New users

\* Returning users



\---



\## 📈 Sample Output



| order\_date | first\_visit\_flag | repeat\_visit\_flag |

| ---------- | ---------------- | ----------------- |

| 2022-01-01 | 3                | 0                 |

| 2022-01-02 | 2                | 1                 |

| 2022-01-03 | 1                | 2                 |



\---



\## 💡 Key Concepts Used



\* Common Table Expressions (CTE)

\* Aggregation (`MIN`, `SUM`)

\* Conditional Logic (`CASE WHEN`)

\* Joins

\* Cohort Analysis Basics



\---



\## 🎯 Why This Matters



This pattern is heavily used in:



\* Product analytics (DAU / retention)

\* E-commerce tracking

\* Customer lifecycle analysis

\* Growth metrics dashboards



\---



\## 🚀 How to Run



1\. Create table

2\. Insert sample data

3\. Execute query



\---



\## 📁 Suggested Repo Structure



```id="o0d7o3"

sql-practice/

│

├── customer\_visit\_analysis.sql

└── README.md

```



\---



\## 🧠 Learning Outcome



After this problem, you should understand:



\* How to identify first-time vs returning users

\* How to perform cohort-style analysis in SQL

\* How to combine CTE + joins + conditional aggregation



\---



🔥 This is a \*\*core analytics pattern\*\* — mastering this unlocks real-world data insights.



