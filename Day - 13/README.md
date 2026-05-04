# User Spending Analysis (Platform-wise Aggregation)

## 📌 Problem Overview

We are given a `spending` table that records:
- user_id
- spend_date
- platform (mobile / desktop)
- amount spent

The goal is to generate a report that shows, for each date and platform:
- total amount spent
- total number of users

Platform categories:
- mobile → users who used only mobile
- desktop → users who used only desktop
- both → users who used both platforms on the same day

---

## 🧱 Table Structure

CREATE TABLE spending (
    user_id INT,
    spend_date DATE,
    platform VARCHAR(10),
    amount INT
);

---

## 📥 Sample Data

INSERT INTO spending VALUES
(1,'2019-07-01','mobile',100),
(1,'2019-07-01','desktop',100),
(2,'2019-07-01','mobile',100),
(2,'2019-07-02','mobile',100),
(3,'2019-07-01','desktop',100),
(3,'2019-07-02','desktop',100);

---

## ⚙️ Approach

We break the problem into 3 logical parts using a CTE (`all_spend`):

### 1. Users using ONLY one platform
- Group by `spend_date` and `user_id`
- Filter using:
  HAVING COUNT(DISTINCT platform) = 1
- Use MAX(platform) to get that platform

### 2. Users using BOTH platforms
- Same grouping
- Filter using:
  HAVING COUNT(DISTINCT platform) = 2
- Assign platform as 'both'

### 3. Ensure 'both' exists for every date
- Add dummy rows with:
  user_id = NULL
  platform = 'both'
  amount = 0

---

## 🧠 Final Aggregation

From the combined dataset:
- SUM(amount) → total_amount
- COUNT(DISTINCT user_id) → total_users

Grouped by:
- spend_date
- platform

---

## 🧾 Final Query

WITH all_spend AS (
    SELECT 
        spend_date, 
        user_id, 
        MAX(platform) AS platform, 
        SUM(amount) AS amount 
    FROM spending
    GROUP BY spend_date, user_id 
    HAVING COUNT(DISTINCT platform) = 1

    UNION ALL

    SELECT 
        spend_date, 
        user_id, 
        'both' AS platform, 
        SUM(amount) AS amount 
    FROM spending
    GROUP BY spend_date, user_id 
    HAVING COUNT(DISTINCT platform) = 2

    UNION ALL

    SELECT DISTINCT 
        spend_date, 
        NULL AS user_id, 
        'both' AS platform, 
        0 AS amount 
    FROM spending
)

SELECT 
    spend_date, 
    platform, 
    SUM(amount) AS total_amount, 
    COUNT(DISTINCT user_id) AS total_users
FROM all_spend
GROUP BY spend_date, platform
ORDER BY spend_date, platform DESC;

---

## ✅ Key Insights

- Clever use of `HAVING COUNT(DISTINCT platform)` to classify users
- `UNION ALL` combines different behavioral groups cleanly
- Dummy rows ensure 'both' category appears even if no users exist
- Final aggregation gives a compact daily report

---

## 🚀 Outcome

Produces a report like:

Date        | Platform | Total Amount | Total Users
------------|----------|--------------|------------
2019-07-01  | both     | ...          | ...
2019-07-01  | mobile   | ...          | ...
2019-07-01  | desktop  | ...          | ...

---
