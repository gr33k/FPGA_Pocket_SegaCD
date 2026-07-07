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
