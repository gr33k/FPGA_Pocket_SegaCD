# Genesis-only Source Closure Report

## Task 6O active source closure snapshot
- Active runtime filelist source: `quartus/files_genesis_runtime.qsf`
- Candidate/reference list: `quartus/files_genesis_runtime.candidate.qsf`
- Planning filelist: `apf/src/fpga/filelists/genesis_runtime_candidate.f`

## Active source list
### Active in runtime list
- `third_party/Genesis_MiSTer/rtl/system.sv`
- `third_party/Genesis_MiSTer/rtl/cheatcodes.sv`
- `third_party/Genesis_MiSTer/rtl/FX68K/fx68k.sv`
- `third_party/Genesis_MiSTer/rtl/FX68K/fx68kAlu.sv`
- `third_party/Genesis_MiSTer/rtl/FX68K/uaddrPla.sv`
- `third_party/Genesis_MiSTer/rtl/EEPROM_STM95.sv`
- `third_party/Genesis_MiSTer/rtl/multitap.sv`
- `third_party/Genesis_MiSTer/rtl/gen_io.sv`
- `third_party/Genesis_MiSTer/rtl/genesis_lpf.v`
- `apf/apf_genesis_base.sv`

## Deferred or unresolved (from scan + source-structure risk)
- `third_party/Genesis_MiSTer/rtl/fourway.v`
- `third_party/Genesis_MiSTer/rtl/ddram.sv`
- `third_party/Genesis_MiSTer/rtl/miracle.sv`
- `third_party/Genesis_MiSTer/rtl/lightgun.sv`
- `third_party/Genesis_MiSTer/rtl/teamplayer.sv`
- `third_party/Genesis_MiSTer/rtl/vdp.vhd`
- `third_party/Genesis_MiSTer/rtl/vdp_common.vhd`
- `third_party/Genesis_MiSTer/rtl/T80/T80s.vhd`
- `third_party/Genesis_MiSTer/rtl/SVP/SVP.vhd`
- `third_party/Genesis_MiSTer/rtl/jt*` families

## Likely missing modules (pending first Quartus compile)
- VHDL runtime units that typically participate in Genesis color/audio paths
- Z80, VDP, and PSG/FM boundary wiring modules not yet forced into active list
- Exact file ordering once Quartus emits first-pass errors

## Mixed-language risks
- Mixed-language files are intentionally commented out.
- No Quartus mixed-language final ordering is claimed here.
- This remains a pre-elaboration, compile-probe-ready milestone.

## Probe status
- `NO_QUARTUS_LINT_PROBE` currently reports no supported local parser (`tool available: none`) in this environment.
- Static dependency visibility is still being used as the decision basis for closure growth.

## Next compile validation action
- On Quartus host: run `tools/run_quartus_analysis_only_if_available.sh` with `quartus_map` available.
- Capture first missing-module / ordering errors and promote from this report only by evidence.
