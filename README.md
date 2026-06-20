# ai-toolkit

A reference toolkit that teaches any AI coding agent how I like my repos set up.

Instead of repeating the same setup in every new project, I keep the conventions here once.
When I start a new repo, I point an agent at this one and say *"set up this repo using my
toolkit"*. The agent reads [`TOOLKIT.md`](./TOOLKIT.md), then recreates the right files into
whatever repo I'm working in.

## How to use it

Point any agent (OpenCode, Claude Code, Cursor, Codex, Gemini, etc.) at this repo:

> Set up this repo using my toolkit at https://github.com/akarankaran/ai-toolkit —
> read TOOLKIT.md and follow it.

The agent installs every `DEFAULT` artifact automatically and any `OPTIONAL` one I name.
Nothing gets cloned — the agent reads what's here and recreates it in the right place.
If the target project is not already a Git repo, the agent initializes it with `git init` first.

### Artifact types

The toolkit holds more than one kind of thing, and each installs to a different place. The agent
classifies before installing:

- **tool** — repo conventions/scaffolding. Recreated *inside the target repo* (e.g. why-journal).
- **skill** — an on-demand agent capability (`SKILL.md`). Installed into the *agent's* global
  skills directory, available across all repos. Never written into the target repo (e.g. humanizer).
- **agent** — a specialized agent/subagent persona (prompt + frontmatter). Installed
  *repo-scoped*, into the host tool's project-local agent dir (e.g. `.opencode/agent/`,
  `.claude/agents/`) so it travels with the repo. Cross-tool, not laptop-wide (e.g. git-agent).
- **mcp** — an external Model Context Protocol server the agent talks to (e.g. agent-browser).
  Installed as a config pointer in the agent's global MCP config; **not vendored** here and never
  written into the target repo.

This is why I can say "set up this repo" (tools land in the repo) and "use the humanizer" (the
skill installs to the agent and works everywhere) and the agent knows the difference.

OpenCode users: there's a skill at `.opencode/skill/setup-ai-repo` that wraps this so you can
just invoke the skill instead of pasting the instructions.

## What's in the box

### why-journal (default tool)
The core tool. Captures the **why** behind every change, because agents are great at the *what*
but the reasoning evaporates the moment a session ends. Six months later `git blame` says
"claude-code: update schema" and nobody remembers why.

It sets up two layers in the target repo:
- **Daily journal** (`docs/why/journal/YYYY-MM-DD.md`) — one entry per task: the ask, what
  changed, and *why*.
- **Decision records** (`docs/why/decisions/NNNN-*.md`) — durable, numbered rationale for
  architecturally significant choices (ADR-lite).

The protocol is written into the target repo's `AGENTS.md`, which nearly every agent reads
automatically — so every agent run is reminded to log its reasoning.

### workspace-hygiene (optional tool)
Keeps a repo tidy **as the agent works**, instead of cleaning up after. AI sessions leave residue:
temp scripts in the root, debug output in source dirs, `.DS_Store` files in commits, throwaway
experiments nobody remembers. It compounds until the repo is a junk drawer.

It installs four conventions, carried in the target repo's `AGENTS.md` so every agent follows
them on every run:
- **Root whitelist** — the root is for config and entry points only; anything else is a violation.
- **A sanctioned `.scratch/` dir** — hidden and gitignored, the one blessed place for temp scripts,
  debug output, and experiments, so working files never land in the root.
- **File-placement rules** — source in the source tree, tests in the test dir, docs in `docs/`.
- **Clean up before done** — agents sweep their own scratch artifacts at the end of a task.

Plus an anti-cruft `.gitignore` block (`.DS_Store`, `*.tmp`, `*.bak`, editor swap files, the
scratch dir) so residue never reaches a commit. It's a **tool**, so it installs *into the target
repo*. It's `OPTIONAL` — install it on request, or when a repo keeps accumulating clutter.

