.headers on
.mode box

-- DQ1: Duplicate users after normalising email case and whitespace.
SELECT LOWER(TRIM(email)) AS normalised_email,
       COUNT(*) AS duplicate_count,
       GROUP_CONCAT(user_id) AS user_ids
FROM users
GROUP BY LOWER(TRIM(email))
HAVING COUNT(*) > 1;

-- DQ2: Missing assignee relationships.
SELECT c.case_id, c.assigned_user_id, c.title
FROM cases AS c
LEFT JOIN users AS u ON u.user_id = c.assigned_user_id
WHERE c.assigned_user_id IS NOT NULL
  AND u.user_id IS NULL;

-- DQ3: Status values not defined in the reference table.
SELECT c.case_id, c.status, c.title
FROM cases AS c
LEFT JOIN case_statuses AS s ON s.status_code = c.status
WHERE s.status_code IS NULL;

-- DQ4: Terminal cases missing a resolution timestamp.
SELECT c.case_id, c.status, c.resolved_at, c.title
FROM cases AS c
JOIN case_statuses AS s ON s.status_code = c.status
WHERE s.is_terminal = 1
  AND c.resolved_at IS NULL;

-- DQ5: Inactive users retaining privileged roles.
SELECT u.user_id, u.full_name, u.account_status, r.role_name
FROM users AS u
JOIN user_roles AS ur ON ur.user_id = u.user_id
JOIN roles AS r ON r.role_id = ur.role_id
WHERE u.account_status <> 'active'
  AND r.role_name IN ('Administrator', 'Support Agent');

-- DQ6: SQLite's built-in foreign-key audit.
PRAGMA foreign_key_check;
