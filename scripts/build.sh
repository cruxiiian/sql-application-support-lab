#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
mkdir -p data
rm -f data/helpdesk.db
sqlite3 data/helpdesk.db < schema.sql
sqlite3 data/helpdesk.db < sample_data.sql
printf 'Built %s\n' "$ROOT/data/helpdesk.db"
