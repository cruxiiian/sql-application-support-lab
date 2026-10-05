PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;

DELETE FROM user_roles
WHERE user_role_id = 3
  AND user_id = 103
  AND role_id = 1
  AND EXISTS (
      SELECT 1 FROM users
      WHERE user_id = 103 AND account_status = 'suspended'
  );

COMMIT;
