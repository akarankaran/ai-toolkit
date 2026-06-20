# playwright (mcp)

Browser automation for the agent via the official Playwright MCP server. Lets the agent navigate
pages, click, fill forms, read accessibility snapshots, and run end-to-end checks against a live
browser.

## What it is

This is an **MCP server**, a fourth artifact type in this toolkit. It is neither repo scaffolding
(a tool) nor a markdown prompt (a skill) — it's an external Model Context Protocol server the
agent talks to over stdio.

The key difference from tools and skills: **this toolkit does not vendor it.** Playwright MCP is a
maintained npm package (`@playwright/mcp`), shipping a browser and a large tool surface. Copying
that here would be wrong and would rot fast. Instead, install registers a tiny config block that
points the agent at the upstream package, which `npx` fetches on first run.

- A **tool** (why-journal) is recreated *inside the target repo*.
- A **skill** (humanizer) is a `SKILL.md` copied into the agent's global skills dir.
- An **mcp** (this) is a config entry in the agent's global MCP config that references an external
  package. Nothing is vendored and nothing lands in the target repo.

## Where it comes from

- Package: [`@playwright/mcp`](https://www.npmjs.com/package/@playwright/mcp) on npm.
- Source + full docs: [microsoft/playwright-mcp](https://github.com/microsoft/playwright-mcp).
- Run command: `npx @playwright/mcp@latest` (Node.js 18+ required).

The agent gets the actual server from npm at runtime. This toolkit only carries the pointer and
the install steps — see [`INSTALL.md`](./INSTALL.md).

## The problem it solves

Agents are blind to anything behind a browser. With Playwright MCP the agent can drive a real
browser to verify a UI change, reproduce a bug, scrape a page, or run a smoke test — using
structured accessibility snapshots rather than screenshots, so no vision model is needed.

## When to use it

`OPTIONAL`. Install it on request, or when a repo's work involves the browser: front-end features,
e2e tests, web scraping, or "open this page and check X". Skip it for backend-only or CLI repos —
it adds a meaningful number of tools (and tokens) to the agent's context.

## CLI alternative (worth knowing)

For high-throughput coding agents, Microsoft now recommends the
[Playwright CLI + SKILLS](https://github.com/microsoft/playwright-cli) over MCP: CLI invocations
are more token-efficient because they avoid loading large tool schemas and verbose accessibility
trees into context. MCP still wins for long-running, stateful agentic loops (exploratory
automation, self-healing tests). This toolkit installs the MCP server; if you find the tool
surface too heavy, the CLI+SKILLS path is the lighter option.

## What gets created on install

Nothing in the target repo. The agent adds a `playwright` entry under `mcp` in the agent's global
config (for OpenCode, `~/.config/opencode/opencode.json`). See [`INSTALL.md`](./INSTALL.md) for the
exact steps and the per-client variations.
