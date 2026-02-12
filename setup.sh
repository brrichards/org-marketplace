#!/usr/bin/env bash
set -euo pipefail

# ── Org Marketplace · Auto-Install ─────────────────────────────────────────
# Private repo (GITHUB_TOKEN is auto-set in Codespaces):
#   curl -fsSL -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.raw" \
#     "https://api.github.com/repos/brrichards/org-marketplace/contents/setup.sh?ref=main" | bash
# ───────────────────────────────────────────────────────────────────────────

# Defaults (override via environment)
MARKETPLACE_REPO="${MARKETPLACE_REPO:-brrichards/org-marketplace}"
MARKETPLACE_REF="${MARKETPLACE_REF:-main}"
# MARKETPLACE_LOCAL — set to a local checkout to read profiles from disk
PROFILE="default"
TARGET_DIR="."

# ── Parse arguments ────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)  PROFILE="$2";     shift 2 ;;
    --target)   TARGET_DIR="$2";  shift 2 ;;
    *)          echo "Unknown argument: $1"; exit 1 ;;
  esac
done

TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
  echo "Error: target directory does not exist: $TARGET_DIR"
  exit 1
}

# ── Helper: read a file from local checkout or remote ──────────────────────
fetch_file() {
  local rel_path="$1"
  if [[ -n "${MARKETPLACE_LOCAL:-}" ]]; then
    cat "${MARKETPLACE_LOCAL}/${rel_path}"
  else
    local url="https://api.github.com/repos/${MARKETPLACE_REPO}/contents/${rel_path}?ref=${MARKETPLACE_REF}"
    local curl_args=(-fsSL -H "Accept: application/vnd.github.raw")
    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
      curl_args+=(-H "Authorization: token ${GITHUB_TOKEN}")
    fi
    curl "${curl_args[@]}" "$url"
  fi
}

# ── 1. Install Claude Code ─────────────────────────────────────────────────
if [[ "${CLAUDE_SKIP_INSTALL:-0}" == "1" ]]; then
  echo "Skipping Claude Code install (CLAUDE_SKIP_INSTALL=1)"
elif command -v claude &>/dev/null; then
  echo "Claude Code already installed: $(claude --version 2>/dev/null || echo 'unknown version')"
else
  echo "Installing Claude Code …"
  npm install -g @anthropic-ai/claude-code
fi

# ── 2. Verify profile exists ──────────────────────────────────────────────
SETTINGS_CONTENT="$(fetch_file "profiles/${PROFILE}/settings.json" 2>/dev/null)" || {
  echo "Error: profile '${PROFILE}' not found."
  if [[ -n "${MARKETPLACE_LOCAL:-}" ]]; then
    echo "Looked in: ${MARKETPLACE_LOCAL}/profiles/${PROFILE}/"
  else
    echo "Check available profiles at: https://github.com/${MARKETPLACE_REPO}/tree/${MARKETPLACE_REF}/profiles"
  fi
  exit 1
}

# ── 3. Create .claude/ and write files ─────────────────────────────────────
CLAUDE_DIR="${TARGET_DIR}/.claude"
mkdir -p "$CLAUDE_DIR"

# settings.json — always overwrite (authoritative source)
echo "$SETTINGS_CONTENT" > "${CLAUDE_DIR}/settings.json"
echo "Wrote ${CLAUDE_DIR}/settings.json"

# CLAUDE.md — only write if not present (preserve project customizations)
if [[ -f "${CLAUDE_DIR}/CLAUDE.md" ]]; then
  echo "Kept existing ${CLAUDE_DIR}/CLAUDE.md (not overwritten)"
else
  CLAUDE_MD_CONTENT="$(fetch_file "profiles/${PROFILE}/CLAUDE.md" 2>/dev/null)" || true
  if [[ -n "${CLAUDE_MD_CONTENT:-}" ]]; then
    echo "$CLAUDE_MD_CONTENT" > "${CLAUDE_DIR}/CLAUDE.md"
    echo "Wrote ${CLAUDE_DIR}/CLAUDE.md"
  fi
fi

# ── 4. Summary ─────────────────────────────────────────────────────────────
echo ""
echo "── Marketplace profile applied ──────────────────────────"
echo "  Profile:   ${PROFILE}"
echo "  Target:    ${TARGET_DIR}"
if [[ -n "${MARKETPLACE_LOCAL:-}" ]]; then
  echo "  Source:    ${MARKETPLACE_LOCAL} (local)"
else
  echo "  Source:    ${MARKETPLACE_REPO}@${MARKETPLACE_REF}"
fi

# List enabled plugins from settings.json
PLUGINS="$(echo "$SETTINGS_CONTENT" | grep -o '"[^"]*@[^"]*"' | tr -d '"' || true)"
if [[ -n "$PLUGINS" ]]; then
  echo "  Plugins:"
  while IFS= read -r plugin; do
    echo "    - ${plugin}"
  done <<< "$PLUGINS"
else
  echo "  Plugins:   (none)"
fi

echo ""
echo "Next steps:"
echo "  cd ${TARGET_DIR} && claude"
echo "  Claude Code will detect the marketplace and prompt to trust it."
echo "────────────────────────────────────────────────────────────"
