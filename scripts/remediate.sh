#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
[[ -f data/helpdesk.db ]] || scripts/build.sh
sqlite3 data/helpdesk.db < remediation/run_all.sql
sqlite3 data/helpdesk.db < tests/validate_lab.sql
