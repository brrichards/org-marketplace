---
name: lint-explain
description: Explains linting errors, why the rule exists, and how to fix the violation
trigger: When the user encounters a linting error or asks about a lint rule
---

# Lint Explain

When triggered by a linting error or a question about a lint rule, follow these steps:

1. **Identify the rule** -- Parse the lint error message or the user's question to determine the exact rule name and the linter it belongs to (e.g., ESLint `no-unused-vars`, Pylint `C0301`, Clippy `needless_return`, Rubocop `Style/StringLiterals`).

2. **Explain the rule** -- Provide a clear explanation of:
   - What the rule enforces and what it disallows.
   - *Why* the rule exists -- what bugs, readability issues, or maintenance problems it prevents.
   - The default configuration and any relevant options.

3. **Show the fix** -- Provide the corrected code:
   - Show the **before** (violating) code.
   - Show the **after** (compliant) code.
   - If there are multiple valid ways to fix it, show the most idiomatic approach first.

4. **Reference documentation** -- When possible, provide a link or reference to the official rule documentation:
   - ESLint: `https://eslint.org/docs/latest/rules/<rule-name>`
   - Pylint: `https://pylint.readthedocs.io/en/latest/user_guide/messages/`
   - Clippy: `https://rust-lang.github.io/rust-clippy/master/`
   - Other linters: provide the most authoritative documentation source.

5. **Suppression guidance** -- If the user needs to suppress the rule for a legitimate reason, show how to do it inline and in the configuration file, but caution against blanket suppression.

Format the response clearly with headings and code blocks. Keep explanations concise but thorough enough that the user understands *why* the rule matters, not just how to silence it.
