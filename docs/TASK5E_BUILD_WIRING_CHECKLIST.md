# Task 5E: APF Scaffold Build Wiring Checklist

## Current scaffold wiring summary

- **APF top module**: `apf/src/fpga/core/core_top.v`
  - This is the single entry-point wrapper for openFPGA/APF builds in this milestone.
- **APF wrapper boundary**: `apf/apf_genesis_base.sv`
  - `core_top` instantiates this wrapper as the only imported runtime adapter.
- **ROM ingress path**: `apf/src/fpga/core/rom_preload_ingress_stub.v`
  - Bridge write debug ingress for future preload stream signals.
- **ROM service path**: `apf/src/fpga/core/rom_local_service_stub.v`
  - Mediates ROM request/ack behavior between `apf_genesis_base` and preload storage.
- **Optional tiny local ROM RAM**: `apf/src/fpga/core/rom_tiny_local_ram_stub.v`
  - Used for structural smoke testing only when enabled.

## Included APF scaffold source manifest

See:
- `apf/src/fpga/core/apf_scaffold_sources.f`

It should include at minimum these scaffold files:
- `apf/src/fpga/core/core_top.v`
- `apf/src/fpga/core/rom_preload_ingress_stub.v`
- `apf/src/fpga/core/rom_local_service_stub.v`
- `apf/src/fpga/core/rom_tiny_local_ram_stub.v`
- `apf/apf_genesis_base.sv`

The manifest intentionally does not enumerate full Genesis/MiSTer runtime RTL;
that set is external-to-this-manifest unless already part of the surrounding build flow.

## Safe compile-time guardrails (expected now)

- No Sega CD files are included.
- No memory-controller files are included.
- No real APF data-slot loader is included.
- No SRAM/PSRAM/SDRAM wrappers are included.
- Host bridge reads remain stubbed (`bridge_rd_data = 0`).

## Build integration notes

- `core_top.v` exposes the following task-scoped parameters for build selection:
  - `ENABLE_GENESIS_STUB_RUN`
  - `ENABLE_PRELOAD_INGRESS_STUB`
  - `ENABLE_TINY_LOCAL_ROM_RAM`
  - `ENABLE_FAKE_ROM_FOR_SMOKE_TEST`
- `rom_local_service_stub` also has `ENABLE_FAKE_ROM_FOR_SMOKE_TEST`.
- Keep parameters at conservative defaults unless intentionally smoke-testing.

Related configuration references:
- [`docs/APF_PARAMETER_OVERRIDES.md`](docs/APF_PARAMETER_OVERRIDES.md) for override ownership and usage.
- [`docs/TASK5G_SMOKE_CONFIG_FLOW.md`](docs/TASK5G_SMOKE_CONFIG_FLOW.md) for the three-task modes.
- [`apf/src/fpga/core/apf_scaffold_config_presets.md`](apf/src/fpga/core/apf_scaffold_config_presets.md) for documentation-only presets.

## Smoke-test compile checklist

1. Confirm source manifest file is loaded into your APF project flow.
2. Confirm `core_top` is the top-level module and `apf_genesis_base` is present.
3. Confirm `rom_preload_ingress_stub` and `rom_local_service_stub` are compiled.
4. Confirm optional `rom_tiny_local_ram_stub` is compiled when `ENABLE_TINY_LOCAL_ROM_RAM=1` path is used.
5. Confirm no unexpected Sega-CD-era or save-state-related files were added to the scaffold source list.
6. Confirm bridge read/write data remains deterministic for this milestone.
7. Confirm ROM path stays local (no host-per-read streaming behavior).

## Elaboration smoke check (Task 5H)

1. Use `apf/src/fpga/sim/apf_core_top_elab_sources.f` for compile sanity without imported Genesis runtime.
2. Confirm the source list compiles:
   - `apf/src/fpga/core/core_top.v`
   - `apf/src/fpga/core/rom_preload_ingress_stub.v`
   - `apf/src/fpga/core/rom_local_service_stub.v`
   - `apf/src/fpga/core/rom_tiny_local_ram_stub.v`
   - `apf/src/fpga/sim/apf_genesis_base_stub.sv`
   - `apf/src/fpga/sim/tb_core_top_elaboration.v`
3. Confirm `core_top` is instantiated with default inert parameters in the TB.
4. Confirm deterministic outputs are checked (bridge/read/video path) for stub-mode sanity.

## Runtime integration planning (Task 5I)

1. Use `docs/TASK5I_GENESIS_RUNTIME_INTEGRATION_PLAN.md` as the integration boundary map.
2. Keep `apf_genesis_base` as the only wrapper boundary between APF shell and imported runtime.
3. Keep `apf/src/fpga/sim/apf_genesis_base_stub.sv` for elaboration-only checks only.
4. Treat `docs/GENESIS_RUNTIME_SOURCE_MANIFEST_DRAFT.md` and `apf/src/fpga/core/genesis_runtime_sources.todo.f` as dependency-draft inputs for the future runtime compile.
