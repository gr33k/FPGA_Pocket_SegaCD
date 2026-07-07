# APF project validation steps (Task 5W, placeholder-only)

Before any real Quartus synthesis or packaging, run these hygiene checks.

## 1) Confirm placeholder files exist

- `test -f quartus/FPGA_Pocket_SegaCD.qpf`
- `test -f quartus/FPGA_Pocket_SegaCD.qsf`
- `test -f quartus/FPGA_Pocket_SegaCD.sdc`
- `test -f quartus/files_apf_scaffold.qsf`
- `test -f quartus/files_genesis_runtime.qsf`
- `test -f quartus/files_constraints.qsf`

## 2) Confirm non-build markers in each placeholder

Each file above must include:

- NON-BUILDABLE PLACEHOLDER
- DO NOT RUN SYNTHESIS FROM THIS FILE YET
- SOURCE LISTS ARE PROVISIONAL
- MIXED-LANGUAGE FLOW IS NOT FINAL
- IMPORTED GENESIS_MISTER RTL MUST REMAIN READ-ONLY

## 3) Confirm no forbidden synthesis sources are present

- `rg -n "Genesis.sv|sys/sys_top.v|ioctl|CD|32X|save|psram|sdram|sram" quartus/*.qsf quartus/*.qpf quartus/*.sdc`

Expected: only placeholder notes and scaffold intent references.

## 4) Confirm no generated outputs now

- `test ! -e quartus/output_files`
- `test ! -e quartus/db`
- `test ! -e quartus/incremental_db`
- `test ! -e quartus/greybox_tmp`
- `test "$(find quartus -maxdepth 2 -type f \( -name '*.sof' -o -name '*.rbf' -o -name '*.rbf_r' \) | wc -l)" = "0"`

## 5) Confirm imported runtime is not modified

- `git status --short third_party/Genesis_MiSTer`

Expected: clean for this workspace.

## 6) Confirm synthesis remains disabled

- No active project flow is enabled in placeholder files.
- No real generation settings or tool-run directives are present in the Task 5W files.
- `test ! -e quartus/openfpga_build.tcl` (still deferred)

## 7) Confirm APF/SDK constraints are still deferred

- No final pin, clock, timing, or packaging assignments are authoritative.
- `quartus/FPGA_Pocket_SegaCD.sdc` and `quartus/files_constraints.qsf` remain TODO/provisional.

## 8) Confirm forbidden feature families remain inactive

- Sega CD and 32X not included in project placeholders.
- No host-per-read ROM loading runtime behavior is introduced in these files.
- No memory-controller integration is activated yet.

## 9) Confirm Task 5X expectation

Task 5X should only validate hygiene and placeholder scope, not claim synthesis,
build success, or playable boot behavior.
