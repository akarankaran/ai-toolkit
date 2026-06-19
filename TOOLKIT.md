# TOOLKIT.md — Agent Entrypoint

> **You are an AI coding agent. The user pointed you at this repo to set up another repo (the "target repo"). Read this file top to bottom, then follow it exactly.**

This repository is a **reference toolkit**. It does not get cloned. Instead, you read the
instructions and templates here and **recreate** the relevant files inside the target repo
the user is currently working in.

The toolkit lives at: `https://github.com/akarankaran/ai-toolkit`
Raw file base:        `https://raw.githubusercontent.com/akarankaran/ai-toolkit/main`

---

## How to set up a target repo

1. **Confirm the target.** The target repo is the user's current working directory, unless
   they say otherwise. Never write toolkit files into this toolkit repo itself.

2. **Install all DEFAULT tools.** Every tool in the catalog marked `DEFAULT` must be installed
   on every setup, without being asked. These are the user's non-negotiable baseline.

3. **Install OPTIONAL tools only when asked.** If the user named a specific tool, or described a
   need that matches one, install it. Otherwise leave it out.

4. **For each tool you install:**
   - Read the tool's `INSTALL.md` (path in the catalog below).
   - Follow its steps. It tells you which files to create in the target repo and where.
   - Get file contents from the tool's `templates/` directory. You already have them if you
     fetched this repo; if not, fetch each from the raw base above.
   - Adapt placeholders (dates, repo name, stack) to the target repo. Never paste a template
     verbatim if it has placeholders.

5. **Report back.** Tell the user which tools you installed, which files you created or
   modified, and how to use them in one or two lines.

### Rules
- **Stack-agnostic.** This toolkit assumes nothing about the target's language or framework.
  Do not add language-specific tooling unless a tool's INSTALL.md says to, or the user asks.
- **Idempotent.** If a file already exists in the target, merge rather than clobber. For
  `AGENTS.md`, append or update the relevant section; never overwrite the whole file.
- **No clone.** Do not `git clone` this toolkit into the target. Recreate files from templates.
- **Minimal footprint.** Only create what the catalog and INSTALL files specify.

---

## Tool catalog

| Tool | Status | What it does | INSTALL |
|------|--------|--------------|---------|
| **why-journal** | `DEFAULT` | Captures the *why* behind every change: a daily journal of asks + rationale, plus durable decision records. The user's core requirement — install on every repo. | `tools/why-journal/INSTALL.md` |

> More tools will be added over time. Anything marked `DEFAULT` installs automatically.
> Anything `OPTIONAL` installs only on request.

### Adding a new tool to this toolkit (for the maintainer/agent extending the toolkit)
Create `tools/<name>/` with:
- `README.md` — what it is and the *why* behind it.
- `INSTALL.md` — the exact steps an agent follows to install it into a target repo.
- `templates/` — the files (with placeholders) the agent recreates.
Then add a row to the catalog above with its status.
