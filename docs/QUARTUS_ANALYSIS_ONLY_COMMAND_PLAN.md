# Quartus analysis-only command plan

## Planned analysis command (future only)

When explicitly authorized in a later task, run:

```bash
cd quartus
quartus_map --analysis_and_elaboration FPGA_Pocket_SegaCD
```

## Execution safeguards

- The command is analysis-only and must not be confused with synthesis/fitter/assembler/timing.
- It should be executed only from the `quartus/` directory.
- It must be run only after `tools/preflight_quartus_analysis_only.sh` passes.
- It may fail because:
  - `quartus/files_genesis_runtime.qsf` is still inactive,
  - constraints are still placeholders,
  - and runtime integration is not yet active.
- Do not treat this command as a full build checkpoint.
- Do not keep or commit generated Quartus outputs from this attempt.

## Error capture for future task

The first analysis run should capture:

- command exit code,
- stderr/stdout summary,
- and first-pass missing-module errors.

These should be committed to an analysis-error report artifact only.

## What is explicitly not done here

- This task does not run Quartus.
- This task does not run synthesis/fitter/timing.
- This task does not claim runtime compile success.
- This task does not claim playable boot.