### humanizer (default skill)
A skill that strips signs of AI-generated writing from text — em dashes, rule-of-three lists,
significance inflation, filler phrases, sycophantic openers, and 29 other patterns. Vendored
verbatim from [blader/humanizer](https://github.com/blader/humanizer) (MIT).

Because it's a **skill**, it installs into the agent's global skills directory
(`~/.claude/skills/humanizer/`, which OpenCode reads too), *not* into the target repo. Once
installed it's available everywhere — invoke it for any writing or editing task ("humanize this
text", or `/humanizer`).

### git-agent (default agent)
A subagent that summarizes git changes in **two registers at once**: a plain-language headline
anyone can follow, and precise technical detail underneath — files and modules touched, the
mechanism, a Conventional Commits type, breaking changes, and how to verify. Nothing technical
gets dropped; the headline just makes it readable to a non-technical person first. Short and
articulated, bottom-line-up-front.

It's the **what** companion to why-journal's **why**: why-journal records the reasoning,
git-agent describes the change. Read-only — it produces text for commit messages, PR
descriptions, or "what changed" status updates; it never commits or pushes.

Because it's an **agent**, it installs **repo-scoped** into the host tool's project-local agent
dir — `.opencode/agent/git-agent.md` for OpenCode, `.claude/agents/git-agent.md` for Claude
Code, a repo-local prompt file for others. It's cross-tool and never installed laptop-wide.
It's `DEFAULT` — installed on every repo setup. Invoke it with `@git-agent`.

### agent-browser (optional MCP server)
Browser automation via [`agent-browser`](https://github.com/vercel-labs/agent-browser), a fast
native (Rust) browser-automation CLI for AI agents with a built-in MCP server — navigate pages,
click, fill forms, read accessibility snapshots, run e2e checks. Useful for front-end work, e2e
tests, or scraping.

Because it's an **mcp**, it's neither vendored nor written into the target repo. Install just adds
an `agent-browser` entry to the agent's global MCP config (for OpenCode,
`~/.config/opencode/opencode.json`) that points at the locally-installed binary via
`agent-browser mcp`. Install the binary once with npm/Homebrew/Cargo, then `agent-browser install`
to fetch Chrome. It's `OPTIONAL` — install it on request or for browser-heavy repos. The MCP
server defaults to a lean `core` tools profile to keep context small; widen it with `--tools` only
when a task needs more.

## Layout

```
ai-toolkit/
├── TOOLKIT.md                 # agent entrypoint — point agents here
├── README.md                  # this file
├── setup.sh                   # optional curl-based installer (no clone)
├── tools/                     # TOOLS — installed inside the target repo
│   ├── why-journal/
│   │   ├── README.md          # what it is + the why behind it
│   │   ├── INSTALL.md         # steps an agent follows to install it
│   │   └── templates/         # files the agent recreates in the target repo
│   └── workspace-hygiene/
│       ├── README.md          # what it is + the why behind it
│       ├── INSTALL.md         # steps an agent follows to install it
│       └── templates/         # AGENTS.md protocol, hygiene + scratch readmes, gitignore block
├── skills/                    # SKILLS — installed into the agent's global skills dir
│   └── humanizer/
│       ├── SKILL.md           # the skill itself (vendored verbatim from upstream)
│       ├── README.md          # what it is, the why, when to use it, provenance
│       ├── INSTALL.md         # steps to install it into ~/.claude/skills/
│       └── LICENSE            # upstream MIT license
├── agents/                    # AGENTS — installed repo-scoped, host tool's project-local dir
│   └── git-agent/
│       ├── git-agent.md       # the agent definition (prompt + frontmatter)
│       ├── README.md          # what it is, the why, when to use it
│       └── INSTALL.md         # repo-scoped, cross-tool install steps
├── mcp/                        # MCP SERVERS — config pointers, not vendored
│   └── agent-browser/
│       ├── README.md          # what it is, the why, when to use it, upstream pointer
│       └── INSTALL.md          # steps to add it to the agent's global MCP config
└── .opencode/
    └── skill/
        └── setup-ai-repo/
            └── SKILL.md        # OpenCode wrapper pointing at TOOLKIT.md
```

## Extending it

- **Add a tool:** create `tools/<name>/` with a `README.md`, an `INSTALL.md`, and a `templates/`
  directory, then register it in the **Tool catalog** in `TOOLKIT.md`.
- **Add a skill:** create `skills/<name>/` with a `SKILL.md`, a `README.md`, an `INSTALL.md`
  (and a `LICENSE` if vendored), then register it in the **Skill catalog** in `TOOLKIT.md`.
- **Add an mcp:** create `mcp/<name>/` with a `README.md` and an `INSTALL.md` (carry only the
  config pointer — never vendor the server), then register it in the **MCP catalog** in
  `TOOLKIT.md`.
- **Add an agent:** create `agents/<name>/` with the agent definition file (prompt +
  frontmatter), a `README.md`, and an `INSTALL.md` (installs repo-scoped into the host tool's
  project-local agent dir), then register it in the **Agent catalog** in `TOOLKIT.md`.

Mark anything `DEFAULT` to install everywhere or `OPTIONAL` to install on request.
