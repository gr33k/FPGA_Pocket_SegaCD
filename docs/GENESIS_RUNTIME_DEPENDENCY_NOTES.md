# Genesis Runtime Dependency Notes (Task 5P updates)

## Task 5P status

- Static inspection tightened `apf/src/fpga/core/genesis_runtime_compile_probe.draft.f`.
- No local compile was run in this task.
- Imported runtime RTL remains read-only.

## Confirmed active (static) dependency set by subsystem

### root/system

- `third_party/Genesis_MiSTer/rtl/system.sv`

### 68000

- `third_party/Genesis_MiSTer/rtl/FX68K/fx68k.sv`

### PSG/FM support

- `third_party/Genesis_MiSTer/rtl/jt89/jt89.v`
- `third_party/Genesis_MiSTer/rtl/jt89/jt89_mixer.v`
- `third_party/Genesis_MiSTer/rtl/jt89/jt89_tone.v`
- `third_party/Genesis_MiSTer/rtl/jt89/jt89_noise.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_top.v`
- `third_party/Genesis_MiSTer/rtl/jt12/mixer/jt12_genmix.v`
- `third_party/Genesis_MiSTer/rtl/genesis_fm_lpf.v`

### Input/help support

- `third_party/Genesis_MiSTer/rtl/multitap.sv`
- `third_party/Genesis_MiSTer/rtl/gen_io.sv`
- `third_party/Genesis_MiSTer/rtl/fourway.v`
- `third_party/Genesis_MiSTer/rtl/teamplayer.sv`
- `third_party/Genesis_MiSTer/rtl/cheatcodes.sv`
- `third_party/Genesis_MiSTer/rtl/EEPROM_STM95.sv`

### Pending / flow-blocked

- VHDL-backed dependencies not yet included in active probe source list:
  - `third_party/Genesis_MiSTer/rtl/T80/T80s.vhd`
  - `third_party/Genesis_MiSTer/rtl/vdp.vhd`
  - `third_party/Genesis_MiSTer/rtl/vdp_common.vhd`
  - `third_party/Genesis_MiSTer/rtl/SVP/SVP.vhd`
  - `third_party/Genesis_MiSTer/rtl/bram.vhd`
- JT12 helper helpers and deep helper files are still expected to be added in compile-confirmation iterations.

## Exclusions retained

- `Genesis.sv`, `sys/sys_top.v`, `sys/hps_io.sv`
- `Sega CD`, `Mega-CD`, `32X`
- `apf/src/fpga/sim/apf_genesis_base_stub.sv` remains simulation-only and is not used for real runtime manifest
- Memory-controller and save implementations remain deferred

## Advisory status

- All items remain planning only.
- Probe docs are advisory, not validated by local compile.
- Do not assume runtime boots from this list.
