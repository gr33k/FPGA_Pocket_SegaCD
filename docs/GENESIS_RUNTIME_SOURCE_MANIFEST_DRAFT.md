# Genesis_MiSTer Runtime Source Manifest Draft (Task 5I)

> Draft status: incomplete and compile-confirmation pending.

This is a **planning draft** for the real runtime integration path:

- `apf/apf_genesis_base.sv`
- `rtl/system.sv`
- supporting runtime modules required by `system.sv`

The list below is intentionally incomplete and will be completed after a real compile dependency pass.

## Core runtime chain (starting point)

- `apf/apf_genesis_base.sv` (boundary)
- `rtl/system.sv`
- 68000 core: `rtl/FX68K/fx68k.sv`
- Z80 core: `rtl/T80/T80s.vhd` (plus related T80 files used by system)
- Video: `rtl/vdp.vhd`, `rtl/vdp_common.vhd`
- FM/OPL synthesis: `rtl/jt12/*` (jt12 top and dependencies)
- PSG/audio support: `rtl/jt89/jt89.v`
- Audio/post-processing: `rtl/genesis_lpf.v`, `rtl/audio_iir_filter.v`

## ROM/memory-related support used by `system.sv`

- `rtl/ddram.sv` (if needed by active system path)
- `rtl/sdram.sv` (if required by compile and local memory mode)
- Any address/data helper modules referenced directly by `system.sv` after dependency scan

## Game Genie/helper/quirk modules

- `rtl/genesis_quick*` / helper modules used for edge-case quirks in `system.sv`
- `rtl/*quirk*` modules that are instantiated from `system.sv` or attached submodules
- `rtl/codes.sv`, input/decode helpers if imported by dependency pass

## Exclusions (do not include yet)

- `sys/sys_top.v`
- `Genesis.sv`
- `sys/hps_io.sv` and other MiSTer framework/menu files
- Sega-CD modules (any `SegaCD*`, `megacd*`, `sub_cpu`, etc.)
- 32X modules
- external board/memory-controller wrappers unless the compile pass explicitly requires them
- `apf/src/fpga/sim/apf_genesis_base_stub.sv`

## How this draft should be used

- Use as a checklist, not as an active synthesis file.
- Keep one manifest for current compile run.
- Add/remove only after dependency errors indicate what is required.
- Keep imported runtime files read-only; do not patch runtime RTL in this repository.
