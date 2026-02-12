# audit-deps

## Description

Audit project dependencies for known vulnerabilities

## Instructions

Detect the project's package manager and run the appropriate dependency audit to identify known vulnerabilities in third-party packages.

### Package Manager Detection

Examine the project root for dependency manifest files and determine the appropriate audit strategy:

| File Found | Package Manager | Audit Command |
|---|---|---|
| `package-lock.json` or `package.json` | npm | `npm audit --json` |
| `yarn.lock` | Yarn | `yarn audit --json` |
| `pnpm-lock.yaml` | pnpm | `pnpm audit --json` |
| `requirements.txt` or `Pipfile.lock` | pip | `pip-audit -f json` (install with `pip install pip-audit` if needed) |
| `Cargo.lock` | Cargo | `cargo audit --json` (install with `cargo install cargo-audit` if needed) |
| `go.sum` | Go | `govulncheck ./...` (install with `go install golang.org/x/vuln/cmd/govulncheck@latest` if needed) |
| `Gemfile.lock` | Bundler | `bundle audit check --format json` (install with `gem install bundler-audit` if needed) |
| `composer.lock` | Composer | `composer audit --format=json` |
| `pubspec.lock` | Dart/Flutter | `dart pub outdated --json` |

If multiple package managers are detected, audit all of them.

### Audit Process

1. **Detect** the package manager(s) in use by checking for manifest and lock files.
2. **Run** the appropriate audit command(s) using Bash.
3. **Parse** the output and categorize findings by severity.
4. **Present** a summary report.

### Output Format

For each package manager audited, present:

#### Summary Table

| Severity | Count |
|---|---|
| Critical | N |
| High | N |
| Medium | N |
| Low | N |

#### Detailed Findings

For each vulnerability found:

- **Package**: Package name and installed version
- **Severity**: CRITICAL / HIGH / MEDIUM / LOW
- **Vulnerability**: CVE ID or advisory ID with a brief description
- **Affected Versions**: Version range that is vulnerable
- **Fixed In**: Version that resolves the issue (if available)
- **Recommendation**: One of:
  - **Upgrade**: Specify the target version (e.g., `npm install package@2.1.0`)
  - **Replace**: Suggest an alternative package if the original is unmaintained
  - **Accept Risk**: If no fix is available, explain the risk and any mitigations

#### Recommended Actions

Provide a prioritized list of commands to resolve the most critical issues first. For example:

```bash
# Critical fixes
npm install lodash@4.17.21
npm install minimist@1.2.8

# High severity
npm update axios
```

If the audit tool is not installed, provide installation instructions before proceeding.
