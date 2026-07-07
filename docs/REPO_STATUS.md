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
- Task 5S documented future Quartus/openFPGA project skeleton, validation checks, and checklist.
- Task 5T implemented generated-output ignore rules in `.gitignore`.
- Task 5U added Quartus project dry-run planning documentation.
- Task 5V created `quartus/` documentation-only directory entries.
- Task 5W added non-buildable Quartus placeholder project files under `quartus/`.
- Task 5X added Quartus placeholder hygiene validation docs and a non-invasive script.
- Task 5Y added controlled Quartus activation planning and removed `rg` dependency from hygiene checks.
- Task 5Z converted `quartus/FPGA_Pocket_SegaCD.qpf` and `quartus/FPGA_Pocket_SegaCD.qsf` to active-but-not-run skeletons.
- `docs/TASK5W_QUARTUS_PLACEHOLDER_PROJECT_FILES.md` now records Task 5W scope and constraints.
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
  - Mixed-language and Quartus planning docs for Tasks 5Q/5R/5S/5T/5U/5W/5X.
- Kept in `quartus/`:
  - `README.md` and `notes_mixed_language.md`.
  - Active/placeholder mixed project structure files:
    - `FPGA_Pocket_SegaCD.qpf`
    - `FPGA_Pocket_SegaCD.qsf`
    - `FPGA_Pocket_SegaCD.sdc`
    - `files_apf_scaffold.qsf`
    - `files_genesis_runtime.qsf`
    - `files_constraints.qsf`
- Kept in `tools/`:
  - `check_quartus_placeholder_hygiene.sh` (Task 5X verification helper).
- No other runtime behavior was modified outside APF scaffold files during this milestone.

## Scope state this milestone
- Runtime source-list planning is still inactive and not compile-ready.
- No actual Quartus/openFPGA synthesis/build is enabled.
- Imported `third_party/Genesis_MiSTer` is present and tracked as read-only runtime input for this phase.
- APF packaging output generation is still deferred.
- No CD hardware path and no memory-controller implementation.

## Planned next steps

- Continue 5Z documentation state updates where needed.
- Task 6A should update `tools/check_quartus_placeholder_hygiene.sh` to support mixed active-skeleton/placeholder states.
- Real project conversion remains deferred to preserve safe incremental scope.
- Synthesis is still not run.
- Runtime source integration and constraints are still deferred.
- Sega CD remains unimplemented.
- Memory-controller integration remains deferred.
- APF packaging remains deferred.
