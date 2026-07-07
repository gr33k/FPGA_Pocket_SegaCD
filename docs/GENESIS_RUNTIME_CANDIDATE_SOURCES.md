# Genesis Runtime Candidate Sources (Task 6O)

## Purpose
Genesis runtime file planning for the first APF build-path promotion.

## Policy
- Candidate-only artifacts are intentionally not directly active.
- `Genesis_MiSTer` RTL remains read-only.
- No Sega CD / Mega-CD / 32X sources.
- No `Genesis.sv` or `sys/sys_top.v` in active/runtime promotion.
- No synthesis claims are made from this task.

## Runtime entrypoint
- `third_party/Genesis_MiSTer/rtl/system.sv` *(Task 6O promoted)*

## Promoted toward active-first boot path
- `third_party/Genesis_MiSTer/rtl/cheatcodes.sv`
- `third_party/Genesis_MiSTer/rtl/FX68K/fx68k.sv`
- `third_party/Genesis_MiSTer/rtl/FX68K/fx68kAlu.sv`
- `third_party/Genesis_MiSTer/rtl/FX68K/uaddrPla.sv`
- `third_party/Genesis_MiSTer/rtl/EEPROM_STM95.sv`
- `third_party/Genesis_MiSTer/rtl/multitap.sv`
- `third_party/Genesis_MiSTer/rtl/gen_io.sv`
- `third_party/Genesis_MiSTer/rtl/genesis_lpf.v`

## Task 6O-deferred entries (still in candidate path)
- `third_party/Genesis_MiSTer/rtl/fourway.v`
- `third_party/Genesis_MiSTer/rtl/ddram.sv`
- `third_party/Genesis_MiSTer/rtl/miracle.sv`
- `third_party/Genesis_MiSTer/rtl/lightgun.sv`
- `third_party/Genesis_MiSTer/rtl/teamplayer.sv`

## Mixed-language blockers (kept deferred until Quartus proof)
- `third_party/Genesis_MiSTer/rtl/vdp.vhd`
- `third_party/Genesis_MiSTer/rtl/vdp_common.vhd`
- `third_party/Genesis_MiSTer/rtl/T80/T80s.vhd`
- `third_party/Genesis_MiSTer/rtl/SVP/SVP.vhd`
- `third_party/Genesis_MiSTer/rtl/jt*` families

## Source-list status
- Active/build-oriented runtime list: `quartus/files_genesis_runtime.qsf`
- Candidate/reference list: `quartus/files_genesis_runtime.candidate.qsf`
- Planning-only scan list: `apf/src/fpga/filelists/genesis_runtime_candidate.f`

## Exclusions
- `Genesis.sv`
- `sys/*.v`
- HPS/IOCTL framework files
- Sega CD / Mega CD runtime
- 32X runtime
- simulation-only APF artifacts
