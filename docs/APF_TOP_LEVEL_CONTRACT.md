# APF Top-Level Contract (Task 4G)

## File
- `apf/src/fpga/core/core_top.v`

## Role
- This is the sole Pocket-facing top-level for the Genesis-only APF feasibility milestone.
- It now matches the openFPGA template style ports and keeps non-implemented subsystems stubbed.
- It instantiates [`apf_genesis_base.sv`](apf_genesis_base.sv) internally.

## Port contract (current skeleton)
- `clk_74a`, `clk_74b`
  - Primary APF clocks.
  - `clk_74a` is the base clock used for deterministic stubs and base runtime clocking.
- Reset
  - `reset_n` is passed into the internal Genesis base.
- Cartridge / link / IR
  - Presence pins are present to match template shape and are tied/stubbed in this milestone.
- Memory buses
  - `cram0_*`, `cram1_*`
  - `dram_*`
  - `sram_*`
  - Memory pins are held in a deterministic off state.
- Video / audio ports
  - `video_rgb`, `video_rgb_clock`, `video_rgb_clock_90`, `video_de`, `video_skip`, `video_vs`, `video_hs`
  - `audio_mclk`, `audio_adc`, `audio_dac`, `audio_lrck`
  - Video is raw Genesis passthrough from the core wrapper; audio serialization remains stubbed/silent.
- Bridge
  - `bridge_addr`, `bridge_rd`, `bridge_rd_data`, `bridge_wr`, `bridge_wr_data`
  - `bridge_endian_little`
  - All bridge reads/writes are stubbed.
- Controller
  - `cont1_key/cont1_joy/cont1_trig` map to one Genesis pad.
  - `cont2_*`, `cont3_*`, `cont4_*` are accepted and held safe as deferred paths.

## Explicit stubs
- Bridge transactions are stubbed and return deterministic defaults.
- ROM preload and memory arbitration are deferred (no on-demand host ROM reads on runtime). ROM signals are currently stubbed for `apf_genesis_base`.
- Cartridge/link/IR physical behavior is stubbed.
- Audio serialization to I2S is intentionally silent in this milestone.
- No Sega CD, no 32X, no save-state behavior, no memory-controller arbitration.

## Safety guardrails
- No change to imported Genesis runtime RTL behavior.
- No Sega CD logic introduced.
- No memory controller and no real ROM loader yet.
- Unused hardware pins are tied in a deterministic, safe way.
