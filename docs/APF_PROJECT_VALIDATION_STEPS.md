# APF project validation steps (Task 6A-6B scaffold milestone)

Before any real Quartus/openFPGA synthesis or packaging, run these checks.

## 1) Confirm required Quartus files exist

- `test -f quartus/FPGA_Pocket_SegaCD.qpf`
- `test -f quartus/FPGA_Pocket_SegaCD.qsf`
- `test -f quartus/FPGA_Pocket_SegaCD.sdc`
- `test -f quartus/files_apf_scaffold.qsf`
- `test -f quartus/files_genesis_runtime.qsf`
- `test -f quartus/files_constraints.qsf`

## 2) Confirm top-level active skeleton markers

For `quartus/FPGA_Pocket_SegaCD.qpf` and `quartus/FPGA_Pocket_SegaCD.qsf`, confirm they include:

- `ACTIVE SKELETON`
- `DO NOT RUN SYNTHESIS YET`
- `PROJECT STRUCTURE ONLY`
- `SOURCE LISTS ARE NOT ACTIVE YET`
- `NO BUILD OUTPUTS SHOULD BE GENERATED`

## 3) Confirm APF scaffold source list activation

For `quartus/files_apf_scaffold.qsf`, confirm:

- It includes only APF-owned files:
  - `../apf/src/fpga/core/core_top.v`
  - `../apf/src/fpga/core/rom_preload_ingress_stub.v`
  - `../apf/src/fpga/core/rom_local_service_stub.v`
  - `../apf/src/fpga/core/rom_tiny_local_ram_stub.v`
  - `../apf/apf_genesis_base.sv`
- It includes the markers:
  - `ACTIVE SCAFFOLD SOURCE LIST`
  - `DO NOT RUN SYNTHESIS YET`
  - `APF SCAFFOLD ONLY`
  - `GENESIS RUNTIME NOT ACTIVE YET`
- It does **not** include any third_party Genesis runtime files, simulation-only test files, or packaging targets.

## 4) Confirm runtime source include is still inactive

- `quartus/files_genesis_runtime.qsf` remains placeholder-only and contains no active runtime source list.
- It includes `NON-BUILDABLE PLACEHOLDER` and `DO NOT RUN SYNTHESIS FROM THIS FILE YET`.

## 5) Confirm constraint placeholder status

- `quartus/files_constraints.qsf` and `quartus/FPGA_Pocket_SegaCD.sdc` remain placeholders.
- Neither file contains active output/timing pins constraints for synthesis.

## 6) Confirm no forbidden synthesis families/features are present

- `grep -nE "Genesis.sv|sys/sys_top.v|ioctl|SegaCD|MegaCD|32X|save|psram|sdram|sram" quartus/*.qsf quartus/*.qpf quartus/*.sdc || true`

Expected: no prohibited features in active regions.

## 7) Confirm script validation run

- `chmod +x tools/check_quartus_placeholder_hygiene.sh`
- `tools/check_quartus_placeholder_hygiene.sh`
- Confirm `docs/QUARTUS_PLACEHOLDER_HYGIENE_REPORT.md` is generated and reviewed.
- This check is advisory only and does not indicate synthesis success.

## 8) Confirm no generated outputs now

- `test ! -e quartus/output_files`
- `test ! -e quartus/db`
- `test ! -e quartus/incremental_db`
- `test ! -e quartus/greybox_tmp`
- `test ! -e quartus/simulation`
- `test "$(find quartus -maxdepth 2 -type f \( -name '*.sof' -o -name '*.rbf' -o -name '*.rbf_r' \) | wc -l)" = "0"`

## 9) Confirm runtime and packaging deferrals

- No real APF package build target is active.
- `test ! -e quartus/openfpga_build.tcl` remains true.

## 10) Confirm imported runtime remains read-only

- Imported `third_party/Genesis_MiSTer` is present and unchanged.
- `git status --short third_party/Genesis_MiSTer` remains clean.

## 11) Confirm task progression

- Task 6A-6B is complete with APF scaffold source activation only.
- Task 6C should remain documentation-first and not run synthesis.
