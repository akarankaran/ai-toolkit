# INSTALL — agent-browser (skill)

> Agent: agent-browser (this) is a **skill**, not the mcp and not a tool. Read this carefully.
>
> - **Do NOT write this skill into the target repo.** Skills are agent capabilities that live in
>   the agent's own global skills directory, not in the user's project. Creating a `SKILL.md`
>   anywhere inside the target repo is wrong.
> - This is separate from the **agent-browser mcp** (`mcp/agent-browser/`). The mcp registers a
>   server in the agent's global MCP config; this skill teaches the agent the workflows. Install
>   either or both — they're independent.

## Status

`OPTIONAL`. Install on request, or when a repo's work involves the browser (front-end, e2e tests,
scraping, exploratory testing). It pairs naturally with the agent-browser mcp; install both for
browser-heavy repos.

## Prerequisites

- For the skill itself: none — it's just a `SKILL.md`.
- To actually run the workflows it describes, the **`agent-browser` binary** must be installed
  (`npm install -g agent-browser`, or Homebrew/Cargo, then `agent-browser install`). The skill
  points the agent at `agent-browser skills get core` for runtime content, which needs the binary.
  If it's absent, tell the user; installing the binary is covered in `mcp/agent-browser/INSTALL.md`.

## Where it goes

Install into the agent's global skills directory:

- **Default (universal):** `~/.claude/skills/agent-browser/SKILL.md`
  This works for both Claude Code and OpenCode — OpenCode also scans `~/.claude/skills/`, so a
  single copy here serves both.
- **OpenCode-only alternative:** `~/.config/opencode/skills/agent-browser/SKILL.md`

Use the default unless the user tells you otherwise.

## Step 1 — Check if it's already installed

If `~/.claude/skills/agent-browser/SKILL.md` already exists, the skill is installed. Skip to
Step 3 (report). Don't overwrite an existing copy unless the user asks for an update.

## Step 2 — Install the skill

1. Create the directory: `~/.claude/skills/agent-browser/`
2. Copy this toolkit's `skills/agent-browser/SKILL.md` into it, verbatim. If you fetched this repo,
   you already have the file. Otherwise fetch it from the raw base:
   `https://raw.githubusercontent.com/akarankaran/ai-toolkit/main/skills/agent-browser/SKILL.md`
3. Copy `skills/agent-browser/LICENSE` alongside it (Apache-2.0 upstream work).

Do **not** modify `SKILL.md`. It's a stable discovery stub copied verbatim from upstream; the real
workflow content is served at runtime by `agent-browser skills get core`.

> Upstream offers `npx skills add vercel-labs/agent-browser`, which installs the same stub. Prefer
> the verbatim copy from this toolkit so installs are reproducible and offline-friendly, matching
> how every other skill here ships. Use the `npx` route only if the user explicitly asks for it.

## Step 3 — Report

Tell the user:
- agent-browser skill is installed at `~/.claude/skills/agent-browser/SKILL.md` (or note it was
  already present and you left it as-is).
- It steers the agent to use agent-browser for browser tasks and points at
  `agent-browser skills get core` for current, version-matched workflows.
- It did **not** touch the target repo.
- If the binary or the agent-browser mcp isn't set up yet, mention `mcp/agent-browser/INSTALL.md`
  for that side.

## Idempotency notes
- Re-running setup must not duplicate or clobber an existing install.
- Never write `SKILL.md` into the target repo.
- The skill is global: installing it once makes it available in every repo, so there's no need to
  reinstall per project.
