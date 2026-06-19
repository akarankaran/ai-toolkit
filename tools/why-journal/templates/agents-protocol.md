## Why-Journal Protocol

This repo tracks the **why** behind every change in `docs/why/`. Follow this on every task.

**When you change code or config:**
1. Add an entry to today's journal file `docs/why/journal/YYYY-MM-DD.md` (create it if missing,
   using an existing day's file as the template). Record:
   - **Ask** — what the user asked for (intent, not implementation).
   - **Changed** — files/areas touched.
   - **Why** — the rationale: why this approach, what problem it solves, what constraint shaped it.
   - **Decision** — link to a decision record if the choice was significant; else "—".
   - **Agent** — your agent/model name, if known.

**When you make an architecturally significant choice** (framework/library pick, data model,
API shape, security tradeoff, notable deviation from the obvious approach):
2. Write a decision record in `docs/why/decisions/NNNN-short-title.md` (next sequential number),
   following `docs/why/decisions/README.md`, and link to it from the journal entry.

**Principles:**
- Capture the why **as you work**, from the context that produced the change — don't reconstruct
  it later from the diff.
- Keep it short and honest. Reasoning over changelog.
- Never delete or rewrite past entries or decision records; supersede instead.

See `docs/why/README.md` for the full explanation.
