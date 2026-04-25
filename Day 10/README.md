Median Salary Per Department (SQL)

Problem:
Find the median salary for each department from the employee table.

Table Structure:
emp(emp_id, emp_name, department_id, salary, manager_id, emp_age)


Approach:

1. Assign row numbers to each employee within a department based on salary order.
2. Count total employees in each department.
3. Identify whether the count is even or odd.
4. For even count:
   - Select the two middle rows.
5. For odd count:
   - Select the single middle row.
6. Take average of selected rows to get median.


SQL Solution:

WITH a AS (
    SELECT 
        emp_name,
        department_id,
        salary,
        ROW_NUMBER() OVER (
            PARTITION BY department_id 
            ORDER BY salary
        ) AS rn,
        COUNT(*) OVER (
            PARTITION BY department_id
        ) AS tl
    FROM emp
),

b AS (
    SELECT 
        *,
        CASE 
            WHEN ((tl * 1.0 / 2) - (tl / 2)) = 0 THEN 1 
            ELSE 0 
        END AS eo
    FROM a
),

c AS (
    SELECT 
        *,
        CASE 
            WHEN eo = 1 
                 AND (rn = tl / 2 OR rn = (tl / 2) + 1) 
            THEN 1 
            ELSE 0 
        END AS even_rn,
        
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
    AVG(salary) OVER (PARTITION BY department_id) AS median_salary
FROM c
WHERE even_rn = 1 
   OR odd_rn = 1;


Key Concepts Used:
- Window Functions (ROW_NUMBER, COUNT)
- Conditional Logic (CASE)
- Handling Even and Odd number of records
- Median calculation using positional logic


Notes:
- Median is calculated as:
  - Middle value (odd count)
  - Average of two middle values (even count)
- This solution explicitly handles both cases using CASE conditions.