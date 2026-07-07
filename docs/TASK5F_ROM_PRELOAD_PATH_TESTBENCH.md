# Task 5F: ROM preload path testbench

## What this testbench proves

This smoke-testbench verifies the scaffold-only preload pipeline without any full Genesis runtime:

- `rom_preload_ingress_stub` receives bridge debug writes.
- `rom_local_service_stub` consumes those writes.
- `rom_tiny_local_ram_stub` stores and serves readback data.
- `rom_req` + `rom_addr` handshake returns deterministic responses.

## What it does not prove

- It does not prove full cartridge timing against the full Genesis core.
- It does not prove save-state, SRAM, memory-controller arbitration, or menu/slot behavior.
- It does not prove real APF data-slot loading protocol behavior.
- It does not prove real Sega CD/CD support.

## Bridge debug writes mapping

In this scaffold, bridge writes drive temporary debug registers:

- `0x00000000` -> latch preload address into `preload_addr` (from `bridge_wr_data[24:1]` semantics).
- `0x00000004` -> latch preload data into `preload_data` and pulse `preload_wr`.
- `0x00000008` -> pulse `preload_commit`.
- (bridge `0x0000000C` also updates `preload_active`, but this path is not functionally checked in this test.)

The testbench specifically writes:
1. address 0 then data `0x1234`
2. address 2 then data `0xABCD`
3. commit

## preload_commit and rom_preload_done

When `preload_commit` pulses, the tiny local RAM stub marks preload complete.
Expected outcome in this test:

- `rom_preload_done == 1`
- `rom_ready == 1`

## Runtime read behavior checked

After commit, the testbench issues ROM-style reads:

- `rom_addr = 24'h00000000` with `rom_req` -> expects valid + `16'h1234`.
- `rom_addr = 24'h00000002` with `rom_req` -> expects valid + `16'hABCD`.

### Address interpretation note

The address buses here are `rom_addr[24:1]` and `preload_addr[24:1]`.
This is a byte-address-style value with bit 0 dropped by interface width.
So `24'h00000000` is word index 0 and `24'h00000002` is next word.

## Why this remains non-final

This testbench only confirms structural scaffolding and does not imply real game-ready cartridge support:
- tiny RAM is 1024x16 only,
- no real APF data-slot protocol,
- no real streaming loader,
- no external memory arbitration,
- no Sega CD or BIOS/image loading.

Host-per-read streaming from APF host is still forbidden in this scaffold.

## What Task 5G should do next

Task 5G should add a documented core_top-level smoke configuration flow so build systems can select:
- default inert mode,
- fake ROM mode,
- tiny local RAM smoke mode
without editing source by hand.
