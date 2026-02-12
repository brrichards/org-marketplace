# Org Marketplace

Claude Code plugin marketplace with **profiles** — lightweight declarations that bundle plugins with settings and instructions, so teams can swap configurations with a single command.

## Quick Start

Install the marketplace locally and apply a profile:

```bash
# Clone marketplace + apply default profile
curl -fsSL https://raw.githubusercontent.com/brrichards/org-marketplace/main/setup.sh | bash

# Apply the developer profile (code-quality + git-workflow + testing)
curl -fsSL https://raw.githubusercontent.com/brrichards/org-marketplace/main/setup.sh | bash -s -- --profile developer

# Apply to a specific project directory
curl -fsSL https://raw.githubusercontent.com/brrichards/org-marketplace/main/setup.sh | bash -s -- --profile full --target /path/to/project
```

This clones the marketplace to `~/.org-marketplace/` and copies the profile into your project's `.claude/` directory.

### Devcontainer / Codespaces

Add this to any repo's `.devcontainer/devcontainer.json` to auto-install on Codespace creation:

```jsonc
// .devcontainer/devcontainer.json
{
  "postCreateCommand": "curl -fsSL https://raw.githubusercontent.com/brrichards/org-marketplace/main/setup.sh | bash -s -- --profile developer"
}
```

See [setup.sh](./setup.sh) for all options (`--profile`, `--target`, `--home`).

## Quick Start

One command to install Claude Code and apply a marketplace profile to any project. `GITHUB_TOKEN` is auto-set in Codespaces:

```bash
curl -fsSL -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.raw" \
  "https://api.github.com/repos/brrichards/org-marketplace/contents/setup.sh?ref=main" | bash
```

Apply a specific profile:

```bash
curl -fsSL -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.raw" \
  "https://api.github.com/repos/brrichards/org-marketplace/contents/setup.sh?ref=main" | bash -s -- --profile example-full
```

Use in a devcontainer:

```jsonc
// .devcontainer/devcontainer.json
{
  "customizations": {
    "codespaces": {
      "repositories": {
        "brrichards/org-marketplace": {
          "permissions": { "contents": "read" }
        }
      }
    }
  },
  "postCreateCommand": "curl -fsSL -H \"Authorization: token $GITHUB_TOKEN\" -H \"Accept: application/vnd.github.raw\" \"https://api.github.com/repos/brrichards/org-marketplace/contents/setup.sh?ref=main\" | bash -s -- --profile example-full"
}
```

See [setup.sh](./setup.sh) for all options (`--profile`, `--target`, `MARKETPLACE_LOCAL`, etc.).

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed

## Plugins

### Available Plugins

| Plugin | Description | Commands | Version |
|--------|-------------|----------|---------|
| [code-quality](./plugins/code-quality) | Code review & best practices | `/code-quality:review`, `/code-quality:refactor` | 1.0.0 |
| [git-workflow](./plugins/git-workflow) | Git conventions & PR workflow | `/git-workflow:commit`, `/git-workflow:pr` | 1.0.0 |
| [security](./plugins/security) | Security scanning & secrets detection | `/security:scan`, `/security:audit-deps` | 1.0.0 |
| [testing](./plugins/testing) | Test generation & TDD workflow | `/testing:gen-tests`, `/testing:coverage` | 1.0.0 |
| [example-plugin](./plugins/example-plugin) | Template demonstrating all extension types | `/example-plugin:hello` | 1.0.0 |

**Install a plugin individually:**

```bash
claude plugin install code-quality@org-marketplace
```

**Test a plugin locally (for development):**

```bash
claude --plugin-dir ./plugins/code-quality
```

## Profiles

Profiles bundle plugins with settings and project instructions. Instead of manually installing plugins and configuring permissions, swap to a profile that sets everything up at once.

### Available Profiles

| Profile | Plugins | Description |
|---------|---------|-------------|
| `default` | (none) | Baseline — safe permissions, no plugins |
| `developer` | code-quality, git-workflow, testing | Standard development workflow |
| `secure-dev` | code-quality, git-workflow, security | Security-focused development with extended deny-list |
| `full` | all 4 plugins | Everything enabled with extended deny-list |

### Swapping Profiles

**Via slash command (from any project with the marketplace installed):**

```
/profiles list
/profiles swap developer
```

**From the marketplace repo:**

```bash
npx tsx scripts/swap-profile.ts list
npx tsx scripts/swap-profile.ts swap developer /path/to/your-project
```

**From any directory (after install):**

```bash
npx tsx ~/.org-marketplace/scripts/swap-profile.ts list
npx tsx ~/.org-marketplace/scripts/swap-profile.ts swap full /path/to/your-project
```

**Via shell wrapper:**

```bash
bash scripts/swap-profile.sh swap default /path/to/your-project
```

See [profiles/README.md](./profiles/README.md) for details on creating and managing profiles.

## Adding a New Plugin

See [CONTRIBUTING.md](./CONTRIBUTING.md) for instructions on creating and publishing plugins to this marketplace.
