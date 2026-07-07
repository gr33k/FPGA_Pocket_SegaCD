# Repository Status

## Branch policy
- Default branch: `main`
- Working branch for this milestone: `main`

## Current milestone
- Genesis-only feasibility scaffold for Analogue Pocket APF.
- No Sega CD / Mega-CD logic is implemented.
- No 32X logic is instantiated.
- No save-state support is implemented.
- No memory-controller feature work is implemented yet.
- No real CD hardware behavior is implemented.
- Task 5E added scaffold build wiring manifest and smoke-test parameter docs.
- Task 5G added a documented smoke configuration override flow for scaffold modes and made `ENABLE_FAKE_ROM_FOR_SMOKE_TEST` independently overrideable through `core_top`.

## Scope currently in-tree
- Kept in `apf/`:
  - APF wrapper scaffold for Genesis base runtime.
  - APF contract JSON set for genesis-only scaffold.
  - APF scaffold source manifest for the current build set (`apf_scaffold_sources.f`).
- Kept in `docs/`:
  - Baseline inventory map.
  - Repository status summary.
  - Smoke-test configuration and build wiring checklist documents for task 5E.
- No other runtime behavior was modified outside APF scaffold files during this milestone.

## Status checks to keep conservative
- Build target for this stage remains APF compile-verification only.
- Imported Genesis runtime RTL is not modified.
- Existing Milestone constraints remain enforced in wrapper review:
  - no Sega CD logic instantiated
  - no fancy menu path
  - one controller
  - video/audio output only

- No checked-in default parameter changes were introduced for smoke behavior.

## Repo-path hygiene
- Replace absolute local paths with repo-relative links in docs.
- Prefer repo-relative references for file links.
