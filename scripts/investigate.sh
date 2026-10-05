#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
[[ -f data/helpdesk.db ]] || scripts/build.sh
for query in queries/*.sql; do
  printf '\n===== %s =====\n' "$query"
  sqlite3 data/helpdesk.db < "$query"
done
