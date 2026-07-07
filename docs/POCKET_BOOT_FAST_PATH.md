# Pocket boot fast path (Genesis-only APF scaffold)

This document tracks the shortest deterministic path for local verification in the
current scaffold-only state.

Current fast path:
1. Project-flow check PASS:
   - `tools/check_genesis_only_project_flow.sh`
2. Package skeleton check PASS:
   - `tools/check_openfpga_package_skeleton.sh`
3. Pocket SD dry-run staging:
   - `DRY_RUN=1 tools/stage_pocket_sd_skeleton.sh`
4. Quartus host produces real bitstream (analysis/elaboration only).
5. Insert real bitstream into package skeleton build release path.
6. Copy package to Pocket SD:
   - `POCKET_SD_ROOT=/Volumes/POCKET DRY_RUN=0 tools/stage_pocket_sd_skeleton.sh`
7. Smoke boot with a real Genesis ROM on device.
8. Only after validated Genesis smoke boot, evaluate Sega-CD or 32X.

Task 6Q changes:
- Added a package skeleton under `openfpga/FPGA_Pocket_SegaCD/`.
- Added non-blocking package skeleton checker with explicit hygiene report.
- No binaries/ROMs/BIOS/CD payloads added.

Next activation remains:
- Quartus toolchain path resolution
- Real APF build artifact packaging and release prep
