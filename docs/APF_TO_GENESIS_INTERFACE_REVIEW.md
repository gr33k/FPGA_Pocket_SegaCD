# APF-to-Genesis Runtime Interface Review (Task 6M)

## Scope
Review of the interface between:
- `apf/src/fpga/core/core_top.v` -> `apf/apf_genesis_base.sv`
- `apf/apf_genesis_base.sv` -> `third_party/Genesis_MiSTer/rtl/system.sv`

## 1) `system.sv` ports (entrypoint summary)
- Control/reset: `RESET_N`, `MCLK`
- Video outputs: `RED`,`GREEN`,`BLUE`,`VS`,`HS`,`HBL`,`VBL`,`CE_PIX`,`INTERLACE`,`FIELD`,`RESOLUTION`
- Audio outputs: `DAC_LDATA`,`DAC_RDATA`
- ROM path: `ROM_ADDR`,`ROM_DATA`,`ROM_WDATA`,`ROM_WE`,`ROM_BE`,`ROM_REQ`,`ROM_ACK`, plus `ROMSZ`
- Second ROM path: `ROM_ADDR2`,`ROM_DATA2`,`ROM_REQ2`,`ROM_ACK2`
- Input: `JOY_1..JOY_5`,`MULTITAP`,`MOUSE`(25b),`MOUSE_OPT`,`GUN_*`,`SERJOYSTICK_*`,`SER_OPT`
- Config: `LPF_MODE`,`ENABLE_FM`,`ENABLE_PSG`,`LOADING`,`PAL`,`EXPORT`,`FAST_FIFO`, quirks
- Debug: `DBG_M68K_A`,`DBG_VBUS_A`

## 2) APF wrapper signals currently provided
### `core_top.v` -> `apf_genesis_base`
- `clk_74a` maps to `clk_50`
- `core_reset_n` maps to `reset_n`
- ROM/romslot signals: `rom_slot_addr`,`rom_slot_req`,`rom_slot_ready`,`rom_slot_data`,`rom_slot_valid`
- Controller: `pad1` (12 bits)
- Video: `video_r/g/b`,`video_hsync`,`video_vsync`,`video_de`
- Audio: `audio_left`,`audio_right`

### `apf_genesis_base` -> `system`
- `RESET_N`: directly `reset_n`
- `MCLK`: directly `clk_50`
- `LOADING`: `~rom_slot_ready`
- `ROM_ADDR`: from `rom_slot_addr`
- `ROM_DATA`: `rom_slot_data`
- `ROM_REQ`: `rom_req`
- `ROM_ACK`: `rom_slot_req && rom_slot_valid`
- `ROM_ADDR2`: tied `24'h000000`
- `ROM_REQ2`: `1'b0`
- `ROM_ACK2`: `1'b0`
- `ROM_DATA2`: `16'hFFFF`
- `BRAM`: address/data/we/ack tied through local wires
- `PAL`, `EXPORT`, `FAST_FIFO`: fixed 0
- `LPF_MODE`,`ENABLE_FM`,`ENABLE_PSG`: fixed values
- `ROMSZ` placeholder set to `24'h400000`
- Joy: `JOY_1 = pad1`; JOY_2..JOY_5 fixed 0
- `MOUSE` width mapped to 25-bit zero vector
- `SERJOYSTICK_IN` zeroed
- `GUN` inputs all zeroed
- `TRANSP_DETECT` left unconnected
- `PAUSE_EN`,`BGA_EN`,`BGB_EN`,`SPR_EN` tied low
- debug outputs (`DBG_*`) consumed to internal wires only

## 3) Connected vs unconnected summary
### Connected and expected
- Core reset/clocks
- Base video and audio feed-through
- ROM channel 0 (single-slot data path)
- Game Genie/cheat path enabled but fixed off (`GG_*` low)
- Primary I/O quirk inputs set to static defaults

### Unconnected / stubbed
- ROM channel 2 path is effectively disabled.
- `TRANSP_DETECT` unconnected (system output ignored).
- `SERJOYSTICK_*` path is stubbed.
- `MOUSE` input is hard-zeroed.
- `BRAM_CHANGE` only wired from local SRAM mux, no cartridge-side BRAM manager.
- `ROMSZ` placeholder, not true cartridge size.

## 4) Reset behavior
- `system` expects `RESET_N` and uses `LOADING` to drive internal reset.
- Wrapper currently gates `loading = ~rom_slot_ready`.
- With no ROM preload completion, wrapper-side preload logic intentionally holds core reset until active reset policy allows.

## 5) ROM request/ack path review
- `system` asserts `ROM_REQ` and expects `ROM_ACK` from runtime memory.
- Wrapper currently uses:
  - `ROM_ACK = rom_slot_req && rom_slot_valid`
  - `rom_slot_data` from `rom_slot_data` wire
  - No local prefetch engine in wrapper; this is handled by `rom_local_service_stub` upstream
- Address line widths match `system` (`[24:1]`) at wrapper boundary.

## 6) Video/audio mapping
- `system` outputs 4-bit RGB + sync/de; wrapper expands to 8-bit `video_rgb` as replicate
- `video_de = ~HBL & ~VBL & CE_PIX`
- Audio (`DAC_LDATA/DAC_RDATA`) passed to APF audio pins without codec adaptation in this milestone.

## 7) Controller mapping review
- One Genesis pad only (`pad1`).
- D-pad and A/B/C/Start mapped with `cont1_key`/`cont1_trig` in `core_top`.
- Remaining buttons (`Mode/X/Y/Z`) currently deferred.

## 8) Interface risks and blockers
- Mouse/GUN/serial joystick inputs are stubbed and not truly wired.
- `ROMSZ` is a local placeholder, not ROM-image-driven.
- `ROM_ADDR2`/SVP SRAM path is disabled in wrapper.
- Mixed-language dependency (`vdp`, `T80`, `SVP`, BRAM memory cells) unresolved for purely Verilog lint/probe.
- Candidate runtime files are not yet active in Quartus.

## 9) Recommended next wrapper edits (Task 6N)
- Keep `apf_genesis_base` behavior unless interface contract changes
- Add explicit local comments for placeholder values (`rom_size`, ROM2 disablement, quirks)
- Gate future real `rom_slot_ready` source from real preload-complete indicator only
- Keep mixed-language/runtime scope decisions in Task 6N+ tasks
