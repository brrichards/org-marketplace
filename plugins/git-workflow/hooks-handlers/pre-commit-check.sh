#!/usr/bin/env bash
# pre-commit-check.sh
#
# PreToolUse hook that validates conventional commit message format
# whenever Claude Code attempts to run a "git commit" command.
#
# Reads the tool input from $CLAUDE_TOOL_INPUT (JSON), checks if the
# command contains "git commit", and if so, validates the commit message
# against the conventional commits pattern.
#
# Exit codes:
#   0 - Allow the tool call (valid commit or not a commit command)
#   2 - Block the tool call with an error message (invalid commit format)

set -euo pipefail

# Read the tool input JSON
TOOL_INPUT="${CLAUDE_TOOL_INPUT:-}"

if [ -z "$TOOL_INPUT" ]; then
  # No input provided, allow the call
  exit 0
fi

# Extract the command string from the JSON input
COMMAND=$(echo "$TOOL_INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('command', ''))
except (json.JSONDecodeError, KeyError):
    print('')
" 2>/dev/null || echo "")

# If the command does not contain "git commit", allow it
if ! echo "$COMMAND" | grep -q "git commit"; then
  exit 0
fi

# If it is a git commit --amend with no new message, allow it
if echo "$COMMAND" | grep -q -- "--amend.*--no-edit"; then
  exit 0
fi

# Extract the commit message from -m flag
# Handles: git commit -m "message", git commit -m 'message', git commit -m message
COMMIT_MSG=$(echo "$COMMAND" | python3 -c "
import sys, re

command = sys.stdin.read().strip()

# Try to match -m with double-quoted string
match = re.search(r'-m\s+\"([^\"]+)\"', command)
if match:
    print(match.group(1))
    sys.exit(0)

# Try to match -m with single-quoted string
match = re.search(r\"-m\s+'([^']+)'\", command)
if match:
    print(match.group(1))
    sys.exit(0)

# Try to match -m with HEREDOC pattern: -m \"\$(cat <<'EOF' ... EOF)\"
match = re.search(r'-m\s+\"\\\$\(cat\s+<<.*?EOF.*?\n(.*?)\nEOF', command, re.DOTALL)
if match:
    # Get the first line of the heredoc content (the commit header)
    lines = match.group(1).strip().split('\n')
    print(lines[0].strip())
    sys.exit(0)

# Try to match -m with unquoted single word
match = re.search(r'-m\s+(\S+)', command)
if match:
    print(match.group(1))
    sys.exit(0)

print('')
" 2>/dev/null || echo "")

# If we could not extract a commit message, allow the call
# (it might be using an editor or a different format)
if [ -z "$COMMIT_MSG" ]; then
  exit 0
fi

# Get just the first line (header) for validation
HEADER=$(echo "$COMMIT_MSG" | head -n 1)

# Define valid conventional commit types
VALID_TYPES="feat|fix|chore|docs|style|refactor|test|perf|ci|build"

# Validate against conventional commit pattern: type(scope)?: description
# Pattern: type followed by optional (scope) followed by optional ! followed by : space description
if echo "$HEADER" | grep -qE "^(${VALID_TYPES})(\([a-z][a-z0-9-]*\))?!?: .+$"; then
  # Valid conventional commit format
  exit 0
else
  echo "BLOCKED: Commit message does not follow conventional commit format." >&2
  echo "" >&2
  echo "  Received: $HEADER" >&2
  echo "" >&2
  echo "  Expected format: type(scope): description" >&2
  echo "  Valid types: feat, fix, chore, docs, style, refactor, test, perf, ci, build" >&2
  echo "" >&2
  echo "  Examples:" >&2
  echo "    feat(auth): add OAuth2 login support" >&2
  echo "    fix: resolve null pointer in user service" >&2
  echo "    chore(deps): update lodash to v4.17.21" >&2
  exit 2
fi
