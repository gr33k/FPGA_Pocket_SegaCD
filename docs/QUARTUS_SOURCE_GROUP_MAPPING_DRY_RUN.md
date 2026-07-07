# Quartus source group mapping for dry-run planning

This document captures the intended future source partitioning for the real Quartus/openFPGA project.

## Source Group 1 — APF top and scaffold

- `apf/src/fpga/core/core_top.v`
- `apf/src/fpga/core/rom_preload_ingress_stub.v`
- `apf/src/fpga/core/rom_local_service_stub.v`
- `apf/src/fpga/core/rom_tiny_local_ram_stub.v`

## Source Group 2 — APF runtime boundary

- `apf/apf_genesis_base.sv`

## Source Group 3 — Imported Genesis_MiSTer runtime root

- `third_party/Genesis_MiSTer/rtl/system.sv`

## Source Group 4 — Imported runtime dependencies

Compile-confirmation pending until real compile pass:

- 68000 CPU group
- Z80 / T80 group
- VDP/video group
- YM/FM audio group
- PSG/audio group
- memory/helper/support group
- VHDL dependencies

No concrete file list is finalized here because exact runtime compile confirmation is still pending.

## Source Group 5 — Constraints and clocks

- `quartus/FPGA_Pocket_SegaCD.sdc` (future)
- future clock definitions
- future reset assumptions
- future APF timing constraints

## Source Group 6 — Excluded from real synthesis

These must remain excluded in this scaffold phase:

- `apf/src/fpga/sim/`
- `apf/src/fpga/sim/apf_genesis_base_stub.sv`
- `third_party/Genesis_MiSTer/Genesis.sv`
- `third_party/Genesis_MiSTer/sys/sys_top.v`
- MiSTer HPS/IOCTL framework
- Sega CD / Mega-CD files
- 32X files
- generated build outputs

