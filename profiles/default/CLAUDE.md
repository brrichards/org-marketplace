# Default Profile

Baseline profile — marketplace registered, no plugins enabled. Safe permissions only.

## Available Profiles

Switch profiles anytime:

```
/profiles list
/profiles swap <name>
```

| Profile | Plugins | Description |
|---------|---------|-------------|
| `default` | (none) | Baseline — safe permissions, no plugins |
| `developer` | code-quality, git-workflow, testing | Standard development workflow |
| `secure-dev` | code-quality, git-workflow, security | Security-focused development |
| `full` | code-quality, git-workflow, security, testing | Everything enabled |

## Available Plugins

These plugins can be enabled by swapping to a profile that includes them:

- **code-quality** — Code review (`/code-quality:review`), refactoring suggestions (`/code-quality:refactor`), lint explanations
- **git-workflow** — Conventional commits (`/git-workflow:commit`), PR generation (`/git-workflow:pr`), commit message validation
- **security** — Security scanning (`/security:scan`), dependency auditing (`/security:audit-deps`), secrets detection
- **testing** — Test generation (`/testing:gen-tests`), coverage analysis (`/testing:coverage`), test failure diagnosis
