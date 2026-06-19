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
# It installs every DEFAULT artifact:
#   - tools  (installed inside this repo):        why-journal
#   - skills (installed in your agent skills dir): humanizer

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

# README + decisions README + search guide (copied as-is)
fetch "tools/why-journal/templates/why-readme.md" > docs/why/README.md
fetch "tools/why-journal/templates/decisions-readme.md" > docs/why/decisions/README.md
fetch "tools/why-journal/templates/search-guide.md" > docs/why/SEARCH.md

# Seed decision record 0001
SEED_DECISION="docs/why/decisions/0001-record-architecture-decisions.md"
if [ ! -f "$SEED_DECISION" ]; then
  cat > "$SEED_DECISION" <<EOF
# 0001 — Record architecture decisions

- **Status:** Accepted
- **Date:** ${TODAY}
- **Tags:** meta
- **Touches:** docs/why/decisions

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
- **Tags:** meta
- **Touches:** docs/why, AGENTS.md
- **Decision:** [../decisions/0001-record-architecture-decisions.md](../decisions/0001-record-architecture-decisions.md)
- **Agent:** setup.sh
EOF
fi

# Seed the index
INDEX="docs/why/INDEX.md"
if [ ! -f "$INDEX" ]; then
  fetch "tools/why-journal/templates/index.md" > "$INDEX"
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
say "  - docs/why/ created (journal + decisions + SEARCH.md + INDEX.md)"
say "  - AGENTS.md updated with the Why-Journal Protocol (read-first loop)"

# ---- humanizer (DEFAULT skill — installs to the agent's GLOBAL skills dir) -
# Skills are agent capabilities, not repo files. This never writes into the target repo.
SKILLS_DIR="${HOME}/.claude/skills/humanizer"
say "Installing humanizer skill (global, not in this repo)"
if [ -f "$SKILLS_DIR/SKILL.md" ]; then
  warn "humanizer already installed at $SKILLS_DIR; leaving it as-is."
else
  mkdir -p "$SKILLS_DIR"
  fetch "skills/humanizer/SKILL.md" > "$SKILLS_DIR/SKILL.md"
  fetch "skills/humanizer/LICENSE" > "$SKILLS_DIR/LICENSE"
  say "  - humanizer installed at $SKILLS_DIR (available in every repo)"
fi

# ---- humanizer (DEFAULT, skill) --------------------------------------------
# Skills are agent capabilities, not repo files. humanizer installs into the
# agent's global skills directory, NOT into this repo. ~/.claude/skills/ is read
# by both Claude Code and OpenCode.
say "Installing humanizer skill"

SKILL_DIR="${HOME}/.claude/skills/humanizer"
if [ -f "${SKILL_DIR}/SKILL.md" ]; then
  warn "humanizer already installed at ${SKILL_DIR}/SKILL.md; leaving it as-is."
else
  mkdir -p "$SKILL_DIR"
  fetch "skills/humanizer/SKILL.md" > "${SKILL_DIR}/SKILL.md"
  fetch "skills/humanizer/LICENSE" > "${SKILL_DIR}/LICENSE" 2>/dev/null || true
  say "  - humanizer installed at ${SKILL_DIR}/SKILL.md (global; not in this repo)"
  say "  - use it for any writing task: ask to \"humanize this text\" or run /humanizer"
fi

say "All DEFAULT artifacts installed."
