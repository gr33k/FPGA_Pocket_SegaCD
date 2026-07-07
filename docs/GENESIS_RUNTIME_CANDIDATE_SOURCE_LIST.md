# Genesis Runtime Candidate Source List (No-Quartus static lane)

This file is a **non-active** planning artifact for the next Quartus compile pass.

## Primary boundary
- `apf/apf_genesis_base.sv` (APF boundary adapter, not to be modified for runtime behavior)

## Expected runtime source group (imported from future submodule)
- `third_party/Genesis_MiSTer/rtl/system.sv` *(inactive, active: NO, confidence: high)*

## Candidate submodules (ordered by direct scan/scan-like discovery)
- `third_party/Genesis_MiSTer/rtl/FX68K/fx68k.sv` *(inactive, active: NO, confidence: medium)*
- `third_party/Genesis_MiSTer/rtl/FX68K/fx68kAlu.sv` *(inactive, active: NO, confidence: medium)*
- `third_party/Genesis_MiSTer/rtl/FX68K/uaddrPla.sv` *(inactive, active: NO, confidence: medium)*
- `third_party/Genesis_MiSTer/rtl/ddram.sv` *(inactive, active: NO, confidence: low, scanner-adjacent)*
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_top.v` *(inactive, active: NO, confidence: medium)*
- `third_party/Genesis_MiSTer/rtl/jt10.v` *(inactive, active: NO, confidence: medium)*
- `third_party/Genesis_MiSTer/rtl/jt03.v` *(inactive, active: NO, confidence: medium)*
- `third_party/Genesis_MiSTer/rtl/teamplayer.sv` *(inactive, active: NO, confidence: low)*
- `third_party/Genesis_MiSTer/rtl/gen_io.sv` *(inactive, active: NO, confidence: low)*
- `third_party/Genesis_MiSTer/rtl/video/` and `third_party/Genesis_MiSTer/rtl/jt*/*` families *(inactive, active: NO, confidence: low; compile verification pending)*
- `third_party/Genesis_MiSTer/rtl/jt89/*` *(inactive, active: NO, confidence: low; pending compile validation)*

## Explicit exclusions
- `third_party/Genesis_MiSTer/Genesis.sv` (MiSTer wrapper)
- `third_party/Genesis_MiSTer/rtl/sys/*.v` and sys-top wrappers
- HPS/IOCTL host-side frameworks
- Sega CD, 32X, save-state, and non-Genesis extensions
- project-specific simulation stubs (`apf/src/fpga/sim/*`) in real runtime source list

## Activation rule
- This list is for **future candidate population only**.
- Keep it out of any active compile source set until:
  1. Quartus validation passes
  2. Analysis-only run is available
  3. Compile errors are classified in Task 6L / 6M+ follow-up

## Status note
- This list does not override the existing active APF scaffold-only source files.

## Why this list is not active
- Candidate list exists to support future compile-driven pruning.
- No entries in this document are currently active in any Quartus source list.
- Any future activation requires:
  - candidate verification against compile feedback,
  - explicit branch control in `NEXT_ACTIVATION_PATH`,
  - and `Task 6N` static refinement or later compile pass updates.
