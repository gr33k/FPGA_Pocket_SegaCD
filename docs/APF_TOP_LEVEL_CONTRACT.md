# APF Top-Level Contract (Task 4H)

## File
- `apf/src/fpga/core/core_top.v`

## Role
- This is the sole Pocket-facing top-level for the Genesis-only APF feasibility milestone.
- It uses official openFPGA top-level ports from the core template and keeps non-implemented subsystems stubbed.
- `apf_genesis_base.sv` is instantiated internally only.

## Port contract (current skeleton)
- `clk_74a`, `clk_74b`
  - APF clocks.
- Cartridge/logic-level interface (official template style)
  - `cart_tran_bank0`, `cart_tran_bank0_dir`
  - `cart_tran_bank1`, `cart_tran_bank1_dir`
  - `cart_tran_bank2`, `cart_tran_bank2_dir`
  - `cart_tran_bank3`, `cart_tran_bank3_dir`
  - `cart_tran_pin30`, `cart_tran_pin30_dir`
  - `cart_pin30_pwroff_reset`
  - `cart_tran_pin31`, `cart_tran_pin31_dir`
  - `port_tran_si`, `port_tran_si_dir`
  - `port_tran_so`, `port_tran_so_dir`
  - `port_tran_sck`, `port_tran_sck_dir`
  - `port_tran_sd`, `port_tran_sd_dir`
- RFU pins
  - `vblank`, `user1`, `user2`, `vpll_feed`
  - `port_ir_rx`, `port_ir_tx`, `port_ir_rx_disable`
  - `aux_sda`, `aux_scl`
- Video / audio
  - `video_rgb`, `video_rgb_clock`, `video_rgb_clock_90`, `video_de`, `video_skip`, `video_vs`, `video_hs`
  - `audio_mclk`, `audio_adc`, `audio_dac`, `audio_lrck`
- Bridge
  - `bridge_addr`, `bridge_rd`, `bridge_rd_data`, `bridge_wr`, `bridge_wr_data`, `bridge_endian_little`
  - Bridge reads return zero in this milestone.
- Memory buses
  - `cram0_*`, `cram1_*`, `dram_*`, `sram_*`
  - Data buses `cram0_dq`, `cram1_dq`, `dram_dq`, `sram_dq` are currently high-Z while this memory tier is deferred.
- Controller
  - `cont1_key`, `cont1_joy`, `cont1_trig` map to the Genesis pad (`pad1`).
  - `cont2_*`, `cont3_*`, `cont4_*` are held safe but otherwise deferred.

## Reset behavior
- No top-level reset port is exposed.
- This milestone uses an internal stub reset (`core_reset_n`) inside `core_top`.
- Final APF reset sequencing is deferred to later tasks.

## Explicit stubs
- `rom_local_service_stub` sits between `core_top` and `apf_genesis_base`:
  - no real ROM preload storage is implemented yet,
  - ROM data/ready/valid are inert until preload is available,
  - `ENABLE_GENESIS_STUB_RUN=1` enables conservative smoke-mode fake responses.
- Bridge transactions are stubbed and return deterministic defaults.
- ROM preload and memory arbitration are deferred.
- Cartridge/link/IR behavior is stubbed with template-safe defaults.
- Audio serialization to Pocket is intentionally silent/dummy.
- No Sega CD, no 32X, no save-state behavior, no real memory controller.

## Safety guardrails
- No change to imported Genesis runtime RTL behavior.
- No Sega CD logic introduced.
- Unused hardware pins are tied deterministically (including explicit high-Z on inout memory buses).
