# Task 5E: APF Smoke-Test Configurations

This document tracks conservative parameter settings for structural APF scaffold smoke testing.

> No configuration in this phase is expected to boot real commercial Genesis games.

## Config 1: Default inert scaffold

- `ENABLE_GENESIS_STUB_RUN = 0`
- `ENABLE_PRELOAD_INGRESS_STUB = 0`
- `ENABLE_FAKE_ROM_FOR_SMOKE_TEST = 0`
- `ENABLE_TINY_LOCAL_ROM_RAM = 0`

Expected behavior:
- Genesis remains held in reset by the 5A/5B shell.
- No fake ROM path is active.
- No preload storage path is active.
- Safest default for normal compile-checking and passive static verification.

## Config 2: Structural Genesis release only

- `ENABLE_GENESIS_STUB_RUN = 1`
- `ENABLE_PRELOAD_INGRESS_STUB = 0`
- `ENABLE_FAKE_ROM_FOR_SMOKE_TEST = 1` (if present/used)
- `ENABLE_TINY_LOCAL_ROM_RAM = 0`

Expected behavior:
- Allows core reset release for structural/smoke build checks only.
- ROM service returns inert fixed data (`16'hFFFF`).
- Runtime execution remains scaffold-only and is not suitable for real software playback.

## Config 3: Tiny local ROM RAM smoke test

- `ENABLE_GENESIS_STUB_RUN = 1`
- `ENABLE_PRELOAD_INGRESS_STUB = 1`
- `ENABLE_FAKE_ROM_FOR_SMOKE_TEST = 0`
- `ENABLE_TINY_LOCAL_ROM_RAM = 1`

Expected behavior:
- Debug bridge ingress can write `preload_addr`, `preload_data`, and pulse `preload_wr`/`preload_commit`.
- `preload_commit` marks preload done and gates reset release through `rom_preload_done`.
- `rom_tiny_local_ram_stub` services runtime ROM reads via preloaded tiny RAM entries.
- Still not real cartridge support; only a structural/test path.

## Cross-check summary

- All configs keep host-per-read ROM streaming disabled.
- No real APF data-slot copy transport is implemented in this phase.
- No Sega CD, no save support, no real memory controller are included.

- Parameter overrides should be applied via top-level build/simulation options (Task 5G flow).
- Task 5G introduces explicit `ENABLE_FAKE_ROM_FOR_SMOKE_TEST` override at `core_top` (instead of reusing `ENABLE_GENESIS_STUB_RUN`) for cleaner mode control.

## Next milestone

Task 5F should add a minimal simulation/sanity testbench for
`rom_preload_ingress_stub` -> `rom_local_service_stub` -> tiny local RAM runtime read path.
