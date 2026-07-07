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
- Task 5P tightened the compile-probe source list by static inspection to confirmed files only.
- Task 5Q documented mixed-language compile strategy and flow constraints.
- Task 5R documented APF Quartus/openFPGA project planning and structure approach.
- Task 5S documented future Quartus/openFPGA project skeleton, file checklist, output-ignore plan, and validation checklist (docs only).
- Task 5T implemented generated-output ignore rules in `.gitignore`.
- Task 5U added Quartus project dry-run planning documentation.
- Task 5V created a documentation-only `quartus/` directory with:
  - `quartus/README.md`
  - `quartus/notes_mixed_language.md`
- Imported runtime RTL remains unmodified and is treated as read-only in this phase.
- `docs/GENESIS_RUNTIME_FIRST_COMPILE_ERRORS.md` records advisory probe output and tool constraints.

## Scope currently in-tree
- Kept in `apf/`:
  - APF wrapper scaffold for Genesis base runtime.
  - APF contract JSON set for genesis-only scaffold.
  - APF scaffold source manifest for the current build set (`apf_scaffold_sources.f`).
- Kept in `docs/`:
  - Baseline inventory map.
  - Repository status summary.
  - Smoke-test configuration and build wiring checklist documents for task 5E.
  - Real-runtime compile-probe planning docs and source-list tightening notes.
  - Mixed-language and Quartus planning docs for Tasks 5Q and 5R.
- No other runtime behavior was modified outside APF scaffold files during this milestone.

- Runtime source-list planning is still inactive and not compile-ready.
- No actual Quartus/openFPGA project files were created in Task 5S.
- No actual Quartus/openFPGA project files were created in Task 5T.
- No actual Quartus/openFPGA project files were created in Task 5U.
- No real Quartus project files were created in Task 5V.
- Runtime compile remains inactive; `.gitignore` contains future generated-output hygiene only.
- APF runtime compile remains inactive; no synthesis claims are made.

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
- Runtime compile planning remains constrained to compile-probe and dependency discovery; full runtime build is still pending.
- No Sega-CD hardware path is present and no memory-controller feature is implemented yet.
- VHDL or mixed-language runtime dependencies remain pending in the current probe tooling.

## Planned runtime import tasks

- Task 5M: completed submodule add for `third_party/Genesis_MiSTer`.
- Task 5S: create a future Quartus/openFPGA skeleton checklist (documentation only).
- Remaining runtime integration remains planning/verification work (compile-oriented dependency pass, manifest completion, and filelist updates).
- Current docs:
  - [docs/TASK5L_GENESIS_IMPORT_STRATEGY.md](docs/TASK5L_GENESIS_IMPORT_STRATEGY.md)
  - [docs/THIRD_PARTY_IMPORT_POLICY.md](docs/THIRD_PARTY_IMPORT_POLICY.md)
  - [docs/GENESIS_MISTER_SUBMODULE_PLAN.md](docs/GENESIS_MISTER_SUBMODULE_PLAN.md)
  - [docs/TASK5N_IMPORTED_RUNTIME_TREE_INSPECTION.md](docs/TASK5N_IMPORTED_RUNTIME_TREE_INSPECTION.md)
  - [docs/GENESIS_RUNTIME_SOURCE_LIST_DRAFT_V1.md](docs/GENESIS_RUNTIME_SOURCE_LIST_DRAFT_V1.md)
  - [docs/TASK5P_RUNTIME_SOURCE_LIST_TIGHTENING.md](docs/TASK5P_RUNTIME_SOURCE_LIST_TIGHTENING.md)
  - [docs/TASK5Q_MIXED_LANGUAGE_COMPILE_STRATEGY.md](docs/TASK5Q_MIXED_LANGUAGE_COMPILE_STRATEGY.md)
  - [docs/GENESIS_MIXED_LANGUAGE_TOOLCHAIN_NOTES.md](docs/GENESIS_MIXED_LANGUAGE_TOOLCHAIN_NOTES.md)
  - [docs/GENESIS_COMPILE_FLOW_OPTIONS.md](docs/GENESIS_COMPILE_FLOW_OPTIONS.md)
  - [docs/TASK5R_APF_QUARTUS_PROJECT_PLAN.md](docs/TASK5R_APF_QUARTUS_PROJECT_PLAN.md)
  - [docs/TASK5S_QUARTUS_OPENFPGA_PROJECT_SKELETON_CHECKLIST.md](docs/TASK5S_QUARTUS_OPENFPGA_PROJECT_SKELETON_CHECKLIST.md)
  - [docs/QUARTUS_PROJECT_FILE_CHECKLIST.md](docs/QUARTUS_PROJECT_FILE_CHECKLIST.md)
  - [docs/APF_BUILD_OUTPUT_IGNORE_PLAN.md](docs/APF_BUILD_OUTPUT_IGNORE_PLAN.md)
  - [docs/APF_PROJECT_VALIDATION_STEPS.md](docs/APF_PROJECT_VALIDATION_STEPS.md)
  - [docs/TASK5T_REPOSITORY_HYGIENE_IGNORE_RULES.md](docs/TASK5T_REPOSITORY_HYGIENE_IGNORE_RULES.md)
  - [docs/TASK5U_QUARTUS_PROJECT_DRY_RUN_PLAN.md](docs/TASK5U_QUARTUS_PROJECT_DRY_RUN_PLAN.md)
  - [docs/QUARTUS_PROJECT_FILES_TO_CREATE_LATER.md](docs/QUARTUS_PROJECT_FILES_TO_CREATE_LATER.md)
  - [docs/QUARTUS_SOURCE_GROUP_MAPPING_DRY_RUN.md](docs/QUARTUS_SOURCE_GROUP_MAPPING_DRY_RUN.md)
  - [docs/OPENFPGA_PACKAGING_DEFERRED_PLAN.md](docs/OPENFPGA_PACKAGING_DEFERRED_PLAN.md)
  - [docs/APF_PROJECT_STRUCTURE_PLAN.md](docs/APF_PROJECT_STRUCTURE_PLAN.md)
  - [docs/QUARTUS_OPENFPGA_INTEGRATION_NOTES.md](docs/QUARTUS_OPENFPGA_INTEGRATION_NOTES.md)
  - [docs/TASK5V_QUARTUS_DOCS_DIRECTORY.md](docs/TASK5V_QUARTUS_DOCS_DIRECTORY.md)

## Repo-path hygiene
- Keep project links repo-relative.
- Prefer repo-relative references for file links.
