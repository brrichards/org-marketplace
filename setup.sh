#!/usr/bin/env bash
set -euo pipefail

MARKETPLACE_REPO="${MARKETPLACE_REPO:-https://github.com/brrichards/org-marketplace.git}"
MARKETPLACE_REF="${MARKETPLACE_REF:-main}"
MARKETPLACE_HOME="${MARKETPLACE_HOME:-$HOME/.org-marketplace}"
PROFILE="default"
TARGET_DIR="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile) PROFILE="$2"; shift 2 ;;
    --target)  TARGET_DIR="$2"; shift 2 ;;
    --home)    MARKETPLACE_HOME="$2"; shift 2 ;;
    *)         echo "Unknown argument: $1"; exit 1 ;;
  esac
done

TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || { echo "Error: target dir not found: $TARGET_DIR"; exit 1; }

# Install Claude Code if missing
if ! command -v claude &>/dev/null && [[ "${CLAUDE_SKIP_INSTALL:-0}" != "1" ]]; then
  echo "Installing Claude Code…"
  npm install -g @anthropic-ai/claude-code
fi

# Clone or update the marketplace
if [[ -d "$MARKETPLACE_HOME/.git" ]]; then
  echo "Updating marketplace at ${MARKETPLACE_HOME}…"
  git -C "$MARKETPLACE_HOME" fetch origin "$MARKETPLACE_REF" --quiet
  git -C "$MARKETPLACE_HOME" checkout "$MARKETPLACE_REF" --quiet 2>/dev/null || git -C "$MARKETPLACE_HOME" checkout "origin/$MARKETPLACE_REF" --quiet
  git -C "$MARKETPLACE_HOME" pull --ff-only --quiet 2>/dev/null || true
else
  echo "Cloning marketplace to ${MARKETPLACE_HOME}…"
  git clone --branch "$MARKETPLACE_REF" "$MARKETPLACE_REPO" "$MARKETPLACE_HOME" --quiet
fi

# Validate profile exists
PROFILE_DIR="${MARKETPLACE_HOME}/profiles/${PROFILE}"
if [[ ! -f "${PROFILE_DIR}/settings.json" ]]; then
  echo "Error: profile '${PROFILE}' not found at ${PROFILE_DIR}"
  echo ""
  echo "Available profiles:"
  for dir in "${MARKETPLACE_HOME}"/profiles/*/; do
    [[ -f "${dir}settings.json" ]] && echo "  - $(basename "$dir")"
  done
  exit 1
fi

# Apply profile to target
CLAUDE_DIR="${TARGET_DIR}/.claude"
rm -rf "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR"
cp -R "${PROFILE_DIR}/." "$CLAUDE_DIR/"

echo "Profile '${PROFILE}' applied to ${TARGET_DIR}/.claude/"

# Show enabled plugins
ENABLED=$(python3 -c "
import json, sys
s = json.load(open('${CLAUDE_DIR}/settings.json'))
plugins = [k for k, v in s.get('enabledPlugins', {}).items() if v]
print(', '.join(plugins) if plugins else '(none)')
" 2>/dev/null || echo "(unknown)")
echo "Enabled plugins: ${ENABLED}"

# Print available profiles
echo ""
echo "Available profiles:"
for dir in "${MARKETPLACE_HOME}"/profiles/*/; do
  [[ -f "${dir}settings.json" ]] && echo "  - $(basename "$dir")"
done
echo ""
echo "Swap profiles anytime with:"
echo "  npx tsx ${MARKETPLACE_HOME}/scripts/swap-profile.ts swap <profile> ${TARGET_DIR}"
echo "  or use /profiles swap <name> inside Claude Code"
