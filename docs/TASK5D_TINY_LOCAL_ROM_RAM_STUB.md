# Task 5D: tiny local ROM RAM stub

## Purpose

Add an optional tiny, synthesizable local ROM RAM stub behind the existing ROM service boundary to enable structural smoke testing of ROM read/write handshake flow without real memory controller work.

## Why this exists

- It gives us a deterministic internal path from preload stream inputs to runtime reads.
- It verifies the `rom_addr`/`rom_req` -> `rom_ready`/`rom_valid` contract without APF host reads on each request.
- It keeps the scaffold conservative while preserving the long-term split between:
  - bridge ingress (`rom_preload_ingress_stub`)
  - runtime service (`rom_local_service_stub`)
  - real APF data-slot loader (future task).

## What this stub does

- New file: `apf/src/fpga/core/rom_tiny_local_ram_stub.v`
- Parameters:
  - `ENABLE_TINY_LOCAL_ROM_RAM` (default `0`)
  - `ADDR_WORDS` (default `1024`)
- 16-bit word storage in a small array.
- Inputs:
  - `clk`
  - `preload_wr`
  - `preload_addr[24:1]`
  - `preload_data[15:0]`
  - `preload_commit`
  - `rom_addr[24:1]`
  - `rom_req`
- Outputs:
  - `rom_data[15:0]`
  - `rom_valid`
  - `rom_ready`
  - `rom_preload_done`

### Behavior

- Disabled (`ENABLE_TINY_LOCAL_ROM_RAM = 0`):
  - `rom_ready = 0`
  - `rom_valid = 0`
  - `rom_data = 16'hFFFF`
  - `rom_preload_done = 0`
- Enabled (`ENABLE_TINY_LOCAL_ROM_RAM = 1`):
  - `preload_wr` writes `preload_data` to tiny local memory.
  - `preload_commit` marks `rom_preload_done = 1`.
  - `rom_ready = rom_preload_done`.
  - `rom_valid = rom_req && rom_ready`.
  - `rom_data` is returned from local RAM using `rom_addr`.

## Why this is not final cartridge ROM

- Capacity is tiny (`ADDR_WORDS = 1024` words) and not capable of real Genesis ROM images.
- No bank switching, no SRAM integration, no real DMA/preload scheduler, and no external memory arbitration.
- The module is for scaffold and smoke-test only.

## How it connects

- `rom_local_service_stub` now instantiates `rom_tiny_local_ram_stub`.
- `core_top` passes `ENABLE_TINY_LOCAL_ROM_RAM` through to `rom_local_service_stub`.
- `rom_preload_ingress_stub` remains the bridge-side injector for `preload_*` signals.

## Host-per-read streaming rule

- Even in this task, runtime ROM bytes are not streamed from APF host on demand.
- `rom_req` reads come from local service output; host writes only occur through preload path and only by design in this scaffold.

## Remaining stubs

- `rom_preload` is still a temporary bridge register path, not official data-slot loader.
- `rom_local_service_stub` fake smoke mode (`ENABLE_GENESIS_STUB_RUN`) remains available and separate from tiny RAM mode.
- `bridge_rd_data` remains deterministic zero.
- No save states, no cartridge SRAM emulation, no Sega CD/bus/memory hardware is introduced.

## Next milestone

Task 5E should add a compile/smoke-test configuration document and build-file wiring checklist so the new stub files are included cleanly in APF project/synthesis flows.
