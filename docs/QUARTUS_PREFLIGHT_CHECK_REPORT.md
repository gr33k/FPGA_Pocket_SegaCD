# Quartus Preflight Check Report

Validation date/time: 2026-07-07 03:03:20 UTC

This is an advisory preflight only. It does not run Quartus, does not run synthesis, and does not perform any build.

## Files checked
- quartus/FPGA_Pocket_SegaCD.qpf
- quartus/FPGA_Pocket_SegaCD.qsf
- quartus/files_apf_scaffold.qsf
- quartus/files_genesis_runtime.qsf
- quartus/files_constraints.qsf
- quartus/FPGA_Pocket_SegaCD.sdc

## 1) Required Quartus files existence
- [PASS] Exists: quartus/FPGA_Pocket_SegaCD.qpf
- [PASS] Exists: quartus/FPGA_Pocket_SegaCD.qsf
- [PASS] Exists: quartus/files_apf_scaffold.qsf
- [PASS] Exists: quartus/files_genesis_runtime.qsf
- [PASS] Exists: quartus/files_constraints.qsf
- [PASS] Exists: quartus/FPGA_Pocket_SegaCD.sdc
## 2) Active skeleton marker check
- [PASS] ACTIVE SKELETON in quartus/FPGA_Pocket_SegaCD.qpf
- [PASS] ACTIVE SKELETON in quartus/FPGA_Pocket_SegaCD.qsf
## 3) APF scaffold source list check
- [PASS] ACTIVE SCAFFOLD SOURCE LIST in quartus/files_apf_scaffold.qsf
## 4) Runtime inactive check (Genesis runtime file)
- [PASS] No active third_party/Genesis_MiSTer runtime activation in quartus/files_genesis_runtime.qsf
## 5) Constraint inactive check
- [PASS] Constraint placeholder markers present in quartus/files_constraints.qsf
- [PASS] Constraint placeholder markers present in quartus/FPGA_Pocket_SegaCD.sdc
## 6) Forbidden reference check
- [PASS] No forbidden pattern found in quartus/FPGA_Pocket_SegaCD.qpf
- [PASS] No forbidden pattern found in quartus/FPGA_Pocket_SegaCD.qsf
- [PASS] No forbidden pattern found in quartus/files_apf_scaffold.qsf
- [PASS] No forbidden pattern found in quartus/files_genesis_runtime.qsf
- [PASS] No forbidden pattern found in quartus/files_constraints.qsf
- [PASS] No forbidden pattern found in quartus/FPGA_Pocket_SegaCD.sdc
## 7) Generated output directory check
- [PASS] Directory absent: build
- [PASS] Directory absent: output_files
- [PASS] Directory absent: db
- [PASS] Directory absent: incremental_db
- [PASS] Directory absent: simulation
- [PASS] Directory absent: greybox_tmp
## 8) Generated output file check
- [PASS] No generated-like binary files detected
## 9) Submodule cleanliness
- [PASS] Submodule status command returned output
- submodule status:  adc0c42cfb1fa5d484cc8566767f7d68982bc44a third_party/Genesis_MiSTer (heads/master)
- [PASS] third_party/Genesis_MiSTer is clean

## Summary
- PASS count: 27
- FAIL count: 0
- Overall status: PASS (advisory only)

## Notes
- No Quartus command was run.
- No synthesis was run.
- No runtime compile success is claimed.
- No games were booted by this task.
