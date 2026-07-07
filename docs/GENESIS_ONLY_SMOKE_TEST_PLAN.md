# Genesis-only smoke-test plan

This milestone keeps smoke-test scope strictly local and deterministic.

## Scope

- Validate package skeleton structure.
- Validate that no disallowed payloads are accidentally introduced.
- Keep all behavior within APF scaffold and existing Genesis-only stubs.
- Add Pocket SD dry-run staging and handoff checks (Task 6R).

## Planned checks (manual/local)

1. Run APF package skeleton check:
   - `tools/check_openfpga_package_skeleton.sh`
2. Run Pocket staging check:
   - `tools/check_pocket_sd_staging.sh`
   - optional: `POCKET_SD_ROOT=/Volumes/POCKET tools/check_pocket_sd_staging.sh`
3. Confirm no generated Quartus/openFPGA artifacts are added:
   - search for `*.sof`, `*.pof`, `*.jic`, `*.rbf`, `*.rbf_r`, `*.prj` under
     package/build paths
4. Confirm no accidental non-skeleton payload copies during staging:
   - `DRY_RUN=1 tools/stage_pocket_sd_skeleton.sh`
   - `POCKET_SD_ROOT=/Volumes/POCKET DRY_RUN=1 tools/stage_pocket_sd_skeleton.sh`
5. Confirm placeholder-only package folders remain intact.
6. Confirm status docs updated for active blockers and next action path.

## Not covered in this task

- Real synthesis/implementation
- BIOS/CD slots
- Save-state paths
- Sega-CD, 32X, host-per-read ROM streaming

## Expected outcome

- `PASS` for structural cleanliness and deterministic non-binary package layout.
- Clear next-step pointer to Quartus-enabled build tasks once toolchain is available.
