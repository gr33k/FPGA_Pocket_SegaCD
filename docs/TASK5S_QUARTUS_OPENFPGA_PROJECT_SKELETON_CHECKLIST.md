# Task 5S — Quartus/openFPGA project skeleton checklist (documentation only)

Task 5S defines the future Quartus/openFPGA project skeleton as a **planning-only** artifact.

This task does not create or modify any real project files and does not start synthesis.

- No APF packaging output is produced in this task.
- No build targets are enabled here.
- No Quartus/openFPGA artifacts are claimed as buildable yet.
- No gameplay/runtime boot claims are introduced.
- `third_party/Genesis_MiSTer` remains read-only for this phase.
- APF glue and compatibility remain in this repo (`apf/`, `docs/`, `tools/`), not under `third_party/`.
- Sega CD / Mega-CD and 32X remain excluded.
- Memory-controller (SDRAM/PSRAM/SRAM) integration remains deferred.
- Host-per-read ROM streaming remains disallowed; ROM architecture is still APF-side preload planning only.

## Scope of this task

- Create checklist documents only:
  - [`docs/TASK5S_QUARTUS_OPENFPGA_PROJECT_SKELETON_CHECKLIST.md`](docs/TASK5S_QUARTUS_OPENFPGA_PROJECT_SKELETON_CHECKLIST.md) (this file)
  - [`docs/QUARTUS_PROJECT_FILE_CHECKLIST.md`](docs/QUARTUS_PROJECT_FILE_CHECKLIST.md)
  - [`docs/APF_BUILD_OUTPUT_IGNORE_PLAN.md`](docs/APF_BUILD_OUTPUT_IGNORE_PLAN.md)
  - [`docs/APF_PROJECT_VALIDATION_STEPS.md`](docs/APF_PROJECT_VALIDATION_STEPS.md)
- Update milestone planning docs without creating `.qpf`, `.qsf`, `.sdc`, `.qip`, `.tcl`, `.sof`, `.rbf`, `.rbf_r`, or synthesis binaries.
- Keep runtime source-lists and runtime dependency work as planning/probe-only.

## What this task did not do

- Did not add real Quartus project files.
- Did not add APF packaging metadata.
- Did not modify upstream runtime code.
- Did not enable save states, CD loading, or CD hardware pathways.
- Did not claim synthesis success.

## What should be done next

- Task 5T should add future `.gitignore` hygiene for Quartus/openFPGA generated files.
- Task 5T should not add or run a real Quartus project yet; it should only prepare safe ignore rules.

