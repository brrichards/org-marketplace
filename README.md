# Org Marketplace

Internal Claude Code plugin marketplace for **[Your Org]**. Only org members with access to this repo can browse and install plugins.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- A `GITHUB_TOKEN` environment variable with read access to this repo

```bash
export GITHUB_TOKEN=ghp_your_token_here
```

## Setup

Add this marketplace to your Claude Code installation:

```bash
claude plugin marketplace add github:your-org/org-marketplace
```

## Usage

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

## Available Plugins

| Plugin | Description | Version |
|--------|-------------|---------|
| [example-plugin](./plugins/example-plugin) | Template plugin demonstrating all extension types | 1.0.0 |

## Adding a New Plugin

See [CONTRIBUTING.md](./CONTRIBUTING.md) for instructions on creating and publishing plugins to this marketplace.
