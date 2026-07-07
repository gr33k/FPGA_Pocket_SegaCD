# Quartus Analysis Blocker Classification

## Date/time
- 2026-07-07 03:09:04 UTC

## Path inspected
- [docs/QUARTUS_ANALYSIS_ONLY_RESULT.md](docs/QUARTUS_ANALYSIS_ONLY_RESULT.md)

## quartus_map status
- **not found**

## Analysis-only status
- **not run**

## Selected blocker category
- **TOOLCHAIN_UNAVAILABLE**

## First relevant output
- `quartus_map unavailable via discovery; analysis not run.`

## Classification rationale
- The failure is environmental:
  - no executable `quartus_map` candidate was discovered
  - therefore no `--analysis_and_elaboration` command was executed
- No runtime-elaboration compile signal is available yet.

## Next safe action
- Document/verify local Quartus install/path and stop runtime activation for now.
- Keep `files_genesis_runtime.qsf` inactive.
- Keep analysis-only classification as advisory until a local Quartus toolchain can be discovered.
- Task 6I added local toolchain validation; rerun this classification after validation:
  - if validation fails: remain on `TOOLCHAIN_UNAVAILABLE`
  - if validation passes: mark as ready for analysis-only re-test (not yet resolved)
