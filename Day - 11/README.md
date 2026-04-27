SQL Practice - Find Winner in Each Group

Problem Description:
Given two tables:

1. players (player_id, group_id)
2. matches (match_id, first_player, second_player, first_score, second_score)

Each match contains scores of two players.

Goal:
For each group, find the player with the highest TOTAL score.
If there is a tie, return the player with the smallest player_id.

---

Approach:

Step 1:
Flatten match data so that each player has one row per match.
Used UNION ALL to combine first_player and second_player.

Step 2:
Aggregate total score for each player using SUM(score).

Step 3:
Join with players table to get group_id.

Step 4:
Use ROW_NUMBER() to rank players within each group:

* Order by total score DESC
* Tie-break using player_id ASC

Step 5:
Select rank = 1 to get the winner of each group.

---

SQL Query:

WITH a AS (
SELECT first_player AS player, first_score AS score FROM matches
UNION ALL
SELECT second_player, second_score FROM matches
),

b AS (
SELECT player, SUM(score) AS score
FROM a
GROUP BY player
),

c AS (
SELECT
b.player,
b.score,
p.group_id,
ROW_NUMBER() OVER (
PARTITION BY p.group_id
ORDER BY b.score DESC, b.player ASC
) AS rank_
FROM b
LEFT JOIN players p
ON b.player = p.player_id
)

SELECT group_id, player, score
FROM c
WHERE rank_ = 1;

---

Key Concepts Used:

* UNION ALL
* GROUP BY with SUM()
* Window Functions (ROW_NUMBER)
* PARTITION BY
* ORDER BY with tie-breaking
* JOIN

---

Notes:

* ROW_NUMBER ensures only one winner per group.
* Tie-breaking is handled using player_id.
* UNION ALL is used instead of UNION to avoid unnecessary deduplication.

---
