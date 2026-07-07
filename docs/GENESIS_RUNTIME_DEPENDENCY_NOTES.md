# Genesis Runtime Dependency Notes (Task 5J, first-pass)

## Task 5L decision

- Runtime import strategy chosen: **git submodule** (documentation-only for now).
- Planned import path: `third_party/Genesis_MiSTer`
- Planned upstream: `https://github.com/MiSTer-devel/Genesis_MiSTer`
- Task 5M performed the actual submodule addition and pinned the first known runtime commit.

## Direct dependency chain found so far

- `core_top`
  - `->` `apf_genesis_base.sv`
  - `->` `system` (instantiated as `u_genesis` in `apf_genesis_base.sv`)
- `system` declaration is now available from the `third_party/Genesis_MiSTer` runtime import (`third_party/Genesis_MiSTer/rtl/system.sv`), while full runtime compile pass is still pending.

## Major dependency groups identified for full runtime integration

### Confirmed in this repo

- `apf/apf_genesis_base.sv` (APF boundary wrapper)
- `third_party/Genesis_MiSTer/rtl/system.sv` (present via submodule)

### Missing from repo (expected external/imported runtime)

- 68000 CPU core group (expected under `third_party/Genesis_MiSTer`, e.g. `rtl/FX68K/fx68k.sv`)
- Z80/T80 group (`third_party/Genesis_MiSTer/rtl/T80/*` family)
- VDP/video group (`third_party/Genesis_MiSTer/rtl/vdp*` family)
- FM/YM group (`third_party/Genesis_MiSTer/rtl/jt12/*`)
- PSG group (`third_party/Genesis_MiSTer/rtl/jt89/*`)
- Memory/helper groups (`third_party/Genesis_MiSTer` equivalents: `ddram`, `sdram`, `genesis_bus`, `rommap`, `misc`, `codes`, `mcu`, etc.)
- Game Genie/helper/quirk-style modules if required by system wiring

### Unknown, compile-time resolution required

- Any exact include/dep-chain beyond the listed high-level modules must be confirmed by a future dependency-oriented compile pass against the imported runtime sources.
- The scanner output is advisory only and must be validated by a compile/elaboration attempt.
- Exact file set is expected to expand as compilation proceeds.

## Exclusions for this milestone

Keep excluded until explicitly planned in later milestones:

- MiSTer top wrapper (`third_party/Genesis_MiSTer/Genesis.sv`)
- `third_party/Genesis_MiSTer/sys/sys_top.v`
- HPS/IOCTL and other framework-level MiSTer integration files
- Sega CD / Mega-CD modules and BIOS/image loading path
- 32X and expansion modules
- Real memory controller / SDRAM / PSRAM / SRAM implementation
- Simulation shim `apf/src/fpga/sim/apf_genesis_base_stub.sv`

## Practical constraints

- No files are added or edited in this pass to alter runtime behavior.
- No active Quartus/APF project is added yet.
- This doc intentionally remains a planning artifact until the runtime sources are present and verified.

## Tooling

- Task 5K added `tools/scan_verilog_deps.py` (read-only dependency scanner).
- Use:
  - `python3 tools/scan_verilog_deps.py`
  - `python3 tools/scan_verilog_deps.py --root .`
  - `python3 tools/scan_verilog_deps.py --root . --entry apf/apf_genesis_base.sv`
- The scanner reports declarations/instantiations/missing modules from present files and is advisory; compile remains the final truth.
