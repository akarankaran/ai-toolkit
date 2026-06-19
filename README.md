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

### Artifact types

The toolkit holds more than one kind of thing, and each installs to a different place. The agent
classifies before installing:

- **tool** — repo conventions/scaffolding. Recreated *inside the target repo* (e.g. why-journal).
- **skill** — an on-demand agent capability (`SKILL.md`). Installed into the *agent's* global
  skills directory, available across all repos. Never written into the target repo (e.g. humanizer).
- **agent** — a specialized agent/subagent persona. Installed into the agent's global agent dir.

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

### humanizer (default skill)
A skill that strips signs of AI-generated writing from text — em dashes, rule-of-three lists,
significance inflation, filler phrases, sycophantic openers, and 29 other patterns. Vendored
verbatim from [blader/humanizer](https://github.com/blader/humanizer) (MIT).

Because it's a **skill**, it installs into the agent's global skills directory
(`~/.claude/skills/humanizer/`, which OpenCode reads too), *not* into the target repo. Once
installed it's available everywhere — invoke it for any writing or editing task ("humanize this
text", or `/humanizer`).

## Layout

```
ai-toolkit/
├── TOOLKIT.md                 # agent entrypoint — point agents here
├── README.md                  # this file
├── setup.sh                   # optional curl-based installer (no clone)
├── tools/                     # TOOLS — installed inside the target repo
│   └── why-journal/
│       ├── README.md          # what it is + the why behind it
│       ├── INSTALL.md         # steps an agent follows to install it
│       └── templates/         # files the agent recreates in the target repo
├── skills/                    # SKILLS — installed into the agent's global skills dir
│   └── humanizer/
│       ├── SKILL.md           # the skill itself (vendored verbatim from upstream)
│       ├── README.md          # what it is, the why, when to use it, provenance
│       ├── INSTALL.md         # steps to install it into ~/.claude/skills/
│       └── LICENSE            # upstream MIT license
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

Mark anything `DEFAULT` to install everywhere or `OPTIONAL` to install on request.
