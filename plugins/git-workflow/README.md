# git-workflow

Git conventions, conventional commits, and PR workflow automation for Claude Code.

This plugin enforces consistent git practices across your team by providing commands, agents, skills, and hooks that standardize commit messages, pull requests, and general git operations.

## Components

### Plugin Manifest

**File:** `.claude-plugin/plugin.json`

Defines the plugin metadata including name, description, version, and author. This file is required for the plugin to be recognized by the Claude Code plugin system.

### Commands

#### `/commit`

**File:** `commands/commit.md`

Creates a conventional commit by analyzing your staged changes.

**Usage:**
1. Stage your changes with `git add`.
2. Run the `/commit` command.
3. Claude will analyze the diff, determine the commit type and scope, and propose a message.
4. Review and approve (or edit) the proposed message.
5. The commit is executed automatically.

**Example interaction:**
```
> /commit
Analyzing staged changes...

Proposed commit message:
  feat(auth): add JWT token refresh endpoint

Shall I proceed with this commit? (yes/no/edit)
```

#### `/pr`

**File:** `commands/pr.md`

Generates a pull request with a structured summary, description, and test plan.

**Usage:**
1. Ensure all changes are committed on your feature branch.
2. Run the `/pr` command.
3. Claude will analyze all commits since the branch diverged from the base branch.
4. Review the generated PR title and body.
5. The PR is created via the `gh` CLI.

**Example interaction:**
```
> /pr
Analyzing 5 commits on feature/user-auth vs main...

Proposed PR:
  Title: Add user authentication with JWT tokens
  Body:
    ## Summary
    - Add JWT-based authentication flow
    - Implement token refresh mechanism
    - Add auth middleware for protected routes

    ## Description
    This PR introduces a complete JWT authentication system...

    ## Test plan
    - [ ] Verify login returns valid JWT token
    - [ ] Verify token refresh works before expiry
    - [ ] Verify expired tokens are rejected

Create this PR? (yes/no/edit)
```

### Agents

#### git-helper

**File:** `agents/git-helper.md`

A specialized agent for git operations that assists with branching, rebasing, conflict resolution, and more.

**Capabilities:**
- **Branching strategies:** Create and manage branches following GitHub Flow, Git Flow, or trunk-based development.
- **Rebasing:** Interactive rebases, rebase onto updated base branches, and advanced `--onto` operations.
- **Conflict resolution:** Walk through merge conflicts step by step, explaining both sides.
- **Cherry-picking:** Pick specific commits between branches and handle resulting conflicts.
- **History management:** Amend commits, squash, reorder, recover lost commits with reflog, and bisect.

**Safety features:**
- Always explains commands before running them.
- Never force-pushes without explicit user confirmation.
- Suggests backup branches before destructive operations.

### Skills

#### commit-lint

**File:** `skills/commit-lint/SKILL.md`

Automatically activates when you write or discuss commit messages. Validates messages against the Conventional Commits specification.

**What it checks:**
- Type prefix is valid (`feat`, `fix`, `chore`, `docs`, `style`, `refactor`, `test`, `perf`, `ci`, `build`).
- Scope (if present) is lowercase and properly formatted.
- Description starts with a lowercase letter and uses imperative mood.
- Description does not end with a period.
- Description is 72 characters or fewer.
- Body and footer formatting (if present).

**Example:**
```
> Is this a good commit message? "Added new feature for users."

That message has several issues:
  1. Missing type prefix (e.g., feat, fix)
  2. "Added" should be imperative mood ("add")
  3. Ends with a period

Suggested correction:
  feat(users): add new feature for users
```

### Hooks

#### Pre-commit message validation

**Files:** `hooks/hooks.json`, `hooks-handlers/pre-commit-check.sh`

A PreToolUse hook that automatically intercepts any `git commit` command and validates the commit message format before it executes.

**Behavior:**
- Runs before every Bash tool call.
- If the command is not a `git commit`, it passes through (exit 0).
- If the command is a `git commit`, extracts the message from the `-m` flag.
- Validates the message against the conventional commit pattern.
- Blocks non-conforming commits (exit 2) with a helpful error message showing the expected format.

**Validated pattern:** `type(scope)?: description`

**Example of a blocked commit:**
```
BLOCKED: Commit message does not follow conventional commit format.

  Received: fixed the bug

  Expected format: type(scope): description
  Valid types: feat, fix, chore, docs, style, refactor, test, perf, ci, build

  Examples:
    feat(auth): add OAuth2 login support
    fix: resolve null pointer in user service
    chore(deps): update lodash to v4.17.21
```

## Installation

Install this plugin through the org marketplace:

```bash
# From the org-marketplace root
npm run install-plugin git-workflow
```

Or manually copy the `plugins/git-workflow` directory into your project's `.claude/plugins/` directory.

## Conventional Commits Quick Reference

```
feat(scope): add new feature
fix(scope): fix a bug
chore(scope): maintenance task
docs(scope): documentation change
style(scope): formatting change
refactor(scope): code restructuring
test(scope): add or update tests
perf(scope): performance improvement
ci(scope): CI/CD change
build(scope): build system change
```

Breaking changes append `!` after the type/scope:

```
feat(api)!: remove deprecated v1 endpoints
```
