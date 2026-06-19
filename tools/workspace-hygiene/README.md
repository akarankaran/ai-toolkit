# workspace-hygiene

Keeps a repo tidy **while** an agent works in it, instead of cleaning up after.

## The problem it solves

Agents are messy houseguests. Over a few sessions a repo accumulates cruft:

- Temp scripts dropped in the root (`test.py`, `debug.js`, `scratch.sh`).
- One-off debug output, logs, and `.DS_Store` files committed by accident.
- Throwaway experiments left lying in source directories.
- Files placed wherever the agent happened to be, not where they belong.

Each session leaves a little residue. A month later the root is a junk drawer, the test dir
has stray scripts in it, and nobody can tell what's real source and what's leftover. You spend
the first ten minutes of every session figuring out what to delete.

The fix isn't a periodic sweep — it's discipline the agent follows on every run, so the mess
never accumulates in the first place.

## How it works

Like why-journal, the mechanism is a protocol injected into the target repo's `AGENTS.md`,
which nearly every coding agent reads automatically. That makes hygiene happen on every run
with no per-agent config. The protocol stands on four conventions:

### 1. Root whitelist — the root is sacred
The repo root is for configuration and entry points only. The protocol defines an explicit
allow-list (`README`, `AGENTS.md`, `LICENSE`, lockfiles, language/tool config, the obvious
dotfiles, and known source/test/docs directories). Anything not on the list is a violation:
the agent either puts it in the right place or, if it's throwaway, in the scratch dir.

### 2. A sanctioned scratch dir — `.scratch/`
One place, hidden and gitignored, where agents may write temp scripts, debug output, scratch
notes, and one-off experiments. Because it exists and is blessed, the agent has somewhere to
put working files other than the root. Because it's gitignored, nothing in it can be committed
by accident.

### 3. File-placement discipline
Tests go in the test dir, docs in `docs/`, source in the source tree. No stray scripts, logs,
or artifacts loose in source directories. The protocol states the rule; the agent follows it
when creating files.

### 4. Clean up before done
At the end of a task the agent removes its own scratch artifacts (temp scripts, debug files)
rather than leaving them for next time. The scratch dir is working space, not a landfill.

Plus an **anti-cruft `.gitignore` baseline** — common junk (`.DS_Store`, `*.tmp`, `*.bak`,
`*.orig`, editor swap files, the scratch dir itself) so the residue that does get created never
reaches a commit.

## Why this design (the why behind the why)

- **Prevention, not cleanup.** A scheduled sweep treats the symptom; it runs after the mess
  exists and risks deleting something real. A convention the agent follows live stops the mess
  at the source. Cheaper, safer, no scripts to maintain.
- **Carried by `AGENTS.md`.** Same reason as why-journal: it's the one file nearly every agent
  reads, so the rules apply on every run without configuring each tool.
- **A blessed scratch dir beats "don't make a mess".** Agents *need* somewhere to put working
  files. Telling them "don't litter" without giving them a bin just pushes the litter into the
  root. `.scratch/` is the bin.
- **Hidden + gitignored.** `.scratch/` is out of sight (doesn't clutter listings), unmistakably
  not source, and trivially excluded from git — so scratch work can never leak into a commit.
- **Stack-agnostic.** The whitelist is expressed in terms every repo has (root config, source,
  tests, docs). No assumption about language or framework.
- **No dependencies, no service.** Plain markdown + a `.gitignore` block. Travels with the repo,
  readable by any human or agent forever.

## What gets created in the target repo

```
<target-repo>/
├── AGENTS.md            # gains a "Workspace Hygiene Protocol" section
├── .gitignore           # gains an anti-cruft block (merged, not clobbered)
├── .scratch/
│   ├── .gitkeep         # so the dir exists in a fresh clone
│   └── README.md        # what belongs here, and that it's gitignored + swept
└── docs/hygiene/
    └── README.md        # the root whitelist + placement rules, explained
```

See [`INSTALL.md`](./INSTALL.md) for the exact, idempotent install steps.
