# Task 6C-6D: Quartus analysis-only preflight and command plan

## Why this preflight exists

The APF scaffold has reached a controlled mixed state: active top-level Quartus skeleton files and an active APF-owned source include, while Genesis runtime sources and constraints remain inactive. Before any analysis command is attempted, we need a deterministic preflight that confirms:

- required Quartus control files exist,
- active/placeholder roles are still consistent,
- no forbidden paths are accidentally introduced,
- and no generated outputs exist.

## Why this does not run Quartus

This task remains explicitly non-run for Quartus.

- No Quartus executable is invoked.
- No analysis, synthesis, fitting, or timing step is executed.
- No `quartus_map`/`quartus_sh`/`quartus_asm` style tool path is run.

The objective here is to prepare safe execution prerequisites and documentation without producing build artifacts.

## Why analysis-only is still deferred

A full analysis command is documented for future execution, but not run in this milestone because:

- `quartus/files_genesis_runtime.qsf` is still inactive,
- constraints remain placeholders,
- and APF packaging is still deferred.

So the first analysis attempt should be done only when explicitly requested in a later task.

## Why synthesis is not run

Even though this project uses Quartus tooling concepts, synthesis/compilation is intentionally deferred:

- this milestone is for structural safety checks only,
- the command planned is analysis-only,
- and any real compile/synthesis flow remains a later controlled task.

## Why generated outputs must not exist

No generated outputs are allowed at this stage because they can hide repository state and imply partial build progress.

Required preflight expectations are that these are absent:

- `build/`
- `output_files/`
- `db/`
- `incremental_db/`
- `simulation/`
- `greybox_tmp/`

And no output-like binaries should be present:

- `*.sof`
- `*.pof`
- `*.jic`
- `*.rpd`
- `*.rbf`
- `*.rbf_r`

## Why Genesis runtime remains inactive

The scaffold now includes only APF-owned runtime-wrapper files; full Genesis runtime activation (from `third_party/Genesis_MiSTer`) is intentionally not active yet.

## Why imported Genesis_MiSTer remains read-only

`third_party/Genesis_MiSTer` is present as an external runtime source and must remain unchanged during scaffold milestones.

## Why Sega CD and 32X are excluded

Both families are excluded by design for this milestone and remain forbidden in Quartus source/pre-flight checks.

## Files and scripts in this milestone

- Added preflight plan document: [docs/TASK6C_6D_QUARTUS_ANALYSIS_PREFLIGHT_PLAN.md](docs/TASK6C_6D_QUARTUS_ANALYSIS_PREFLIGHT_PLAN.md)
- Added command plan: [docs/QUARTUS_ANALYSIS_ONLY_COMMAND_PLAN.md](docs/QUARTUS_ANALYSIS_ONLY_COMMAND_PLAN.md)
- Added script: [tools/preflight_quartus_analysis_only.sh](tools/preflight_quartus_analysis_only.sh)
- Added report output: [docs/QUARTUS_PREFLIGHT_CHECK_REPORT.md](docs/QUARTUS_PREFLIGHT_CHECK_REPORT.md)

## Task 6E should do next

Task 6E should run the preflight script and, only if it passes and Quartus is available locally, execute a documented first analysis-only attempt that captures analysis errors without committing outputs.
