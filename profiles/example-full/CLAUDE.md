# Example Full Profile

Full-featured profile with the `example-plugin` enabled.

## What's Included

The **example-plugin** provides:

- **Commands:** `/example-plugin:hello` — greeting command
- **Agents:** `example-agent` — demonstration agent with Bash and Read tools
- **Skills:** `example-skill` — triggered by relevant user input
- **Hooks:** `SessionStart` handler that runs on session initialization
- **MCP:** Example MCP server configuration

## Permissions

Standard deny-list applied (no force push, no `rm -rf /`, etc.). See `settings.json` for details.
