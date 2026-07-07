# Task 5P Runtime Source-List Tightening

## What I inspected

- Imported runtime root: `third_party/Genesis_MiSTer/rtl/system.sv` (submodule present).
- Direct instantiations in `system.sv` include: `fx68k`, `CODES`, `vdp`, `jt89`, `multitap`, `STM95XXX`, `SVP`, `T80s`, `jt12`, `genesis_fm_lpf`, `jt12_genmix`, `genesis_lpf`.
- Immediate dependencies from those instantiated modules were checked where definitions are clearly visible in-tree:
  - `gen_io.sv`, `fourway.v`, and `teamplayer.sv` via `multitap`
  - `jt89_mixer.v`, `jt89_tone.v`, `jt89_noise.v` via `jt89`
  - `jt12_top.v` via `jt12`
  - `genesis_fm_lpf.v` and `jt12_genmix.v` via `system.sv`
- `SVP`, `vdp`, `T80s`, `dpram`, and `dpram_dif` remain VHDL/mixed-language-dependent or not yet compile-confirmed for this phase.

## What changed in this tightening pass

- Kept the required header comments:
  - DO NOT USE FOR SYNTHESIS YET
  - COMPILE ORDER IS PROVISIONAL
  - DO NOT MODIFY IMPORTED RTL TO SATISFY THIS FILE
- Promoted only confirmed runtime dependencies to active entries based on direct or immediate instantiation from checked files.
- Kept uncertain, broad, or VHDL-only dependencies commented with explicit notes.
- Kept a strict exclusion list for this milestone.

## Why this remains a compile-probe draft only

- No local compile was run for Task 5P because no supported Verilog/VHDL mixed flow tool was available.
- The manifest is advisory and may expand as compile feedback arrives.
- This filelist does not imply runtime bootability.

## Read-only rule for imported runtime

- `third_party/Genesis_MiSTer` runtime RTL is not edited in this task.
- The probe filelist only reflects source inclusion planning, not runtime modification.

## Exclusions retained

- No Sega CD/mega-CD files added.
- No 32X files added.
- MiSTer framework-level files (`Genesis.sv`, `sys/sys_top.v`, `sys/hps_io.sv`) remain excluded.
