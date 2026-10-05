.headers on
.mode box

-- Q4: Case queue with requester and assignee names.
SELECT c.case_id, c.priority, c.status,
       req.full_name AS requester,
       COALESCE(agent.full_name, 'UNASSIGNED OR MISSING') AS assignee,
       c.title
FROM cases AS c
JOIN users AS req ON req.user_id = c.requester_id
LEFT JOIN users AS agent ON agent.user_id = c.assigned_user_id
ORDER BY CASE c.priority
           WHEN 'critical' THEN 1 WHEN 'high' THEN 2
           WHEN 'medium' THEN 3 ELSE 4 END,
         c.created_at;

-- Q5: Full chronological audit trail for case 1002.
SELECT a.audit_id, a.action_at,
       COALESCE(u.full_name, '[SYSTEM/UNKNOWN]') AS actor,
       a.action_type, a.old_value, a.new_value, a.note
FROM audit_history AS a
LEFT JOIN users AS u ON u.user_id = a.actor_id
WHERE a.case_id = 1002
ORDER BY a.action_at, a.audit_id;

-- Q6: Open workload aggregation by valid status.
SELECT c.status, COUNT(*) AS case_count
FROM cases AS c
JOIN case_statuses AS s ON s.status_code = c.status
WHERE s.is_terminal = 0
GROUP BY c.status
ORDER BY case_count DESC, c.status;

-- Q7: Agents whose active workload is above the average agent workload.
SELECT u.user_id, u.full_name, COUNT(c.case_id) AS active_cases
FROM users AS u
JOIN cases AS c ON c.assigned_user_id = u.user_id
WHERE c.status IN (SELECT status_code FROM case_statuses WHERE is_terminal = 0)
GROUP BY u.user_id, u.full_name
HAVING COUNT(c.case_id) > (
    SELECT AVG(active_count)
    FROM (
        SELECT COUNT(*) AS active_count
        FROM cases
        WHERE status IN (SELECT status_code FROM case_statuses WHERE is_terminal = 0)
          AND assigned_user_id IN (SELECT user_id FROM users)
        GROUP BY assigned_user_id
    ) AS workloads
)
ORDER BY active_cases DESC;
