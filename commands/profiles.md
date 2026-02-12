---
name: profiles
description: Manage Claude profiles — list, swap, or get help
---

You are managing Claude profiles. Profiles control which marketplace plugins are active and what permissions apply.

Determine the marketplace repo location:
- If the current working directory contains a `profiles/` directory with profile subdirectories, use the current directory as the marketplace repo.
- Otherwise, use `~/org-marketplace` as the marketplace repo.

Parse the user's arguments after `/profiles`:

**`/profiles` or `/profiles list`**
Run: `npx tsx <marketplace-repo>/scripts/swap-profile.ts list`
Show only the script output.

**`/profiles swap <name>`**
Run: `npx tsx <marketplace-repo>/scripts/swap-profile.ts swap <name> <cwd>`
Where `<cwd>` is the user's current working directory (the target project).
Show only the script output.

**`/profiles help`**
Run: `npx tsx <marketplace-repo>/scripts/swap-profile.ts help`
Show only the script output.

Do not add extra commentary beyond the script output. If the script fails, show the error output as-is.
