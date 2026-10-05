# Interview talking points

- **Situation:** A compact service-management database contained defects representative of imports, integrations and incomplete workflows.
- **Task:** Trace user access, case ownership, workflow status and audit history without risking further data loss.
- **Action:** Started with read-only `SELECT` statements, used `LEFT JOIN` to preserve broken parent references, grouped normalised emails to find duplicates, used subqueries for derived timestamps, and applied guarded transactional remediation.
- **Result:** Five documented incidents are reproducible, remediations are idempotent, and automated validation reaches zero known issues.
- **Safety:** Production practice would include backup/change approval, row-count review, rollback planning, least-privilege access and post-change monitoring.
