# Clock & Reset Plan

## Scope
Conservative reset-order definition for this feasibility milestone. No imported-runtime behavior changes and no ROM preload controller yet.

## Required reset order

1. APF reset asserted
2. PLL lock
3. ROM preload complete
4. Genesis reset released

## Current scaffold behavior

- This milestone keeps reset behavior explicit and conservative in the APF shell.
- `reset_n` is passed through to the internal Genesis base wrapper.
- `rom_slot_*` and preload arbitration are still stubs; this means runtime remains in deterministic startup-safe behavior until preload architecture is implemented.

## Stubbed / deferred in this task

- No on-demand ROM streaming from host bridge on every read.
- No memory controller implementation.
- No ROM preloading state machine in top-level logic yet.
- No save-state restore timing.
- No additional clock domains beyond existing `clk_74a`/`clk_74b` baseline.

## Next milestone transition (Task 5)

- Add explicit ROM preload complete handshake.
- Gate core reset release on: APF reset deassertion, PLL lock, and preload complete.
- Keep deterministic behavior when preload stalls or fails.
- Keep Genesis base behavior unchanged while layering the state machine outside it.
