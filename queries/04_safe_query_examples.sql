.headers on
.mode box

-- SELECT: explicit columns and a restrictive predicate.
SELECT case_id, title, priority, created_at
FROM cases
WHERE priority IN ('high', 'critical')
ORDER BY created_at;

-- LEFT JOIN: retain every case and expose missing assignees.
SELECT c.case_id, c.title, u.full_name AS assignee
FROM cases AS c
LEFT JOIN users AS u ON u.user_id = c.assigned_user_id
ORDER BY c.case_id;

-- Aggregation: group workload and filter after aggregation with HAVING.
SELECT assigned_user_id, COUNT(*) AS active_case_count
FROM cases
WHERE status IN ('open', 'in_progress', 'pending')
  AND assigned_user_id IS NOT NULL
GROUP BY assigned_user_id
HAVING COUNT(*) >= 1
ORDER BY active_case_count DESC;

-- Subquery: terminal cases whose resolution time exceeds the average.
SELECT case_id, title,
       ROUND((julianday(resolved_at) - julianday(created_at)) * 24, 1) AS hours_to_resolve
FROM cases
WHERE resolved_at IS NOT NULL
  AND (julianday(resolved_at) - julianday(created_at)) > (
      SELECT AVG(julianday(resolved_at) - julianday(created_at))
      FROM cases
      WHERE resolved_at IS NOT NULL
  )
ORDER BY hours_to_resolve DESC;

-- EXISTS: users who requested at least one case.
SELECT u.user_id, u.full_name
FROM users AS u
WHERE EXISTS (
    SELECT 1 FROM cases AS c WHERE c.requester_id = u.user_id
)
ORDER BY u.user_id;
