# Clock & Reset Plan

## Scope
Conservative reset-order definition for the Genesis-only APF feasibility phase. This plan does not alter Genesis runtime behavior and does not implement clock manager logic beyond explicit ordering expectations.

## Reset order (required)

1. APF reset asserted
2. PLL lock
3. ROM preload complete
4. Genesis reset released

## Signal-level expectation

- `pll_lock` must be observed before entering ROM-load complete wait state exit.
- `rom_preload_done` is the gating condition for releasing core reset.
- Genesis `reset_n` (or equivalent active-low release) must not assert to runtime until all three conditions are true:
  - APF reset deasserted
  - PLL lock achieved
  - ROM preload complete

## Conservative implementation notes

- Maintain a synchronous reset synchronizer in the APF-facing top logic for all clocks in use.
- Keep reset generation explicit, with named intermediate states for safety/debug:
  - `WAIT_APF_RESET_RELEASE`
  - `WAIT_PLL_LOCK`
  - `WAIT_ROM_PRELOAD`
  - `RUN`
- During non-`RUN` states, keep ROM fetch paths quiescent to avoid invalid ROM transactions.
- If this conservative state machine stalls in `WAIT_ROM_PRELOAD` past expected timeout, keep output channels inert and expose deterministic defaults.

## Do not do in this milestone

- Do not stream ROM from APF host on demand.
- Do not add memory controller arbitration yet.
- Do not add save-state restore timing or CD reset coordination.
- Do not change non-APF runtime reset behavior of imported Genesis modules.

## Future handoff for Task 4F+

When implementing preloader/controller memory plumbing:
- Replace the current stub reset release logic with the above state sequencing.
- Assert/deassert all dependent output enables only after entering `RUN`.
- Keep this order stable unless explicitly superseded by later architecture decisions.
