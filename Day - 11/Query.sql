-- Step 1: Flatten match results
-- Convert both first_player and second_player into a single column (player)
WITH a AS (
    SELECT 
        first_player AS player, 
        first_score  AS score 
    FROM matches

    UNION ALL

    SELECT 
        second_player AS player, 
        second_score  AS score 
    FROM matches
),

-- Step 2: Calculate total score per player
b AS (
    SELECT 
        player, 
        SUM(score) AS score   -- total score across all matches
    FROM a 
    GROUP BY player
),

-- Step 3: Assign players to groups and rank them
c AS (
    SELECT 
        b.player, 
        b.score, 
        p.group_id,

        -- Rank players within each group
        -- Order by:
        --   1. Highest total score
        --   2. Lowest player_id (tie-breaker)
        ROW_NUMBER() OVER (
            PARTITION BY p.group_id 
            ORDER BY b.score DESC, b.player ASC
        ) AS rank_

    FROM b
    LEFT JOIN players p
        ON b.player = p.player_id
)

-- Step 4: Select top player from each group
SELECT 
    group_id, 
    player, 
    score 
FROM c 
WHERE rank_ = 1;