# SQL Practice - Day 09

## Problem Statement

Find the daily cancellation rate of trips where both client and driver are not banned.

Conditions:

* Only include trips where client and driver are not banned
* Date range: 2013-10-01 to 2013-10-03
* Cancellation includes any trip not marked as 'completed'

Cancellation Rate = Cancelled Trips / Total Trips

---

## Database Schema

### Trips Table

```sql
CREATE TABLE Trips (
    id INT,
    client_id INT,
    driver_id INT,
    city_id INT,
    status VARCHAR(50),
    request_at VARCHAR(50)
);
```

### Users Table

```sql
CREATE TABLE Users (
    users_id INT,
    banned VARCHAR(50),
    role VARCHAR(50)
);
```

---

## Approach

1. Join Trips with Users to get client ban status
2. Join again to get driver ban status
3. Filter only valid trips (both not banned + date range)
4. Aggregate:

   * count total trips
   * count cancelled trips
5. Compute cancellation rate

---

## SQL Solution

```sql
WITH a AS (
    SELECT 
        t.id,
        t.client_id,
        t.driver_id,
        t.city_id,
        t.status,
        t.request_at,
        u.banned AS client_ban
    FROM Trips t
    LEFT JOIN Users u
        ON t.client_id = u.users_id
),

b AS (
    SELECT 
        a.*,
        u.banned AS driver_ban
    FROM a
    LEFT JOIN Users u
        ON a.driver_id = u.users_id
),

c AS (
    SELECT *
    FROM b
    WHERE 
        client_ban = 'No'
        AND driver_ban = 'No'
        AND request_at BETWEEN '2013-10-01' AND '2013-10-03'
)

SELECT 
    request_at,
    SUM(CASE 
            WHEN status <> 'completed' THEN 1 
            ELSE 0 
        END) AS cancelled,
    COUNT(*) AS total,
    ROUND(
        SUM(CASE 
                WHEN status <> 'completed' THEN 1 
                ELSE 0 
            END) * 1.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM c
GROUP BY request_at;
```

---

## Output

| request_at | cancelled | total | cancellation_rate |
| ---------- | --------- | ----- | ----------------- |
| 2013-10-01 | 1         | 3     | 0.33              |
| 2013-10-02 | 0         | 2     | 0.00              |
| 2013-10-03 | 1         | 3     | 0.33              |

---

## Key Learnings

* Filtering before aggregation
* Multiple joins on same table
* Using CTE for step-by-step logic
* Ratio calculations using SUM and COUNT

---

## Author

Pavan Kumar
