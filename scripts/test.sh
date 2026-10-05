#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
scripts/build.sh >/dev/null
before="$(sqlite3 data/helpdesk.db "SELECT COUNT(*) FROM pragma_foreign_key_check;")"
[[ "$before" -eq 2 ]] || { echo "Expected 2 seeded FK issues, got $before"; exit 1; }
sqlite3 data/helpdesk.db < remediation/run_all.sql
remaining="$(sqlite3 data/helpdesk.db <<'SQL'
SELECT
 (SELECT COUNT(*) FROM (SELECT LOWER(TRIM(email)) FROM users GROUP BY LOWER(TRIM(email)) HAVING COUNT(*) > 1)) +
 (SELECT COUNT(*) FROM cases c LEFT JOIN users u ON u.user_id=c.assigned_user_id WHERE c.assigned_user_id IS NOT NULL AND u.user_id IS NULL) +
 (SELECT COUNT(*) FROM cases c LEFT JOIN case_statuses s ON s.status_code=c.status WHERE s.status_code IS NULL) +
 (SELECT COUNT(*) FROM cases c JOIN case_statuses s ON s.status_code=c.status WHERE s.is_terminal=1 AND c.resolved_at IS NULL) +
 (SELECT COUNT(*) FROM users u JOIN user_roles ur ON ur.user_id=u.user_id JOIN roles r ON r.role_id=ur.role_id WHERE u.account_status<>'active' AND r.role_name IN ('Administrator','Support Agent')) +
 (SELECT COUNT(*) FROM pragma_foreign_key_check);
SQL
)"
[[ "$remaining" -eq 0 ]] || { echo "Validation failed: $remaining issue(s) remain"; exit 1; }
echo "PASS: all five seeded defects were remediated and integrity checks are clean."
