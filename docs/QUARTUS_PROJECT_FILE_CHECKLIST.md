# Quartus/openFPGA project file checklist (Task 5Z milestone)

## Placeholder status

Task 5Z converted only top-level files to first active skeletons:

- `quartus/FPGA_Pocket_SegaCD.qpf`
- `quartus/FPGA_Pocket_SegaCD.qsf`

The following remain non-buildable placeholders:

- `quartus/FPGA_Pocket_SegaCD.sdc`
- `quartus/files_apf_scaffold.qsf`
- `quartus/files_genesis_runtime.qsf`
- `quartus/files_constraints.qsf`

## Checklist

- [x] Top-level `qpf` and `qsf` are active skeleton files (Task 5Z).
- [x] Remaining placeholder files contain required non-buildable markers.
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
- Task 5Z conversion beyond top-level (`qpf` + `qsf`) and source include activation remains pending.
- Active Quartus conversion should not occur until all gate checklist items pass and the validator is updated.
