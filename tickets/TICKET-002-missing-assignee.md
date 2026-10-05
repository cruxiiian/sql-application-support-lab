# TICKET-002 — Case assigned to missing user

- **Symptom:** Case 1003 displays “UNASSIGNED OR MISSING”.
- **Impact:** High; the password-reset request may breach its service target.
- **Investigation:** Used `LEFT JOIN` from `cases` to `users` and selected non-null assignee IDs with no matching user.
- **Evidence:** Case 1003 references user ID 999, absent from `users`; audit 5006 records the same retired ID.
- **Root cause:** A legacy import ran while foreign-key enforcement was unavailable.
- **Resolution:** Reassign case 1003 to active administrator 101 and correct its assignment audit note transactionally.
- **Validation:** Missing-assignee query returns zero rows and the foreign-key audit is clean.
- **Prevention:** Enable foreign keys per connection and reject imports containing unknown identifiers.
