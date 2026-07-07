# APF project validation steps (Genesis-only)

1. Verify APF scaffold source structure:
   - `apf/src/fpga/core/core_top.v`
   - `apf/src/fpga/core/apf_scaffold_sources.f`
2. Run local sanity/probe checkers already present:
   - ROM preload/load smoke checks and sim stubs (prior tasks)
3. Run openFPGA package skeleton checker:
   - `tools/check_openfpga_package_skeleton.sh`
4. Run Pocket SD staging check:
   - `tools/check_pocket_sd_staging.sh`
5. Review package status output:
   - `docs/OPENFPGA_PACKAGE_SKELETON_STATUS.md`
6. Confirm staged root check (if staging path known):
   - `POCKET_SD_ROOT=/Volumes/POCKET tools/check_pocket_sd_staging.sh`
7. Confirm no generated/forbidden artifacts exist in package path:
   - `*.sof`, `*.pof`, `*.jic`, `*.rbf`, `*.rbf_r`, `*.wlf`
8. Run dry-run package staging:
   - `DRY_RUN=1 tools/stage_pocket_sd_skeleton.sh`
9. Confirm no active Sega-CD/32X paths are introduced in APF top-level docs.

All steps in Task 6Q are non-intrusive and should not require Quartus.
