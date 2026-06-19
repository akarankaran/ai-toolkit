# INSTALL — humanizer

> Agent: humanizer is a **skill**, not a tool. Read this carefully — it installs differently
> from why-journal.
>
> **Do NOT write humanizer into the target repo.** Skills are agent capabilities that live in
> the agent's own global skills directory, not in the user's project. Creating a `SKILL.md`
> anywhere inside the target repo is wrong.

## Where it goes

Install into the agent's global skills directory:

- **Default (universal):** `~/.claude/skills/humanizer/SKILL.md`
  This works for both Claude Code and OpenCode — OpenCode also scans `~/.claude/skills/`, so a
  single copy here serves both.
- **OpenCode-only alternative:** `~/.config/opencode/skills/humanizer/SKILL.md`

Use the default unless the user tells you otherwise.

## Step 1 — Check if it's already installed

If `~/.claude/skills/humanizer/SKILL.md` already exists, humanizer is installed. Skip to
Step 3 (report). Do not overwrite an existing copy unless the user asks for an update.

## Step 2 — Install the skill

1. Create the directory: `~/.claude/skills/humanizer/`
2. Copy this toolkit's `skills/humanizer/SKILL.md` into it, verbatim. If you fetched this repo,
   you already have the file. Otherwise fetch it from the raw base:
   `https://raw.githubusercontent.com/akarankaran/ai-toolkit/main/skills/humanizer/SKILL.md`
3. Copy `skills/humanizer/LICENSE` alongside it (it's MIT-licensed upstream work).

Do **not** modify `SKILL.md`. It is the product, copied verbatim from upstream.

## Step 3 — Report

Tell the user:
- humanizer is installed at `~/.claude/skills/humanizer/SKILL.md` (or note if it was already
  present and you left it as-is).
- It's available for any writing or editing task — invoke it by asking to "humanize this text",
  or with `/humanizer` in tools that support slash commands.
- It did **not** touch the target repo.

## Idempotency notes
- Re-running setup must not duplicate or clobber an existing install.
- Never write `SKILL.md` into the target repo.
- The skill is global: installing it once makes it available in every repo, so there's no need
  to reinstall per project.
