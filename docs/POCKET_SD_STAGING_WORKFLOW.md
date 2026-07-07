# Pocket SD staging workflow (Genesis-only)

## Variables

- `POCKET_SD_ROOT=/path/to/PocketSD`
- `DRY_RUN=1` (default)
- `DRY_RUN=0` to perform copy

## Commands

- Dry-run (default):
  - `DRY_RUN=1 tools/stage_pocket_sd_skeleton.sh`
- Validate layout print-only:
  - `POCKET_SD_ROOT=/Volumes/POCKET DRY_RUN=1 tools/stage_pocket_sd_skeleton.sh`
- Perform copy (only when ready):
  - `POCKET_SD_ROOT=/Volumes/POCKET DRY_RUN=0 tools/stage_pocket_sd_skeleton.sh`

## Script behavior

- `tools/stage_pocket_sd_skeleton.sh`:
  - validates source package exists.
  - validates `POCKET_SD_ROOT` when `DRY_RUN=0`.
  - refuses likely accidental overwrite of pre-existing files.
  - skips forbidden payloads and missing bitstream placeholder expectations.
  - writes a human-readable report to `docs/POCKET_SD_STAGING_CHECK_REPORT.md`.

- `tools/check_pocket_sd_staging.sh`:
  - checks repo package skeleton shape.
  - checks staged SD package shape if `POCKET_SD_ROOT` is set.
  - validates no known forbidden payload patterns in staged/skeleton areas.
  - exits non-failing; writes the same report file.

## What this workflow intentionally does not do

- run Quartus
- run synthesis
- run fitter
- package/boot a real core
- claim boot success

