# INSTALL — playwright (MCP server)

> Agent: playwright is an **MCP server**, not a tool or a skill. Read this carefully — it installs
> differently from why-journal (tool) and humanizer (skill).
>
> - **Do NOT write anything into the target repo.** An MCP server is an agent capability; it
>   belongs in the agent's global config, not the user's project.
> - **Do NOT vendor or copy the server.** It's the npm package `@playwright/mcp`, pulled at
>   runtime by `npx`. This toolkit only carries the config pointer — recreate that, nothing else.

## Status

`OPTIONAL`. Install only when the user asks for it, or when the repo's work clearly involves the
browser (front-end, e2e tests, scraping, "open this page and check…"). It adds a sizable tool
surface to the agent's context, so don't install it by default.

## Prerequisites

- **Node.js 18+** (so `npx` can run the server). If absent, tell the user; don't try to install
  Node yourself.
- On first run `npx @playwright/mcp@latest` downloads the package and a browser. This is expected.

## Where it goes

Into the **agent's global MCP config**, not the target repo. The exact location and schema depend
on the agent:

- **OpenCode (default here):** `~/.config/opencode/opencode.json`, under the `mcp` key.
- **Claude Code:** run `claude mcp add playwright npx @playwright/mcp@latest`.
- **Other clients:** see the per-client list in the upstream README
  (https://github.com/microsoft/playwright-mcp). The standard `mcpServers` block works for most.

Use the OpenCode path unless the user tells you which agent they're on.

## Step 1 — Check if it's already installed

Look for a `playwright` entry under `mcp` in `~/.config/opencode/opencode.json` (or the
equivalent for the user's agent). If present, it's installed — skip to Step 3 (report). Don't
overwrite an existing entry unless the user asks for an update.

## Step 2 — Add the MCP server entry

For **OpenCode**, merge this into `~/.config/opencode/opencode.json` (create the file with just
this content if it doesn't exist; otherwise add the `playwright` key to the existing `mcp`
object — never clobber other servers):

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "playwright": {
      "type": "local",
      "command": ["npx", "@playwright/mcp@latest"],
      "enabled": true
    }
  }
}
```

For **Claude Code**, prefer the CLI instead of hand-editing config:

```bash
claude mcp add playwright npx @playwright/mcp@latest
```

Common optional args (add to the `command`/`args` array if the user wants them):
- `--headless` — run the browser without a visible window.
- `--isolated` — fresh in-memory profile per session (no persisted login state).
- `--browser <chrome|firefox|webkit|msedge>` — pick the browser engine.
- `--caps <vision,pdf,devtools>` — opt into extra tool capabilities.

Leave these off unless asked; the defaults are sensible.

## Step 3 — Report

Tell the user:
- playwright MCP is configured in their agent's global config (give the path), or note it was
  already present and you left it as-is.
- It pulls `@playwright/mcp` from npm via `npx` on first use (needs Node 18+); the first run
  downloads a browser.
- It did **not** touch the target repo and was **not** vendored into this toolkit.
- One line on use: ask the agent to drive the browser ("open localhost:3000 and check the login
  form"), and it'll use the `browser_*` tools.
- Mention the lighter alternative if relevant: for token-heavy sessions, Microsoft's
  Playwright CLI+SKILLS (https://github.com/microsoft/playwright-cli) is more context-efficient
  than the MCP server.

## Idempotency notes
- Re-running setup must not duplicate the `playwright` entry or clobber other MCP servers in the
  config.
- Never write MCP config into the target repo.
- The server is global: configuring it once makes it available in every repo, so there's no need
  to reinstall per project.
- Don't pin a specific version in this toolkit; `@latest` keeps it current. Pin only if the user
  asks for reproducibility.
