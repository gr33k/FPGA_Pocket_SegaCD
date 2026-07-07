# Genesis-only Pre-Quartus Project Flow Check
Run timestamp: 2026-07-07 06:43:20 UTC

## Required files

## Core project-flow checks

## Runtime list checks

## APF scaffold checks

## Forbidden active reference scan

## Candidate file usage check

## Constraint checks

## Generated-output absence checks

## Summary
Final advisory status: PASS

## Check log
- quartus/FPGA_Pocket_SegaCD.qsf: **OK** - exists
- quartus/files_apf_scaffold.qsf: **OK** - exists
- quartus/files_genesis_runtime.qsf: **OK** - exists
- quartus/files_constraints.qsf: **OK** - exists
- quartus/files_genesis_runtime.candidate.qsf: **OK** - exists
- Top-level shell shell header: **OK** - found in FPGA_Pocket_SegaCD.qsf
- Top-level shell runtime-source marker: **OK** - found in FPGA_Pocket_SegaCD.qsf
- Top-level shell scaffold-source marker: **OK** - found in FPGA_Pocket_SegaCD.qsf
- Top-level shell constraints marker: **OK** - found in FPGA_Pocket_SegaCD.qsf
- Top-level shell no-synthesis marker: **OK** - found in FPGA_Pocket_SegaCD.qsf
- Runtime list header: **OK** - found in files_genesis_runtime.qsf
- Runtime list Sega CD exclusion: **OK** - found in files_genesis_runtime.qsf
- Runtime list 32X exclusion: **OK** - found in files_genesis_runtime.qsf
- Runtime list system entry: **OK** - found in files_genesis_runtime.qsf
- Runtime list wrapper entry: **OK** - found in files_genesis_runtime.qsf
- Scaffold header: **OK** - found in files_apf_scaffold.qsf
- Scaffold core_top: **OK** - found in files_apf_scaffold.qsf
- Scaffold apf_genesis_base: **OK** - found in files_apf_scaffold.qsf
- Forbidden reference scan: **OK** - no forbidden token found
- Candidate file referenced by Quartus top files: **OK** - not referenced in quartus/*.qsf/*.qpf
- Constraints header: **OK** - found in files_constraints.qsf
- Constraints placeholder marker: **OK** - found in files_constraints.qsf
- Generated bitstream artifacts: **OK** - none found
- No output dir: quartus/output_files: **OK** - not present
- No output dir: quartus/db: **OK** - not present
- No output dir: quartus/incremental_db: **OK** - not present
- No output dir: quartus/simulation: **OK** - not present
- No output dir: quartus/greybox_tmp: **OK** - not present
