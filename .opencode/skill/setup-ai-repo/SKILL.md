---
name: setup-ai-repo
description: Use when the user asks to set up a new repo, scaffold a project, or apply their personal AI-repo conventions/toolkit. Installs the user's standard toolkit (default: why-journal for capturing the reasoning behind changes) into the current repo.
---

# Set up a repo with the ai-toolkit

The user keeps their personal repo conventions in a GitHub toolkit. Your job is to apply that
toolkit to the **current repo** (the target).

> **Repo-only installs:** Every install you perform must be scoped to the target repo only —
> never install anything for the entire laptop / global agent config. All artifacts (tools,
> skills, agents, mcp servers) land inside the target repo (e.g. under `.opencode/` in the repo),
> not in `~/.config/` or any other machine-wide location.

## What to do

1. Fetch the toolkit entrypoint:
   `https://raw.githubusercontent.com/akarankaran/ai-toolkit/main/TOOLKIT.md`

2. Follow it exactly. In short:
   - If the target project is not already a Git repo, run `git init` before installing artifacts.
     If it is already a Git repo, leave its Git setup as-is.
   - Install every artifact marked `DEFAULT` (currently: **why-journal** tool, **humanizer**
     skill) without asking.
   - Install `OPTIONAL` artifacts only if the user named one or described a matching need (e.g.
     **playwright** MCP for browser work).
   - Classify each artifact first (tool / skill / agent / mcp) — the type decides where inside the
     target repo it installs. Every artifact installs *inside the target repo only*; never touch
     the machine-wide / global agent config.
   - For each artifact, fetch its `INSTALL.md` (and `templates/` for tools, or `SKILL.md` for
     skills) from the raw base
     `https://raw.githubusercontent.com/akarankaran/ai-toolkit/main` and follow it, adapting
     placeholders (dates, repo name, stack). MCP servers are not vendored — INSTALL.md gives you
     the config block to recreate.

3. Do **not** clone the toolkit. Recreate files from the templates.

4. Be idempotent: merge into existing files (especially `AGENTS.md`); never clobber or
   duplicate. Never delete existing journal entries or decision records.

5. Report which artifacts you installed (and their types), which files you created or modified,
   and one line on usage.

## Notes
- Stack-agnostic: add no language-specific tooling unless a tool's INSTALL.md says so or the
  user asks.
- The target repo is the current working directory unless the user says otherwise. Never write
  toolkit files into the toolkit repo itself.
- New target projects should be Git-initialized; do this idempotently with `git init` only when
  the target is not already inside a Git worktree.
