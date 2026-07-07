# Quartus Placeholder Hygiene Report

Validation date/time: 2026-07-07 02:38:38 UTC

This report is advisory and does not claim synthesis success.

## Files checked
- quartus/FPGA_Pocket_SegaCD.qpf
- quartus/FPGA_Pocket_SegaCD.qsf
- quartus/FPGA_Pocket_SegaCD.sdc
- quartus/files_genesis_runtime.qsf
- quartus/files_constraints.qsf
- quartus/files_apf_scaffold.qsf

## 1) Quartus control file existence
- [PASS] Exists: quartus/FPGA_Pocket_SegaCD.qpf
- [PASS] Exists: quartus/FPGA_Pocket_SegaCD.qsf
- [PASS] Exists: quartus/FPGA_Pocket_SegaCD.sdc
- [PASS] Exists: quartus/files_genesis_runtime.qsf
- [PASS] Exists: quartus/files_constraints.qsf
- [PASS] Exists: quartus/files_apf_scaffold.qsf
## 2) Active skeleton markers
- [PASS] Marker 'ACTIVE SKELETON' in quartus/FPGA_Pocket_SegaCD.qpf
- [PASS] Marker 'DO NOT RUN SYNTHESIS YET' in quartus/FPGA_Pocket_SegaCD.qpf
- [PASS] Marker 'ACTIVE SKELETON' in quartus/FPGA_Pocket_SegaCD.qsf
- [PASS] Marker 'DO NOT RUN SYNTHESIS YET' in quartus/FPGA_Pocket_SegaCD.qsf
## 3) Placeholder marker presence
- [PASS] Marker 'NON-BUILDABLE PLACEHOLDER' in quartus/FPGA_Pocket_SegaCD.sdc
- [PASS] Marker 'DO NOT RUN SYNTHESIS FROM THIS FILE YET' in quartus/FPGA_Pocket_SegaCD.sdc
- [PASS] Marker 'NON-BUILDABLE PLACEHOLDER' in quartus/files_genesis_runtime.qsf
- [PASS] Marker 'DO NOT RUN SYNTHESIS FROM THIS FILE YET' in quartus/files_genesis_runtime.qsf
- [PASS] Marker 'NON-BUILDABLE PLACEHOLDER' in quartus/files_constraints.qsf
- [PASS] Marker 'DO NOT RUN SYNTHESIS FROM THIS FILE YET' in quartus/files_constraints.qsf
## 4) APF scaffold source include markers
- [PASS] Marker 'ACTIVE SCAFFOLD SOURCE LIST' in quartus/files_apf_scaffold.qsf
- [PASS] Marker 'DO NOT RUN SYNTHESIS YET' in quartus/files_apf_scaffold.qsf
- [PASS] Marker 'APF SCAFFOLD ONLY' in quartus/files_apf_scaffold.qsf
- [PASS] Marker 'GENESIS RUNTIME NOT ACTIVE YET' in quartus/files_apf_scaffold.qsf
## 5) Forbidden source reference check
- [PASS] No forbidden pattern found in quartus/FPGA_Pocket_SegaCD.qpf
- [PASS] No forbidden pattern found in quartus/FPGA_Pocket_SegaCD.qsf
- [PASS] No forbidden pattern found in quartus/FPGA_Pocket_SegaCD.sdc
- [PASS] No forbidden pattern found in quartus/files_genesis_runtime.qsf
- [PASS] No forbidden pattern found in quartus/files_constraints.qsf
- [PASS] No forbidden pattern found in quartus/files_apf_scaffold.qsf
## 6) Generated output files
- [PASS] No generated output files matched known binary markers
## 7) Generated output directories
- [PASS] Directory absent: build
- [PASS] Directory absent: output_files
- [PASS] Directory absent: db
- [PASS] Directory absent: incremental_db
- [PASS] Directory absent: simulation
- [PASS] Directory absent: greybox_tmp
## 8) Imported runtime cleanliness
- [PASS] Submodule status command returned output
- submodule status:  adc0c42cfb1fa5d484cc8566767f7d68982bc44a third_party/Genesis_MiSTer (heads/master)
- [PASS] third_party/Genesis_MiSTer status is clean
## 9) .gitignore generated-output rules
- [PASS] .gitignore contains: build/
- [PASS] .gitignore contains: output_files/
- [PASS] .gitignore contains: db/
- [PASS] .gitignore contains: incremental_db/
- [PASS] .gitignore contains: *.sof
- [PASS] .gitignore contains: *.rbf
- [PASS] .gitignore contains: *.rbf_r

## Summary
- PASS count: 42
- FAIL count: 0
- Overall status: PASS (advisory only)

## Notes
- No synthesis was run.
- No runtime compile success is claimed.
- No games were booted by this task.
