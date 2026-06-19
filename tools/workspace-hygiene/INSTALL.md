# INSTALL — workspace-hygiene

> Agent: follow these steps to install workspace-hygiene into the **target repo** (the user's
> current project, not this toolkit repo). All paths below are relative to the target repo root.

## Step 0 — Observe the repo first

Before writing anything, look at the target repo so the rules you install match reality:
- Note the source dir(s) (`src/`, `lib/`, `app/`, `cmd/`, …), the test dir(s) (`tests/`,
  `test/`, `__tests__/`, `spec/`, …), and the docs dir if any.
- Note the language/tool config files at the root (e.g. `package.json`, `pyproject.toml`,
  `go.mod`, `Cargo.toml`, `Makefile`, CI config).
- Note the existing `.gitignore` if present.

You'll use these to fill the `{{PLACEHOLDERS}}` in the templates. The goal is a whitelist that
reflects *this* repo, not a generic one.

## Step 1 — Create the scratch directory

Create `.scratch/` at the repo root, with:
- `.scratch/.gitkeep` — empty file, so the directory survives a fresh clone.
- `.scratch/README.md` — from `templates/scratch-readme.md`, copied as-is.

## Step 2 — Create `docs/hygiene/README.md`

Create the `docs/hygiene/` directory if it doesn't exist. Create `docs/hygiene/README.md` from
`templates/hygiene-readme.md`, filling the placeholders:
- `{{SOURCE_DIRS}}` — the repo's source dir(s), comma-separated (e.g. `src/`). If none is
  obvious, write `the project's source directories`.
- `{{TEST_DIRS}}` — the repo's test dir(s) (e.g. `tests/`). If none, write `the test directory`.
- `{{ROOT_CONFIG}}` — the actual root config files you saw in Step 0, comma-separated
  (e.g. `package.json, tsconfig.json, .eslintrc`). Keep it to what's really there.

## Step 3 — Merge the anti-cruft block into `.gitignore`

Use the lines in `templates/gitignore-block.md` (the fenced block only, not the prose).

- If `.gitignore` does **not** exist, create it with that block.
- If `.gitignore` **already exists**, append the block as a new trailing section. Before adding
  any line, check it isn't already present — skip duplicates. Never remove existing entries.
- Ensure `.scratch/` is ignored (it's in the block). If the repo already ignores it under another
  pattern, don't add a duplicate.

## Step 4 — Inject the protocol into `AGENTS.md`

This is the step that makes hygiene automatic on every future agent run.

- If `AGENTS.md` does **not** exist at the target repo root, create it. Start it with a one-line
  project heading (e.g. `# <repo name>`) then add the protocol block below.
- If `AGENTS.md` **already exists**, append the protocol block as a new section. Do **not**
  overwrite existing content. If a `## Workspace Hygiene Protocol` section already exists, update
  it in place rather than duplicating.

Use the contents of `templates/agents-protocol.md` for the protocol block, filling the same
`{{SOURCE_DIRS}}` / `{{TEST_DIRS}}` / `{{ROOT_CONFIG}}` placeholders as in Step 2 so the
in-`AGENTS.md` summary matches `docs/hygiene/README.md`.

## Step 5 — Report

Tell the user:
- workspace-hygiene is installed.
- Files created/modified: `.scratch/.gitkeep`, `.scratch/README.md`, `docs/hygiene/README.md`,
  the anti-cruft block in `.gitignore`, and the `## Workspace Hygiene Protocol` section in
  `AGENTS.md`.
- One line on how it works: agents keep the root to its whitelist, put temp/scratch work in
  `.scratch/` (gitignored), place files where they belong, and clean up scratch artifacts before
  finishing.

## Idempotency notes
- Re-running setup must not duplicate files, `.gitignore` lines, or `AGENTS.md` sections.
- Never delete a user's existing `.gitignore` entries, scratch contents, or `AGENTS.md` content.
- If `.scratch/` already exists, leave its contents alone; only add `.gitkeep`/`README.md` if
  missing.
- `docs/hygiene/README.md` may be overwritten with the latest template only if unchanged;
  otherwise leave the user's edits in place.
