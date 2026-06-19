# Workspace Hygiene

This repo keeps itself tidy through a convention agents follow as they work, rather than a
periodic cleanup. The rules are summarized in `AGENTS.md` (the "Workspace Hygiene Protocol"
section); this file is the full reference.

## Why

Without a rule, agent sessions leave residue: temp scripts in the root, debug output in source
dirs, `.DS_Store` files in commits, throwaway experiments nobody remembers. It compounds until
the repo is hard to read and risky to clean. Stopping it at the source — every agent, every run
— is cheaper and safer than sweeping up afterward.

## The root whitelist

The repo root is for configuration and entry points only. These are allowed at the root:

- **Meta files:** `README*`, `AGENTS.md`, `LICENSE*`, `.gitignore`, `.editorconfig`, and other
  root-level dotfiles.
- **Project config:** {{ROOT_CONFIG}}.
- **Known directories:** {{SOURCE_DIRS}}, {{TEST_DIRS}}, `docs/`, `.scratch/`.

Anything else at the root is a violation. It belongs in the right directory — or, if it's
throwaway, in `.scratch/`.

## The scratch directory: `.scratch/`

`.scratch/` is the sanctioned home for working files:

- Temp scripts written to test or reproduce something.
- Debug output, intermediate data, captured logs.
- Scratch notes and one-off experiments.

It is **gitignored**, so nothing in it can be committed by accident. It is **hidden** so it
stays out of directory listings. Use it freely while working — it's the alternative to
littering the root or a source directory.

`.scratch/` is working space, not storage. Clean up artifacts once they've served their purpose.

## File-placement rules

| Kind of file            | Goes in                |
|-------------------------|------------------------|
| Source code             | {{SOURCE_DIRS}}        |
| Tests                   | {{TEST_DIRS}}          |
| Documentation           | `docs/`                |
| Temp / debug / scratch  | `.scratch/`            |
| Project config          | repo root (whitelist)  |

Don't leave stray scripts, logs, or build artifacts loose in source directories.

## Clean up before done

At the end of a task, remove the scratch artifacts you created. The aim is to leave `.scratch/`
roughly as empty as you found it, and the rest of the tree free of leftovers.

## Anti-cruft `.gitignore`

The install adds a baseline block to `.gitignore` covering common junk (`.DS_Store`, editor
swap files, `*.tmp`, `*.bak`, `*.orig`, `*.log`) and the `.scratch/` directory itself, so the
residue that does get created never reaches a commit.
