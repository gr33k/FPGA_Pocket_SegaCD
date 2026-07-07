# Quartus/openFPGA project file checklist (documentation only)

The following files are part of the future Quartus/openFPGA scaffolding plan.
They are **not created in Task 5U**.

Task 5U clarifies the full future file set and keeps all of these as dry-run planning targets.

## Planned Quartus/openFPGA files

| File | Purpose | Maintained by | Commit later? | Core source groups | Excluded groups |
|---|---|---|---|---|---|
| `quartus/FPGA_Pocket_SegaCD.qpf` | Quartus project descriptor | Human | Yes | Global project metadata only | generated outputs |
| `quartus/FPGA_Pocket_SegaCD.qsf` | Source file assignments, pins, and compile options | Human / generated include fragments | Yes | APF top/wrapper, ROM preload/service stubs, scaffold boundary, runtime file list | `apf/src/fpga/sim/*`, stub-only files |
| `quartus/FPGA_Pocket_SegaCD.sdc` | Timing constraints and clock definition | Human | Yes | Clock constraints and timing targets for APF paths | None (constraints-only file) |
| `quartus/files_apf_scaffold.qsf` | APF scaffold source include list | Human | Yes | `apf/src/fpga/core/*`, `apf/apf_genesis_base.sv` | Any simulation sources |
| `quartus/files_genesis_runtime.qsf` | Imported runtime include list | Human | Yes | `third_party/Genesis_MiSTer` confirmed runtime files | `Genesis.sv`, `sys/sys_top.v`, HPS/IOCTL |
| `quartus/openfpga_build.tcl` | Build helper for scripted Quartus/openFPGA flow | Human / generated helper | Yes | Source include flow and compile targets | real runtime internals |
| `quartus/files_constraints.qsf` | Constraint include list and assignment grouping | Human | Yes | Clock/reset and APF timing constraints | runtime source definitions |
| `quartus/README.md` | Local Quartus/openFPGA setup and launch notes | Human | Yes | Toolchain assumptions and workflow notes | build outputs |
| `quartus/notes_mixed_language.md` | Mixed-language implementation notes and VHDL integration caveats | Human | Yes | VHDL dependency assumptions | binary outputs |

## Expected source groups

The following source groups are expected to be represented once the real project is added:

- APF top/wrapper files:
  - `apf/src/fpga/core/core_top.v`
  - `apf/apf_genesis_base.sv`
  - `apf/src/fpga/core/rom_preload_ingress_stub.v`
  - `apf/src/fpga/core/rom_local_service_stub.v`
  - `apf/src/fpga/core/rom_tiny_local_ram_stub.v`
- Real APF ROM preload/service path scaffolds:
  - load/ingress path
  - local ROM service path
  - optional tiny local ROM RAM smoke path
- Imported Genesis runtime files from `third_party/Genesis_MiSTer` (confirmed when dependency pass completes)
- VHDL dependency files (mixed-language path only)
- Constraints/clock definitions and openFPGA pin mapping artifacts
- APF packaging metadata (future; not active)

## Explicitly excluded for this milestone

- `apf/src/fpga/sim/*` (simulation-only directory)
- `apf/src/fpga/sim/apf_genesis_base_stub.sv`
- `third_party/Genesis_MiSTer/Genesis.sv`
- `third_party/Genesis_MiSTer/sys/sys_top.v`
- HPS/IOCTL framework files
- Sega CD / Mega-CD modules
- 32X modules
- save-state, SRAM, memory-controller, and host-per-read ROM loader modules
- generated build output directories/files

## Notes

- The list above is a planning checklist and not a buildable manifest.
- Final filename choices may change with upstream project conventions.
- Runtime file paths should follow the dependency manifests once confirmed by a compile/probe pass.
