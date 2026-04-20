WITH a AS (
  SELECT team_1 AS team,
         CASE WHEN team_1 = winner THEN 1 ELSE 0 END AS flag
  FROM icc_world_cup

  UNION ALL

  SELECT team_2,
         CASE WHEN team_2 = winner THEN 1 ELSE 0 END
  FROM icc_world_cup
)

SELECT team,
       COUNT(*) AS matches_played,
       SUM(flag) AS wins,
       COUNT(*) - SUM(flag) AS losses,
       SUM(flag) * 2 AS points
FROM a
GROUP BY team
ORDER BY points DESC;