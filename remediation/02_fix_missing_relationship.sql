PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;

-- Reassign only the known broken case to the Application Support administrator.
UPDATE cases
SET assigned_user_id = 101,
    updated_at = '2026-10-05 10:00:00'
WHERE case_id = 1003
  AND assigned_user_id = 999;

UPDATE audit_history
SET new_value = '101',
    note = 'Corrected retired agent reference; assigned to Aisha Rahman.'
WHERE audit_id = 5006
  AND new_value = '999';

COMMIT;
