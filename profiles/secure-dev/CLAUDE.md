# Secure Dev Profile

Security-focused development workflow with code quality, git conventions, and security scanning plugins. Extended deny-list blocks additional risky commands.

## Enabled Plugins

### code-quality
- `/code-quality:review` — Run a code review on files or the current changeset
- `/code-quality:refactor` — Get refactoring suggestions for specified code
- `reviewer` agent — Deep analysis for anti-patterns and code smells
- `lint-explain` skill — Explains lint rule violations and suggests fixes

### git-workflow
- `/git-workflow:commit` — Create a conventional commit with a formatted message
- `/git-workflow:pr` — Generate a pull request with summary and test plan
- `git-helper` agent — Assists with branching, rebasing, and conflict resolution
- `commit-lint` skill — Validates commit messages against conventional commits spec
- Pre-commit hook validates commit message format automatically

### security
- `/security:scan` — Run a security scan on the codebase (OWASP Top 10)
- `/security:audit-deps` — Audit project dependencies for known vulnerabilities
- `security-reviewer` agent — OWASP-focused security code review
- `secret-check` skill — Detects hardcoded secrets, API keys, and credentials
- Pre-write hook blocks file writes containing secret patterns

## Extended Deny-List

This profile blocks additional risky commands beyond the standard deny-list:
- Remote code execution (`curl | bash`, `eval`)
- Package publishing (`npm publish`)
- Unconfirmed package execution (`npx --yes`)

## Switch Profiles

```
/profiles list
/profiles swap <name>
```
