## Problem
Given match-level data with two teams and a winner,
calculate a points table with matches, wins, losses, and points.

## Approach
- Each match contains 2 teams → need to convert into team-level rows
- Used UNION ALL to split team_1 and team_2 into separate rows
- Created a flag using CASE:
  - 1 → win
  - 0 → loss
- Aggregated using COUNT and SUM

## Key Learning
Transforming data (row expansion + flags) simplifies aggregation problems.