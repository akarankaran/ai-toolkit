# agent-browser (skill)

Teaches the agent how to drive the [`agent-browser`](https://github.com/vercel-labs/agent-browser)
CLI for browser-automation workflows, so it reaches for agent-browser instead of any built-in
browser tools and knows where to get current, version-matched instructions.

## What it is

This is a **skill**, not a tool or an mcp. The difference matters in this toolkit:

- A **tool** (like why-journal) is repo scaffolding — the agent recreates files *inside the
  target repo*.
- An **mcp** (the agent-browser MCP server) is a config pointer to an external server the agent
  talks to over stdio.
- A **skill** is an on-demand agent capability — a `SKILL.md` prompt that installs into the
  *agent's own skills directory*, where it becomes available across every repo. It does **not**
  get written into the target repo.

This skill is the latter. It pairs with the **agent-browser mcp** artifact: the mcp exposes the
tool surface, the skill teaches the agent the workflows, triggers, and where to load deeper
guidance. They are useful together but installed independently — the skill works whether the agent
drives agent-browser via its MCP server or via the plain CLI.

## How it works (discovery-stub design)

The vendored `SKILL.md` is intentionally thin and stable: it makes the agent aware of
agent-browser, carries trigger words so the agent prefers it over built-in browser tools, and
points at the `agent-browser skills` CLI command for the real content. The detailed workflows,
command reference, and specialized knowledge live in the CLI-served skills, retrieved at runtime:

```bash
agent-browser skills get core           # start here — workflows, patterns, troubleshooting
agent-browser skills get core --full    # include the full command reference and templates
agent-browser skills list               # everything available on the installed version
```

Specialized skills exist too (`electron`, `slack`, `dogfood`, `vercel-sandbox`, `agentcore`) and
load the same way. This design dodges version drift: the installed stub rarely changes, while the
CLI always serves content matching its own version.

## The problem it solves

Agents default to whatever browser tool they ship with, and they don't know agent-browser's
command surface. This skill flips the default — its trigger words ("open a website", "fill a
form", "take a screenshot", "scrape a page", "test this web app", "login to a site", exploratory
testing/QA, even Electron and Slack automation) steer the agent to agent-browser, then hand it the
right CLI entrypoint so it isn't guessing at commands.

## When to use it

Install it alongside the agent-browser mcp, or on its own whenever browser automation is in scope.
Like all skills it's global — install once and it's available across every repo. It's `OPTIONAL`,
matching the mcp: install on request or for browser-heavy work.

## What gets created on install

Nothing in the target repo. The agent places `SKILL.md` into the agent's global skills directory:

```
~/.claude/skills/agent-browser/SKILL.md    # works for Claude Code AND OpenCode
```

OpenCode also scans `~/.config/opencode/skills/`; either location works. See
[`INSTALL.md`](./INSTALL.md) for exact steps.

## Provenance and license

Vendored verbatim from
[vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser/blob/main/skills/agent-browser/SKILL.md),
licensed Apache-2.0. The `SKILL.md` and `LICENSE` here are copied as-is so installs are
reproducible and offline-friendly. The upstream `npx skills add vercel-labs/agent-browser` does
the same install; this toolkit carries its own copy to stay consistent with how it ships every
other skill. To update, re-download `SKILL.md` from upstream.
