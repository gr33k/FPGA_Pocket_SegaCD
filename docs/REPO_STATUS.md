# FPGA_Pocket_SegaCD repository status

Date: 2026-07-10

## Current runtime state

- The Pocket package loads and the core menu/settings are accessible on hardware.
- Launching a Genesis ROM currently results in a black screen.
- No visible crash or explicit runtime error has been reported.
- Current staged package identity is now:
  - `Cores/gr33k.SegaCD`
  - platform id: `gr33k_segacd`
  - `Platforms/gr33k_segacd.json`
  - displayed author: `Gr33k`
  - displayed core name: `Sega CD`
- Current implementation remains Genesis only.
- Sega CD and 32X are deferred future investigation paths.

## Build state carried forward from Task 8A

- `quartus_map` exit: `0`
- `quartus_fit` exit: `0`
- `quartus_sta` exit: `0`
- `quartus_asm` exit: `0`
- Worst setup slack: `0.711`
- Worst hold slack: `0.221`
- Generated artifacts remain staged under ignored build paths.
- No ROM is bundled.
- No runtime correctness is claimed.

## Current debug posture

- Stop Quartus archaeology for now.
- Focus on runtime behavior.
- Investigate in this order:
  - ROM load / preload completion
  - reset / PLL lock
  - CPU execution
  - video / VDP output
  - audio
  - controller path

## Safety constraints

- Do not edit `third_party/openFPGA-Genesis`.
- Do not edit `third_party/Genesis_MiSTer`.
- Do not bundle ROMs or BIOS payloads.
- Do not claim Pocket boot success or runtime correctness until hardware behavior is proven.
