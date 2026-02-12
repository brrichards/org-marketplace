# Security Plugin for Claude Code

Security scanning, secrets detection, and OWASP-focused code review for Claude Code.

## Overview

This plugin provides a comprehensive security toolkit that integrates directly into your Claude Code workflow. It includes automated scanning commands, a dedicated security review agent, a secret-detection skill, and pre-write hooks that block hardcoded secrets from being introduced into your codebase.

## Components

### Commands

#### `/scan` - Security Scan

Run a full security scan on your codebase or specific files.

```
/scan
/scan src/api/
/scan src/auth/login.ts
```

Checks for:
- SQL injection
- Cross-site scripting (XSS)
- Command injection
- Path traversal
- Insecure deserialization
- Hardcoded credentials
- Weak cryptography
- Insecure HTTP usage
- Other OWASP Top 10 issues

Produces a structured report with severity ratings, locations, descriptions, and remediation guidance.

#### `/audit-deps` - Dependency Audit

Audit your project's third-party dependencies for known vulnerabilities.

```
/audit-deps
```

Supports the following package managers:
- **npm** / **Yarn** / **pnpm** (JavaScript/TypeScript)
- **pip** (Python)
- **Cargo** (Rust)
- **Go modules** (Go)
- **Bundler** (Ruby)
- **Composer** (PHP)
- **pub** (Dart/Flutter)

Presents a severity-categorized summary with specific upgrade, replace, or accept-risk recommendations.

### Agents

#### `security-reviewer` - OWASP Security Code Reviewer

An autonomous agent that performs deep security-focused code review.

```
Ask the security-reviewer agent to review src/api/ for security issues.
```

**Model**: Sonnet
**Tools**: Read, Glob, Grep, Bash

Reviews code against the full OWASP Top 10:
- A01: Broken Access Control
- A02: Cryptographic Failures
- A03: Injection
- A04: Insecure Design
- A05: Security Misconfiguration
- A06: Vulnerable and Outdated Components
- A07: Identification and Authentication Failures
- A08: Software and Data Integrity Failures
- A09: Security Logging and Monitoring Failures
- A10: Server-Side Request Forgery (SSRF)

Also checks for input validation gaps, error handling that leaks information, insecure configurations, and hardcoded secrets.

### Skills

#### `secret-check` - Hardcoded Secret Detection

Automatically activates when code is written or modified that may contain secrets.

Detects:
- AWS access keys and secret keys (`AKIA...`)
- GitHub, Slack, and Stripe tokens
- Google API keys
- Generic API key and password assignments
- PEM-encoded private keys
- Database connection strings with embedded credentials
- JWT tokens
- Base64-encoded credentials

Suggests secure alternatives:
- Environment variables (`process.env.API_KEY`, `os.environ["API_KEY"]`)
- Secret managers (AWS Secrets Manager, HashiCorp Vault)
- `.env` files (with `.gitignore` inclusion)
- CI/CD secret storage

### Hooks

#### Pre-Write Secret Scanning

Automatically scans content before any `Write` or `Edit` tool use. If hardcoded secrets are detected, the operation is blocked with a warning listing the matched patterns.

**Monitored patterns**:
- AWS Access Key IDs and Secret Access Keys
- Generic API keys, tokens, and credentials
- GitHub, Slack, Stripe, and Google tokens
- Passwords in assignments
- Private key headers (RSA, EC, OPENSSH, DSA)
- Database connection strings with embedded passwords
- JWT tokens
- Basic Auth headers

The hook handler script is located at `hooks-handlers/secret-scan.sh`.

## File Structure

```
plugins/security/
├── .claude-plugin/
│   └── plugin.json              # Plugin metadata
├── commands/
│   ├── scan.md                  # Security scanning command
│   └── audit-deps.md            # Dependency audit command
├── agents/
│   └── security-reviewer.md     # OWASP-focused review agent
├── skills/
│   └── secret-check/
│       └── SKILL.md             # Secret detection skill
├── hooks/
│   └── hooks.json               # Hook definitions
├── hooks-handlers/
│   └── secret-scan.sh           # Secret scanning hook script
└── README.md                    # This file
```

## Installation

This plugin is available through the Org Marketplace. Install it using the marketplace CLI or by adding it to your organization's plugin configuration.

## Configuration

No additional configuration is required. The plugin works out of the box with sensible defaults.

To customize secret detection patterns, edit `hooks-handlers/secret-scan.sh` and add or modify the regex patterns in the detection section.

## Examples

### Run a full project security scan

```
> /scan

Scanning project for security vulnerabilities...

| Severity | Category          | Count |
|----------|-------------------|-------|
| CRITICAL | SQL Injection     | 1     |
| HIGH     | XSS               | 3     |
| MEDIUM   | Hardcoded Secrets | 2     |
| LOW      | Weak Crypto       | 1     |
```

### Audit dependencies

```
> /audit-deps

Detected: npm (package-lock.json)
Running npm audit...

| Severity | Count |
|----------|-------|
| Critical | 0     |
| High     | 2     |
| Medium   | 5     |
| Low      | 3     |

Recommended fixes:
  npm install lodash@4.17.21
  npm install axios@1.6.0
```

### Blocked secret in a write operation

```
Writing file src/config.ts...
BLOCKED: Potential secrets detected in tool input.

The following secret patterns were matched:
  - AWS Access Key ID (AKIA...)
  - Hardcoded Password

Recommendations:
  1. Use environment variables instead of hardcoding secrets.
  2. Store secrets in a .env file and add it to .gitignore.
  3. Use a secret manager (AWS Secrets Manager, HashiCorp Vault, etc.).
```
