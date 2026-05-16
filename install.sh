#!/usr/bin/env bash
set -euo pipefail

DEVSKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_COMMANDS_DIR="${HOME}/.claude/commands"
OPENCODE_COMMANDS_DIR="${HOME}/.opencode/commands"

log() { printf '[devskills] %s\n' "$1"; }
warn() { printf '[devskills] WARN: %s\n' "$1" >&2; }

# ------------------------------------------------------------
# Arguments
# ------------------------------------------------------------

LANG_PROFILE=""
SKIP_EXTERNAL=0
DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
    --lang=*) LANG_PROFILE="${arg#--lang=}" ;;
    --skip-external) SKIP_EXTERNAL=1 ;;
    --dry-run) DRY_RUN=1 ;;
    --help|-h)
      echo "Usage: install.sh [--lang=go|typescript|javascript|rust] [--skip-external] [--dry-run]"
      exit 0
      ;;
  esac
done

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------

install_file() {
  local src="$1"
  local dst="$2"
  if [ "$DRY_RUN" -eq 1 ]; then
    log "DRY: would install $src -> $dst"
    return
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  log "installed $dst"
}

# ------------------------------------------------------------
# Claude Code skills
# ------------------------------------------------------------

install_claude() {
  if command -v claude &>/dev/null || [ -d "${HOME}/.claude" ]; then
    log "Installing Claude Code commands to ${CLAUDE_COMMANDS_DIR}"
    mkdir -p "${CLAUDE_COMMANDS_DIR}"
    for f in "${DEVSKILLS_DIR}/claude/commands/"*.md; do
      install_file "$f" "${CLAUDE_COMMANDS_DIR}/$(basename "$f")"
    done
  else
    warn "Claude Code not detected. Skipping. Install from https://claude.ai/code"
  fi
}

# ------------------------------------------------------------
# OpenCode skills
# ------------------------------------------------------------

install_opencode() {
  if command -v opencode &>/dev/null || [ -d "${HOME}/.opencode" ]; then
    log "Installing OpenCode commands to ${OPENCODE_COMMANDS_DIR}"
    mkdir -p "${OPENCODE_COMMANDS_DIR}"
    for f in "${DEVSKILLS_DIR}/opencode/commands/"*.md; do
      install_file "$f" "${OPENCODE_COMMANDS_DIR}/$(basename "$f")"
    done
  else
    warn "OpenCode not detected. Skipping."
  fi
}

# ------------------------------------------------------------
# External tools
# ------------------------------------------------------------

install_gsd() {
  if command -v npx &>/dev/null; then
    log "Installing GSD (Get Shit Done)..."
    if [ "$DRY_RUN" -eq 0 ]; then
      npx get-shit-done-cc@latest 2>&1 | tail -5
    else
      log "DRY: would run npx get-shit-done-cc@latest"
    fi
  else
    warn "npx not found. Install GSD manually: https://github.com/gsd-build/get-shit-done"
  fi
}

install_rtk() {
  if command -v cargo &>/dev/null; then
    log "Installing RTK via Cargo..."
    if [ "$DRY_RUN" -eq 0 ]; then
      cargo install rtk-cli 2>&1 | tail -3 || warn "RTK cargo install failed. Try: https://github.com/rtk-ai/rtk"
    else
      log "DRY: would run cargo install rtk-cli"
    fi
  elif command -v brew &>/dev/null; then
    log "Installing RTK via Homebrew..."
    if [ "$DRY_RUN" -eq 0 ]; then
      brew install rtk-ai/tap/rtk 2>&1 | tail -3 || warn "RTK brew install failed. Check: https://github.com/rtk-ai/rtk"
    else
      log "DRY: would run brew install rtk-ai/tap/rtk"
    fi
  else
    warn "Neither cargo nor brew found. Install RTK manually: https://github.com/rtk-ai/rtk"
  fi
}

install_caveman() {
  if command -v node &>/dev/null; then
    local node_major
    node_major=$(node -e 'process.stdout.write(process.version.split(".")[0].slice(1))')
    if [ "$node_major" -ge 18 ]; then
      log "Installing Caveman (lite mode)..."
      if [ "$DRY_RUN" -eq 0 ]; then
        curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash 2>&1 | tail -5
      else
        log "DRY: would curl-install caveman"
      fi
    else
      warn "Node >= 18 required for Caveman. Found: $node_major"
    fi
  else
    warn "Node not found. Install Caveman manually: https://github.com/juliusbrussee/caveman"
  fi
}

