Activate frontend task mode for this session.

Applies to component work, UI logic, state management, API integration, and styling. Works with React, Svelte, Vue, and vanilla JS/TS. Includes Cloudflare Workers and edge-side rendering patterns.

## Mode Behavior

In frontend mode:
- Prefer composable, pure components. Side effects are explicit and isolated.
- State is minimal and co-located with the component that owns it.
- API calls go through typed fetch wrappers, not inline.
- Styling via CSS modules or utility classes — no inline styles except for dynamic values.
- Accessibility is not optional: semantic HTML, ARIA roles where native elements are insufficient.

## Component Design Rules

- One component, one responsibility.
- Props typed explicitly. No `any`. No optional props without default values.
- Event handlers named `handle<Event>` at the definition site.
- Loading, error, and empty states handled explicitly — no implicit undefined.
- Data that does not change is not state. Derive from props or compute in render.

## State Management

Prefer local state. Elevate only when two unrelated components need the same value.

| Need | Approach |
|------|----------|
| Local UI state | `useState`, `useSignal`, or component-local store |
| Form state | Controlled inputs with explicit change handlers |
| Server data | Tanstack Query, SWR, or fetch-in-effect with cleanup |
| Global app state | Zustand, Jotai, Nanostores — keep it flat |
| URL-derived state | Read from URL params — do not duplicate into state |

## API Integration

- Typed fetch functions in a dedicated `api/` or `lib/` directory.
- No fetch calls inline in components.
- Request and response types defined. Validate responses at the boundary.
- Errors surfaced to the UI explicitly — no silent failures.
- Abort controllers on fetch calls inside effects to prevent race conditions.

## Performance

- Images: explicit width/height to prevent layout shift. Lazy-load below the fold.
- Bundle size: import only what you use. Check with `wrangler deploy --dry-run` or `next build` output.
- Avoid rendering waterfalls: load in parallel where possible.
- No synchronous expensive computation in render path — move to worker or memoize.

## Cloudflare Workers / Edge

- Pages Functions in `functions/` directory follow filesystem routing.
- Workers use `fetch` event handler or `export default { fetch }` module syntax.
- Static assets served from KV or R2, not bundled.
- Environment variables via `env` bindings — typed in `Env` interface.

## Accessibility Checklist

- Interactive elements are keyboard reachable
- Focus order is logical
- Color is not the sole indicator of state
- Form inputs have associated labels
- Error messages are announced to screen readers

## Output Conventions

When generating components:
1. Component file first
2. Types/interfaces at the top of the file
3. No default exports on types
4. Named exports preferred for components used across files

Confirm activation with "frontend mode active." then proceed.
