# APF project validation steps (Task 5W, placeholder-only)

Before any real Quartus synthesis or packaging, run these hygiene checks.

## 1) Confirm placeholder files exist

- `test -f quartus/FPGA_Pocket_SegaCD.qpf`
- `test -f quartus/FPGA_Pocket_SegaCD.qsf`
- `test -f quartus/FPGA_Pocket_SegaCD.sdc`
- `test -f quartus/files_apf_scaffold.qsf`
- `test -f quartus/files_genesis_runtime.qsf`
- `test -f quartus/files_constraints.qsf`

## 2) Confirm top-level active skeleton markers

For `quartus/FPGA_Pocket_SegaCD.qpf` and `quartus/FPGA_Pocket_SegaCD.qsf`, confirm:

- ACTIVE SKELETON - DO NOT RUN SYNTHESIS YET
- PROJECT STRUCTURE ONLY
- SOURCE LISTS ARE NOT ACTIVE YET
- NO BUILD OUTPUTS SHOULD BE GENERATED

## 2b) Confirm non-build markers in placeholders

For the remaining placeholder files, confirm each includes:

- NON-BUILDABLE PLACEHOLDER
- DO NOT RUN SYNTHESIS FROM THIS FILE YET
- SOURCE LISTS ARE PROVISIONAL
- MIXED-LANGUAGE FLOW IS NOT FINAL
- IMPORTED GENESIS_MISTER RTL MUST REMAIN READ-ONLY

## 3) Confirm no forbidden synthesis sources are present

- `grep -nE "Genesis.sv|sys/sys_top.v|ioctl|CD|32X|save|psram|sdram|sram" quartus/*.qsf quartus/*.qpf quartus/*.sdc || true`

Expected: only placeholder notes and scaffold intent references.

### Task 5Y: activation gate hygiene workflow

- Confirm `tools/check_quartus_placeholder_hygiene.sh` does not require `rg`:
  - `grep -n "rg" tools/check_quartus_placeholder_hygiene.sh || true`
  - This should return no active `rg` dependency.
- Add Task 5Y gate checks before any placeholder-to-active conversion.
- Run `tools/check_quartus_placeholder_hygiene.sh` again after any placeholder conversion step.
- Keep the check as an advisory pre/post-step for each conversion phase.

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

## 9) Confirm Task 5X requirement

- Run: `tools/check_quartus_placeholder_hygiene.sh`
- Confirm the generated report: `docs/QUARTUS_PLACEHOLDER_HYGIENE_REPORT.md`
- Use this validation before any conversion from placeholder files to real project files.
- Task 5X validates hygiene only; it does not claim synthesis readiness.

## 10) Confirm Task 5Y gate checks

- Confirm `docs/QUARTUS_ACTIVATION_GATE_CHECKLIST.md` is complete and reviewed.
- Re-run the Task 5X hygiene check after any placeholder conversion edits.

## 11) Confirm Task 5X expectation

Task 5X should only validate hygiene and placeholder scope, not claim synthesis,
build success, or playable boot behavior.

## 12) Confirm Task 5Z state

- `quartus/FPGA_Pocket_SegaCD.qpf` and `quartus/FPGA_Pocket_SegaCD.qsf` contain active-skeleton markers.
- `quartus/FPGA_Pocket_SegaCD.sdc`, `quartus/files_apf_scaffold.qsf`,
  `quartus/files_genesis_runtime.qsf`, `quartus/files_constraints.qsf` remain
  non-buildable placeholders.
- no generated output files/directories are present.
