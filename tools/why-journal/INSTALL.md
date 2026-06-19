# INSTALL — why-journal

> Agent: follow these steps to install why-journal into the **target repo** (the user's current
> project, not this toolkit repo). All paths below are relative to the target repo root.

## Step 1 — Create the directory structure

Create these directories if they don't exist:
- `docs/why/`
- `docs/why/journal/`
- `docs/why/decisions/`

## Step 2 — Create `docs/why/README.md`

Use the contents of `templates/why-readme.md`. No placeholders to fill — copy as-is.

## Step 3 — Create `docs/why/decisions/README.md`

Use the contents of `templates/decisions-readme.md`. Copy as-is.

## Step 4 — Seed the first decision record

Create `docs/why/decisions/0001-record-architecture-decisions.md` from
`templates/decision-record.md`, filled in as the seed record that establishes the practice:
- Number: `0001`
- Title: `Record architecture decisions`
- Status: `Accepted`
- Date: today's date (`YYYY-MM-DD`)
- Context: "This repo uses why-journal to capture the reasoning behind changes. We need a
  durable place for architecturally significant decisions, separate from the daily journal."
- Decision: "We will keep ADR-lite decision records in `docs/why/decisions/`, numbered
  sequentially, one decision per file."
- Rationale: "Plain-markdown records travel with the code, diff in PRs, and stay readable by
  any human or agent. Numbering gives a stable reference the journal can link to."
- Consequences: "Every architecturally significant choice gets a record. The daily journal
  links to these for the durable why."
- Alternatives considered: "A single decisions file (rejected: grows unwieldy, hard to link
  to); only the daily journal (rejected: big decisions get buried in chronological noise)."

## Step 5 — Seed today's journal entry

Create `docs/why/journal/<today>.md` where `<today>` is today's date in `YYYY-MM-DD` format,
using `templates/journal-entry.md` as the file scaffold. Add one entry recording this very
setup, so the journal starts with a real example:
- Title: `Set up why-journal`
- Ask: paraphrase what the user asked (e.g. "Set up the repo using my ai-toolkit").
- Changed: `docs/why/**`, `AGENTS.md`.
- Why: "Establish why-tracking from day one so the reasoning behind every change is captured
  as work happens, not reconstructed later."
- Decision: link to `../decisions/0001-record-architecture-decisions.md`.
- Agent: the agent/model doing the setup, if known.

## Step 6 — Inject the protocol into `AGENTS.md`

This is the step that makes capture automatic on every future agent run.

- If `AGENTS.md` does **not** exist at the target repo root, create it. Start it with a one-line
  project heading (e.g. `# <repo name>`) then add the protocol block below.
- If `AGENTS.md` **already exists**, append the protocol block as a new section. Do **not**
  overwrite existing content. If a `## Why-Journal Protocol` section already exists, update it
  in place rather than duplicating.

Use the exact contents of `templates/agents-protocol.md` for the protocol block.

## Step 7 — Report

Tell the user:
- why-journal is installed.
- Files created: `docs/why/README.md`, `docs/why/decisions/README.md`,
  `docs/why/decisions/0001-record-architecture-decisions.md`,
  `docs/why/journal/<today>.md`, and the protocol section in `AGENTS.md`.
- One line on how it works: every change should get a journal entry; significant choices get a
  decision record.

## Idempotency notes
- Re-running setup must not duplicate files or `AGENTS.md` sections.
- Never delete existing journal entries or decision records.
- If today's journal file already exists, append a new entry rather than recreating the file.
