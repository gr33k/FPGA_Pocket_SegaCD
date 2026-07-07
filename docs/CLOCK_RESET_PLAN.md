# Clock & Reset Plan

## Scope
Conservative reset-order definition for this feasibility milestone. No imported-runtime behavior changes and no ROM preload controller yet.

## Required reset order

1. APF reset asserted
2. PLL lock
3. ROM preload complete
4. Genesis reset released

## Current scaffold behavior

- This milestone introduces a conservative reset gate in `core_top` before `apf_genesis_base`.
- Reset state sequence is:
  1. `WAIT_APF_RESET_RELEASE`
  2. `WAIT_PLL_LOCK`
  3. `WAIT_ROM_PRELOAD`
  4. `RUN`
- In normal scaffold mode (`ENABLE_GENESIS_STUB_RUN = 0`), `rom_preload_done` remains false and the core remains held in reset.
- In smoke-test mode (`ENABLE_GENESIS_STUB_RUN = 1`), the FSM allows transition into `RUN` without the stubbed preload gate.
- `rom_slot_*` signals and preload arbitration remain stubs; runtime remains deterministic until preload architecture is implemented.

## Stubbed / deferred in this task

- No on-demand ROM streaming from host bridge on every read.
- No memory controller implementation.
- ROM preload state machine is present as a conservative gate; real preload completion signal is still stubbed.
- No save-state restore timing.
- No additional clock domains beyond existing `clk_74a`/`clk_74b` baseline.

## Next milestone transition (Task 5)

- Add explicit ROM preload complete handshake.
- Gate core reset release on: APF reset deassertion, PLL lock, and preload complete.
- Keep deterministic behavior when preload stalls or fails.
- Keep Genesis base behavior unchanged while layering the state machine outside it.
