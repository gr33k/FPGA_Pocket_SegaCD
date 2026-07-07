# Task 6U: Pivot to Pocket-native Genesis base

## Decision

The main implementation path is pivoting away from raw MiSTer-first scaffolding and toward an existing Analogue Pocket/openFPGA Genesis core.

Primary upstream base/reference:
- `third_party/openFPGA-Genesis`
- upstream: https://github.com/opengateware/openFPGA-Genesis

Secondary reference:
- `third_party/Analogizer_openFPGA-Genesis`
- upstream: https://github.com/RndMnkIII/Analogizer_openFPGA-Genesis

Feature/reference-only:
- https://github.com/spiritualized1997/openFPGA-Genesis

## Why

Existing Pocket Genesis cores already implement the Pocket-specific integration work:
- APF bridge command handling
- data slot ROM loading
- SDRAM ROM storage/access
- Genesis controller mapping for 3/6-button pads
- Pocket scaler/video timing
- audio serialization
- package layout expectations

The previous MiSTer/runtime scaffold remains useful research, but it is no longer the main implementation path.

## Immediate target

Genesis-only Pocket core first.

## Later targets

After Genesis boots on real Pocket:
1. Add Sega CD in a dedicated branch.
2. Evaluate 32X.
3. If 32X is too large or messy, split it into a separate 32X core repo/path

## Hard boundaries

- Do not implement Sega CD in this pivot task.
- Do not implement 32X in this pivot task.
- Do not edit upstream submodules directly.
- Do not commit ROMs, BIOS files, generated bitstreams, Quartus installers, or Quartus install directories.
- Do not claim synthesis or Pocket boot.
