# Pocket Genesis upstream audit

## Primary upstream: opengateware/openFPGA-Genesis

Repository:
- https://github.com/opengateware/openFPGA-Genesis

Use:
- primary Pocket-native Genesis implementation reference
- APF bridge/data slot model
- SDRAM ROM loading model
- video/scaler behavior
- audio serializer pattern
- controller mapping
- clock/PLL structure

Expected files/patterns to audit:
- `src/fpga/core/core_top.sv`
- `src/fpga/apf/apf_top.v`
- `src/fpga/core/rtl/system.sv`
- `data_loader`
- `core_bridge_cmd`
- `sdram`
- `sound_i2s`
- PLL modules
- package JSON and release structure, if present

## Secondary upstream: RndMnkIII/Analogizer_openFPGA-Genesis

Repository:
- https://github.com/RndMnkIII/Analogizer_openFPGA-Genesis

Use:
- reference for Analogizer/SNAC-specific changes
- reference for relaxed SDRAM/ROM loading changes
- not the main base unless Analogizer support becomes a target

Avoid initially:
- Analogizer-specific output modes
- SNAC-specific controller paths
- extra scope unrelated to Pocket built-in/Dock testing

## Feature/reference-only upstream: spiritualized1997/openFPGA-Genesis

Repository:
- https://github.com/spiritualized1997/openFPGA-Genesis

Use:
- feature target reference only
- claims/README reference for automatic region, 3/6 button support, 4-player/J-Cart, EEPROM saves

Do not use as main source base unless source files are available and useful.

## Current local scaffold status

The existing APF/MiSTer integration scaffold remains in the repo as research and backup.
It should not continue expanding as the main implementation unless the Pocket-native base fails.

## Licensing/attribution note

Preserve upstream attribution.
Do not remove upstream copyright/license notices.
Do not blindly copy source files into active runtime paths until license/attribution policy is documented.
Submodules are used first to keep upstream history and references intact.
