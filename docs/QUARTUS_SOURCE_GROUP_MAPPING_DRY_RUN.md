# Quartus source group mapping for dry-run planning

This document is aligned with Task 5W placeholder project files.

## Source Group 1 — APF top and scaffold

Planned scaffold files are listed in the placeholder file:

- `quartus/files_apf_scaffold.qsf`
  - `apf/src/fpga/core/core_top.v`
  - `apf/src/fpga/core/rom_preload_ingress_stub.v`
  - `apf/src/fpga/core/rom_local_service_stub.v`
  - `apf/src/fpga/core/rom_tiny_local_ram_stub.v`
  - `apf/apf_genesis_base.sv`

## Source Group 2 — Imported Genesis_MiSTer runtime root (placeholder)

- `third_party/Genesis_MiSTer/rtl/system.sv` (provisional include list via
  `quartus/files_genesis_runtime.qsf`)

## Source Group 3 — Constraints

- `quartus/FPGA_Pocket_SegaCD.sdc`
- `quartus/files_constraints.qsf`

## Compile confirmation status

- This remains a dry-run mapping plan only.
- Source order and exact compile list are still pending a confirmed dependency pass.
- VHDL-backed runtime dependencies are still pending and remain outside this file as real compile-ready source.

## Exclusions (still enforced)

- `apf/src/fpga/sim/*`
- `apf/src/fpga/sim/apf_genesis_base_stub.sv`
- `third_party/Genesis_MiSTer/Genesis.sv`
- `third_party/Genesis_MiSTer/sys/sys_top.v`
- MiSTer HPS/IOCTL framework
- Sega-CD / Mega-CD
- 32X
- generated outputs
