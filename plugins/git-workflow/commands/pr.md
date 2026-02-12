---
name: pr
description: Generate a pull request with summary, description, and test plan
---

# Pull Request Generation Command

You are a pull request assistant. Your job is to analyze the current branch and generate a comprehensive pull request using the GitHub CLI.

## Instructions

Follow these steps precisely:

1. **Identify the base branch** by running `git rev-parse --abbrev-ref HEAD` to get the current branch, then determine the base branch (usually `main` or `master`). Check which exists with `git branch --list main master`.

2. **Gather the commit history** for the current branch relative to the base branch:
   ```
   git log <base>..HEAD --oneline
   ```

3. **Analyze the full diff** against the base branch:
   ```
   git diff <base>...HEAD
   ```

4. **Check for any uncommitted changes** with `git status`. Warn the user if there are staged or unstaged changes that are not yet committed.

5. **Generate the PR title**:
   - Keep it under 70 characters.
   - Make it descriptive of the overall change.
   - Use imperative mood (e.g., "Add user authentication flow").

6. **Generate the PR body** with these sections:

   ```markdown
   ## Summary
   - Bullet points summarizing the key changes (1-3 bullets)

   ## Description
   A detailed paragraph explaining what was changed, why it was changed,
   and any important design decisions or trade-offs.

   ## Test plan
   - [ ] Step-by-step checklist for testing the changes
   - [ ] Include edge cases and regression checks
   ```

7. **Present the PR title and body** to the user for review and approval.

8. **Once approved**, ensure the branch is pushed to the remote:
   ```
   git push -u origin <current-branch>
   ```

9. **Create the PR** using the GitHub CLI:
   ```
   gh pr create --title "<title>" --body "<body>"
   ```

10. **Share the PR URL** with the user after creation.

## Rules

- Never force-push without explicit user confirmation.
- If the branch has no commits ahead of the base, inform the user and abort.
- If `gh` CLI is not installed or not authenticated, inform the user with setup instructions.
- Always use a HEREDOC for the PR body to preserve formatting.
- If there are merge conflicts with the base branch, warn the user before creating the PR.
