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

The agent installs every `DEFAULT` tool automatically and any `OPTIONAL` tool I name.
Nothing gets cloned — the agent reads the templates here and recreates them in the target repo.

OpenCode users: there's a skill at `.opencode/skill/setup-ai-repo` that wraps this so you can
just invoke the skill instead of pasting the instructions.

## What's in the box

### why-journal (default)
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

## Layout

```
ai-toolkit/
├── TOOLKIT.md                 # agent entrypoint — point agents here
├── README.md                  # this file
├── setup.sh                   # optional curl-based installer (no clone)
├── tools/
│   └── why-journal/
│       ├── README.md          # what it is + the why behind it
│       ├── INSTALL.md         # steps an agent follows to install it
│       └── templates/         # files the agent recreates in the target repo
└── .opencode/
    └── skill/
        └── setup-ai-repo/
            └── SKILL.md        # OpenCode wrapper pointing at TOOLKIT.md
```

## Extending it

Add a folder under `tools/<name>/` with a `README.md`, an `INSTALL.md`, and a `templates/`
directory, then register it in the catalog table in `TOOLKIT.md`. Mark it `DEFAULT` to install
everywhere or `OPTIONAL` to install on request.
