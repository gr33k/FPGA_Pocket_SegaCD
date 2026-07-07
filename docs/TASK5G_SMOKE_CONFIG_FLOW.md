# Task 5G: Smoke configuration flow for APF scaffold

## What changed

Task 5G adds a documented smoke-test configuration approach so the APF scaffold can be built and tested in three safe modes without editing RTL source.  

The flow is parameter-driven and keeps all default values conservative (`0`).

- Top-level defaults stay inert in `apf/src/fpga/core/core_top.v`.
- `core_top` now owns and forwards all scaffold toggles to the relevant children.
- `core_top` remains a Genesis-only, non-game-capable structural shell.
- No real APF cartridge loader, Sega CD, memory controller, or host-per-read ROM streaming is introduced.

## Why this task exists

We need a repeatable way to choose "safest", "fake structural smoke", or "tiny local RAM smoke" during build invocation, rather than manual source edits. That supports:

- deterministic verification of build settings,
- easier handoff for future integrators,
- and a clear separation between checked-in default behavior and temporary smoke workflows.

## Three required modes

1. Default inert scaffold  
   - `ENABLE_GENESIS_STUB_RUN = 0`
   - `ENABLE_PRELOAD_INGRESS_STUB = 0`
   - `ENABLE_FAKE_ROM_FOR_SMOKE_TEST = 0`
   - `ENABLE_TINY_LOCAL_ROM_RAM = 0`

   Expected:
   - Genesis stays held in reset.
   - No fake ROM service is active.
   - No local ROM RAM stub is active.
   - Safest mode for compile/electrical smoke.

2. Fake ROM structural smoke  
   - `ENABLE_GENESIS_STUB_RUN = 1`
   - `ENABLE_PRELOAD_INGRESS_STUB = 0`
   - `ENABLE_FAKE_ROM_FOR_SMOKE_TEST = 1`
   - `ENABLE_TINY_LOCAL_ROM_RAM = 0`

   Expected:
   - Genesis may release from reset.
   - ROM service returns inert constant data.
   - Structural/compile smoke only.
   - Not a real gameplay mode.

3. Tiny local RAM ROM path smoke  
   - `ENABLE_GENESIS_STUB_RUN = 1`
   - `ENABLE_PRELOAD_INGRESS_STUB = 1`
   - `ENABLE_FAKE_ROM_FOR_SMOKE_TEST = 0`
   - `ENABLE_TINY_LOCAL_ROM_RAM = 1`

   Expected:
   - Debug bridge ingress can inject small local ROM words.
   - `preload_commit` can mark preload done.
   - Tiny local RAM services runtime `rom_addr/rom_req` reads.
   - Still not real cartridge support.

## Why defaults remain inert

Checked-in defaults are kept conservative to avoid accidental false-positive "working" behavior while the real preload/load pipeline and memory controller are not implemented.

- No default override should enable any smoke mode.
- Keeping defaults inert prevents host-visible runtime surprises during routine structural builds.

## Why this still does not boot real games yet

Even in tiny RAM mode, preload is only a debug scaffold path (small fixed memory + debug bridge map), not APF data-slot loading, not cartridge timing model, and no memory arbitration.

## What Task 5H should do next

Task 5H should add a minimal top-level compile sanity stub/checklist so `core_top` can be elaborated with these parameters under default/inert and smoke settings without requiring full Genesis runtime compilation yet.
