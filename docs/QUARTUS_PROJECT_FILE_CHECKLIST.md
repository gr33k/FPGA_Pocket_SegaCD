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

## Not done yet

- Active project-file wiring and build automation
- APF package build target flow
- Final clock/pin/timing constraints
- Confirmed runtime compile integration manifest
