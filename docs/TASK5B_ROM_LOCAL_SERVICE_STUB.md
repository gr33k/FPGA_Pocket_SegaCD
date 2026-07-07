# Task 5B: ROM local service stub

## Purpose

Task 5B introduces a dedicated local ROM service module to separate:

1. `apf`-facing preload path (future APF data-slot copy), and
2. Genesis runtime ROM fetch semantics (`rom_addr` / `rom_req` / `rom_ready` / `rom_data` / `rom_valid`).

This avoids a direct and unsafe coupling of ROM bus reads to APF host fetch operations.

## Why this module exists

- It enforces a clean seam for the future memory-local preload architecture.
- It keeps imported Genesis runtime untouched while allowing a conservative scaffold.
- It provides deterministic behavior for structural compile/smoke checks without requiring full memory logic.

## Current behavior (Task 5B milestone)

- `rom_local_service_stub` is instantiated in `core_top`.
- All runtime ROM request outputs are inert by default:
  - `rom_preload_done = 1'b0`
  - `rom_ready = 1'b0`
  - `rom_valid = 1'b0`
  - `rom_data = 16'hFFFF`
- `preload_wr`, `preload_addr`, `preload_data`, `preload_commit` inputs are present for future wiring but currently have no storage behavior.
- When `ENABLE_FAKE_ROM_FOR_SMOKE_TEST` is set, the module reports:
  - `rom_preload_done = 1'b1`
  - `rom_ready = 1'b1`
  - `rom_valid = rom_req`
  - `rom_data = 16'hFFFF`
- In this repo, `ENABLE_FAKE_ROM_FOR_SMOKE_TEST` is tied to `ENABLE_GENESIS_STUB_RUN` from `core_top` for controlled smoke behavior.

## Inert preload write path (future)

- Inputs reserved: `preload_wr`, `preload_addr[24:1]`, `preload_data[15:0]`, `preload_commit`.
- Planned behavior in later task:
  - Write phase stores ROM bytes into local memory (SRAM/PSRAM/other local store).
  - `rom_preload_done` asserts once copy is complete.
  - Runtime reads begin from this local storage.

## Future local read path (future)

- Planned behavior:
  - On `rom_req`, service local memory at `rom_addr`.
  - Assert `rom_ready` consistently when storage can accept/supply the request.
  - Return `rom_data` and pulse `rom_valid` according to memory timing contract.
  - Keep deterministic timing so runtime expectations are satisfied.

## No host-per-read streaming rule

- ROM reads from runtime must **not** request data directly from APF host/bridge in this scaffold.
- All ROM bytes must come from preloaded local storage once implemented.
- This requirement is reflected in `docs/ROM_PRELOAD_MEMORY_PLAN.md` and the current stub default behavior.

## Relationship to Task 5A reset FSM

- Task 5A defines reset hold sequence in `core_top`:
  - WAIT_APF_RESET_RELEASE → WAIT_PLL_LOCK → WAIT_ROM_PRELOAD → RUN.
- Task 5B routes `rom_preload_done` from this stub into that FSM.
- With default parameters, `rom_preload_done` is false so core remains in reset.
- When smoke mode is explicitly enabled, this preloaded flag is forced true for structural/run-only validation.
