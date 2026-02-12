# Code Quality Plugin

Code review, refactoring suggestions, and best practices enforcement for Claude Code. This plugin provides a suite of tools to help maintain high code quality standards across your organization.

## Components

| Component | Path | Description |
|-----------|------|-------------|
| Command | `commands/review.md` | Slash command: `/code-quality:review` |
| Command | `commands/refactor.md` | Slash command: `/code-quality:refactor` |
| Agent | `agents/reviewer.md` | Deep code analysis agent with tool access |
| Skill | `skills/lint-explain/SKILL.md` | Explains lint errors and how to fix them |

## Commands

### `/code-quality:review`

Runs a comprehensive code review on specified files or the current git changeset.

**Usage:**
- `/code-quality:review` -- Reviews the current uncommitted changes (via `git diff`)
- `/code-quality:review src/auth.ts src/auth.test.ts` -- Reviews specific files

**Output:** A structured report with issues categorized as Critical, Warning, or Info, each with line references and concrete fix suggestions.

### `/code-quality:refactor`

Analyzes code and suggests refactoring improvements with before/after examples.

**Usage:**
- `/code-quality:refactor` -- Scans the current directory for refactoring opportunities
- `/code-quality:refactor src/utils/` -- Analyzes specific files or directories

**Output:** Prioritized list of refactoring opportunities with problem descriptions, recommended techniques, and refactored code examples.

## Agents

### `reviewer`

A thorough code review agent powered by Claude Sonnet. It uses Read, Glob, Grep, and Bash tools to perform deep analysis across your codebase including anti-pattern detection, SOLID principle checks, code smell identification, and complexity analysis.

**Example:**
> Ask the reviewer agent to analyze the authentication module for security issues and code quality.

## Skills

### `lint-explain`

Automatically activates when you encounter a linting error or ask about a lint rule. It explains what the rule enforces, why it exists, shows the correct fix, and links to official documentation.

**Example:**
> "I'm getting an ESLint no-unused-vars error on line 12"
> "What does Pylint C0301 mean?"

## Installation

```bash
# Using the org marketplace CLI
claude --plugin-dir ./plugins/code-quality

# Or add to your profile
# See the org marketplace documentation for profile-based installation
```

## Testing locally

```bash
claude --plugin-dir ./plugins/code-quality
```

Then try:
- `/code-quality:review` to review your current changes
- `/code-quality:refactor` to find refactoring opportunities
- Paste a lint error to trigger the lint-explain skill
