# Task 5C: APF bridge preload ingress stub

## Purpose

Task 5C adds a structural ingress path that can feed `rom_local_service_stub` preload inputs from the APF bridge interface without implementing real data-slot loading yet.

## Why this stub exists

- It creates a narrow, explicit seam for future preload flow before implementing a real APF data-slot copy engine.
- It allows local ROM service wiring and reset gating to be exercised without modifying imported Genesis runtime behavior.
- It preserves the safety rule that runtime ROM fetches must not be sourced directly from APF host reads.

## Temporary debug register map

This is scaffold/debug behavior only and must be replaced by real APF loading flow later:

- `bridge_wr` to `0x00000000`:
  - latches `preload_addr` from `bridge_wr_data[24:1]`
- `bridge_wr` to `0x00000004`:
  - latches `preload_data` from `bridge_wr_data[15:0]`
  - pulses `preload_wr` for one clock
- `bridge_wr` to `0x00000008`:
  - pulses `preload_commit` for one clock
- `bridge_wr` to `0x0000000C`:
  - writes `preload_active = bridge_wr_data[0]`

Default (`ENABLE_PRELOAD_INGRESS_STUB=0`) keeps outputs inert:
- `preload_wr = 0`
- `preload_addr = 0`
- `preload_data = 0`
- `preload_commit = 0`
- `preload_active = 0`

## Connection to Task 5B

- `core_top` instantiates:
  - `rom_preload_ingress_stub` (bridge side)
  - `rom_local_service_stub` (runtime side)
- `rom_preload_ingress_stub` outputs are directly wired into `rom_local_service_stub`:
  - `preload_wr` → `preload_wr`
  - `preload_addr` → `preload_addr`
  - `preload_data` → `preload_data`
  - `preload_commit` → `preload_commit`
- `core_top` continues to use `rom_preload_done` from `rom_local_service_stub` for FSM gating.

## Why host-per-read streaming is still forbidden

- The task scope does not permit fetching ROM bytes from APF host on every runtime ROM request.
- The bridge ingress is only a debug loader lane for future local preload, and is intentionally not coupled to ROM runtime reads.
- `rom_local_service_stub` still defaults to inert behavior unless smoke mode is explicitly enabled.

## Next step: Task 5D

- Add an inert compile-time local ROM RAM stub / fake memory module to consume preload writes structurally and return deterministic read data during scaffold testing.
