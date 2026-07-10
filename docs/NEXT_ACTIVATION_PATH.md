# Next activation path after Task 8C-fix

## Current milestone status

- Package identity has been rebranded for this project:
  - `Cores/gr33k.SegaCD`
  - platform id: `gr33k_segacd`
  - `Platforms/gr33k_segacd.json`
  - displayed author: `Gr33k`
  - displayed name: `Sega CD`
- Current implementation is still Genesis only.
- Hardware state reported so far:
  - core loads on Pocket
  - core menu/settings work
  - Genesis ROM launch currently black screens
- No runtime correctness claim is made.

## Immediate next human action

- Retest the renamed package on Pocket so the console list reflects `Gr33k / Sega CD`.
- Use one known-good Genesis ROM only.
- Record the first exact result in this order:
  - core visible under new name
  - ROM browser opens
  - ROM selected
  - ROM load begins
  - video output / black screen
  - controls
  - audio

## If black screen persists

Use these docs first:
- `docs/GENESIS_RUNTIME_SMOKE_DEBUG_PLAN.md`
- `docs/GENESIS_BLACK_SCREEN_DEBUG_CHECKLIST.md`
- `docs/FIRST_GENESIS_BOOT_CANDIDATE_STATUS.md`
- `docs/FIRST_GENESIS_OPENFPGA_PACKAGE_STATUS.md`

Debug in this order:
- ROM load / preload completion
- reset release
- PLL lock
- CPU execution
- video / VDP activity
- audio activity
- input path
