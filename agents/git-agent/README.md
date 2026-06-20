# git-agent (agent)

Writes change summaries for git work in two registers at once: a plain-language headline
anyone can follow, and precise technical detail underneath.

## What it is

This is an **agent** — a specialized subagent persona with its own prompt and (read-only)
permissions. It differs from the other artifact types in this toolkit:

- A **tool** (why-journal) is repo scaffolding the agent recreates *inside the target repo*.
- A **skill** (humanizer) is a `SKILL.md` capability loaded on demand.
- An **mcp** (agent-browser) is a config pointer to an external server.
- An **agent** (this) is a persona definition — a markdown file with frontmatter (mode,
  permissions) and a system prompt — that the host agent tool loads as an invokable subagent.

Unlike the original toolkit assumption that agents install globally, **git-agent installs
repo-scoped**, into the target repo's project-local agent directory for whatever agent tool
the user is on (opencode, Claude Code, etc.). It is **not** opencode-only. See `INSTALL.md`
for the per-tool paths.

## The problem it solves

The reasoning behind a change and the change itself are both worth recording, but the
audiences differ. A teammate skimming a PR wants the plain-language outcome; a reviewer
merging it needs the exact files, mechanisms, and breaking changes. Hand-written summaries
usually serve one audience and shortchange the other — either too vague to act on, or a wall
of jargon nobody outside the diff can read.

git-agent writes both at once: a headline a non-technical person follows, then the full
technical detail underneath with nothing dropped. Short, articulated, and structured
bottom-line-up-front.

## How it works

A single markdown file carries the agent: frontmatter sets it to a read-only subagent (only
read-only `git` commands allowed, no edits), and the prompt body specifies the two-register
output format — plain-language headline, plain-terms bullets, technical detail, a
Conventional Commits type, breaking-change note, and a verify step. There is no code; the
host tool loads the markdown and runs it as an invokable subagent.

## When to use it

Reach for git-agent whenever you need to describe git work to someone:
- Drafting a commit message (it emits a Conventional Commits message on request).
- Writing a PR or merge-request description.
- A "what changed since yesterday" status update for a standup or a non-technical stakeholder.

Invoke it by `@git-agent` in tools that support subagent mentions, or by pointing the host
agent at the staged diff / commit range you want summarized. It is read-only — it produces
text for you to paste; it never commits or pushes.

## Pairing with why-journal

git-agent reports the **what**; why-journal records the **why**. They are complementary —
when both are installed, git-agent references the relevant journal entry or decision record
rather than re-deriving the rationale.

## What gets created on install

Files in the **target repo only**, in the project-local agent directory for the user's agent
tool (e.g. `.opencode/agent/git-agent.md`, `.claude/agents/git-agent.md`). Nothing is written
to the global/laptop-wide agent config. See [`INSTALL.md`](./INSTALL.md) for exact paths and
the cross-tool steps.
