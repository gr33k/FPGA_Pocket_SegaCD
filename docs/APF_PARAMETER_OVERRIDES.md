# APF Parameter Override Guide (Scaffold)

## Scope

This document defines the scaffold parameter model for structural APF smoke builds.  

Defaults are intentionally conservative and inert.

## Safe default rule

- Do not change checked-in defaults for smoke-run convenience.
- Checked-in defaults in this milestone are:
  - `ENABLE_GENESIS_STUB_RUN = 0`
  - `ENABLE_PRELOAD_INGRESS_STUB = 0`
  - `ENABLE_FAKE_ROM_FOR_SMOKE_TEST = 0`
  - `ENABLE_TINY_LOCAL_ROM_RAM = 0`

- Use build configuration, synthesis invocation, or simulation override flow when you need non-default test behavior.
- Do not enable fake ROM/tiny RAM in the default checked-in top for baseline compile checks.

## Parameter ownership and propagation

- `core_top` owns:
  - `ENABLE_GENESIS_STUB_RUN`
  - `ENABLE_PRELOAD_INGRESS_STUB`
  - `ENABLE_TINY_LOCAL_ROM_RAM`
  - `ENABLE_FAKE_ROM_FOR_SMOKE_TEST`

- `core_top` passes:
  - `ENABLE_PRELOAD_INGRESS_STUB` → `rom_preload_ingress_stub`
  - `ENABLE_FAKE_ROM_FOR_SMOKE_TEST` → `rom_local_service_stub`
  - `ENABLE_TINY_LOCAL_ROM_RAM` → `rom_local_service_stub`

- `rom_local_service_stub` passes:
  - `ENABLE_TINY_LOCAL_ROM_RAM` → `rom_tiny_local_ram_stub`

## How to apply overrides

When the build system supports parameter overrides, set them at the top-level elaboration boundary (for `core_top`) and let children inherit the values through existing parameter wiring.

- Keep override scope narrow to temporary build/test actions only.
- Verify the command/system actually applies parameter overrides rather than relying on comments.
- Avoid editing RTL defaults for routine tests.

## Future build-file notes

Until a project-level Quartus/APF build template is added, these values are documentation-only:
- Build file (when available) should define the top-level parameters at instantiation/elaboration time.
- The future build description should avoid baking smoke-mode values into source.
- Example placeholders:
  - preset selection from `apf_scaffold_config_presets.md`,
  - corresponding synthesis/simulation parameter assignments.

## Do not do

- Do not stream ROM per runtime `rom_req` from APF host.
- Do not add real APF data-slot loading behavior to satisfy these parameters.
- Do not use these parameters as a substitute for real memory arbitration or cartridge timing validation.
