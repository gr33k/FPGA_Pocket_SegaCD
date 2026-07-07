# Task 6R: Genesis-only Pocket SD staging and Quartus build-host handoff

## Scope (Task 6R)

- This milestone adds practical non-synthesis packaging workflow for a Genesis-only
  openFPGA skeleton.
- No Sega-CD and no 32X packaging.
- No Quartus execution.
- No fake bitstreams generated.
- No ROM/BIOS/CD payloads committed.
- Genesis_MiSTer runtime RTL remains untouched.

## Added

- `tools/stage_pocket_sd_skeleton.sh`
- `tools/check_pocket_sd_staging.sh`
- `docs/POCKET_SD_STAGING_WORKFLOW.md`
- `docs/POCKET_SD_STAGING_CHECK_REPORT.md`
- `docs/QUARTUS_BUILD_HOST_HANDOFF.md`
- `docs/GENESIS_ONLY_PACKAGE_COPY_CHECKLIST.md`

## Core workflow

- Repository skeleton is checked by existing and new checker scripts.
- SD card staging is dry-run by default and requires user opt-in to copy.
- Build-host handoff is documented separately and does not claim successful
  synthesis.

## Fast path

1. Check Genesis/project skeleton checks.
2. Run Pocket SD staging checks.
3. Perform dry-run package staging.
4. Move to Quartus-capable host for analysis/elaboration only.

