-- Step 1: Create a Common Table Expression (CTE) 'a'
-- This joins the Friend table with Person table
-- to get each friend's score and name
WITH a AS (
    SELECT 
        f.pid,          -- Person ID (the main person)
        f.fid,          -- Friend ID
        p.name,         -- Friend's name
        p.score         -- Friend's score
    FROM friend AS f
    LEFT JOIN person AS p
        ON f.fid = p.PersonID   -- Match friend ID with person table
)

-- Step 2: Main query
-- Calculate total score of all friends for each person
SELECT 
    a.pid,                  -- Person ID
    p.name,                 -- Person's name
    SUM(a.score) AS total_sum   -- Total score of all friends
FROM a
LEFT JOIN person AS p
    ON a.pid = p.PersonID   -- Match person ID to get their name

-- Step 3: Grouping
GROUP BY 
    a.pid, 
    p.name

-- Step 4: Filter results
-- Only include persons whose friends' total score > 100
HAVING 
    SUM(a.score) > 100;