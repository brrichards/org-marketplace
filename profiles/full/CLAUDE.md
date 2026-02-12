# Full Profile

All plugins enabled — code quality, git workflow, security scanning, and testing.

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

### testing
- `/testing:gen-tests` — Generate tests for specified files or functions
- `/testing:coverage` — Analyze test coverage and identify gaps
- `test-writer` agent — TDD workflow assistant (test first, then implement)
- `test-fix` skill — Diagnoses failing tests and suggests fixes
- Session start hook detects the project's test framework

## Extended Deny-List

This profile includes the extended deny-list from the secure-dev profile, blocking remote code execution, package publishing, and unconfirmed package execution.

## Switch Profiles

```
/profiles list
/profiles swap <name>
```
