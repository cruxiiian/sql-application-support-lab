# TICKET-005 — Suspended user retains administrator role

- **Symptom:** User 103 is suspended but still resolves to administrator permissions.
- **Impact:** Critical security risk if another component relies on roles without checking account status.
- **Investigation:** Joined users, user roles, and roles; filtered inactive accounts with privileged role names.
- **Evidence:** Chloe Evans (103) is `suspended` and linked to `Administrator`.
- **Root cause:** The account suspension workflow did not revoke privileged role assignments.
- **Resolution:** Delete the exact administrator assignment only when the account is still suspended.
- **Validation:** The privileged-inactive query returns zero rows; other assignments remain unchanged.
- **Prevention:** Include role revocation in the suspension workflow and schedule a daily access-control reconciliation.
