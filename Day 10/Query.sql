-- 📌 Problem: Find median salary per department

WITH a AS (
    SELECT 
        emp_name,
        department_id,
        salary,

        -- Assign row number based on salary order within each department
        ROW_NUMBER() OVER (
            PARTITION BY department_id 
            ORDER BY salary
        ) AS rn,

        -- Total number of employees in each department
        COUNT(*) OVER (
            PARTITION BY department_id
        ) AS tl

    FROM emp
),

b AS (
    SELECT 
        *,

        -- Identify whether total count is even or odd
        -- eo = 1 → even
        -- eo = 0 → odd
        CASE 
            WHEN ((tl * 1.0 / 2) - (tl / 2)) = 0 THEN 1 
            ELSE 0 
        END AS eo

    FROM a
),

c AS (
    SELECT 
        *,

        -- For even count: select two middle rows
        CASE 
            WHEN eo = 1 
                 AND (rn = tl / 2 OR rn = (tl / 2) + 1) 
            THEN 1 
            ELSE 0 
        END AS even_rn,

        -- For odd count: select only middle row
        CASE 
            WHEN eo = 0 
                 AND rn = (tl / 2) + 1 
            THEN 1 
            ELSE 0 
        END AS odd_rn

    FROM b
)

SELECT 
    emp_name,
    department_id,
    salary,

    -- Median calculated as average of selected rows
    AVG(salary) OVER (PARTITION BY department_id) AS median_salary

FROM c

-- Keep only rows that represent median positions
WHERE even_rn = 1 
   OR odd_rn = 1;