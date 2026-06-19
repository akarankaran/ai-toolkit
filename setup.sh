#!/usr/bin/env bash
#
# setup.sh — optional convenience installer for ai-toolkit (no clone required).
#
# This is a fallback for when you'd rather run a script than have an agent recreate files.
# The primary path is instruction-driven: point an agent at TOOLKIT.md and let it follow along.
#
# Usage (run from inside your target repo):
#   curl -fsSL https://raw.githubusercontent.com/akarankaran/ai-toolkit/main/setup.sh | bash
#
# It installs every DEFAULT tool. Right now that's: why-journal.

set -euo pipefail

RAW_BASE="https://raw.githubusercontent.com/akarankaran/ai-toolkit/main"
TODAY="$(date +%Y-%m-%d)"
NOW="$(date +%H:%M)"

say() { printf '\033[1;32m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m warn:\033[0m %s\n' "$1"; }

fetch() {
  # fetch <relative-path> -> stdout
  curl -fsSL "$RAW_BASE/$1"
}

if [ ! -d .git ]; then
  warn "No .git here. Run this from the root of the repo you want to set up."
fi

# ---- why-journal (DEFAULT) -------------------------------------------------
say "Installing why-journal"

mkdir -p docs/why/journal docs/why/decisions

# README + decisions README (copied as-is)
fetch "tools/why-journal/templates/why-readme.md" > docs/why/README.md
fetch "tools/why-journal/templates/decisions-readme.md" > docs/why/decisions/README.md

# Seed decision record 0001
SEED_DECISION="docs/why/decisions/0001-record-architecture-decisions.md"
if [ ! -f "$SEED_DECISION" ]; then
  cat > "$SEED_DECISION" <<EOF
# 0001 — Record architecture decisions

- **Status:** Accepted
- **Date:** ${TODAY}

## Context

This repo uses why-journal to capture the reasoning behind changes. We need a durable place for
architecturally significant decisions, separate from the daily journal.

## Decision

We will keep ADR-lite decision records in \`docs/why/decisions/\`, numbered sequentially, one
decision per file.

## Rationale (the why)

Plain-markdown records travel with the code, diff in PRs, and stay readable by any human or
agent. Numbering gives a stable reference the journal can link to.

## Consequences

Every architecturally significant choice gets a record. The daily journal links to these for the
durable why.

## Alternatives considered

- **A single decisions file** — rejected: grows unwieldy, hard to link to.
- **Only the daily journal** — rejected: big decisions get buried in chronological noise.
EOF
fi

# Seed today's journal entry
JOURNAL="docs/why/journal/${TODAY}.md"
if [ ! -f "$JOURNAL" ]; then
  cat > "$JOURNAL" <<EOF
# Journal — ${TODAY}

> One entry per task. Newest at the bottom. Capture the *why*, not just the *what*.

## ${NOW} — Set up why-journal

- **Ask:** Set up the repo using my ai-toolkit.
- **Changed:** docs/why/**, AGENTS.md
- **Why:** Establish why-tracking from day one so the reasoning behind every change is captured
  as work happens, not reconstructed later.
- **Decision:** [../decisions/0001-record-architecture-decisions.md](../decisions/0001-record-architecture-decisions.md)
- **Agent:** setup.sh
EOF
fi

# Inject protocol into AGENTS.md
PROTOCOL="$(fetch tools/why-journal/templates/agents-protocol.md)"
if [ ! -f AGENTS.md ]; then
  REPO_NAME="$(basename "$(pwd)")"
  {
    printf '# %s\n\n' "$REPO_NAME"
    printf '%s\n' "$PROTOCOL"
  } > AGENTS.md
elif ! grep -q "## Why-Journal Protocol" AGENTS.md; then
  printf '\n%s\n' "$PROTOCOL" >> AGENTS.md
else
  warn "AGENTS.md already has a Why-Journal Protocol section; leaving it as-is."
fi

say "Done. why-journal installed."
say "  - docs/why/ created (journal + decisions)"
say "  - AGENTS.md updated with the Why-Journal Protocol"
