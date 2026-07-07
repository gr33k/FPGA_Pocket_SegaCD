# Future Quartus/openFPGA files to create (documentation only)

The following files are planned to be created later as part of the real Quartus/openFPGA scaffold.
For Task 5U, all entries are **future-only** and **not created yet**.

| File | Purpose | Maintainer | Commit? | Allowed in this task |
|---|---|---|---|---|
| `quartus/README.md` | Human notes and workflow entrypoint for Quartus/openFPGA setup | Human | Yes | Task 5V (created) |
| `quartus/FPGA_Pocket_SegaCD.qpf` | Quartus project descriptor | Human | Yes | No |
| `quartus/FPGA_Pocket_SegaCD.qsf` | Source lists, device/family, pin/IO and include assignment | Human / generated include files | Yes | No |
| `quartus/FPGA_Pocket_SegaCD.sdc` | Clock/timing constraints and platform timing policy | Human | Yes | No |
| `quartus/files_apf_scaffold.qsf` | APF/top wrapper/scaffold source include list | Human | Yes | No |
| `quartus/files_genesis_runtime.qsf` | Imported runtime source include list | Human | Yes | No |
| `quartus/files_constraints.qsf` | Constraint-specific includes and helper assignments | Human | Yes | No |
| `quartus/openfpga_build.tcl` | Human/automation build flow wrapper | Human | Yes | No |
| `quartus/notes_mixed_language.md` | Mixed-language and Quartus support notes for VHDL dependencies | Human | Yes | Task 5V (created) |

## Status for Task 5U
## Status

- `quartus/README.md` and `quartus/notes_mixed_language.md` were created in Task 5V as documentation-only.
- Remaining project files listed above remain **future-only**:
  - `.qpf`, `.qsf`, `.sdc`, `.tcl` flow files
  - include files and generated helper build flows
- No `.qpf/.qsf/.sdc/.qip/.tcl` project files are created yet.
