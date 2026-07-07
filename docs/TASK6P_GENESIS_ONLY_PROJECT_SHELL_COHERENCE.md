# Task 6P: Genesis-only Quartus project shell coherence

## Scope

Task 6P aligns the Quartus skeleton shell with the promoted Genesis-only source lists introduced in Task 6O, while keeping no-Quartus, no-synthesis behavior on this host.

## What was changed

- Updated `quartus/FPGA_Pocket_SegaCD.qsf` to clearly declare the shell intent:
  - `GENESIS-ONLY PROJECT SHELL`
  - `APF SCAFFOLD SOURCE LIST EXISTS`
  - `GENESIS RUNTIME SOURCE LIST EXISTS`
  - `CONSTRAINTS STILL PLACEHOLDER`
  - `SEGA CD EXCLUDED`
  - `32X EXCLUDED`
  - `DO NOT RUN FULL SYNTHESIS YET`
  - `FIRST QUARTUS ACTION SHOULD BE ANALYSIS/ELABORATION ONLY`
- Kept candidate qsf intentionally out of active flow.
- Re-annotated `quartus/files_apf_scaffold.qsf` as the APF-only scaffold boundary.
- Reframed `quartus/files_genesis_runtime.qsf` to remain the first active-style Genesis runtime list.
- Reframed `quartus/files_constraints.qsf` as placeholder-only constraints.
- Added no-Quartus project-flow checker `tools/check_genesis_only_project_flow.sh` and report target `docs/GENESIS_ONLY_PRE_QUARTUS_CHECK_REPORT.md`.
- Added Quartus command flow guide `docs/GENESIS_ONLY_QUARTUS_PROJECT_FLOW.md`.

## Why this was needed

After Task 6O, the runtime list moved toward active compile orientation, but the top shell still described a generic inactive state. This could cause future hosts to start from an inconsistent path and either miss the scaffold or accidentally include the wrong source set.

Task 6P fixes that by:

- Making shell intent explicit and safe.
- Separating APF scaffold and runtime lists in dedicated files.
- Explicitly marking constraints as still placeholder.
- Adding a deterministic pre-check that does not require Quartus.

## Why synthesis is still not claimed

This host still has no verified Quartus `quartus_map` flow.

This task only prepares the shell and docs for future analysis/elaboration. It does not run synthesis, fitter, timing, or packaging.

## Why Quartus is still required

Actual compile/error classification still requires Quartus to emit first-pass elaboration results. The source list is now coherent enough for that host run, but still needs toolchain execution to prove correctness.

## Why Sega CD and 32X remain excluded

Both are out of scope for this milestone and materially increase risk before Genesis bootstrap.

## Next task

Task 6Q should prepare openFPGA package skeleton and Pocket file layout for Genesis-only smoke testing only, after Quartus hosts complete analysis/elaboration triage and initial blockers are handled.
