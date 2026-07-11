# MegaCD Pocket port architecture

## Chosen strategy

`FULL_DONOR_GEN_PLUS_MCD_PORT`

## Reason

The donor `gen` module exposes the Genesis expansion-bus signals required by donor `MCD`:

- address bus
- data in / data out
- read / write
- upper / lower strobes
- address strobe
- DTACK
- address select
- VCLK enable
- RAS2
- ROM select
- FDC select

The existing Pocket `system.sv` is a Genesis-only wrapper that hides those internals and must not be mixed with donor `gen` in the same active design.

## Genesis donor subsystem

From donor `gen.sv` and related GEN qip:

- main 68000
- Z80 / T80
- VDP
- YM2612 / JT12
- PSG / JT89
- cartridge interface
- Genesis expansion-bus interface

## MegaCD donor subsystem

From donor `MCD.vhd` and related MCD qip:

- second 68000
- Sega CD ASIC / gate array
- Program RAM interface
- Word RAM / BRAM blocks
- BIOS ROM interface
- backup RAM / BRAM path
- CDC
- CDC RAM
- PCM
- PCM RAM
- CDDA path
- CDD command / status interface

## MiSTer-only pieces excluded

- `emu`
- `hps_io`
- MiSTer menu config string
- MiSTer video scaler path
- MiSTer controller wrapper
- MiSTer DDR / HPS wrapper path
- donor `hps_ext.v` as active CD service

## Pocket replacements retained

- `apf_top`
- `core_bridge_cmd`
- Pocket bridge bus
- APF data-slot loaders
- Pocket SDRAM physical interface
- Pocket video output shell
- Pocket I2S audio shell
- Pocket controller inputs

## Active design rule

Do not instantiate both Pocket `system` and donor `gen` in the active MegaCD lane.
Do not create duplicate Genesis CPUs, duplicate VDPs, or duplicate FM/PSG paths.

## First probe scope

- Preserve Genesis cartridge operation path
- Add optional BIOS loader slot
- Instantiate donor `MCD`
- Replace donor `hps_ext` with a Pocket no-disc service stub
- No disc-sector streaming yet
- No CUE, CHD, CDDA streaming, or 32X
