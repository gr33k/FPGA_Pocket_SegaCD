# ROM Preload & Local Memory Plan

## Milestone scope
This milestone defines only the ROM preload and local-memory interface contract for the APF feasibility port. It does **not** implement a memory controller, any memory DMA engine, or streaming ROM behavior from host on demand.

## Target behavior (skeleton)

APF data slot ROM bytes are loaded once during startup into on-device local storage, then reused for runtime ROM reads.

## Data flow

1. APF firmware places ROM bytes into the APF data slot interface.
2. Pocket-side loader path copies ROM payload into local storage (SRAM/PSRAM/other local memory).
3. Preload complete signal indicates local memory contains the ROM image.
4. Runtime reset is held until preload complete.
5. Genesis core begins operation with:
   - `ROM_REQ` / `ROM_ACK` handled from local memory only.
   - no per-read host bus requests.

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
- If preload incomplete, Genesis reset stays asserted and runtime ROM fetch remains disabled/invalid.
- If local-memory path is unavailable, fail safe through existing stubs and keep ROM access inert.

## Notes for review

This document is the source of truth for the first APF-genesis-feasibility boot contract. Any future implementation should preserve this order and the no-streaming rule unless the milestone explicitly changes. 
