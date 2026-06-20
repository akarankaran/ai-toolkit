# INSTALL — agent-browser (MCP server)

> Agent: agent-browser is an **MCP server**, not a tool or a skill. Read this carefully — it
> installs differently from why-journal (tool) and humanizer (skill).
>
> - **Do NOT write anything into the target repo.** An MCP server is an agent capability; it
>   belongs in the agent's global config, not the user's project.
> - **Do NOT vendor or copy the server.** It's the `agent-browser` binary (npm/Homebrew/Cargo),
>   installed once on the machine. This toolkit only carries the config pointer — recreate that,
>   nothing else.

## Status

`OPTIONAL`. Install only when the user asks for it, or when the repo's work clearly involves the
browser (front-end, e2e tests, scraping, "open this page and check…"). It adds a tool surface to
the agent's context, so don't install it by default.

## Prerequisites

- The **`agent-browser` binary** must be installed on the machine. If it's missing, install it
  once (pick one):
  - `npm install -g agent-browser`
  - `brew install agent-browser` (macOS)
  - `cargo install agent-browser` (Rust)
- Then run `agent-browser install` once to download Chrome from Chrome for Testing (Google's
  official automation channel). Existing Chrome/Brave/Playwright/Puppeteer installs are detected
  automatically. On Linux, use `agent-browser install --with-deps` to also pull system deps.
- Verify with `agent-browser doctor`.

If `agent-browser` is absent and you can't install it, tell the user; don't silently skip.

## Where it goes

Into the **agent's global MCP config**, not the target repo. The exact location and schema depend
on the agent:

- **OpenCode (default here):** `~/.config/opencode/opencode.json`, under the `mcp` key.
- **Claude Code:** run `claude mcp add agent-browser agent-browser mcp`.
- **Other clients:** the standard `mcpServers` block works for most. agent-browser also ships as a
  Claude plugin; see the upstream README (https://github.com/vercel-labs/agent-browser).

Use the OpenCode path unless the user tells you which agent they're on.

## Step 1 — Check if it's already installed

Look for an `agent-browser` entry under `mcp` in `~/.config/opencode/opencode.json` (or the
equivalent for the user's agent). If present, it's installed — skip to Step 3 (report). Don't
overwrite an existing entry unless the user asks for an update.

## Step 2 — Add the MCP server entry

For **OpenCode**, merge this into `~/.config/opencode/opencode.json` (create the file with just
this content if it doesn't exist; otherwise add the `agent-browser` key to the existing `mcp`
object — never clobber other servers):

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "agent-browser": {
      "type": "local",
      "command": ["agent-browser", "mcp"],
      "enabled": true
    }
  }
}
```

For **Claude Code**, prefer the CLI instead of hand-editing config:

```bash
claude mcp add agent-browser agent-browser mcp
```

### Tools profile (context budget)

The MCP server defaults to the `core` profile, which keeps context small for everyday browser
automation. Opt into more only when a task needs it by adding `--tools` to the command array:

- `core` — default: navigation, snapshots, interaction, waits, reads, screenshots, eval, tabs.
- `network`, `state`, `debug`, `tabs`, `react`, `mobile` — focused add-ons.
- `all` — the full typed CLI-parity surface (heavy; use sparingly).

Example for a fuller surface:

```json
{
  "agent-browser": {
    "type": "local",
    "command": ["agent-browser", "mcp", "--tools", "core,network,react"],
    "enabled": true
  }
}
```

Leave it on `core` unless asked; the default is the sensible, lean choice.

## Step 3 — Report

Tell the user:
- agent-browser MCP is configured in their agent's global config (give the path), or note it was
  already present and you left it as-is.
- It talks to the locally-installed `agent-browser` binary via `agent-browser mcp` (install once
  with npm/Homebrew/Cargo, then `agent-browser install` to fetch Chrome).
- It did **not** touch the target repo and was **not** vendored into this toolkit.
- One line on use: ask the agent to drive the browser ("open localhost:3000 and check the login
  form"), and it'll use the `agent_browser_*` tools.
- Mention the lighter knob if relevant: the MCP server defaults to the lean `core` tools profile;
  widen it with `--tools` only when a task needs more.

## Idempotency notes
- Re-running setup must not duplicate the `agent-browser` entry or clobber other MCP servers in the
  config.
- Never write MCP config into the target repo.
- The server is global: configuring it once makes it available in every repo, so there's no need
  to reinstall per project.
- Don't pin a specific version in this toolkit; the installed binary is updated with
  `agent-browser upgrade`. Pin only if the user asks for reproducibility.
