# Profiles

Profiles are lightweight declarations that control which marketplace plugins are active. Each profile is a directory containing:

- **`settings.json`** — uses native Claude Code settings format (`extraKnownMarketplaces`, `enabledPlugins`, `permissions`)
- **`CLAUDE.md`** — project instructions applied when the profile is active

## How It Works

When you swap to a profile, the script copies `settings.json` and `CLAUDE.md` into the target project's `.claude/` directory. That's it — no CLI calls needed.

Claude Code reads these settings natively:
- **`extraKnownMarketplaces`** registers the marketplace automatically
- **`enabledPlugins`** tells Claude Code which plugins to enable
- On the next session, Claude Code prompts the user to install any missing marketplaces and plugins

Existing `.claude/settings.local.json` is never touched.

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
2. Add `settings.json` using the native Claude Code format
3. Add `CLAUDE.md` documenting what the profile provides
4. Open a PR

### settings.json Format

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
