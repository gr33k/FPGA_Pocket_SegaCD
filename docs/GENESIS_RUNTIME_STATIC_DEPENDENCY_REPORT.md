# Genesis Runtime Static Dependency Report (Task 6M)

This report is a static, non-compiling artifact prepared for the no-Quartus lane.

## Date/time
- 2026-07-06T00:00:00Z

## Scope
- APF wrapper boundary in scope:
  - `apf/apf_genesis_base.sv`
- Runtime target:
  - Imported `third_party/Genesis_MiSTer` (strategy selected previously)
- Output target:
  - future APF Quartus runtime compile

## Static findings
- `apf/apf_genesis_base.sv` currently depends on `system` plus APF-side adapter interfaces.
- `third_party/Genesis_MiSTer/rtl/system.sv` is present from import planning and remains unchanged.
- Scanner command used:
  - `python3 tools/scan_verilog_deps.py --root . --entry third_party/Genesis_MiSTer/rtl/system.sv`
- Scanner succeeded (no script failure).
- Static scan indicates a broad transitive set around `third_party/Genesis_MiSTer/rtl/system.sv` and nested helper modules, with mixed-language signals still present.
- Conflicting/ambiguous findings are marked as advisory.

## Modules/files found (advisory, confidence-labeled)
- Declared `system` module confirmed.
- Confirmed module instantiations reported by scanner include:
  - `aluCorf`, `aluGetOp`, `aluShifter`, `busArbiter`, `busControl`, `dataIo`, `fx68k`, `fx68kAlu`, `jt10_*`, `jt12_*`, `jt89_*`, `sequencer`, `uRom`, `uaddrDecode`, etc.
- Confidence:
  - High: `third_party/Genesis_MiSTer/rtl/system.sv` (direct entry).
  - Medium: modules that appear in both declared and suspected instantiation sets.
  - Low: mixed-language or parser-adjacent modules that need compile-time confirmation.

## Unresolved / advisory-only entries
- One keyword-like scan artifact: `unique` appears as a suspected item; treat as advisory.
- Mixed-language hints:
  - VHDL files were scanned and surfaced (`.vhd`, `.vhdl`) in the dependency graph (`T80`, `JT12`, `SVP`, `vdp_common`, etc.).
  - No runtime compile pass has been performed in this task.

## Exclusions (do not activate now)
- No Sega CD / Mega-CD RTL.
- No 32X modules.
- No `Genesis.sv` (MiSTer top wrapper) in APF runtime compile path.
- No `sys/sys_top.v`.
- No HPS/IOCTL/MiSTer framework files.
- No real SDRAM/PSRAM/SRAM controller files unless compile reports require it in the next phase.

## Known dependency risk areas (review only)
- 68000/Turbo 68000 variant modules
- Z80/T80 path
- VDP/video pipeline modules
- YM/FM audio modules
- PSG audio modules
- Memory helper/mapper/helper modules
- Optional game-genie or quirk/compatibility modules used by `system.sv`

## Excluded files and reasons
- `Genesis.sv`, `sys/sys_top.v`, HPS/IOCTL framework files
- Sega CD / Mega-CD runtime
- 32X runtime
- Memory-controller integration
- Active runtime compile files not yet intended for this phase

## Status classification
- `system` dependency is the core boundary dependency to validate.
- Missing-module certainty cannot be proven without active Quartus or at least a full compile pass.
- This report remains advisory until analysis pass execution on a Quartus-capable host.

## Boundaries and claims
- No Quartus run was performed.
- No synthesis was run.
- No runtime compile success is claimed.

## Next action
- On Quartus availability, move from static report to `Task 6N`-style compile-oriented dependency activation and error classification.
