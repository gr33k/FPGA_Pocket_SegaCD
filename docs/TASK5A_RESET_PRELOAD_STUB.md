# Task 5A Reset + ROM Preload Stub

## Objective
Introduce a conservative reset/preload state-machine shell in `apf/src/fpga/core/core_top.v` that gates `apf_genesis_base` reset without implementing real APF data-slot copy or memory arbitration.

## Scope constraints
- No Sega CD logic.
- No real memory arbitration.
- No APF data-slot copy implementation yet.
- No imported Genesis RTL behavior changes.

## Implementation notes
- Added module parameter:
  - `parameter ENABLE_GENESIS_STUB_RUN = 0`
- Added FSM states (state enum constants):
  1. `WAIT_APF_RESET_RELEASE`
  2. `WAIT_PLL_LOCK`
  3. `WAIT_ROM_PRELOAD`
  4. `RUN`
- Stub signals:
  - `pll_locked_stub = 1'b1`
  - `rom_preload_done_stub = 1'b0`
  - `rom_preload_done = ENABLE_GENESIS_STUB_RUN ? 1'b1 : rom_preload_done_stub`
- `core_reset_n` is now derived from FSM reachability to `RUN` and passed to `apf_genesis_base`.

## Behavior
- Default mode (`ENABLE_GENESIS_STUB_RUN = 0`):
  - FSM remains in preload wait because `rom_preload_done_stub` is false.
  - `core_reset_n` remains deasserted (Genesis held in reset).
- Smoke-test mode (`ENABLE_GENESIS_STUB_RUN = 1`):
  - FSM allows transition to `RUN` to permit structural verification.

## Deferred work (unchanged)
- Real APF reset source wire-up.
- Real PLL lock source integration.
- Real ROM preload completion signal/loader implementation.
- Any real bridge/data-slot or memory-controller driven ROM service.
