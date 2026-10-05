# TICKET-004 — Closed case missing resolution time

- **Symptom:** Case 1004 is closed but has no `resolved_at` value.
- **Impact:** Medium; time-to-resolution and SLA reports are incorrect.
- **Investigation:** Joined terminal status definitions to cases and selected null resolution timestamps; then inspected case audit history.
- **Evidence:** Audit 5008 records the close event at `2026-09-25 16:00:00`.
- **Root cause:** A close batch changed status without copying its event time to the case record.
- **Resolution:** Set `resolved_at` from the closing audit event using a scalar subquery.
- **Validation:** Terminal-without-timestamp query returns zero rows.
- **Prevention:** Update status and resolution timestamp atomically in one service transaction.
