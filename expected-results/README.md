# Expected results

- `before-remediation.txt` contains the output of every investigation query against the deliberately defective dataset.
- `after-remediation.txt` shows zero remaining issues for all five acceptance checks; `PRAGMA foreign_key_check` produces no additional rows.
- `automated-test.txt` records the repeatable test result.

Exact spacing can vary by SQLite version and terminal width, but row values should match.
