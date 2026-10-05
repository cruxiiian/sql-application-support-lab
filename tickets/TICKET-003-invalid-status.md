# TICKET-003 — Obsolete case status

- **Symptom:** Case 1005 is absent from standard open-workload reporting.
- **Impact:** High; the case can disappear from operational queues.
- **Investigation:** `LEFT JOIN` connected case statuses to the reference table and filtered rows without a match.
- **Evidence:** `waiting_customer` is not in `case_statuses`; audit 5010 shows it came from a legacy integration.
- **Root cause:** The integration used an obsolete value instead of the supported `pending` code.
- **Resolution:** Map the case and matching audit value to `pending` in a guarded transaction.
- **Validation:** Invalid-status query returns zero rows and case 1005 appears in active workload results.
- **Prevention:** Validate integration payloads against the status reference table before insertion.
