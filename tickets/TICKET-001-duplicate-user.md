# TICKET-001 — Duplicate finance user

- **Symptom:** Profile changes appear against two records for Daniel Wong.
- **Impact:** Medium; case ownership and audit reporting can be split.
- **Investigation:** Normalised email with `LOWER(TRIM(email))`, grouped it, and filtered duplicate groups with `HAVING COUNT(*) > 1`.
- **Evidence:** User IDs 104 and 106 share `daniel.wong@example.com` after normalisation. Case 1007 and audit 5013 point to duplicate ID 106.
- **Root cause:** A user import did not normalise email or enforce uniqueness.
- **Resolution:** Repoint dependent case and audit rows to user 104, then delete user 106 inside a transaction.
- **Validation:** Duplicate query returns zero rows; case 1007 now belongs to user 104; `PRAGMA foreign_key_check` returns no rows.
- **Prevention:** Add a unique index on normalised email during a production migration and normalise at ingestion.
