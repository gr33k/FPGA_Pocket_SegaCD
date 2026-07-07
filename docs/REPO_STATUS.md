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
- Task 5H added compile/elaboration sanity scaffolding for `core_top` with simulation-only `apf_genesis_base_stub` and a dedicated core-top smoke testbench.
- Task 5I added a non-invasive Genesis_MiSTer runtime integration plan, manifest draft, and runtime source TODO draft.
- Task 5L selected the future import strategy as a pinned git submodule at `third_party/Genesis_MiSTer`.
- Task 5M added the submodule and recorded pinned revision `adc0c42cfb1fa5d484cc8566767f7d68982bc44a`.
- Task 5N inspected the imported submodule tree and created runtime source-list draft V1.
- Task 5O added a compile-probe workflow for the real runtime boundary and recorded first-error capture scaffolding.
- Task 5O status: compile probe artifacts are present, but no runtime build is active yet.
- Imported runtime RTL remains unmodified and must remain read-only for this phase.
- `docs/GENESIS_RUNTIME_FIRST_COMPILE_ERRORS.md` records advisory probe output and tool availability notes.

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

- Runtime source-list planning is still inactive and not compile-ready.

## Status checks to keep conservative
- Build target for this stage remains APF compile-verification only.
- Imported Genesis runtime RTL is not modified.
- Existing Milestone constraints remain enforced in wrapper review:
  - no Sega CD logic instantiated
  - no fancy menu path
  - one controller
  - video/audio output only

- No checked-in default parameter changes were introduced for smoke behavior.
- `apf_genesis_base_stub` is simulation-only and does not replace runtime boundary behavior.
- Runtime manifest work is planning-only and does not alter imported MiSTer files.
- Runtime compile planning remains constrained to compile-probe and dependency discovery; full runtime build is still pending.
- No Sega-CD hardware path is present and no memory-controller feature is implemented yet.

## Planned runtime import tasks

- Task 5M: completed submodule add for `third_party/Genesis_MiSTer`.
- Remaining runtime integration remains planning/verification work (compile-oriented dependency pass, manifest completion, and integration filelist updates).
- Current docs:
  - [docs/TASK5L_GENESIS_IMPORT_STRATEGY.md](docs/TASK5L_GENESIS_IMPORT_STRATEGY.md)
  - [docs/THIRD_PARTY_IMPORT_POLICY.md](docs/THIRD_PARTY_IMPORT_POLICY.md)
  - [docs/GENESIS_MISTER_SUBMODULE_PLAN.md](docs/GENESIS_MISTER_SUBMODULE_PLAN.md)
  - [docs/TASK5N_IMPORTED_RUNTIME_TREE_INSPECTION.md](docs/TASK5N_IMPORTED_RUNTIME_TREE_INSPECTION.md)
  - [docs/GENESIS_RUNTIME_SOURCE_LIST_DRAFT_V1.md](docs/GENESIS_RUNTIME_SOURCE_LIST_DRAFT_V1.md)

## Repo-path hygiene
- Replace absolute local paths with repo-relative links in docs.
- Prefer repo-relative references for file links.
