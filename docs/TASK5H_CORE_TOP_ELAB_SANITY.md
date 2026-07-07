# Task 5H: core_top compile/elaboration sanity scaffold

## Why this exists

`core_top` instantiates `apf_genesis_base`, and that real wrapper depends on imported Genesis/MiSTer runtime modules.
For this milestone we need a smoke check that validates:
- APF top-level port binding
- Compile/elaboration of the openFPGA wrapper shell
- Default inert parameter behavior

without requiring the full imported runtime to be in the compile pass.

To do this, a simulation-only stub is introduced for:
- `apf/src/fpga/sim/apf_genesis_base_stub.sv`

## Why this is simulation-only

`apf_genesis_base_stub.sv` is explicitly a compile/elaboration shim:
- It defines `module apf_genesis_base` with the same port interface consumed by `core_top`.
- It drives deterministic zeros and simple stubs.
- It performs no cartridge bus, ROM, video, or audio emulation.
- It **must not** be used in real hardware builds.

## Why the real `apf_genesis_base.sv` stays

The real `apf/apf_genesis_base.sv` is still the runtime boundary for imported Genesis behavior and is intentionally kept unchanged until the project is ready to compile real runtime RTL with APF integration.

This task only validates shell structure and defaults.

## What this sanity check proves

The Task 5H sanity path proves:
- `core_top` compiles/elaborates with APF ports and local stubs.
- Default inert parameters (`0`) are accepted at top-level.
- Stubbed bridge/outputs are deterministic (`bridge_rd_data = 0`, zeroed video path).
- Basic compile-time pass/finish flow for smoke verification.

## What it does not prove

This does **not** prove:
- Full Genesis runtime functionality.
- Cartridge timing correctness.
- Real ROM load from APF data slot.
- Host-per-read ROM streaming behavior (still disallowed).
- Sega CD / audio-CD / memory-controller behavior.

## Difference from Task 5F testbench

Task 5F testbench validates the preload internals:
- `rom_preload_ingress_stub`
- `rom_local_service_stub`
- `rom_tiny_local_rom_ram_stub`

Task 5H is instead a top-level compile sanity for `core_top` with only a placeholder `apf_genesis_base`.
It does not validate ROM preload plumbing behavior.

## Why no commercial game is expected to boot

No real cartridge runtime path is instantiated. ROM requests are not served from actual game ROM data.
This is a structural/elaboration scaffold only.

## Why Sega CD stays untouched

This task is purely APF shell compile hygiene. No Sega CD logic, CD BIOS, ISO support, or sub-CPU memory hardware is added or modified.

## What Task 5I should do next

Task 5I should add a real build-plan document for integrating imported Genesis_MiSTer runtime RTL into the APF source manifest without changing the imported runtime files.