install_tldt() {
  if command -v go &>/dev/null; then
    log "Installing tldt..."
    if [ "$DRY_RUN" -eq 0 ]; then
      go install github.com/gleicon/tldt/cmd/tldt@latest
      log "tldt installed to $(go env GOPATH)/bin/tldt"
    else
      log "DRY: would run go install github.com/gleicon/tldt/cmd/tldt@latest"
    fi
  else
    warn "Go not found. Install tldt manually: https://github.com/gleicon/tldt"
  fi
}

# ------------------------------------------------------------
# Language profile
# ------------------------------------------------------------

install_lang_profile() {
  local lang="$1"
  local profile_file="${DEVSKILLS_DIR}/prompts/language/${lang}.md"

  if [ ! -f "$profile_file" ]; then
    warn "No language profile for '${lang}'. Available: go, typescript, javascript, rust"
    return 1
  fi

  log "Setting up language profile: ${lang}"

  # Write profile marker for Claude Code CLAUDE.md
  local claude_md="${PWD}/CLAUDE.md"
  if [ "$DRY_RUN" -eq 0 ]; then
    if [ -f "$claude_md" ]; then
      # Append if not already present
      if ! grep -q "devskills language profile" "$claude_md" 2>/dev/null; then
        {
          echo ""
          echo "<!-- devskills language profile: ${lang} -->"
          cat "$profile_file"
        } >> "$claude_md"
        log "Appended ${lang} profile to ${claude_md}"
      else
        log "Language profile already in ${claude_md}"
      fi
    else
      {
        echo "<!-- devskills language profile: ${lang} -->"
        cat "$profile_file"
      } > "$claude_md"
      log "Created ${claude_md} with ${lang} profile"
    fi

    # Write .devskills/language marker
    mkdir -p "${PWD}/.devskills"
    echo "${lang}" > "${PWD}/.devskills/language"
    log "Wrote .devskills/language: ${lang}"
  else
    log "DRY: would write ${lang} profile to CLAUDE.md and .devskills/language"
  fi
}

# ------------------------------------------------------------
# Cursor rules
# ------------------------------------------------------------

install_cursor() {
  if [ -d "${PWD}/.cursor" ] || command -v cursor &>/dev/null; then
    log "Installing Cursor rules to ${PWD}/.cursor/rules/"
    mkdir -p "${PWD}/.cursor/rules"
    for f in "${DEVSKILLS_DIR}/cursor/rules/"*.mdc; do
      install_file "$f" "${PWD}/.cursor/rules/$(basename "$f")"
    done
  else
    warn "Cursor not detected in current project. Run from a project directory with .cursor/ or with Cursor installed."
  fi
}

# ------------------------------------------------------------
# VSCode Copilot
# ------------------------------------------------------------

install_vscode() {
  if [ -d "${PWD}/.vscode" ] || command -v code &>/dev/null; then
    log "Installing VSCode Copilot instructions to ${PWD}/.github/copilot-instructions.md"
    install_file \
      "${DEVSKILLS_DIR}/vscode/copilot-instructions.md" \
      "${PWD}/.github/copilot-instructions.md"
  else
    warn "VSCode not detected in current project."
  fi
}

# ------------------------------------------------------------
# Main
# ------------------------------------------------------------

log "devskills installer"
log "source: ${DEVSKILLS_DIR}"

install_claude
install_opencode
install_cursor
install_vscode

if [ "$SKIP_EXTERNAL" -eq 0 ]; then
  log "Installing external tools..."
  install_gsd
  install_rtk
  install_caveman
  install_tldt
else
  log "Skipping external tools (--skip-external)"
fi

if [ -n "$LANG_PROFILE" ]; then
  install_lang_profile "$LANG_PROFILE"
fi

log ""
log "Done. Verify with:"
log "  claude /tiger-style    — in Claude Code"
log "  /tiger-style           — in Cursor or OpenCode"
log "  rtk --version          — RTK token proxy"
log "  tldt --version         — text summarizer"
log ""
log "Set language profile in any project:"
log "  ./install.sh --lang=go"
log "  ./install.sh --lang=typescript"
