.headers on
.mode box

-- Q1: Inspect user accounts and their teams.
SELECT u.user_id, u.full_name, u.email, u.account_status,
       COALESCE(t.team_name, 'UNASSIGNED') AS team
FROM users AS u
LEFT JOIN teams AS t ON t.team_id = u.team_id
ORDER BY u.user_id;

-- Q2: Inspect effective permissions inherited through roles.
SELECT u.user_id, u.full_name, r.role_name, p.permission_code
FROM users AS u
JOIN user_roles AS ur ON ur.user_id = u.user_id
JOIN roles AS r ON r.role_id = ur.role_id
JOIN role_permissions AS rp ON rp.role_id = r.role_id
JOIN permissions AS p ON p.permission_id = rp.permission_id
ORDER BY u.user_id, p.permission_code;

-- Q3: Identify inactive accounts that still have privileged roles.
SELECT u.user_id, u.full_name, u.account_status, r.role_name
FROM users AS u
JOIN user_roles AS ur ON ur.user_id = u.user_id
JOIN roles AS r ON r.role_id = ur.role_id
WHERE u.account_status <> 'active'
  AND r.role_name IN ('Administrator', 'Support Agent')
ORDER BY u.user_id;
