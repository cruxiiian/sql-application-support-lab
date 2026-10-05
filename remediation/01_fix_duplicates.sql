-- Review queries should be run first. This script is repeatable and transactional.
PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;

UPDATE cases
SET requester_id = 104
WHERE requester_id = 106;

UPDATE audit_history
SET actor_id = 104
WHERE actor_id = 106;

DELETE FROM users
WHERE user_id = 106
  AND LOWER(TRIM(email)) = 'daniel.wong@example.com';

COMMIT;
