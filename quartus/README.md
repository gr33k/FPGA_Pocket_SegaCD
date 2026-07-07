# Quartus/openFPGA Documentation & Placeholder Skeletons (Task 6C-6E)

Task 5V created Quartus project planning documentation.
Task 5W added non-buildable placeholder Quartus project files under `quartus/`.
Task 5Z converted `quartus/FPGA_Pocket_SegaCD.qpf` and `quartus/FPGA_Pocket_SegaCD.qsf` to active-but-not-run skeletons.
Task 6A updated hygiene validation for mixed active-skeleton and placeholder states.
Task 6B activated `quartus/files_apf_scaffold.qsf` as an APF-owned scaffold source include list only.
Task 6C-6D added a Quartus analysis-only command plan and preflight script.
Task 6C-6E added a guarded analysis-only Quartus execution script and result capture.

## Current state

The following files now exist as:

- **Active skeleton (Task 5Z):**
  - `quartus/FPGA_Pocket_SegaCD.qpf`
  - `quartus/FPGA_Pocket_SegaCD.qsf`

- **Human-maintained non-buildable placeholders still:**
  - `quartus/FPGA_Pocket_SegaCD.sdc`
  - `quartus/files_genesis_runtime.qsf`
  - `quartus/files_constraints.qsf`

- **Active APF scaffold source include (non-run):**
  - `quartus/files_apf_scaffold.qsf`

- **Preflight/plan artifacts added (Task 6C-6D):**
  - `tools/preflight_quartus_analysis_only.sh`
  - `docs/TASK6C_6D_QUARTUS_ANALYSIS_PREFLIGHT_PLAN.md`
  - `docs/QUARTUS_ANALYSIS_ONLY_COMMAND_PLAN.md`

The top-level `qpf`/`qsf` files now carry active-shell identity only.
`files_apf_scaffold.qsf` now carries the active APF-owned source list.
Runtime and constraints files still carry non-build markers and stay planning-only.
Neither file set includes executable build steps or output generation.

## What is still disabled

- No real synthesis/build flow is enabled in-tree.
- No APF package output is generated in this milestone.
- No real timing closure/clock strategy is finalized in `*.sdc`.
- No `*.sof`, `*.pof`, `*.jic`, `*.rpd`, `*.rbf`, `*.rbf_r`, `output_files/`, `db/`, or `incremental_db/` outputs are expected from this scaffold stage.
- `quartus/openfpga_build.tcl` is still not created.
- `quartus/files_genesis_runtime.qsf` is not active yet.
- Quartus analysis was attempted only under guarded conditions in Task 6C-6E.
- Review:
  - [docs/QUARTUS_ANALYSIS_ONLY_COMMAND_PLAN.md](docs/QUARTUS_ANALYSIS_ONLY_COMMAND_PLAN.md)
  - [docs/QUARTUS_ANALYSIS_ONLY_RESULT.md](docs/QUARTUS_ANALYSIS_ONLY_RESULT.md)
  - [docs/TASK6C_6E_QUARTUS_ANALYSIS_ONLY_ATTEMPT.md](docs/TASK6C_6E_QUARTUS_ANALYSIS_ONLY_ATTEMPT.md)
  - `tools/preflight_quartus_analysis_only.sh`
  - `tools/run_quartus_analysis_only_if_available.sh`
- Quartus analysis/synthesis/APF packaging remain deferred.
  - The analysis-only path is advisory, does not prove runtime compile readiness, and may fail while runtime and constraints are inactive.

## Exclusions still enforced

- `third_party/Genesis_MiSTer` is treated as read-only runtime input for now.
- Sega-CD / Mega-CD and 32X remain excluded.
- Memory-controller integration (SDRAM/PSRAM/SRAM) remains deferred.
- Simulation-only artifacts (including APF core-top stub testbench paths) remain excluded from real build scaffolds.

## Future work

- Task 6C-6D introduced the preflight + command plan.
- Task 6C-6E added the actual guarded analysis-only invocation and result report capture.
- A later task will classify the first analysis errors and update activation plan without modifying runtime RTL.
