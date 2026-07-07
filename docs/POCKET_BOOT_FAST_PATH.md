# Pocket boot fast path (Genesis-only APF scaffold)

This document tracks the shortest deterministic path for local verification in the
current scaffold-only state.

Current fast path:
1. Keep to APF/Genesis-only compile-time scaffold path.
2. Verify APF package skeleton hygiene:
   - run `tools/check_openfpga_package_skeleton.sh`
3. Validate source-level gatekeeping docs:
   - `docs/OPENFPGA_PACKAGING_DEFERRED_PLAN.md`
   - `docs/OPENFPGA_PACKAGE_SKELETON_STATUS.md`
   - `docs/GENESIS_ONLY_ACTIVE_BUILD_PATH_STATUS.md`
4. No Quartus/APF final packaging run until Quartus toolchain is available.

Task 6Q changes:
- Added a package skeleton under `openfpga/FPGA_Pocket_SegaCD/`.
- Added non-blocking package skeleton checker with explicit hygiene report.
- No binaries/ROMs/BIOS/CD payloads added.

Next activation remains:
- Quartus toolchain path resolution
- Real APF build artifact packaging and release prep

