# secret-check

## Trigger

When the user writes or modifies code that may contain secrets, API keys, tokens, or credentials.

## Instructions

Scan code for hardcoded secrets and sensitive data that should not be committed to source control. This skill activates automatically when code changes may introduce secrets.

### Patterns to Detect

#### AWS Credentials
- AWS Access Key IDs matching `AKIA[0-9A-Z]{16}`
- AWS Secret Access Keys (40-character base64 strings following key identifiers)
- AWS Session Tokens

#### API Keys and Tokens
- Generic API key patterns: variables or strings named `api_key`, `apikey`, `api-key`, `apiKey` with literal values assigned
- Bearer tokens hardcoded in authorization headers
- OAuth client secrets
- JWT tokens (strings matching `eyJ[A-Za-z0-9_-]+\.eyJ[A-Za-z0-9_-]+`)
- GitHub tokens (`ghp_`, `gho_`, `ghu_`, `ghs_`, `ghr_` prefixes)
- Slack tokens (`xoxb-`, `xoxp-`, `xoxs-` prefixes)
- Stripe keys (`sk_live_`, `pk_live_` prefixes)
- Google API keys (`AIza[0-9A-Za-z_-]{35}`)

#### Passwords and Connection Strings
- Password assignments: `password = "..."`, `passwd`, `pwd`, `secret` with string literal values
- Database connection strings with embedded credentials (e.g., `postgresql://user:pass@host/db`)
- SMTP credentials with embedded passwords
- Redis URLs with passwords (`redis://:password@host`)

#### Private Keys and Certificates
- PEM-encoded private keys (`-----BEGIN RSA PRIVATE KEY-----`, `-----BEGIN EC PRIVATE KEY-----`, `-----BEGIN PRIVATE KEY-----`)
- PKCS#8 and PKCS#12 key material
- SSH private keys (`-----BEGIN OPENSSH PRIVATE KEY-----`)

#### Base64-Encoded Secrets
- Suspiciously long base64 strings (> 40 characters) assigned to secret-related variable names
- Basic auth headers with base64-encoded credentials

### Recommended Alternatives

When a secret is detected, suggest the appropriate alternative:

1. **Environment Variables**: `process.env.API_KEY`, `os.environ["API_KEY"]`, `std::env::var("API_KEY")`
2. **Secret Managers**: AWS Secrets Manager, HashiCorp Vault, Azure Key Vault, GCP Secret Manager
3. **Configuration Files**: `.env` files (added to `.gitignore`), platform-specific config stores
4. **CI/CD Secrets**: GitHub Actions secrets, GitLab CI variables, Jenkins credentials

### Response Format

When secrets are detected:

1. Identify the specific pattern matched and its location
2. Explain why this is a security risk
3. Provide a concrete code example showing how to replace the hardcoded secret with a secure alternative appropriate for the project's language and framework
4. Remind the user to add any local secret files (`.env`) to `.gitignore`
5. If the secret may have already been committed, advise rotating the credential immediately and purging it from git history using `git filter-repo` or BFG Repo-Cleaner
