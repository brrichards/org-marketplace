# scan

## Description

Run a security scan on the codebase

## Instructions

Scan the specified files or entire project for security vulnerabilities. Analyze source code to identify the following classes of issues:

### Vulnerability Categories

1. **SQL Injection** - Look for unsanitized user input concatenated into SQL queries, use of raw query methods without parameterized statements, and ORM misuse that bypasses query parameterization.

2. **Cross-Site Scripting (XSS)** - Identify unescaped user input rendered in HTML templates, use of `innerHTML`, `dangerouslySetInnerHTML`, `v-html`, or equivalent without sanitization, and reflected or stored XSS vectors.

3. **Command Injection** - Find user input passed to `exec`, `spawn`, `system`, `popen`, `subprocess`, or shell invocations without proper escaping or allowlisting.

4. **Path Traversal** - Detect user-controlled file paths that are not validated or sanitized, missing checks for `../` sequences, and symlink-following vulnerabilities.

5. **Insecure Deserialization** - Flag use of `pickle.loads`, `yaml.load` (without SafeLoader), `unserialize`, `JSON.parse` on untrusted input fed to constructors, and Java `ObjectInputStream` on untrusted data.

6. **Hardcoded Credentials** - Identify hardcoded passwords, API keys, tokens, connection strings with embedded credentials, and private keys committed to source.

7. **Weak Cryptography** - Flag use of MD5, SHA1 for security purposes, DES, RC4, ECB mode, small key sizes, and custom cryptographic implementations.

8. **Insecure HTTP Usage** - Detect HTTP URLs where HTTPS should be used, disabled TLS certificate verification, weak TLS versions (< 1.2), and missing security headers.

9. **Other OWASP Top 10 Issues** - Check for broken authentication patterns, sensitive data exposure, XML External Entity (XXE) processing, broken access control, security misconfiguration, insufficient logging, and server-side request forgery (SSRF).

### Output Format

Present findings as a structured report with the following fields for each vulnerability:

- **Severity**: CRITICAL / HIGH / MEDIUM / LOW / INFO
- **Category**: The vulnerability class (e.g., SQL Injection, XSS)
- **Location**: File path and line number(s)
- **Description**: Clear explanation of the vulnerability and its potential impact
- **Code Snippet**: The relevant vulnerable code
- **Remediation**: Specific guidance on how to fix the issue, with code examples where appropriate

End the report with a summary table showing counts by severity and category.

If no files are specified, scan the entire project. Respect `.gitignore` patterns and skip `node_modules`, `vendor`, `venv`, `.git`, and other common dependency/build directories.
