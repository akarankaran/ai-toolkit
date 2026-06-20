# agent-browser (mcp)

Browser automation for the agent via [`agent-browser`](https://github.com/vercel-labs/agent-browser),
a fast native (Rust) browser-automation CLI for AI agents. It ships an MCP server mode, so the
agent can navigate pages, click, fill forms, read accessibility snapshots, and run end-to-end
checks against a live browser.

## What it is

This is an **MCP server**, a fourth artifact type in this toolkit. It is neither repo scaffolding
(a tool) nor a markdown prompt (a skill) — it's an external Model Context Protocol server the
agent talks to over stdio.

The key difference from tools and skills: **this toolkit does not vendor it.** agent-browser is a
maintained binary (npm `agent-browser`, Homebrew, or Cargo), shipping a browser driver and a large
tool surface. Copying that here would be wrong and would rot fast. Instead, install registers a
tiny config block that points the agent at the installed `agent-browser mcp` command.

- A **tool** (why-journal) is recreated *inside the target repo*.
- A **skill** (humanizer) is a `SKILL.md` copied into the agent's global skills dir.
- An **mcp** (this) is a config entry in the agent's global MCP config that references an external
  command. Nothing is vendored and nothing lands in the target repo.

## Where it comes from

- Source + full docs: [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser).
- Install (one-time): `npm install -g agent-browser` (or `brew install agent-browser`, or
  `cargo install agent-browser`), then `agent-browser install` to download Chrome from Chrome for
  Testing. Existing Chrome/Brave/Playwright/Puppeteer installs are detected automatically.
- MCP run command: `agent-browser mcp`.

The agent talks to a locally-installed binary. This toolkit only carries the pointer and the
install steps — see [`INSTALL.md`](./INSTALL.md).

## The problem it solves

Agents are blind to anything behind a browser. With agent-browser the agent can drive a real
browser to verify a UI change, reproduce a bug, scrape a page, or run a smoke test — using
structured accessibility snapshots (with `@e1`-style element refs) rather than screenshots, so no
vision model is needed.

## Why agent-browser over Playwright MCP

agent-browser is a native binary rather than a Node process, so startup is fast and there's no
`npx` cold-start. Its MCP server defaults to a small `core` tools profile to keep context lean, and
you can opt into more (`--tools all`, or comma-separated profiles like `core,network,react`) only
when a task needs it. It also exposes the same surface as a plain CLI, so the agent can run
one-shot commands without loading MCP schemas at all when that's lighter.

## When to use it

`OPTIONAL`. Install it on request, or when a repo's work involves the browser: front-end features,
e2e tests, web scraping, or "open this page and check X". Skip it for backend-only or CLI repos —
even the lean `core` profile adds tools (and tokens) to the agent's context.

## What gets created on install

Nothing in the target repo. The agent adds an `agent-browser` entry under `mcp` in the agent's
global config (for OpenCode, `~/.config/opencode/opencode.json`). See [`INSTALL.md`](./INSTALL.md)
for the exact steps and the per-client variations.
