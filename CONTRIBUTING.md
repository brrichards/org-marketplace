# Contributing Plugins

Guide for org members adding plugins to this marketplace.

## Quick Start

1. Clone this repo
2. Copy the example plugin as a starting point:
   ```bash
   cp -r plugins/example-plugin plugins/your-plugin-name
   ```
3. Edit your plugin (see structure below)
4. Register it in `.claude-plugin/marketplace.json`
5. Open a PR

## Plugin Structure

```
plugins/your-plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Required: plugin metadata
├── README.md                # Required: documentation
├── commands/                # Optional: slash commands
│   └── your-command.md
├── agents/                  # Optional: agents
│   └── your-agent.md
├── skills/                  # Optional: skills
│   └── your-skill/
│       └── SKILL.md
├── hooks/                   # Optional: hook configuration
│   └── hooks.json
├── hooks-handlers/          # Optional: hook handler scripts
│   └── your-handler.sh
└── .mcp.json                # Optional: MCP server config
```

### plugin.json (required)

```json
{
  "name": "your-plugin-name",
  "description": "What your plugin does",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  }
}
```

### Commands (`commands/*.md`)

Slash commands use markdown with frontmatter:

```markdown
---
name: your-command
description: What the command does
---

Prompt instructions for Claude when the command is invoked.
```

Users invoke with `/your-plugin-name:your-command`.

### Agents (`agents/*.md`)

Agents have tool declarations and optional model overrides:

```markdown
---
name: your-agent
description: What the agent does
model: sonnet
tools:
  - Bash
  - Read
---

System prompt for the agent.
```

### Skills (`skills/your-skill/SKILL.md`)

Skills are triggered by patterns in user input:

```markdown
---
name: your-skill
description: What the skill does
trigger: When the user asks to ...
---

Instructions for the skill.
```

### Hooks (`hooks/hooks.json`)

Hook configuration maps lifecycle events to handler commands:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "bash ./plugins/your-plugin/hooks-handlers/handler.sh"
      }
    ]
  }
}
```

Available hook events: `SessionStart`, `PreToolUse`, `PostToolUse`, `Notification`, `Stop`.

### MCP Servers (`.mcp.json`)

Configure external tool servers:

```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "@scope/mcp-server"],
      "env": {
        "API_KEY": ""
      }
    }
  }
}
```

## Registering Your Plugin

Add an entry to the `plugins` array in `.claude-plugin/marketplace.json`:

```json
{
  "name": "your-plugin-name",
  "description": "What your plugin does",
  "version": "1.0.0",
  "author": { "name": "Your Name" },
  "source": "./plugins/your-plugin-name",
  "category": "development"
}
```

Categories: `development`, `testing`, `deployment`, `documentation`, `utilities`.

## PR Checklist

- [ ] Plugin directory follows the naming convention (`lowercase-with-dashes`)
- [ ] `plugin.json` has name, description, version, and author
- [ ] `README.md` documents what the plugin does and how to use it
- [ ] Plugin is registered in `.claude-plugin/marketplace.json`
- [ ] Tested locally with `claude --plugin-dir ./plugins/your-plugin-name`
