# Genesis_MiSTer Runtime Source Manifest Draft (Task 5I + Task 5J update)

> Draft status: incomplete and compile-confirmation pending.  
> This file is a planning draft only, not an active build manifest.

## Required chain for this APF scaffold phase

- `apf/apf_genesis_base.sv` (confirmed present in repo)
- `third_party/Genesis_MiSTer/rtl/system.sv` (present via submodule)

## Dependency status (first-pass)

### confirmed present

- `apf/apf_genesis_base.sv` (APF boundary wrapper)
- `third_party/Genesis_MiSTer/rtl/system.sv` (runtime module root now present under submodule)

### external/runtime expected / compile-confirmed pending

- `third_party/Genesis_MiSTer/rtl/system.sv` exists but compile-coverage for APF boundary is still pending
- 68000 CPU core group (e.g. `third_party/Genesis_MiSTer/rtl/FX68K/fx68k.sv`)
- Z80/T80 group (`third_party/Genesis_MiSTer/rtl/T80/*` + dependent files)
- VDP/video group (`third_party/Genesis_MiSTer/rtl/vdp.vhd`, `third_party/Genesis_MiSTer/rtl/vdp_common.vhd`, and helpers)
- YM/FM audio group (`third_party/Genesis_MiSTer/rtl/jt12/*`)
- PSG/audio support group (`third_party/Genesis_MiSTer/rtl/jt89/jt89.v`, etc.)
- Memory/helper modules used by `system.sv`
- Game Genie / helper / quirk support modules if instantiated by `system.sv`
- ROM/memory bridge/helper modules (e.g. `third_party/Genesis_MiSTer/rtl/ddram.sv`, `third_party/Genesis_MiSTer/rtl/sdram.sv`, `third_party/Genesis_MiSTer/rtl/genesis_bus.sv`, `third_party/Genesis_MiSTer/rtl/rommap.sv`, `third_party/Genesis_MiSTer/rtl/misc.sv`, `third_party/Genesis_MiSTer/rtl/codes.sv`, `third_party/Genesis_MiSTer/rtl/mcu.sv`) — exact list pending compile pass.

### intentionally excluded for this milestone

- MiSTer wrapper and framework files:
-   `third_party/Genesis_MiSTer/Genesis.sv`
-   `third_party/Genesis_MiSTer/sys/sys_top.v`
-   `third_party/Genesis_MiSTer/hps_io` / IOCTL framework files
- Sega-CD / Mega-CD files
- 32X modules
- Real memory-controller files unless a compile dependency requires one of them later
- `apf/src/fpga/sim/apf_genesis_base_stub.sv` (for real runtime manifest path)

## Notes for next passes

- Task 5L selected `git submodule` as the future runtime import strategy.
- Task 5M added the submodule and pinned the runtime commit.
- Task 5J performed a source-inspection pass only (no compile). Next step remains compile-oriented validation.
- `apf/src/fpga/core/genesis_runtime_dependency_probe.todo.f` now carries a Task-5J probe manifest with explicit status tags.

## Exclusions (do not include yet)

- `sys/sys_top.v`
- `Genesis.sv`
- `sys/hps_io.sv` and other MiSTer framework/menu files
- Sega-CD modules (any `SegaCD*`, `megacd*`, `sub_cpu`, etc.)
- 32X modules
- external board/memory-controller wrappers unless the compile pass explicitly requires them
- `apf/src/fpga/sim/apf_genesis_base_stub.sv`

## How this draft should be used

- Use as a checklist, not as an active synthesis file.
- Keep one manifest for current compile run.
- Add/remove only after dependency errors indicate what is required.
- Keep imported runtime files read-only; do not patch runtime RTL in this repository.
