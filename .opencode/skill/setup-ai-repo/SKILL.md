---
name: setup-ai-repo
description: Use when the user asks to set up a new repo, scaffold a project, or apply their personal AI-repo conventions/toolkit. Installs the user's standard toolkit (default: why-journal for capturing the reasoning behind changes) into the current repo.
---

# Set up a repo with the ai-toolkit

The user keeps their personal repo conventions in a GitHub toolkit. Your job is to apply that
toolkit to the **current repo** (the target).

## What to do

1. Fetch the toolkit entrypoint:
   `https://raw.githubusercontent.com/akarankaran/ai-toolkit/main/TOOLKIT.md`

2. Follow it exactly. In short:
   - Install every tool marked `DEFAULT` (currently: **why-journal**) without asking.
   - Install `OPTIONAL` tools only if the user named one or described a matching need.
   - For each tool, fetch its `INSTALL.md` and `templates/` from the raw base
     `https://raw.githubusercontent.com/akarankaran/ai-toolkit/main` and recreate the files in
     the target repo, adapting placeholders (dates, repo name, stack).

3. Do **not** clone the toolkit. Recreate files from the templates.

4. Be idempotent: merge into existing files (especially `AGENTS.md`); never clobber or
   duplicate. Never delete existing journal entries or decision records.

5. Report which tools you installed, which files you created or modified, and one line on usage.

## Notes
- Stack-agnostic: add no language-specific tooling unless a tool's INSTALL.md says so or the
  user asks.
- The target repo is the current working directory unless the user says otherwise. Never write
  toolkit files into the toolkit repo itself.
