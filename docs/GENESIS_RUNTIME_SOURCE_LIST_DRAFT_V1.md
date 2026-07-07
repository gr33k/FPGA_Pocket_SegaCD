# Genesis_MiSTer Runtime Source List Draft V1

> Draft status: inactive / planning-only / not used for synthesis yet

- Probe source manifest used for compile dependency capture: `apf/src/fpga/core/genesis_runtime_compile_probe.draft.f`
- Task 5P tightened this list from static inspection only (no local compile confirmation).
- Compile order is provisional and not final.

## Intended runtime chain

- `apf/src/fpga/core/core_top.v`
- `apf/apf_genesis_base.sv`
- `third_party/Genesis_MiSTer/rtl/system.sv`

## Source groups confirmed active in Task 5P probe draft

### root/system

- `third_party/Genesis_MiSTer/rtl/system.sv`

### 68000 CPU core

- `third_party/Genesis_MiSTer/rtl/FX68K/fx68k.sv`

### Z80/T80 core

- `third_party/Genesis_MiSTer/rtl/T80/T80s.vhd` *(VHDL candidate, compile-flow pending)*

### VDP / video

- `third_party/Genesis_MiSTer/rtl/vdp.vhd` *(VHDL candidate, compile-flow pending)*
- `third_party/Genesis_MiSTer/rtl/vdp_common.vhd` *(VHDL candidate, compile-flow pending)*

### YM / FM audio

- `third_party/Genesis_MiSTer/rtl/jt12/jt12.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_top.v`
- `third_party/Genesis_MiSTer/rtl/jt12/mixer/jt12_genmix.v`
- `third_party/Genesis_MiSTer/rtl/genesis_fm_lpf.v`

### PSG audio

- `third_party/Genesis_MiSTer/rtl/jt89/jt89.v`
- `third_party/Genesis_MiSTer/rtl/jt89/jt89_mixer.v`
- `third_party/Genesis_MiSTer/rtl/jt89/jt89_tone.v`
- `third_party/Genesis_MiSTer/rtl/jt89/jt89_noise.v`

### Memory / helper / support

- `third_party/Genesis_MiSTer/rtl/cheatcodes.sv`
- `third_party/Genesis_MiSTer/rtl/multitap.sv`
- `third_party/Genesis_MiSTer/rtl/gen_io.sv`
- `third_party/Genesis_MiSTer/rtl/fourway.v`
- `third_party/Genesis_MiSTer/rtl/teamplayer.sv`
- `third_party/Genesis_MiSTer/rtl/EEPROM_STM95.sv`
- `third_party/Genesis_MiSTer/rtl/genesis_lpf.v`
- `third_party/Genesis_MiSTer/rtl/bram.vhd` *(VHDL candidate for dpram/dpram_dif support, compile-flow pending)*

## Pending/uncertain items

- `third_party/Genesis_MiSTer/rtl/jt12/mixer/jt12_mixer.v`
- `third_party/Genesis_MiSTer/rtl/jt12/alt/*` (JT12 helpers not yet activated)
- `third_party/Genesis_MiSTer/rtl/jt89/jt89.vhd`
- `third_party/Genesis_MiSTer/rtl/SVP/*` *(SVP path currently excluded from this compile phase)*

## Exclusions for this milestone

- `SegaCD*`, `megacd*`, and `32X*`
- `third_party/Genesis_MiSTer/Genesis.sv`
- `third_party/Genesis_MiSTer/sys/sys_top.sv`
- `third_party/Genesis_MiSTer/sys/hps_io.sv`
- Simulation-only APF stub and non-runtime-only wrappers

## Current status notes

- No runtime game-boot milestone is implied by this list.
- This list remains a planning manifest and must be validated by supported compile tooling.
- Real mixed-language build integration is pending.
