# openFPGA-Genesis integration delta (Task 6W)

## Purpose

Compare current repo scaffold behavior with the new upstream `openFPGA-Genesis` path.

## 1) Controller mapping

- Current scaffold:
  - uses APF wrapper-local controller wiring in the APF scaffold and early bridge stubs.
- openFPGA-Genesis:
  - becomes the source of truth for controller mapping through `apf_top.v` and core input wiring (`joystick_0` patterns and related input paths).

## 2) ROM loading

- Current scaffold:
  - relies on local preload/service stubs (`rom_preload_ingress_stub`, `rom_local_service_stub`, `rom_tiny_local_ram_stub`) for runtime testing.
- openFPGA-Genesis:
  - uses APF bridge/data-loader/unloader and integrated SRAM/SDRAM ROM flow in `src/fpga/core/data_loader.sv` and `src/fpga/core/data_unloader.sv`.

## 3) Video

- Current scaffold:
  - direct pass-through style with deterministic blank outputs for stub modes.
- openFPGA-Genesis:
  - includes Pocket-native video timing/clock behavior in `core_top.sv` with `video_rgb_clock` and related scaler/constraints flows.

## 4) Audio

- Current scaffold:
  - uses stubbed/safety audio behavior in APF wrapper tests.
- openFPGA-Genesis:
  - includes serialized audio pipeline (`sound_i2s`, DAC/audio bridge logic) and active audio routing in the core/APF integration.

## 5) Clocking

- Current scaffold:
  - simple/internal clock hookup with placeholder stubs and minimal generation.
- openFPGA-Genesis:
  - uses Pocket-native PLL/core/system clock generation with APF timing constraints and explicit clock source separation.

## 6) Packaging

- Current repo:
  - contains openFPGA package skeleton, staging scripts, and APF checks.
- openFPGA-Genesis lane:
  - should drive future package metadata layout and APF port wiring updates using upstream project structure when moving from scaffold-only state to active implementation.

## Net result

This task moves the active implementation target from a MiSTer-facing scaffold to
`openFPGA-Genesis` as the source-of-truth lane for next compile-driven activation.
Sega CD and 32X remain out of scope.
