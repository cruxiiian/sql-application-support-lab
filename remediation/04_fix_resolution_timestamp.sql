PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;

-- Derive the missing timestamp from the closing audit event.
UPDATE cases
SET resolved_at = (
        SELECT MAX(action_at)
        FROM audit_history
        WHERE case_id = 1004
          AND action_type = 'STATUS_CHANGED'
          AND new_value = 'closed'
    )
WHERE case_id = 1004
  AND status = 'closed'
  AND resolved_at IS NULL;

COMMIT;
