Enter the development workflow — orient, spec, build, verify, ship.

This command works GSD-free by default. If `.planning/` exists, it surfaces GSD commands alongside. If `.project/` exists, it reads the plan and reports where to pick up.

## On activation

1. Check for `.planning/ROADMAP.md` (GSD), `.project/PLAN.md` (lightweight), or nothing (fresh start).
2. Report current state: what exists, what phase you appear to be in, what's next.
3. Activate `/tiger-style` implicitly — engineering bar on for the session.
4. If a language profile is set in `AGENTS.md` (look for `<!-- profile: <lang> -->`), apply its conventions.

## Phase map

Each phase has a primary command and the question it answers. Emit an Insight block when entering each phase.

### Orient
*"Where am I? What does this code do?"*
```
`Insight ─────────────────────────────────────`
/zoom-out — map the area before changing it
/project-resume — pick up from .project/PLAN.md if it exists
`─────────────────────────────────────────────`
```

### Spec
*"What exactly are we building?"*
```
`Insight ─────────────────────────────────────`
/spec — lock the WHAT + acceptance criteria → SPEC.md
/explore — lay out approaches at a fork (--web to research)
/grill-me --record — decide open branches → DECISIONS.md
`─────────────────────────────────────────────`
```

### Plan
*"In what order do we build it?"*

Without GSD:
```
/project-plan    # turn spec/decisions into ordered tasks → .project/PLAN.md
```

With GSD (`.planning/` present):
```
/gsd-discuss-phase   # capture constraints before planning
/gsd-plan-phase      # research + execution plan
```

### Build
*"Build it."*
```
`Insight ─────────────────────────────────────`
/tiger-style — safety + explicitness bar (already active)
/tdd — drive implementation with tests
/test — keep the core tested as you build (mode, stays on)
/ui — component/state discipline + design craft (UI work)
`─────────────────────────────────────────────`
```
Modes compose: `/tiger-style /test /ui` can all be active at once.

### Clean
*"Strip the AI slop before anyone looks at it."*
```
`Insight ─────────────────────────────────────`
/deslop — remove narrating comments, defensive overkill, type escape hatches
Run this before any review pass.
`─────────────────────────────────────────────`
```

### Review
*"Is it correct, safe, and idiomatic?"*
```
`Insight ─────────────────────────────────────`
/code-quality-review — structure: is the diff making the codebase worse?
/bug-review — correctness: real bugs, not style
/security-review — if it touches input, auth, secrets, or I/O
/test-quality-review — is the risky logic actually covered?
/go-review · /ts-review · /rust-review — language idioms + security
`─────────────────────────────────────────────`
```

### Verify
*"Does it actually do what I claimed?"*
```
`Insight ─────────────────────────────────────`
/verify-this <claim> — before/after repro, hard verdict: VERIFIED / NOT VERIFIED
Give it something measurable. It refuses vague claims.
`─────────────────────────────────────────────`
```

### Persist / ship
*"Save state, open the PR."*
```
`Insight ─────────────────────────────────────`
/project-checkpoint — persist state before /clear or end of session
/handoff — richer context file for a long pause or handoff to another person
Then: git push + gh pr create
`─────────────────────────────────────────────`
```

## Shortcuts

```
/workflow orient   → zoom out, then report state
/workflow spec     → jump to specification phase
/workflow build    → activate tiger-style + suggest build modes
/workflow review   → run the full pre-PR gate (deslop → reviews → verify)
/workflow status   → report current phase, what exists, what's next
/workflow ship     → checkpoint + gh pr create guidance
```

## Surviving long sessions

```
`Insight ─────────────────────────────────────`
/caveman-lite (~30% savings) or /caveman-ultra (~80%) — compress responses
/tldt <file|url> — compress a long doc before adding it to context
`─────────────────────────────────────────────`
```

Respond with: current state (what files exist, what phase), the recommended next command, and the Insight block for that phase.
