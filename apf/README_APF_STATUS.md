# Analogue Pocket APF Skeleton Status

## Scope
- This is a **feasibility-only** APF scaffold for a future Sega CD / Mega-CD Pocket port.
- It is intentionally non-functional for full product goals and does not modify or
  depend on runtime behavior in `Genesis.sv`/`rtl/system.sv`.

## What was added (Task 3)
- Added a dedicated Genesis-only APF wrapper:
  - [apf_genesis_base.sv](/Users/phassold/Documents/FPGA/Genesis_MiSTer/apf/apf_genesis_base.sv)
- Added an explicit APF ROM-slot contract:
  - [apf_data_slot.json](/Users/phassold/Documents/FPGA/Genesis_MiSTer/apf/apf_data_slot.json)
- Updated status metadata:
  - [core.json](/Users/phassold/Documents/FPGA/Genesis_MiSTer/apf/core.json)
  - [metadata.json](/Users/phassold/Documents/FPGA/Genesis_MiSTer/apf/metadata.json)
- Kept existing Task 2 placeholder artifacts for non-Rom smoke checks:
  - [video_test_pattern.json](/Users/phassold/Documents/FPGA/Genesis_MiSTer/apf/video_test_pattern.json)
  - [silent_audio.json](/Users/phassold/Documents/FPGA/Genesis_MiSTer/apf/silent_audio.json)

## Task 3 constraints implemented in wrapper
- No Sega CD logic instantiated.
- No 32X logic instantiated.
- No save-state path.
- No fancy menu path.
- ROM loads from APF data-slot request path.
- One controller (`pad1`, 12-bit Genesis pad format).
- Video/audio output only from wrapper:
  - RGB and sync/de from core video path.
  - DAC outputs passed through as 16-bit signed channels.

## Guardrail recap
- No modifications were made outside `apf/`.
- No behavior changes were made to existing Genesis runtime modules.
- APF bus contract and clocks are currently a feasibility skeleton and still need
  target-toolchain binding.
