# Org Marketplace

Internal Claude Code plugin marketplace for **[Your Org]**. Only org members with access to this repo can browse and install plugins.

This repo also includes **profiles** — lightweight declarations that bundle plugins with settings and instructions, so teams can swap configurations with a single command.

## Quick Start

One command to install Claude Code and apply a marketplace profile to any project. `GITHUB_TOKEN` is auto-set in Codespaces:

```bash
curl -fsSL -H "Authorization: token $GITHUB_TOKEN" \
  https://raw.githubusercontent.com/brrichards/org-marketplace/main/setup.sh | bash
```

Apply a specific profile:

```bash
curl -fsSL -H "Authorization: token $GITHUB_TOKEN" \
  https://raw.githubusercontent.com/brrichards/org-marketplace/main/setup.sh | bash -s -- --profile example-full
```

Use in a devcontainer:

```jsonc
// .devcontainer/devcontainer.json
{
  "postCreateCommand": "curl -fsSL -H \"Authorization: token $GITHUB_TOKEN\" https://raw.githubusercontent.com/brrichards/org-marketplace/main/setup.sh | bash -s -- --profile example-full"
}
```

See [setup.sh](./setup.sh) for all options (`--profile`, `--target`, `MARKETPLACE_LOCAL`, etc.).

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- A `GITHUB_TOKEN` environment variable with read access to this repo

```bash
export GITHUB_TOKEN=ghp_your_token_here
```

## Setup

The fastest way to get started is the [Quick Start](#quick-start) one-liner above. Alternatively, add the marketplace manually:

```bash
claude plugin marketplace add your-org/org-marketplace
```

## Plugins

**Browse available plugins:**

```
/plugin > Discover
```

**Install a plugin:**

```bash
claude plugin install example-plugin@org-marketplace
```

**Test a plugin locally (for development):**

```bash
claude --plugin-dir ./plugins/example-plugin
```

### Available Plugins

| Plugin | Description | Version |
|--------|-------------|---------|
| [example-plugin](./plugins/example-plugin) | Template plugin demonstrating all extension types | 1.0.0 |

## Profiles

Profiles bundle plugins with settings and project instructions. Instead of manually installing plugins and configuring permissions, swap to a profile that sets everything up at once.

### Available Profiles

| Profile | Plugins | Description |
|---------|---------|-------------|
| `default` | (none) | Baseline — safe permissions, no plugins |
| `example-full` | example-plugin | Full example with commands, agents, skills, hooks, MCP |

### Swapping Profiles

**From the marketplace repo:**

```bash
# List available profiles
npx tsx scripts/swap-profile.ts list

# Apply a profile to your project
npx tsx scripts/swap-profile.ts swap example-full /path/to/your-project
```

**Via shell wrapper:**

```bash
bash scripts/swap-profile.sh swap default /path/to/your-project
```

**Via slash command (from any project):**

```
/profiles list
/profiles swap example-full
```

See [profiles/README.md](./profiles/README.md) for details on creating and managing profiles.

## Adding a New Plugin

See [CONTRIBUTING.md](./CONTRIBUTING.md) for instructions on creating and publishing plugins to this marketplace.
