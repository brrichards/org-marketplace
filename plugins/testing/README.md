# Testing Plugin

Test generation, TDD workflow, and coverage analysis for Claude Code.

## Components

### Commands

#### `/gen-tests`

Generate comprehensive test suites for specified files or functions.

- Automatically detects the project's test framework (jest, pytest, go test, cargo test, vitest, mocha, ava, rspec, minitest).
- Generates tests covering happy paths, edge cases, error conditions, and boundary values.
- Places test files in the project's conventional test directory.

**Usage:**

```
/gen-tests src/utils/parser.ts
/gen-tests -- generate tests for the User model
```

#### `/coverage`

Analyze test coverage and identify untested code paths.

- Runs the test suite with coverage enabled.
- Identifies uncovered functions, partially covered branches, and untested error handling.
- Prioritizes gaps by risk: complex logic, error handling, public API surface.
- Provides concrete test suggestions for each gap.

**Usage:**

```
/coverage
/coverage -- focus on the authentication module
```

### Agents

#### `test-writer`

A TDD workflow assistant that guides you through the red-green-refactor cycle.

- **Red**: Helps you write a focused, failing test that captures the desired behavior.
- **Green**: Guides you to write the minimal implementation that makes the test pass.
- **Refactor**: Identifies opportunities to improve code quality while keeping tests green.

Supports jest, pytest, go test, vitest, mocha, and cargo test.

**Usage:**

```
Ask the test-writer agent to help you build a new feature using TDD.
```

### Skills

#### `test-fix`

Diagnoses failing tests and suggests fixes.

- Reads test runner error output and stack traces.
- Examines both the test code and the implementation under test.
- Classifies failures: implementation bug, outdated test, missing mock, environment issue, test isolation failure, or flaky test.
- Suggests the specific code change needed, distinguishing between test bugs and implementation bugs.

**Trigger:** Activated when you have failing tests or ask about test failures.

### Hooks

#### Session Start — Framework Detection

On session start, the plugin runs `detect-test-framework.sh` to scan the project for known test framework configuration files and reports what it finds. This is informational only and does not modify any files.

Detected frameworks include:

| File Checked         | Frameworks Detected          |
|----------------------|------------------------------|
| `package.json`       | jest, vitest, mocha, ava     |
| `pytest.ini`         | pytest                       |
| `setup.cfg`          | pytest                       |
| `pyproject.toml`     | pytest                       |
| `go.mod`             | go test                      |
| `Cargo.toml`         | cargo test                   |
| `Gemfile`            | rspec, minitest              |

## Installation

Install via the org marketplace:

```
Select the "testing" plugin from the marketplace plugin list.
```

## File Structure

```
plugins/testing/
  .claude-plugin/
    plugin.json          # Plugin metadata
  commands/
    gen-tests.md         # Test generation command
    coverage.md          # Coverage analysis command
  agents/
    test-writer.md       # TDD workflow assistant agent
  skills/
    test-fix/
      SKILL.md           # Failing test diagnosis skill
  hooks/
    hooks.json           # Hook definitions
  hooks-handlers/
    detect-test-framework.sh  # Framework detection script
  README.md              # This file
```
