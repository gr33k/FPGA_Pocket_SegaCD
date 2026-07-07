# Genesis Runtime Candidate Sources (Task 6M)

## Purpose
Candidate-only source list for the next real Quartus compile lane.

## Policy
- Candidate-only. Not active in current build.
- No Sega CD / Mega-CD / 32X source files.
- No `Genesis.sv` and no sys/HPS/IOCTL wrappers.
- No changes to `third_party/Genesis_MiSTer` runtime RTL in this task.

## Runtime entrypoint
- `third_party/Genesis_MiSTer/rtl/system.sv` *(high confidence, candidate only)*

## Confirmed direct dependencies (from static scan and header audit)
- `third_party/Genesis_MiSTer/rtl/cheatcodes.sv` *(high)*
- `third_party/Genesis_MiSTer/rtl/FX68K/fx68k.sv` *(high)*
- `third_party/Genesis_MiSTer/rtl/FX68K/fx68kAlu.sv` *(high)*
- `third_party/Genesis_MiSTer/rtl/FX68K/uaddrPla.sv` *(high)*
- `third_party/Genesis_MiSTer/rtl/EEPROM_STM95.sv` *(medium)*
- `third_party/Genesis_MiSTer/rtl/multitap.sv` *(medium)*
- `third_party/Genesis_MiSTer/rtl/gen_io.sv` *(medium)*
- `third_party/Genesis_MiSTer/rtl/genesis_lpf.v` *(high)*
- `third_party/Genesis_MiSTer/rtl/fourway.v` *(low, scan-adjacent)*
- `third_party/Genesis_MiSTer/rtl/ddram.sv` *(low, scan-adjacent)*
- `third_party/Genesis_MiSTer/rtl/miracle.sv` *(low)*
- `third_party/Genesis_MiSTer/rtl/lightgun.sv` *(low)*
- `third_party/Genesis_MiSTer/rtl/teamplayer.sv` *(low)*

## Candidate-but-deferred entries (not currently included in active compile)
- `third_party/Genesis_MiSTer/rtl/jt*` family (JT03/10/12 + FM/PSG modules) *(medium/high mix, mixed language + many files)*
- `third_party/Genesis_MiSTer/rtl/jt89/*` *(low)*
- `third_party/Genesis_MiSTer/rtl/vdp.vhd` and `vdp_common.vhd` *(high functional impact, VHDL)*
- `third_party/Genesis_MiSTer/rtl/T80/T80s.vhd` *(high for Z80 path, VHDL)*
- `third_party/Genesis_MiSTer/rtl/SVP/SVP.vhd` / `SSP160x*` *(optional module depending on quirks)*

## Exclusions
- `third_party/Genesis_MiSTer/Genesis.sv`
- `third_party/Genesis_MiSTer/sys/*.v`
- HPS/IOCTL framework files
- Sega CD / Mega CD runtime
- 32X runtime
- simulation-only APF scaffolding files

## Activation status
- Candidate files are non-active planning artifacts.
- The active Quartus runtime compile list in this task remains untouched.
