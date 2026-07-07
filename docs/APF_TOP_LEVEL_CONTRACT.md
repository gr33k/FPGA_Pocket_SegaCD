# APF Top-Level Contract (Task 4C)

## File
- `apf/src/fpga/core/core_top.v`

## Role
- This is the sole Pocket-facing top-level for this feasibility milestone.
- It instantiates [`apf_genesis_base.sv`](apf_genesis_base.sv) internally.

## Port contract (current skeleton)
- `clk_50`, `clk_74a`
  - APF clocks accepted by the top-level.
  - `clk_74a` is currently accepted but not used.
- `reset_n`
  - Stub reset input routed directly to the inner Genesis wrapper.
- Bridge interface
  - `bridge_sel`, `bridge_rd`, `bridge_wr`, `bridge_addr`, `bridge_wdata`
  - `bridge_ready`, `bridge_rdata`, `bridge_valid`
  - All bridge responses are stubbed for this milestone.
- Controller
  - `pad1_raw[11:0]` drives inner wrapper `pad1`.
  - `pad2_raw` is currently unused and tied off by `pad2_safety`.
- ROM preload
  - `rom_slot_*` signals are passed through from top-level to inner wrapper.
  - ROM arbitration/preload memory pipeline is intentionally not implemented.
- Outputs
  - `video_*` and `audio_left/audio_right` map directly from the wrapper.
- Unused APF pins
  - `apf_unused_*` and `apf_unused_flags` are tied to safe zero values.

## Explicit stubs
- Bridge logic is stubbed and returns deterministic defaults.
- Controller adapter is limited to a single 12-bit Genesis pad path.
- ROM preload is only a pass-through contract; no per-read host bus arbiter or local loader logic.
- No memory arbitration and no CD hardware are implemented.

## Safety guardrails
- Do not add Genesis behavior changes in this module.
- Do not introduce Sega CD / SVP / save-state logic in this task.
- Keep additional top-level behavior explicit as a stub until milestone sign-off.
