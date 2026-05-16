#!/usr/bin/env bash
# update.sh: pull latest devskills and reinstall
set -euo pipefail

DEVSKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[devskills] Updating..."

if [ -d "${DEVSKILLS_DIR}/.git" ]; then
  git -C "${DEVSKILLS_DIR}" pull --ff-only
  echo "[devskills] Pulled latest from git"
elif command -v npm &>/dev/null && [ -f "${DEVSKILLS_DIR}/package.json" ]; then
  npm -g update devskills
  echo "[devskills] Updated via npm"
else
  echo "[devskills] WARN: not a git repo and npm not available. Update manually."
  exit 1
fi

# Reinstall skills only (no external tools, no language profile changes)
"${DEVSKILLS_DIR}/install.sh" --skip-external "$@"

echo "[devskills] Update complete."
