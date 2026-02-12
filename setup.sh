#!/usr/bin/env bash
set -euo pipefail

MARKETPLACE_REPO="${MARKETPLACE_REPO:-brrichards/org-marketplace}"
MARKETPLACE_REF="${MARKETPLACE_REF:-main}"
PROFILE="default"
TARGET_DIR="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile) PROFILE="$2"; shift 2 ;;
    --target)  TARGET_DIR="$2"; shift 2 ;;
    *)         echo "Unknown argument: $1"; exit 1 ;;
  esac
done

TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || { echo "Error: target dir not found: $TARGET_DIR"; exit 1; }

fetch_file() {
  if [[ -n "${MARKETPLACE_LOCAL:-}" ]]; then
    cat "${MARKETPLACE_LOCAL}/$1"
  else
    curl -fsSL "https://raw.githubusercontent.com/${MARKETPLACE_REPO}/${MARKETPLACE_REF}/$1"
  fi
}

# Install Claude Code if missing
if ! command -v claude &>/dev/null && [[ "${CLAUDE_SKIP_INSTALL:-0}" != "1" ]]; then
  echo "Installing Claude Code…"
  npm install -g @anthropic-ai/claude-code
fi

# Fetch and write profile
CLAUDE_DIR="${TARGET_DIR}/.claude"
mkdir -p "$CLAUDE_DIR"

SETTINGS="$(fetch_file "profiles/${PROFILE}/settings.json")" || { echo "Error: profile '${PROFILE}' not found."; exit 1; }
echo "$SETTINGS" > "${CLAUDE_DIR}/settings.json"

if [[ ! -f "${CLAUDE_DIR}/CLAUDE.md" ]]; then
  CLAUDE_MD="$(fetch_file "profiles/${PROFILE}/CLAUDE.md" 2>/dev/null)" || true
  [[ -n "${CLAUDE_MD:-}" ]] && echo "$CLAUDE_MD" > "${CLAUDE_DIR}/CLAUDE.md"
fi

echo "Profile '${PROFILE}' applied to ${TARGET_DIR}/.claude/"
echo "Run: cd ${TARGET_DIR} && claude"
