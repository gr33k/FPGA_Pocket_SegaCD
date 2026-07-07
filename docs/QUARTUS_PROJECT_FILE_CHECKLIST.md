# Quartus/openFPGA project file checklist (Task 6A-6B)

## Placeholder and active status

Task 5Z converted top-level files to active skeletons.
Task 6B activates only the APF scaffold source list.

- `quartus/FPGA_Pocket_SegaCD.qpf` (active skeleton, non-run)
- `quartus/FPGA_Pocket_SegaCD.qsf` (active skeleton, non-run)
- `quartus/files_apf_scaffold.qsf` (active APF scaffold source list)
- `quartus/FPGA_Pocket_SegaCD.sdc` (non-buildable placeholder)
- `quartus/files_genesis_runtime.qsf` (non-buildable placeholder)
- `quartus/files_constraints.qsf` (non-buildable placeholder)

## Checklist

- [x] Top-level `qpf` and `qsf` are active skeleton files (Task 5Z).
- [x] `files_apf_scaffold.qsf` now contains an active APF-only source list.
- [x] `files_genesis_runtime.qsf` remains a placeholder.
- [x] Runtime source placeholder remains root-first (`third_party/Genesis_MiSTer/rtl/system.sv`) and provisional.
- [x] Constraint and SDC lists remain placeholders.
- [x] `qsf` runtime list does not include `sys_top`, HPS/IOCTL, Sega-CD, or 32X dependencies.
- [x] `apf_genesis_base.sv` is included only in the scaffold source list (as an owned wrapper boundary).
- [x] No active output generation settings are included.
- [x] Synthesis/build remains disabled.
- [x] `tools/check_quartus_placeholder_hygiene.sh` supports active skeleton vs. placeholder categories.
- [x] Task 5Y activation gate checks remain in force.

## Not done yet

- Real project-file wiring beyond APF scaffold source list.
- APF package/analysis/synthesis build target flow.
- Final clock/pin/timing constraints.
- Confirmed runtime compile integration manifest in Quartus.
- Active Quartus conversion should not occur beyond 6B without 6C+ control checks.
