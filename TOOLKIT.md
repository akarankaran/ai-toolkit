# TOOLKIT.md — Agent Entrypoint

> **You are an AI coding agent. The user pointed you at this repo to set up another repo (the "target repo"). Read this file top to bottom, then follow it exactly.**

This repository is a **reference toolkit**. It does not get cloned. Instead, you read the
instructions and templates here and **recreate** the relevant files in the right place — which
depends on the artifact type (see below).

The toolkit lives at: `https://github.com/akarankaran/ai-toolkit`
Raw file base:        `https://raw.githubusercontent.com/akarankaran/ai-toolkit/main`

---

## Artifact types — classify before you install

This toolkit holds more than one kind of thing. **Before installing anything, identify which
type it is**, because each installs to a different place. Getting this wrong (e.g. dumping a
skill into the target repo) is the most common mistake.

| Type | What it is | Installs to | Touches the target repo? |
|------|------------|-------------|--------------------------|
| **tool** | Repo conventions / scaffolding. Files the repo should carry (docs, `AGENTS.md` sections, config). | **Inside the target repo** (the user's current project). | Yes — this is the point. |
| **skill** | An on-demand agent capability: a `SKILL.md` prompt the agent loads when relevant. | **The agent's global skills directory** (`~/.claude/skills/<name>/`; OpenCode reads this too). | **No.** Never write a skill into the target repo. |
| **agent** | A specialized agent/subagent persona + config. | **The agent's global agent directory** (e.g. `~/.config/opencode/agent/<name>.md`). | No. |
| **mcp** | An external [Model Context Protocol](https://modelcontextprotocol.io) server the agent talks to (e.g. an npm package run via `npx`). **Not vendored** — install registers a config pointer to the upstream package. | **The agent's global MCP config** (e.g. `~/.config/opencode/opencode.json` under `mcp`). | No. |

Rules of thumb:
- A **tool** answers "how should this repo be set up?" — it belongs in the repo.
- A **skill**, **agent**, or **mcp** answers "what can the assistant do?" — it belongs in the
  agent's global config and works across all repos. Installing it once is enough; it does not get
  reinstalled per project, and it never lands in the target repo.
- An **mcp** is the one type this toolkit deliberately **does not vendor**: it's an external
  package (the agent fetches it at runtime), so install only recreates a small config pointer to
  it. Never copy an MCP server's code into this toolkit.

Each catalog entry below is tagged with its type. Every artifact has its own `INSTALL.md` with
the exact, type-correct steps — follow it.

---

## How to set up a target repo

1. **Confirm the target.** The target repo is the user's current working directory, unless
   they say otherwise. Never write toolkit files into this toolkit repo itself.

2. **Install all DEFAULT artifacts.** Every entry in the catalogs marked `DEFAULT` must be
   installed on every setup, without being asked. These are the user's non-negotiable baseline.
   This applies to skills too: ensure DEFAULT skills are present in the agent's global skills
   directory (idempotent — skip if already installed).

3. **Install OPTIONAL artifacts only when asked.** If the user named a specific one, or described
   a need that matches one, install it. Otherwise leave it out.

4. **For each artifact you install:**
   - First confirm its **type** (tool / skill / agent / mcp) from the catalog. The type decides
     where it goes — see the Artifact types table above.
   - Read the artifact's `INSTALL.md` (path in the catalog below).
   - Follow its steps. It tells you which files to create and where.
   - Get file contents from the artifact's directory (`templates/` for tools, `SKILL.md` for
     skills). You already have them if you fetched this repo; if not, fetch each from the raw
     base above. For **mcp** artifacts there's nothing to vendor — INSTALL.md gives you the
     config block to recreate.
   - Adapt placeholders (dates, repo name, stack) where the INSTALL says to. Skills like
     humanizer are copied **verbatim** — do not edit them.

5. **Report back.** Tell the user which artifacts you installed, their types, which files you
   created or modified (and where — repo vs. global skills dir), and how to use them in one or
   two lines.

### Rules
- **Classify first.** Never install an artifact without knowing its type. A skill in the target
  repo, or a tool in the global skills dir, is a bug.
- **Stack-agnostic.** This toolkit assumes nothing about the target's language or framework.
  Do not add language-specific tooling unless an INSTALL.md says to, or the user asks.
- **Idempotent.** If a file already exists, merge rather than clobber. For `AGENTS.md`, append or
  update the relevant section; never overwrite the whole file. For skills, skip if already
  installed.
- **No clone.** Do not `git clone` this toolkit or any upstream source. Recreate files from what
  this toolkit carries.
- **Minimal footprint.** Only create what the catalogs and INSTALL files specify.

---

## Catalogs

### Tool catalog (installs *inside* the target repo)

| Tool | Status | What it does | INSTALL |
|------|--------|--------------|---------|
| **why-journal** | `DEFAULT` | Captures the *why* behind every change: a daily journal of asks + rationale, plus durable decision records. The user's core requirement — install on every repo. | `tools/why-journal/INSTALL.md` |
| **workspace-hygiene** | `OPTIONAL` | Keeps the repo tidy *as the agent works*: a root whitelist, a sanctioned gitignored `.scratch/` dir for temp work, file-placement rules, and an anti-cruft `.gitignore` — all carried in `AGENTS.md`. Install on request, or when a repo keeps accumulating stray temp files/clutter. | `tools/workspace-hygiene/INSTALL.md` |

### Skill catalog (installs into the *agent's* global skills dir — NOT the target repo)

| Skill | Status | What it does | INSTALL |
|-------|--------|--------------|---------|
| **humanizer** | `DEFAULT` | Removes signs of AI-generated writing from text (33 patterns: em dashes, rule-of-three, significance inflation, filler, etc.). Use for any writing/editing task. Vendored from blader/humanizer (MIT). | `skills/humanizer/INSTALL.md` |

### Agent catalog (installs into the *agent's* global agent dir)

_None yet._ When added, agents install to the agent's global agent directory, not the target repo.

### MCP catalog (installs into the *agent's* global MCP config — NOT the target repo, NOT vendored)

| MCP | Status | What it does | INSTALL |
|-----|--------|--------------|---------|
| **playwright** | `OPTIONAL` | Browser automation via the official `@playwright/mcp` server: navigate, click, fill forms, read accessibility snapshots, run e2e checks. Pulled from npm at runtime — not vendored here. Install on request or for browser-heavy repos. | `mcp/playwright/INSTALL.md` |

> More artifacts will be added over time. Anything marked `DEFAULT` installs automatically.
> Anything `OPTIONAL` installs only on request. **Always install to the location dictated by the
> artifact's type** (see the Artifact types table above).

### Adding a new artifact to this toolkit (for the maintainer/agent extending the toolkit)

**A tool** — create `tools/<name>/` with:
- `README.md` — what it is and the *why* behind it.
- `INSTALL.md` — the exact steps an agent follows to install it into a target repo.
- `templates/` — the files (with placeholders) the agent recreates.
Then add a row to the **Tool catalog** with its status.

**A skill** — create `skills/<name>/` with:
- `SKILL.md` — the skill itself (copied verbatim if vendored from upstream).
- `README.md` — what it is, the *why*, when to use it, and provenance/license if vendored.
- `INSTALL.md` — steps to install it into the agent's global skills dir. Must state plainly
  that it does **not** go into the target repo.
- `LICENSE` — if vendored from a licensed upstream, carry the license.
Then add a row to the **Skill catalog** with its status.

**An agent** — create `agents/<name>/` with a `README.md`, an `INSTALL.md` (installs to the
agent's global agent dir), and the agent definition file. Then add a row to the **Agent catalog**.

**An mcp** — create `mcp/<name>/` with:
- `README.md` — what it is, the *why*, when to use it, and a pointer to the upstream package/repo.
- `INSTALL.md` — steps to add the server to the agent's global MCP config. Must state plainly
  that it does **not** go into the target repo and is **not** vendored (it's fetched at runtime).
Do **not** copy the server's code into this toolkit — carry only the config pointer. Then add a
row to the **MCP catalog** with its status.
