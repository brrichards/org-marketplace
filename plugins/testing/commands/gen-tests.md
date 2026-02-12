---
name: gen-tests
description: Generate tests for specified files or functions
---

Analyze the specified source files, identify all testable functions, methods, and classes, and generate comprehensive test suites.

## Framework Detection

Detect the project's test framework automatically by inspecting configuration files and dependencies:

- **JavaScript/TypeScript**: jest, vitest, mocha, ava (check package.json)
- **Python**: pytest, unittest (check pytest.ini, setup.cfg, pyproject.toml, or imports)
- **Go**: go test (check go.mod)
- **Rust**: cargo test (check Cargo.toml)
- **Ruby**: rspec, minitest (check Gemfile)

Generate tests in the appropriate style and syntax for the detected framework.

## Test Generation Guidelines

For each testable unit, generate tests covering:

1. **Happy paths** — Verify correct behavior with valid, expected inputs.
2. **Edge cases** — Empty inputs, single-element collections, maximum/minimum values, unicode strings, zero values.
3. **Error conditions** — Invalid inputs, null/undefined/nil values, out-of-range arguments, malformed data.
4. **Boundary values** — Off-by-one scenarios, integer overflow boundaries, empty vs. non-empty distinctions.

## Test Structure

- Use descriptive test names that explain the scenario and expected outcome.
- Group related tests using describe/context blocks where the framework supports it.
- Include proper setup and teardown to avoid test interdependence.
- Use meaningful assertion messages where supported.
- Mock external dependencies (network, filesystem, databases) appropriately.

## File Placement

Place generated test files in the project's conventional test location:

- **Jest/Vitest**: `__tests__/` directory or `*.test.{js,ts,jsx,tsx}` co-located with source
- **Pytest**: `tests/` directory with `test_*.py` naming
- **Go**: `*_test.go` co-located with source
- **Rust**: Inline `#[cfg(test)]` module or `tests/` directory
- **RSpec**: `spec/` directory with `*_spec.rb` naming

If the project already has tests, follow the existing conventions for location and naming.
