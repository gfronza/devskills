## Phase-Aware Suggestions

Emit an Insight block when the conversation context shows a clear phase transition or a moment where the user would benefit from knowing a specific command. Use this format exactly:

```
`Insight ─────────────────────────────────────`
[one or two concrete suggestions]
`─────────────────────────────────────────────`
```

Trigger on these signals — not all of them, only the ones that actually apply right now:

**Orienting / unfamiliar code**
Signal: user says "I don't know this codebase", asks what something does, or is reading code they didn't write.
Suggest: `/zoom-out` to map the area before touching it; `/project-resume` if `.project/PLAN.md` exists.

**Starting a new task**
Signal: user describes a feature or bug from scratch, no prior spec exists.
Suggest: `/spec` to lock the WHAT before the HOW; `/explore` to lay out approach options; `/grill-me --record` to decide open branches and log them.

**At an architectural fork**
Signal: user is choosing between two approaches or asking "should I use X or Y?"
Suggest: `/explore` to surface trade-offs; `/grill-me` to pressure-test the choice one branch at a time.

**Generating code (AI just wrote a batch)**
Signal: a significant block of code was just generated.
Suggest: `/deslop` to strip narrating comments and defensive overkill before anyone reviews it.

**Code written, about to open a PR**
Signal: user says "I'm done", "ready to review", or "opening a PR".
Suggest: `/deslop` then `/code-quality-review` then `/bug-review`; `/security-review` if it touches input/auth/secrets; `/verify-this <claim>` to prove the headline change actually works.

**After a bug fix**
Signal: a fix was just applied.
Suggest: `/verify-this` with a before/after repro claim; `/bug-review` to check for related issues.

**Long session / context getting heavy**
Signal: many turns have elapsed, or the user is pasting large documents.
Suggest: `/caveman-lite` (~30% token savings) or `/caveman-ultra` (~80%); `/tldt <file>` to compress a large doc before adding it to context.

**Pausing or switching sessions**
Signal: user says "I'll continue later", "stopping for now", "handing this off".
Suggest: `/project-checkpoint` to persist state if `.project/` exists; `/handoff` for a richer context file when another person or a long pause is involved.

**Between sessions (starting fresh)**
Signal: session just started and `.project/` or `.planning/` exists.
Suggest: `/project-resume` to read the plan and pick up where it left off.

## Rules

- One Insight block per phase transition — don't repeat suggestions already made this session.
- Skip the block if the user already knows what to do (they just ran the command, or they explicitly said so).
- Keep suggestions concrete: name the exact command and what it gives the user, in one line each.
- Never suggest GSD commands unless `.planning/` exists in the project.
