# Developer Profile

Standard development workflow with code quality, git conventions, and testing plugins.

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

### testing
- `/testing:gen-tests` — Generate tests for specified files or functions
- `/testing:coverage` — Analyze test coverage and identify gaps
- `test-writer` agent — TDD workflow assistant (test first, then implement)
- `test-fix` skill — Diagnoses failing tests and suggests fixes
- Session start hook detects the project's test framework

## Permissions

Standard deny-list for destructive commands (no force push, no `rm -rf /`, etc.).

## Switch Profiles

```
/profiles list
/profiles swap <name>
```
