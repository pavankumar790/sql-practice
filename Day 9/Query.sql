-- Step 1: CTE 'a'
-- Join Trips with Users to get CLIENT ban status
WITH a AS (
    SELECT 
        t.id,              -- Trip ID
        t.client_id,       -- Client (user who requested the ride)
        t.driver_id,       -- Driver assigned to the ride
        t.city_id,         -- City of the trip
        t.status,          -- Trip status (completed / cancelled)
        t.request_at,      -- Date of request
        u.banned AS client_ban   -- Whether client is banned (Yes/No)
    FROM Trips AS t
    LEFT JOIN Users AS u
        ON t.client_id = u.users_id   -- Match client_id to Users table
),

-- Step 2: CTE 'b'
-- Join again to get DRIVER ban status
b AS (
    SELECT 
        a.id,
        a.client_id,
        a.driver_id,
        a.city_id,
        a.status,
        a.request_at,
        a.client_ban,
        u.banned AS driver_ban   -- Whether driver is banned (Yes/No)
    FROM a
    LEFT JOIN Users AS u
        ON a.driver_id = u.users_id   -- Match driver_id to Users table
),

-- Step 3: CTE 'c'
-- Filter only VALID trips:
-- 1. Both client and driver must NOT be banned
-- 2. Only consider trips within given date range
c AS (
    SELECT * 
    FROM b
    WHERE 
        client_ban = 'No' 
        AND driver_ban = 'No'
        AND request_at BETWEEN '2013-10-01' AND '2013-10-03'
)

-- Step 4: Final aggregation
-- Calculate cancellation rate per day
SELECT 
    request_at,   -- Grouping by each day

    -- Count of cancelled trips (status not 'completed')
    SUM(CASE 
            WHEN status <> 'completed' THEN 1 
            ELSE 0 
        END) AS cancelled,

    -- Total number of valid trips
    COUNT(*) AS total,

    -- Cancellation rate = cancelled / total
    -- Multiply by 1.0 to ensure decimal division
    -- Round result to 2 decimal places
    ROUND(
        SUM(CASE 
                WHEN status <> 'completed' THEN 1 
                ELSE 0 
            END) * 1.0 / COUNT(*),
        2
    ) AS cancellation_rate

FROM c

-- Group results by date
GROUP BY request_at;