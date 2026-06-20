# INSTALL — git-agent

> Agent: git-agent is an **agent** (a subagent persona), not a tool, skill, or mcp. Read this
> carefully — it installs differently from the others.
>
> - **Install it repo-scoped, into the TARGET REPO.** Unlike the toolkit's older assumption
>   that agents go in the global agent dir, git-agent belongs in the target repo's
>   project-local agent directory, so it travels with the repo and stays scoped to this project.
> - **Do NOT install it laptop-wide / globally.** Never write it to `~/.config/opencode/agent/`,
>   `~/.claude/agents/`, or any machine-wide location.
> - **It is not opencode-only.** Detect the user's agent tool and install to that tool's
>   project-local path (see the table below).

## Status

`DEFAULT`. Install on every repo setup, alongside why-journal. git-agent is part of the
baseline workflow: why-journal captures the *why*, git-agent describes the *what*.

## Where it goes (repo-scoped, per tool)

Install into the **target repo's** project-local agent directory for whichever agent tool the
user runs. All paths are relative to the target repo root:

| Agent tool | Project-local path | Frontmatter keys |
|------------|--------------------|------------------|
| **opencode** | `.opencode/agent/git-agent.md` | `description`, `mode: subagent`, `permission` |
| **Claude Code** | `.claude/agents/git-agent.md` | `name`, `description`, `tools` (or `model`) |
| **Other (Cursor, Codex, Gemini, …)** | a repo-local instructions/prompt file the tool reads (e.g. under `.<tool>/` or the repo's rules dir) | n/a — drop the prompt body as a reusable instruction |

If you can't tell which tool the user is on, ask, or default to the opencode path. If the user
runs more than one tool against this repo, install to each tool's path — the prompt body is the
same; only the frontmatter and location differ.

## Step 1 — Check if it's already installed

Look for an existing `git-agent` agent file at the tool's project-local path above. If present,
it's installed — skip to Step 3 (report). Don't overwrite an existing copy unless the user asks
for an update.

## Step 2 — Create the agent file

Recreate this toolkit's `agents/git-agent/git-agent.md` at the correct project-local path. The
**prompt body is identical across tools**; adapt only the frontmatter to the host tool.

**opencode** — `.opencode/agent/git-agent.md`. Use the file from this toolkit as-is; its
frontmatter already matches opencode (`description`, `mode: subagent`, `permission` with
read-only git allowed).

**Claude Code** — `.claude/agents/git-agent.md`. Keep the same prompt body, but convert the
frontmatter to Claude Code's shape:

```markdown
---
name: git-agent
description: Writes change summaries for git work in two registers — a plain-language headline plus precise technical detail. Use for commit messages, PR descriptions, and "what changed" updates.
tools: Bash, Read, Grep, Glob
---
```

(Restrict to read-only use in the body; Claude Code agents don't take per-command bash
permissions in frontmatter, so the prompt's "you never edit, commit, or push" rule does the
gating.)

**Other tools** — if the tool has no native subagent file format, drop the prompt body (the
content below the frontmatter in `git-agent.md`) into a repo-local instruction/prompt file the
tool loads, and tell the user how to invoke it.

Do not change the prompt body's two-register format or the read-only rule.

## Step 3 — Report

Tell the user:
- git-agent is installed repo-scoped at `<the project-local path you used>` (or note it was
  already present and you left it as-is).
- It is read-only: it summarizes changes into a plain-language headline + technical detail, and
  emits a Conventional Commits message on request. It never edits, commits, or pushes.
- Invoke it with `@git-agent` (tools that support subagent mentions) or by pointing the host
  agent at a staged diff / commit range.
- It did **not** install anything laptop-wide / globally.

## Idempotency notes
- Re-running setup must not duplicate the agent file or clobber an existing one.
- Never install git-agent to the global agent dir — it is intentionally repo-scoped.
- If the user runs multiple agent tools against the repo, each tool's path holds its own copy;
  installing one does not remove another.
