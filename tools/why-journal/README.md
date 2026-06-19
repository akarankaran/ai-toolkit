# why-journal

Captures the **why** behind every change in a repo, in plain markdown.

## The problem it solves

AI agents are excellent at the *what* and *how*. They write the code, change the schema, add
the flag. But the **why** lives only in the chat session that produced it — and that session
evaporates the moment it ends.

Six months later you find a column called `user_tier_v2`, or a retry with a hardcoded `3`, or
a seemingly redundant cache layer. `git blame` points at a commit that says "update logic". The
prompt that asked for it, the constraint that shaped it, the alternative that was rejected — all
gone. You (or the next agent) end up reverse-engineering intent from a diff, and that's where
regressions are born.

why-journal fixes this by making every agent record the *why* **as it works**, in the same
context that produced the change — not inferred afterward from the diff.

## How it works

Two layers of markdown, both committed alongside the code.

### 1. Daily journal — the running log
`docs/why/journal/YYYY-MM-DD.md`. One file per day, one entry per task. Each entry records:
- **Ask** — what the user actually asked for (the intent, not the implementation).
- **Changed** — the files/areas touched.
- **Why** — the rationale. Why this approach, what problem it solves, what constraint shaped it.
- **Decision** — a link to a decision record, if the choice was architecturally significant.

This is fast to write and gives you a chronological story of how the repo got to where it is.

### 2. Decision records — the durable why
`docs/why/decisions/NNNN-title.md`. ADR-lite (Architectural Decision Records). When a choice is
significant enough that someone will question it later — a framework pick, a data model, a
tradeoff between two real options — it gets its own numbered, permanent record: context,
the decision, **the rationale**, consequences, and the alternatives that were rejected and why.

Journal entries are the *stream*; decision records are the *durable index* of the choices that
matter. A journal entry links up to a decision record when one exists.

## Why this design (the why behind the why)

- **Plain markdown, in-repo.** No database, no service, no MCP server, no accounts. It travels
  with the code, survives clones, diffs in PRs, and is readable by any human or agent forever.
- **Carried by `AGENTS.md`.** The protocol is written into the target repo's `AGENTS.md`, which
  nearly every coding agent reads automatically. That's what makes the capture happen on *every*
  run without per-agent configuration.
- **Two layers, not one.** A single log either drowns in noise (everything) or loses the daily
  texture (only big decisions). Splitting the running journal from durable decisions keeps both
  useful.
- **Capture live, not after.** The agent writes the why from the same context that made the
  change, so it reflects actual intent rather than a guess reconstructed from the diff.

## What gets created in the target repo

```
<target-repo>/
├── AGENTS.md                       # gains a "Why-Journal Protocol" section
└── docs/why/
    ├── README.md                   # explains the system in-repo
    ├── journal/
    │   └── YYYY-MM-DD.md            # daily entries (first one seeded for today)
    └── decisions/
        ├── README.md               # how to write a decision record
        └── 0001-record-architecture-decisions.md   # the seed ADR
```

See [`INSTALL.md`](./INSTALL.md) for the exact install steps.
