#!/usr/bin/env bash
# sync.test.sh — commands/ is the single source; all .md files must be non-empty.
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CMDS="${REPO}/commands"

echo "commands/ source integrity"

if [ ! -d "$CMDS" ]; then
  echo "  FAIL commands/ directory missing"
  exit 1
fi

fail=0
for f in "${CMDS}"/*.md; do
  [ -s "$f" ] || { echo "  FAIL empty: $(basename "$f")"; fail=1; }
done

if [ "$fail" -eq 0 ]; then
  count=$(ls "${CMDS}"/*.md 2>/dev/null | wc -l | tr -d ' ')
  echo "  ok   ${count} commands found, all non-empty"
  exit 0
fi
exit 1
