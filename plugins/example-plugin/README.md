# Example Plugin

A template plugin demonstrating all Claude Code extension types. Use this as a starting point when creating new plugins for the org marketplace.

## Components

| Component | Path | Description |
|-----------|------|-------------|
| Command | `commands/hello.md` | Slash command: `/example-plugin:hello` |
| Agent | `agents/example-agent.md` | Agent with tool access and model override |
| Skill | `skills/example-skill/SKILL.md` | Trigger-based skill |
| Hook | `hooks/hooks.json` | SessionStart hook configuration |
| Hook handler | `hooks-handlers/session-start.sh` | Shell script run on session start |
| MCP server | `.mcp.json` | MCP server configuration (disabled by default) |

## Testing locally

```bash
claude --plugin-dir ./plugins/example-plugin
```

Then try:
- `/example-plugin:hello` to run the slash command
- Reference the agent or skill in conversation

## Creating a new plugin from this template

1. Copy this directory: `cp -r plugins/example-plugin plugins/your-plugin`
2. Edit `.claude-plugin/plugin.json` with your plugin's name and description
3. Modify or remove components you don't need
4. Register your plugin in the root `.claude-plugin/marketplace.json`
5. Open a PR
