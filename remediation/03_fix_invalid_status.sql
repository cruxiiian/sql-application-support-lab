PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;

UPDATE cases
SET status = 'pending',
    updated_at = '2026-10-05 10:05:00'
WHERE case_id = 1005
  AND status = 'waiting_customer';

UPDATE audit_history
SET new_value = 'pending',
    note = 'Mapped obsolete integration value waiting_customer to pending.'
WHERE audit_id = 5010
  AND new_value = 'waiting_customer';

COMMIT;
