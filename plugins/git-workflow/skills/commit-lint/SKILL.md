---
name: commit-lint
trigger: When the user writes or asks about commit messages
---

# Commit Lint Skill

Validate and correct commit messages against the Conventional Commits specification.

## Instructions

When a user provides a commit message or asks about commit message formatting, validate it against the following rules and provide feedback.

### Conventional Commits Format

```
type(scope): description

[optional body]

[optional footer(s)]
```

### Validation Rules

1. **Type (required):** Must be one of the following:
   - `feat` -- A new feature
   - `fix` -- A bug fix
   - `chore` -- Maintenance tasks or tooling
   - `docs` -- Documentation changes
   - `style` -- Code formatting (not CSS)
   - `refactor` -- Code restructuring without behavior change
   - `test` -- Adding or modifying tests
   - `perf` -- Performance improvements
   - `ci` -- CI/CD configuration changes
   - `build` -- Build system or dependency changes

2. **Scope (optional):** A noun in parentheses describing the section of the codebase affected.
   - Must be lowercase.
   - Must be a single word or hyphenated (e.g., `auth`, `user-api`).
   - Example: `feat(auth): add OAuth2 support`

3. **Breaking change indicator (optional):** An `!` placed after the type/scope and before the colon.
   - Example: `feat(api)!: remove deprecated endpoints`

4. **Description (required):**
   - Must start with a lowercase letter.
   - Must use imperative mood ("add" not "added" or "adds").
   - Must not end with a period.
   - Should be 72 characters or fewer.

5. **Body (optional):**
   - Separated from the description by a blank line.
   - Should explain the "what" and "why" of the change, not the "how".
   - Wrap at 72 characters per line.

6. **Footer (optional):**
   - Separated from the body by a blank line.
   - Used for referencing issues: `Closes #123`, `Fixes #456`.
   - Breaking changes can also be noted here: `BREAKING CHANGE: description`.

### Validation Process

When checking a commit message:

1. Parse the first line (header) and check it matches the pattern: `type(scope)?: description`
2. Verify the type is in the allowed list.
3. If a scope is present, verify it is lowercase and properly formatted.
4. Verify the description starts with a lowercase letter and does not end with a period.
5. Check the description length (warn if over 72 characters).
6. If a body is present, verify it is separated by a blank line.
7. If footers are present, verify their format.

### Response Format

For each commit message, provide:

- **Valid** or **Invalid** status.
- If invalid, list each issue found.
- Provide a corrected version of the message.
- If valid, confirm and optionally suggest improvements.

### Examples

**Valid messages:**
- `feat: add user authentication`
- `fix(parser): handle empty input gracefully`
- `chore!: drop support for Node 14`
- `docs(readme): update installation instructions`

**Invalid messages and corrections:**
- `Added new feature` -> `feat: add new feature`
- `Fix: Bug in parser.` -> `fix(parser): resolve parsing bug`
- `FEAT: Add Login` -> `feat: add login`
- `update stuff` -> `chore: update dependencies` (needs a type prefix and clearer description)
