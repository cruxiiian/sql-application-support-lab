.headers on
.mode box

SELECT 'duplicate_emails' AS check_name, COUNT(*) AS remaining_issues
FROM (
    SELECT LOWER(TRIM(email))
    FROM users
    GROUP BY LOWER(TRIM(email))
    HAVING COUNT(*) > 1
)
UNION ALL
SELECT 'missing_assignees', COUNT(*)
FROM cases c LEFT JOIN users u ON u.user_id = c.assigned_user_id
WHERE c.assigned_user_id IS NOT NULL AND u.user_id IS NULL
UNION ALL
SELECT 'invalid_statuses', COUNT(*)
FROM cases c LEFT JOIN case_statuses s ON s.status_code = c.status
WHERE s.status_code IS NULL
UNION ALL
SELECT 'terminal_without_resolved_at', COUNT(*)
FROM cases c JOIN case_statuses s ON s.status_code = c.status
WHERE s.is_terminal = 1 AND c.resolved_at IS NULL
UNION ALL
SELECT 'inactive_privileged_users', COUNT(*)
FROM users u
JOIN user_roles ur ON ur.user_id = u.user_id
JOIN roles r ON r.role_id = ur.role_id
WHERE u.account_status <> 'active'
  AND r.role_name IN ('Administrator', 'Support Agent');

PRAGMA foreign_key_check;
