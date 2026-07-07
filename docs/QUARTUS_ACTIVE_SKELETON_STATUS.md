# Quartus Active Skeleton Status (Task 6A-6C/6D)

## Active skeleton files

- `quartus/FPGA_Pocket_SegaCD.qpf`
- `quartus/FPGA_Pocket_SegaCD.qsf`

These are active skeleton files and remain non-run.

## APF-only scaffold source include

- `quartus/files_apf_scaffold.qsf`

This file is active as an APF scaffold source list and includes only:
- `apf/src/fpga/core/core_top.v`
- `apf/src/fpga/core/rom_preload_ingress_stub.v`
- `apf/src/fpga/core/rom_local_service_stub.v`
- `apf/src/fpga/core/rom_tiny_local_ram_stub.v`
- `apf/apf_genesis_base.sv`

## Analysis preflight status

- Added: [tools/preflight_quartus_analysis_only.sh](tools/preflight_quartus_analysis_only.sh)
- Preflight report: [docs/QUARTUS_PREFLIGHT_CHECK_REPORT.md](docs/QUARTUS_PREFLIGHT_CHECK_REPORT.md)
- `quartus/FPGA_Pocket_SegaCD.qsf`/`qpf` still only show active-skeleton markers.
- Task 6C-6E introduced a guarded analysis-only run command path via [tools/run_quartus_analysis_only_if_available.sh](tools/run_quartus_analysis_only_if_available.sh).
- Latest result is tracked in [docs/QUARTUS_ANALYSIS_ONLY_RESULT.md](docs/QUARTUS_ANALYSIS_ONLY_RESULT.md).
- This analysis-only flow is advisory only and does not represent full synthesis success.
- No runtime/constraint files were activated by this step.

## Placeholder files still inactive

- `quartus/FPGA_Pocket_SegaCD.sdc`
- `quartus/files_genesis_runtime.qsf`
- `quartus/files_constraints.qsf`

These still carry non-buildable placeholder intent only.

## Not created yet

- `quartus/openfpga_build.tcl`

## Not generated

No build outputs are expected:

- `.sof`
- `.rbf`
- `.rbf_r`
- `output_files/`
- `db/`
- `incremental_db/`

## Notes

This is not a successful compile.
This is not synthesis-ready.
No games are expected to boot from this stage.

Validation note:
- Task 6C-6D added analysis preflight + command plan for future-only Quartus analysis.
- Analysis commands are not run in this milestone.
- Runtime and constraints remain inactive as expected.

## 6G-6H blocker snapshot

- Blocker category: **TOOLCHAIN_UNAVAILABLE**.
- APF skeleton remains active-only with no runtime source activation.
- No files were promoted to active runtime compile path in this step.
- No synthesis/fitter/assembler/timing outputs are expected or committed.
- Next action remains local toolchain setup before any source-activation branch continues.
