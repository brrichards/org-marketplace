---
name: coverage
description: Analyze test coverage and identify gaps
---

Run the project's test suite with coverage enabled, analyze the coverage report, and identify untested code paths.

## Coverage Execution

Determine the correct coverage command based on the project's test framework:

- **Jest**: `npx jest --coverage`
- **Vitest**: `npx vitest run --coverage`
- **Pytest**: `pytest --cov=. --cov-report=term-missing`
- **Go**: `go test -coverprofile=coverage.out ./... && go tool cover -func=coverage.out`
- **Cargo**: `cargo tarpaulin` or `cargo llvm-cov`
- **RSpec**: Run with SimpleCov configured

Run the coverage command and capture the output.

## Coverage Analysis

After obtaining the coverage report, analyze it to identify:

1. **Uncovered functions and methods** — List functions with 0% coverage.
2. **Partially covered branches** — Identify conditional branches (if/else, switch/match, ternary) where only some paths are tested.
3. **Untested error handling** — Find catch blocks, error returns, and fallback paths that lack test coverage.
4. **Untested public API surface** — Highlight exported/public functions that are not exercised by any test.

## Prioritization

Rank uncovered areas by risk, with highest priority first:

1. **Complex logic** — Functions with high cyclomatic complexity and no tests.
2. **Error handling paths** — Untested error conditions that could silently fail in production.
3. **Public API surface** — Exported interfaces that consumers depend on.
4. **Data validation** — Input parsing and validation logic without coverage.
5. **Integration points** — Code that interacts with external systems (database queries, API calls, file I/O).

## Output

For each coverage gap, provide:

- The file path and line numbers of the uncovered code.
- A brief explanation of why this gap matters.
- A concrete test suggestion: a description of the test case(s) that would cover the gap, including setup, action, and assertion.
