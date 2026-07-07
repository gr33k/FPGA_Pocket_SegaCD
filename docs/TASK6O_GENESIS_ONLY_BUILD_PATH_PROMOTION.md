# Task 6O: Genesis-only build-path promotion (control-plane)

## Scope
This pass promotes a first Genesis-only runtime source list from candidate planning into a controlled active Quartus-oriented runtime list while keeping Sega CD, 32X, and mixed-language expansion deferred.

## What was promoted
The following high-confidence Genesis-only sources were promoted to `quartus/files_genesis_runtime.qsf` and marked as active assignments:

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

## What remains deferred
The following were intentionally deferred (kept commented or candidate-only):

- `fourway.v`, `ddram.sv`, `miracle.sv`, `lightgun.sv`, `teamplayer.v`
- `vdp.vhd`, `vdp_common.vhd`, `T80/T80s.vhd`
- `SVP/SVP.vhd`
- other `jt*` and mixed-language dependencies not yet validated in Quartus flow

## Why Sega CD and 32X are excluded
They remain out of scope per milestone constraint and would materially increase bootstrap risk before the Genesis-only baseline is established.

## Why Genesis_MiSTer is read-only
The upstream runtime remains in `third_party/Genesis_MiSTer` and is not modified by APF-side integration tasks.

## Why compile success is not claimed
This is the first scaffolded active source-list promotion; compile blockers are still expected because Quartus is unavailable and mixed-language ordering is not fully confirmed.

## Tooling behavior for this task
No synthesis/build was run on this host.

- `tools/run_no_quartus_runtime_lint_probe.sh` was run in advisory mode (no parser tool installed).
- `python3 tools/scan_verilog_deps.py --root . --entry third_party/Genesis_MiSTer/rtl/system.sv` remains the static visibility pass.

## What to do next (Task 6P)
- Move to a Quartus-capable host.
- Re-run analysis/elaboration using the promoted list.
- Triage first compile errors and decide whether blockers are:
  - missing dependencies,
  - ordering issues,
  - or Quartus/mixed-language/project-setup issues.
