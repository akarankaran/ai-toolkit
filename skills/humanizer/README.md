# humanizer (skill)

Removes signs of AI-generated writing from text so it reads like a human wrote it.

## What it is

This is a **skill**, not a tool. The difference matters in this toolkit:

- A **tool** (like why-journal) is repo scaffolding — the agent recreates files *inside the
  target repo*.
- A **skill** is an on-demand agent capability — a `SKILL.md` prompt that installs into the
  *agent's own skills directory*, where it becomes available across every repo. It does **not**
  get written into the target repo.

humanizer is the latter. Once installed, the agent can invoke it for any writing or editing
task ("humanize this text", or `/humanizer` in tools that support slash commands).

## The problem it solves

AI-generated prose has tells: em dashes everywhere, "rule of three" lists, significance
inflation ("marks a pivotal moment"), promotional language ("nestled in the heart of"), filler
phrases, sycophantic openers, the "It's not just X, it's Y" construction, and so on. humanizer
scans for 33 documented patterns and rewrites them into natural prose while preserving meaning.

## How it works

A single `SKILL.md` carries the whole capability: YAML frontmatter (name, version, description,
allowed tools) followed by a numbered pattern list with before/after examples and a
draft → audit → final rewrite loop. There is no code and no build step — the agent reads the
markdown and follows it.

## When to use it

Reach for humanizer on any writing-related task: drafting or editing essays, blog posts,
documentation, READMEs, release notes, emails, PR descriptions — anywhere AI-isms creep in.
Optionally provide a sample of your own writing for voice matching; the skill will mirror your
cadence instead of producing generic "clean" output.

## What gets created on install

Nothing in the target repo. The agent places `SKILL.md` into the agent's global skills
directory:

```
~/.claude/skills/humanizer/SKILL.md      # works for Claude Code AND OpenCode
```

OpenCode also scans `~/.config/opencode/skills/`; either location works. See
[`INSTALL.md`](./INSTALL.md) for the exact steps.

## Provenance and license

Vendored from [blader/humanizer](https://github.com/blader/humanizer) (version 2.8.0), licensed
MIT. The `SKILL.md` and `LICENSE` here are copied verbatim — this toolkit keeps its own copy
rather than cloning or referencing the upstream repo at install time, so installs are
reproducible and offline-friendly. To update, re-download `SKILL.md` and `LICENSE` from upstream
and bump the version noted above.

The patterns derive from
[Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing),
maintained by WikiProject AI Cleanup.
