# Task 5U — Quartus/openFPGA project skeleton dry-run planning

This task defines a **dry-run** for future human-maintained Quartus/openFPGA project artifacts.

No project files are created here.
No synthesis is enabled.
No APF packaging output is produced.

- Imported runtime remains read-only: `third_party/Genesis_MiSTer`.
- APF glue remains outside `third_party/`.
- Sega CD / 32X remain excluded.
- Memory-controller integration remains deferred.
- Generated-output ignore hygiene was added in Task 5T and remains active.

## Scope

- Plan the exact set of future files.
- Define source grouping for a future compile manifest.
- Keep this as implementation guidance only; no Quartus build files are created in this task.

## Task outcome

- Future file list and ownership is documented in:
  - [`docs/QUARTUS_PROJECT_FILES_TO_CREATE_LATER.md`](docs/QUARTUS_PROJECT_FILES_TO_CREATE_LATER.md)
  - [`docs/QUARTUS_SOURCE_GROUP_MAPPING_DRY_RUN.md`](docs/QUARTUS_SOURCE_GROUP_MAPPING_DRY_RUN.md)
  - [`docs/OPENFPGA_PACKAGING_DEFERRED_PLAN.md`](docs/OPENFPGA_PACKAGING_DEFERRED_PLAN.md)
- Existing planning/status docs were updated to reference the dry-run plan.

## What this task does not do

- It does not create:
  - `quartus/README.md`
  - `quartus/FPGA_Pocket_SegaCD.qpf`
  - `quartus/FPGA_Pocket_SegaCD.qsf`
  - `quartus/FPGA_Pocket_SegaCD.sdc`
  - `quartus/files_apf_scaffold.qsf`
  - `quartus/files_genesis_runtime.qsf`
  - `quartus/files_constraints.qsf`
  - `quartus/openfpga_build.tcl`
  - `quartus/notes_mixed_language.md`
- It does not generate `.sof/.rbf/.rbf_r` outputs.
- It does not claim runtime boot behavior.

## Next task

Task 5V should add `quartus/README.md` and `quartus/notes_mixed_language.md` in documentation-only form and keep all actual project files (`.qpf`, `.qsf`, `.sdc`, `.tcl`, packaging files) not created in this task.

