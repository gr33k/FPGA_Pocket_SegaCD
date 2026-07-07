# Pocket Genesis migration plan

## New implementation direction

Use `third_party/openFPGA-Genesis` as the Pocket-native Genesis base/reference.

## Migration sequence

1. Keep current repo scaffold and docs as research.
2. Import Pocket-native Genesis upstreams as read-only submodules.
3. Audit upstream source layout and build flow.
4. Decide whether to:
   - fork `opengateware/openFPGA-Genesis` directly and rename/package it, or
   - vendor a clearly attributed source snapshot into this repo, or
   - keep it as a submodule and build wrapper/package around it.
5. Make Genesis-only build as close to upstream Pocket Genesis as possible.
6. Rename/package as `FPGA_Pocket_SegaCD`.
7. Boot Genesis on Pocket.
8. Add Sega CD in a separate branch.
9. Evaluate 32X after Genesis is stable.

## Pocket-specific pieces to adopt from upstream

- APF host/target bridge command handling
- data slot ROM loading
- SDRAM ROM loader/controller wiring
- `ROM_ADDR`, `ROM_DATA`, `ROM_REQ`, `ROM_ACK` path
- `ROMSZ` from loaded ROM metadata
- Genesis 3/6-button controller mapping
- video mode/scaler slot behavior for 256/320 and 224/240 modes
- audio serializer path
- PLL/clocking structure
- input/settings synchronization into core clock domain

## Known current scaffold mismatches

- Current controller mapping uses trigger bits for X/Y/Z; Pocket Genesis upstream maps X/Y/Z to digital key bits.
- Current ROM path is still preload/stub-style; upstream uses APF data loader plus SDRAM.
- Current video path directly uses `clk_74a`; upstream uses generated pixel clocks and scaler mode signaling.
- Current audio path is stubbed; upstream uses real audio serialization.
- Current external SDRAM is tied off; upstream uses SDRAM for ROM storage.

## Sega CD plan

Do not add Sega CD until Genesis boots.

After Genesis boots:
- add Sega CD branch
- define BIOS data slot
- define disc image/data slot strategy
- integrate sub-CPU/CD block
- add PCM/CDDA audio path
- add word RAM/program RAM handling
- test progressively

## 32X plan

Do not add 32X until Genesis boots.

After Genesis boots:
- evaluate 32X resource/timing impact
- if manageable, branch from Genesis base
- if too large or messy, create a separate 32X core repo/path
