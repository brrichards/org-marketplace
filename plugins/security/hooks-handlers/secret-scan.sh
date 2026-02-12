#!/usr/bin/env bash
#
# secret-scan.sh
# Pre-tool-use hook that scans tool input for hardcoded secrets.
# Reads from $CLAUDE_TOOL_INPUT and exits with:
#   0 - No secrets detected (allow the operation)
#   2 - Secrets detected (block the operation with a warning)
#

set -euo pipefail

INPUT="${CLAUDE_TOOL_INPUT:-}"

if [ -z "$INPUT" ]; then
  exit 0
fi

MATCHES=()

# --- AWS Access Key IDs ---
if echo "$INPUT" | grep -qE 'AKIA[0-9A-Z]{16}'; then
  MATCHES+=("AWS Access Key ID (AKIA...)")
fi

# --- AWS Secret Access Keys (40-char base64 after common key names) ---
if echo "$INPUT" | grep -qEi '(aws_secret_access_key|secret_key|secretkey)\s*[=:]\s*[A-Za-z0-9/+=]{40}'; then
  MATCHES+=("AWS Secret Access Key")
fi

# --- Generic API key assignments ---
if echo "$INPUT" | grep -qEi '(api_key|apikey|api-key|apiKey)\s*[=:]\s*["\x27][A-Za-z0-9_\-]{16,}["\x27]'; then
  MATCHES+=("Generic API Key")
fi

# --- GitHub tokens ---
if echo "$INPUT" | grep -qE 'gh[pousr]_[A-Za-z0-9_]{36,}'; then
  MATCHES+=("GitHub Token")
fi

# --- Slack tokens ---
if echo "$INPUT" | grep -qE 'xox[bpsar]-[A-Za-z0-9\-]{10,}'; then
  MATCHES+=("Slack Token")
fi

# --- Stripe secret keys ---
if echo "$INPUT" | grep -qE 'sk_live_[A-Za-z0-9]{20,}'; then
  MATCHES+=("Stripe Secret Key")
fi

# --- Google API keys ---
if echo "$INPUT" | grep -qE 'AIza[0-9A-Za-z_\-]{35}'; then
  MATCHES+=("Google API Key")
fi

# --- Password assignments ---
if echo "$INPUT" | grep -qEi '(password|passwd|pwd)\s*[=:]\s*["\x27][^"\x27]{4,}["\x27]'; then
  MATCHES+=("Hardcoded Password")
fi

# --- Secret assignments ---
if echo "$INPUT" | grep -qEi '(secret|token|credential)\s*[=:]\s*["\x27][A-Za-z0-9_\-/+=]{8,}["\x27]'; then
  MATCHES+=("Hardcoded Secret/Token/Credential")
fi

# --- Private key headers ---
if echo "$INPUT" | grep -qE '-----BEGIN (RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----'; then
  MATCHES+=("Private Key (PEM-encoded)")
fi

# --- Database connection strings with passwords ---
if echo "$INPUT" | grep -qEi '(postgres|mysql|mongodb|redis|amqp|mssql)://[^:]+:[^@]+@'; then
  MATCHES+=("Database Connection String with Embedded Password")
fi

# --- JWT tokens ---
if echo "$INPUT" | grep -qE 'eyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}'; then
  MATCHES+=("JWT Token")
fi

# --- Basic Auth headers ---
if echo "$INPUT" | grep -qEi 'Authorization:\s*Basic\s+[A-Za-z0-9+/=]{10,}'; then
  MATCHES+=("Basic Auth Header with Credentials")
fi

# --- Check results ---
if [ ${#MATCHES[@]} -eq 0 ]; then
  exit 0
fi

# Build warning message
echo "BLOCKED: Potential secrets detected in tool input."
echo ""
echo "The following secret patterns were matched:"
for match in "${MATCHES[@]}"; do
  echo "  - $match"
done
echo ""
echo "Recommendations:"
echo "  1. Use environment variables instead of hardcoding secrets."
echo "  2. Store secrets in a .env file and add it to .gitignore."
echo "  3. Use a secret manager (AWS Secrets Manager, HashiCorp Vault, etc.)."
echo "  4. If this is a false positive, review the flagged patterns and adjust the code."

exit 2
