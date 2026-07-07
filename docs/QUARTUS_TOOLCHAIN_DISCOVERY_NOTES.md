# Quartus Toolchain Discovery Notes

## Environment discovery overrides

To help the analysis runner locate `quartus_map`, set one of:

- `export QUARTUS_MAP=/path/to/quartus_map`
- `export QUARTUS_ROOTDIR=/path/to/quartus_root`

`QUARTUS_MAP` is checked first and must point to an executable `quartus_map` binary.

`QUARTUS_ROOTDIR` is then checked for:
- `$QUARTUS_ROOTDIR/bin/quartus_map`
- `$QUARTUS_ROOTDIR/quartus/bin/quartus_map`

## Expected workflow
1. `chmod +x tools/preflight_quartus_analysis_only.sh tools/run_quartus_analysis_only_if_available.sh`
2. `tools/run_quartus_analysis_only_if_available.sh`

## Report expectations
`docs/QUARTUS_ANALYSIS_ONLY_RESULT.md` should show:
- whether preflight ran,
- whether a discovery candidate was found,
- the full candidate list,
- which candidate was selected,
- the attempted command,
- analysis output/errors (if run),
- and cleanup status for any generated files.

## Output policy
- No generated outputs (`*.sof`, `*.pof`, `*.jic`, `*.rpd`, `*.rbf`, `*.rbf_r`, `output_files/`, `db/`, `incremental_db/`, `simulation/`, `greybox_tmp/`) should be committed.
- This runner deletes those generated outputs from an analysis attempt when found.

## Scope reminder
- Full synthesis/fitter/assembler/timing is not run.
- No APF packaging is run.
- Runtime compile success is not claimed at this stage.

## Latest blocker classification

- Current status: **TOOLCHAIN_UNAVAILABLE**.
- If `quartus_map` is unavailable, prefer:
  - `export QUARTUS_MAP=/path/to/quartus_map`
  - or `export QUARTUS_ROOTDIR=/path/to/quartus`
- Project activation for runtime is intentionally paused until toolchain discovery succeeds.
