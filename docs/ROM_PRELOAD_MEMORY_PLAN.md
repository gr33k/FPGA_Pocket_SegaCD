# ROM Preload & Local Memory Plan

## Milestone scope
This milestone defines only the ROM preload and local-memory interface contract for the APF feasibility port. It does **not** implement a memory controller, any memory DMA engine, or streaming ROM behavior from host on demand.

## Target behavior (skeleton)

APF data slot ROM bytes are loaded once during startup into on-device local storage, then reused for runtime ROM reads.

## Data flow

1. APF firmware places ROM bytes into the APF data slot interface.
2. A future loader path copies ROM payload into local storage (SRAM/PSRAM/other local memory).
3. Preload complete signal indicates local memory contains the ROM image.
4. Runtime reset is held until preload complete.
5. Genesis runtime begins operation with:
   - `ROM_REQ` / `ROM_ACK` handled from local memory only.
   - no per-read host bus requests.

## Task 5A reset/preload shell

The top-level now implements a conservative reset FSM with these states:
1. `WAIT_APF_RESET_RELEASE`
2. `WAIT_PLL_LOCK`
3. `WAIT_ROM_PRELOAD`
4. `RUN`

For Task 5A, these are currently wired as stubs:
- `pll_locked_stub = 1'b1`
- `rom_preload_done` from local service stub = `1'b0` unless smoke mode is enabled.
- `ENABLE_GENESIS_STUB_RUN` parameter controls whether reset can be force-released for smoke testing.

Behavior:
- `ENABLE_GENESIS_STUB_RUN = 0` (default): FSM stays in preload wait because `rom_preload_done` is false, so `core_reset_n` remains asserted.
- `ENABLE_GENESIS_STUB_RUN = 1`: FSM allows progression to `RUN` after stubbed lock and preload states for compile/build smoke checks.

## Task 5B local ROM service stub

- `core_top` now instantiates `rom_local_service_stub` and routes:
  - runtime `rom_slot_addr` / `rom_slot_req` → service request interface
  - service `rom_slot_ready` / `rom_slot_data` / `rom_slot_valid` → `apf_genesis_base`
  - service `rom_preload_done` → reset FSM gate.
- The stub keeps preload write ports present as inert placeholders:
  - `preload_wr`
  - `preload_addr`
  - `preload_data`
  - `preload_commit`
- Default behavior is intentionally inert (`preload_done=0`, `ready=0`, `valid=0`, `data=16'hFFFF`).
- Smoke mode inherits `ENABLE_GENESIS_STUB_RUN` so `rom_preload_done` can be forced high for structural tests.

## Task 5C bridge preload ingress stub

- A new bridge-side ingress stub module (`rom_preload_ingress_stub`) now accepts:
  - `clk`
  - `bridge_addr`
  - `bridge_wr`
  - `bridge_wr_data`
  - `bridge_rd`
- The ingress stub outputs preload write tokens to the local ROM service stub:
  - `preload_wr`
  - `preload_addr`
  - `preload_data`
  - `preload_commit`
  - `preload_active`
- In Task 5C mode (`ENABLE_PRELOAD_INGRESS_STUB = 1`), the bridge writes use a private debug register map:
  - `0x00000000`: set `preload_addr` from `bridge_wr_data[24:1]`
  - `0x00000004`: set `preload_data` from `bridge_wr_data[15:0]` and pulse `preload_wr`
  - `0x00000008`: pulse `preload_commit`
  - `0x0000000C`: set `preload_active = bridge_wr_data[0]`
- This is intentionally not final APF loading behavior; real APF data-slot/preload transport remains a future milestone.
- Runtime contract is unchanged: ROM reads remain serviced from preloaded local memory once implemented; per-read host streaming remains forbidden.

## Task 5D tiny local ROM RAM stub

- `rom_local_service_stub` now instantiates `rom_tiny_local_ram_stub` to add an optional tiny fabric RAM path for structural smoke testing.
- Parameters:
  - `ENABLE_TINY_LOCAL_ROM_RAM` (default `0`) enables/disables this path.
  - `ADDR_WORDS` is `1024` for this scaffold.
- Tiny RAM behavior:
  - defaults to inert (`rom_preload_done=0`, `rom_ready=0`, `rom_valid=0`, `rom_data=16'hFFFF`) when disabled.
  - when enabled, accepts `preload_wr` / `preload_addr` / `preload_data` writes and raises `rom_preload_done` on `preload_commit`.
  - runtime reads return local tiny-memory data from `rom_addr` with deterministic `rom_valid = rom_req & rom_ready`.
- This remains intentionally incomplete: 1024x16 is not enough for real ROM images and is used only for structural handshake verification.
- Difference from Task 5B fake mode:
  - fake mode still uses `ENABLE_GENESIS_STUB_RUN` and reports 16'hFFFF for every request,
  - tiny RAM mode is enabled only by `ENABLE_TINY_LOCAL_ROM_RAM` and serves writes to local storage.
- Host-per-read streaming from APF bridge/host remains forbidden.

## Task 5E compile/build wiring and smoke configs

- Additive documentation-only task: add source manifest and explicit smoke-test configurations.
- `apf/src/fpga/core/apf_scaffold_sources.f` tracks current scaffold files for build wiring.
- `docs/APF_SMOKE_TEST_CONFIGS.md` defines conservative task-scoped parameter sets.
- No configuration in this milestone is expected to boot real commercial Genesis ROMs.
- Task 5F is planned for minimal simulation/testbench coverage of ingress → service → tiny RAM path.

## Interface contract to implement in a future milestone

- Add a local-memory-backed ROM service layer that:
  - accepts preload write stream from APF interface,
  - exposes an internal read port aligned to Genesis ROM bus expectations,
  - drives `ROM_REQ`, `ROM_ACK`, `ROM_ADDR`, and `ROM_DATA` semantics from local memory only.
- During this milestone, these ports remain in a safe pass-through/stub state except for documented handshake points.

## Non-goals for this milestone

- Do not stream ROM from APF host on each ROM read.
- Do not add dynamic ROM paging or demand-fetch logic.
- Do not implement save states, SRAM emulation file export/import, or CD image loading.
- No full memory controller design yet; only define sequencing and signal ownership.

## Deterministic safety policy

- ROM must be treated as immutable after preload completion.
- If preload is incomplete, Genesis reset stays asserted (except explicit scaffold test mode).
- If local-memory path is unavailable, fail safe through existing stubs and keep ROM access inert.

## Notes for review

This document is the source of truth for the APF genesis-feasibility boot contract. Any future implementation should preserve this order and the no-streaming rule unless the milestone explicitly changes it.
