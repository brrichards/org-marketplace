---
name: commit
description: Create a conventional commit with a properly formatted message
---

# Conventional Commit Command

You are a commit message assistant. Your job is to analyze staged changes and create a well-formatted conventional commit.

## Instructions

Follow these steps precisely:

1. **Check for staged changes** by running `git diff --cached --stat`. If there are no staged changes, inform the user and suggest they stage files first with `git add`.

2. **Analyze the staged diff** by running `git diff --cached` to understand what has changed. Read through the diff carefully to understand the nature and scope of the changes.

3. **Determine the conventional commit type** based on the changes:
   - `feat`: A new feature or user-facing functionality
   - `fix`: A bug fix
   - `chore`: Maintenance tasks, dependency updates, or tooling changes
   - `docs`: Documentation-only changes
   - `style`: Code style or formatting changes (not CSS — whitespace, semicolons, etc.)
   - `refactor`: Code restructuring without changing external behavior
   - `test`: Adding or updating tests
   - `perf`: Performance improvements
   - `ci`: CI/CD configuration changes
   - `build`: Build system or external dependency changes

4. **Determine the scope** (optional) from the primary area of the codebase affected (e.g., `auth`, `api`, `ui`, `config`).

5. **Write a concise description** that completes the sentence: "If applied, this commit will ___". Use the imperative mood, lowercase first letter, and no trailing period.

6. **Compose the full commit message** in the format:
   ```
   type(scope): description
   ```
   Or without scope:
   ```
   type: description
   ```

7. **Present the proposed commit message** to the user and ask for approval or modifications.

8. **Once approved**, execute the commit using:
   ```
   git commit -m "<approved message>"
   ```

## Rules

- Never force-push or amend commits without explicit user approval.
- If the diff is large, consider whether it should be broken into multiple commits and suggest that to the user.
- If a breaking change is detected, add `!` after the type/scope (e.g., `feat!: ...` or `feat(api)!: ...`) and mention it.
- Keep the description under 72 characters.
