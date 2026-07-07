# No-Quartus Genesis Runtime Static Report

## Date/time
- 2026-07-07 05:16:00 UTC

## Scope
- Task 6M static runtime-prep lane, no Quartus execution.
- Runtime root inspected: `third_party/Genesis_MiSTer/rtl/system.sv`
- APF runtime wrapper boundary reviewed: `apf/apf_genesis_base.sv`

## Toolchain status
- `quartus_map` unavailable during this lane.
- See [docs/QUARTUS_TOOLCHAIN_VALIDATION_RESULT.md](docs/QUARTUS_TOOLCHAIN_VALIDATION_RESULT.md) for current status.

## Scanner command
- `python3 tools/scan_verilog_deps.py --root . --entry third_party/Genesis_MiSTer/rtl/system.sv`
- Initial direct run with positional arg fails by design (script requires `--entry`).

## Task 6O promotion summary
- `quartus/files_genesis_runtime.qsf` now contains first-step active-style runtime assignments for:
  - `system.sv`, `cheatcodes.sv`, `fx68k*`, `EEPROM_STM95.sv`, `multitap.sv`, `gen_io.sv`, `genesis_lpf.v`.
- `apf/apf_genesis_base.sv` is included in the same active-style file to keep compile boundary coherent.
- `fourway/ddram/miracle/lightgun/teamplayer` remain deferred in `files_genesis_runtime.qsf` as comments.
- `vdp.vhd`, `vdp_common.vhd`, `T80/T80s.vhd`, `SVP/SVP.vhd` and other `jt*` modules stay deferred pending Quartus mixed-language activation.

## `system.sv` quick static observations
- Module: `system`
- Clocks/resets: `MCLK` and `RESET_N`
- ROM interface: `ROMSZ`, `ROM_ADDR`, `ROM_DATA`, `ROM_WDATA`, `ROM_WE`, `ROM_BE`, `ROM_REQ`, `ROM_ACK`, `ROM_ADDR2`, `ROM_DATA2`, `ROM_REQ2`, `ROM_ACK2`
- Video ports: `RED/GREEN/BLUE` (4 bits), `VS`, `HS`, `HBL`, `VBL`, `CE_PIX`, `INTERLACE`, `FIELD`, `RESOLUTION`
- Audio ports: `DAC_LDATA`, `DAC_RDATA`
- Controller ports: `JOY_1..JOY_5`, `MULTITAP`, `MOUSE[24:0]`, `MOUSE_OPT[2:0]`, serial joystick, lightgun ports
- Memory-like ports: `BRAM_A/DI/DO/WE/CHANGE`
- Note: `LOADING` participates in internal reset sequencing.

## Direct/static dependency notes
- Scanner-reported missing/external-only module token: `unique` (tool-pattern artifact).
- High-confidence confirmed files observed:
  - `third_party/Genesis_MiSTer/rtl/system.sv`
  - `third_party/Genesis_MiSTer/rtl/cheatcodes.sv`
  - `third_party/Genesis_MiSTer/rtl/FX68K/fx68k.sv`
  - `third_party/Genesis_MiSTer/rtl/FX68K/fx68kAlu.sv`
  - `third_party/Genesis_MiSTer/rtl/FX68K/uaddrPla.sv`
  - `third_party/Genesis_MiSTer/rtl/multitap.sv`
  - `third_party/Genesis_MiSTer/rtl/EEPROM_STM95.sv`
  - `third_party/Genesis_MiSTer/rtl/gen_io.sv`
  - `third_party/Genesis_MiSTer/rtl/genesis_lpf.v`
  - `third_party/Genesis_MiSTer/rtl/fourway.v`
  - `third_party/Genesis_MiSTer/rtl/ddram.sv`
  - `third_party/Genesis_MiSTer/rtl/miracle.sv`
  - `third_party/Genesis_MiSTer/rtl/lightgun.sv`
  - `third_party/Genesis_MiSTer/rtl/teamplayer.sv`
- Likely mixed-language dependency groups:
  - `jt03/jt10/jt12` VHDL/Verilog set (`third_party/Genesis_MiSTer/rtl/jt*/*`)
  - `jt89` family
  - `SVP`/`SSP160x` and `T80` VHDL families
  - `vdp.vhd` / `vdp_common.vhd`

## Exclusions for this task
- `Genesis.sv` and `sys` wrappers
- HPS / IOCTL MiSTer framework files
- Sega CD / Mega-CD runtime
- 32X runtime
- APF packaging and simulation-only artifacts

## Interface/probe risk notes
- APF wrapper currently wires only one Genesis controller vector and stubs many ports.
- `ROM_ADDR2`/`ROM_DATA2`/`ROM_REQ2`/`ROM_ACK2` are intentionally disabled in wrapper.
- ROM size currently uses a local placeholder in wrapper.
- No `apf_genesis_base` runtime behavior changes were made.

## Lint/probe status
- `tools/run_no_quartus_runtime_lint_probe.sh` executed.
- `verilator`/`iverilog` not found in this environment.
- Reported status: lint probe not run (tooling unavailable).
- See [docs/NO_QUARTUS_LINT_PROBE_RESULT.md](docs/NO_QUARTUS_LINT_PROBE_RESULT.md).

## Recommended next action
- Keep this static lane and source manifests active-only.
- Wait for Quartus-capable host and re-run toolchain validation + analysis-only.
- Then compile-driven dependency activation can begin from candidate manifests only.
