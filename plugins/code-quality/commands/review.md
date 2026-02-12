---
name: review
description: Run a code review on specified files or the current changeset
---

Perform a thorough code review on the files the user specifies. If no files are specified, run `git diff` (and `git diff --cached`) to identify the current changeset and review those changes instead.

Analyze the code for all of the following categories:

1. **Anti-patterns** -- Identify any well-known anti-patterns (god objects, spaghetti code, magic numbers, premature optimization, etc.).
2. **Code smells** -- Flag duplicated code, dead code, overly long functions, deep nesting, and feature envy.
3. **Complexity issues** -- Call out functions or blocks with high cyclomatic complexity, excessive branching, or convoluted control flow.
4. **Naming conventions** -- Check that variable, function, class, and file names are clear, consistent, and follow the project's conventions.
5. **Best practices violations** -- Look for missing error handling, unsafe type coercions, security concerns, missing input validation, and anything that deviates from widely accepted best practices for the language in use.

Output a structured report in the following format:

```
## Code Review Report

### Critical
- [file:line] Description of the issue and why it is critical
  **Suggestion:** Concrete fix or refactored code

### Warning
- [file:line] Description of the issue
  **Suggestion:** Concrete fix or refactored code

### Info
- [file:line] Description of the minor issue or improvement opportunity
  **Suggestion:** Recommended improvement

### Summary
- Total issues found: N (X critical, Y warnings, Z info)
- Overall assessment of code quality
```

Be specific -- always reference exact file paths and line numbers. Provide actionable suggestions with concrete code examples wherever possible. If the code is clean, say so and highlight what was done well.
