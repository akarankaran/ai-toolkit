## Workspace Hygiene Protocol

This repo stays tidy by discipline, not cleanup. Follow these rules on every task that creates
or moves files. The full explanation lives in `docs/hygiene/README.md`.

### 1. The root is sacred

The repo root is for configuration and entry points only. Do **not** drop temp scripts, debug
output, logs, notes, or one-off experiments there. Allowed at the root:
- Standard meta files: `README*`, `AGENTS.md`, `LICENSE*`, `.gitignore`, `.editorconfig`,
  and other dotfiles that belong at the root.
- This repo's config: {{ROOT_CONFIG}}.
- Known directories: {{SOURCE_DIRS}}, {{TEST_DIRS}}, `docs/`, `.scratch/`.

If a file you're about to create at the root isn't one of these, it belongs somewhere else —
the right source/test/docs dir, or `.scratch/` if it's throwaway.

### 2. Put temp and scratch work in `.scratch/`

`.scratch/` is the one sanctioned place for working files: temp scripts, debug output, scratch
notes, scratch data, one-off experiments. It is gitignored, so nothing in it is ever committed.
When you need to write a quick script to test something, or dump intermediate output, put it
in `.scratch/` — never in the root or a source directory.

### 3. Place files where they belong

- Source code → {{SOURCE_DIRS}}.
- Tests → {{TEST_DIRS}}. Don't leave stray test or debug scripts in source directories.
- Documentation → `docs/`.
- Throwaway/working files → `.scratch/`.

### 4. Clean up before you're done

At the end of a task, remove the scratch artifacts you created (temp scripts, debug files) once
they've served their purpose. `.scratch/` is working space, not a dumping ground — leave it as
empty as you found it. Never commit anything from `.scratch/`.

### Principles
- Prevent the mess; don't rely on a later sweep to fix it.
- When unsure where a file goes, prefer `.scratch/` over the root.
- Keep the root listing short enough to read at a glance.
