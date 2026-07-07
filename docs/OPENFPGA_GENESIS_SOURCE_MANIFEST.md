# openFPGA-Genesis source manifest (Task 6W)

## Primary active lineage

- Upstream: https://github.com/opengateware/openFPGA-Genesis
- Submodule path: `third_party/openFPGA-Genesis`

## Core areas to use in the next activation pass

- `src/fpga/core/core_top.sv` (core entry)
- `src/fpga/apf/apf_top.v` (APF top)
- `src/fpga/core/rtl/system.sv` (Genesis runtime entry in pocket lane)
- `src/fpga/core/core_bridge_cmd.v` (bridge command path)
- `src/fpga/core/data_loader.sv` (ROM/data preload loader)
- `src/fpga/core/data_unloader.sv` (ROM/data unload path)
- `src/fpga/core/sdram.sv` (runtime RAM path)
- `src/fpga/core/sound_i2s.sv` (audio serializer/output path)
- `src/fpga/core/mf_pllbase.v` and related PLL artifacts (clocking)
- `src/fpga/core/rtl` (VDP/audio/input/video/runtime modules)
- `src/fpga/core/rtl/jt12/*` and `src/fpga/core/rtl/jt89/*` (audio families)
- `src/fpga/core/rtl/video*`/`vdp*` (video path) if active in current upstream branch
- controller mapping and port mux modules in `src/fpga/core` and `src/fpga/apf`
- package metadata in:
  - `src/fpga/apf/*.v`
  - `src/fpga/core/core_constraints.sdc`
  - `src/fpga/core/core_bridge_cmd.v`
  - `src/fpga/core/core_top.sv`

## Status

This is the **new primary Genesis-only runtime source lane**.
`third_party/Genesis_MiSTer` is not the active runtime source lane in this phase.

## Deferral notes

- Sega CD is deferred until Genesis boots.
- 32X is deferred until Genesis boots and platform risk is acceptable.

## Task 6X note

- Added Task 6X active-source planning from the real upstream tree:
  - `docs/OPENFPGA_GENESIS_UPSTREAM_FILE_INVENTORY.md`
  - `docs/OPENFPGA_GENESIS_ACTIVE_SOURCE_PLAN.md`
  - `docs/OPENFPGA_GENESIS_SOURCE_PLAN_CHECK.md`
- Added planning candidate list at:
  - `quartus/files_openfpga_genesis_runtime.candidate.qsf`
- No Quartus analysis/elaboration or synthesis was executed in Task 6X.
- `third_party/Genesis_MiSTer` remains reference-only, not active.
