# Task 6C-6E: Quartus analysis-only attempt

## Goal
Run a controlled Quartus analysis-only attempt against the APF scaffold project skeleton only if Quartus tools are available.

## What was attempted
- Added `tools/run_quartus_analysis_only_if_available.sh`.
- The script runs preflight first.
- It attempts `quartus_map --analysis_and_elaboration FPGA_Pocket_SegaCD` when `quartus_map` is available.
- It captures command output to `docs/QUARTUS_ANALYSIS_ONLY_RESULT.md`.

## Why this is analysis-only
- `analysis_and_elaboration` performs front-end legality/elaboration work only.
- This task intentionally does **not** run:
  - `quartus_sh`/fitter
  - assembler
  - timing analysis
  - full synthesis flow
  - APF packaging

No `*.sof`, `*.pof`, `*.jic`, `*.rpd`, `*.rbf`, `*.rbf_r`, `db/`, `output_files/`, `incremental_db/`, `simulation/`, or `greybox_tmp/` outputs are expected from this stage.

## Why failure is expected
The scaffold still keeps runtime inactive by design:
- `quartus/files_apf_scaffold.qsf` is active and APF-owned.
- `quartus/files_genesis_runtime.qsf` remains inactive placeholder.
- `quartus/files_constraints.qsf` and `quartus/FPGA_Pocket_SegaCD.sdc` remain placeholders.
- Mixed-language/imported runtime dependencies are not yet active in the scaffold flow.

Because of this, analysis can fail on unresolved imports and project-setup gaps while we keep the scope constrained.

## Why Genesis runtime stays inactive
- Runtime integration is planned after scaffold proofing.
- `third_party/Genesis_MiSTer` is present as a pinned submodule but intentionally not switched to full active synthesis paths yet.
- This keeps the milestone conservative and reversible.

## Why runtime RTL remains read-only
- Imported runtime code is under `third_party/Genesis_MiSTer`.
- This task applies no runtime modifications.
- Any compatibility fix must be in APF-side glue once runtime activation is explicitly enabled in later tasks.

## Why generated outputs must not be committed
- Generated `.sof/.pof/.jic/.rpd/.rbf/.rbf_r` files and Quartus build trees are artifacts.
- They are environment-local and must remain out of source history to preserve reviewability and avoid noisy changes.
- The analysis runner removes generated artifacts produced by this task attempt before completion.

## Exclusions retained for this task
- No Sega CD / Mega-CD.
- No 32X.
- No memory-controller integration (SDRAM/PSRAM/SRAM).
- No APF packaging output flow.
- No save-state or BIOS/CD-image paths.

## Next task
Task 6F should classify first Quartus errors into:
- APF scaffold issues,
- missing Genesis runtime dependency issues,
- constraint/project setup issues,
- expected-not-yet-active issues,
without modifying imported runtime RTL.
