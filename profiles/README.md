# Profiles

Profiles are `.claude/` folder templates. Each profile is a directory containing everything that belongs in a project's `.claude/` folder — `settings.json`, `CLAUDE.md`, and any other config files.

## How It Works

When you swap to a profile, the script **replaces** the target's `.claude/` directory entirely with the profile contents. The profile directory becomes the `.claude/` folder.

Claude Code handles the rest natively — it reads `extraKnownMarketplaces` and `enabledPlugins` from the copied `settings.json` and prompts the user to install marketplaces and plugins when they trust the project folder.

## Available Profiles

| Profile | Plugins | Description |
|---------|---------|-------------|
| `default` | (none) | Baseline — safe permissions, marketplace registered but no plugins enabled |
| `example-full` | example-plugin | Full example plugin with commands, agents, skills, hooks, MCP |

## Usage

### From the marketplace repo

```bash
# List profiles
npx tsx scripts/swap-profile.ts list

# Swap a target project to a profile
npx tsx scripts/swap-profile.ts swap example-full /path/to/project
```

### Remote setup (without cloning the marketplace)

Apply a profile to any project with a single command — no clone required. `GITHUB_TOKEN` is auto-set in Codespaces:

```bash
# Default profile in the current directory
curl -fsSL -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.raw" \
  "https://api.github.com/repos/brrichards/org-marketplace/contents/setup.sh?ref=main" | bash

# Specific profile to a specific directory
curl -fsSL -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.raw" \
  "https://api.github.com/repos/brrichards/org-marketplace/contents/setup.sh?ref=main" | bash -s -- --profile example-full --target /path/to/project
```

This downloads `settings.json` (always overwritten) and `CLAUDE.md` (only written if absent) from the profile into the target's `.claude/` directory.

### Via slash command (from any project)

```
/profiles list
/profiles swap example-full
```

### Via shell wrapper

```bash
bash scripts/swap-profile.sh list
bash scripts/swap-profile.sh swap default /path/to/project
```

## Creating a New Profile

1. Create a directory under `profiles/` with your profile name
2. Add everything that should go in `.claude/` — at minimum `settings.json`
3. Add `CLAUDE.md` documenting what the profile provides
4. Open a PR

### settings.json Format

Uses the native Claude Code settings format:

```json
{
  "extraKnownMarketplaces": {
    "org-marketplace": {
      "source": {
        "source": "github",
        "repo": "brrichards/org-marketplace"
      }
    }
  },
  "enabledPlugins": {
    "plugin-a@org-marketplace": true,
    "plugin-b@org-marketplace": true
  },
  "permissions": {
    "deny": [
      "Bash(git push --force*)"
    ]
  }
}
```

### Conventions

- Profile names use `lowercase-with-dashes`
- Only reference plugins that exist in this marketplace
- Use `"plugin-name@marketplace-name": true` format for `enabledPlugins`
- Always include `extraKnownMarketplaces` so the marketplace registers automatically
- Always include a deny-list for destructive commands
- Document everything the profile enables in CLAUDE.md
