# Why

This directory captures the **why** behind changes in this repo, in plain markdown.

Code and `git blame` tell you *what* changed and *when*. They rarely tell you *why* — and once
an AI agent's session ends, the intent behind a change is gone. This directory keeps that intent
alive so future readers (you, teammates, or the next agent) don't have to reverse-engineer it.

## Two layers

### Daily journal — `journal/YYYY-MM-DD.md`
A running log. One file per day, one entry per task. Each entry records the **ask** (what was
requested), what **changed**, and the **why** (the rationale). Fast to write; gives a
chronological story of how the repo evolved.

### Decision records — `decisions/NNNN-title.md`
Durable, numbered records for architecturally significant choices (ADR-lite). When a decision is
big enough that someone will question it later, it gets its own permanent file with context,
the decision, the rationale, consequences, and rejected alternatives. See
[`decisions/README.md`](./decisions/README.md).

Journal entries link up to a decision record when one exists.

## How to use it

- **When you change code, add a journal entry** to today's file in `journal/`. Create the file
  if it doesn't exist (use the existing entries as a template).
- **When you make a significant choice, write a decision record** in `decisions/` and link to it
  from the journal entry.
- Keep entries short and honest. The goal is the reasoning, not a changelog.

Agents working in this repo are instructed to do this automatically — see the
"Why-Journal Protocol" section in the repo's `AGENTS.md`.
