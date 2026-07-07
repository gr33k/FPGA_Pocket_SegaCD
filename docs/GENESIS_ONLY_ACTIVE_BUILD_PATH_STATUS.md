# Genesis-only Active Build Path Status

## Active (Task 6O / 6P) files
- `quartus/files_genesis_runtime.qsf`
  - Includes explicit `SYSTEMVERILOG_FILE` / `VERILOG_FILE` assignments for `apf/apf_genesis_base.sv` and high-confidence Genesis runtime files.
  - Excludes Sega CD, 32X, sys/top wrapper, and HPS/IOCTL framework files.
- `quartus/FPGA_Pocket_SegaCD.qsf`
  - Updated in Task 6P as a coherent Genesis-only shell that points to a future 6P flow and documents scaffold/runtime list split.
- `quartus/files_apf_scaffold.qsf`
  - Active APF-only file list used only for scaffold-only shell activation.
- `quartus/files_constraints.qsf`
  - Constraint file exists but remains placeholder in this milestone.
- `apf/apf_genesis_base.sv`
  - Existing APF boundary scaffold for Genesis-only milestone.

## Deferred runtime files
- `fourway.v`
- `ddram.sv`
- `miracle.sv`
- `lightgun.sv`
- `teamplayer.v`
- `vdp.vhd`
- `vdp_common.vhd`
- `T80/T80s.vhd`
- `SVP/SVP.vhd`
- `jt*` and other unresolved audio/mixed-language groups

## VHDL / mixed-language blockers
- `vdp.vhd`, `vdp_common.vhd`, and `T80/T80s.vhd` remain commented in active runtime file list.
- `SVP/SVP` and jt audio family VHDL/Verilog modules remain documented as blockers until Quartus confirms exact activation requirements.

## Explicitly excluded
- `third_party/Genesis_MiSTer/Genesis.sv`
- `third_party/Genesis_MiSTer/sys/sys_top.v`
- HPS/IOCTL framework files
- Sega CD / Mega CD files
- 32X files
- simulation-only scaffold/test artifacts in runtime active lists

## Active / inactive project state
- `quartus/files_genesis_runtime.qsf` is now a controlled active-leaning runtime source list.
- `quartus/files_genesis_runtime.candidate.qsf` and `apf/src/fpga/filelists/genesis_runtime_candidate.f` remain planning references.
- `quartus/FPGA_Pocket_SegaCD.qsf` is now a coherent Genesis-only shell with explicit scaffold/runtime/constraints split.

## Synthesis outcome
- No synthesis/build is claimed in-tree for this task.
- No real Quartus analysis has been used to validate compile success in this environment.
- `tools/check_genesis_only_project_flow.sh` runs an advisory pre-check only and exits non-blocking.

## Runtime claims
- No successful Genesis boot claim is made in this task.
- No Sega CD/32X functionality is enabled.
