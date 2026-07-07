# Quartus/openFPGA project file checklist (Task 5W milestone)

## Placeholder status

Task 5W added the following files as non-buildable placeholders:

- `quartus/FPGA_Pocket_SegaCD.qpf`
- `quartus/FPGA_Pocket_SegaCD.qsf`
- `quartus/FPGA_Pocket_SegaCD.sdc`
- `quartus/files_apf_scaffold.qsf`
- `quartus/files_genesis_runtime.qsf`
- `quartus/files_constraints.qsf`

## Checklist

- [x] Placeholder files exist in `quartus/`.
- [x] Each placeholder file contains required non-buildable markers.
- [x] APF/Genesis-only scaffold source notes are included.
- [x] Runtime source placeholder is root-first (`third_party/Genesis_MiSTer/rtl/system.sv`) and provisional.
- [x] Runtime outputs and simulation stubs remain excluded.
- [x] No active output settings are included.
- [x] Synthesis/build remains disabled.
- [x] Task 5X hygiene validation now exists via `tools/check_quartus_placeholder_hygiene.sh`.
- [x] Task 5Y activation gate plan added and gates defined for controlled placeholder activation.

## Not done yet

- Active project-file wiring and build automation
- APF package build target flow
- Final clock/pin/timing constraints
- Confirmed runtime compile integration manifest
- Task 5Y activation plan for converting placeholders into first real project skeleton (added now; conversion still deferred to Task 5Z)
- Active Quartus conversion should not occur until all gate checklist items pass.
