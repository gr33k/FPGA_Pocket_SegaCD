# FPGA_Pocket_SegaCD repository status

Date: 2026-07-10

## Active branch

- branch: `feature/megacd-bringup`
- known-good Genesis baseline on `main`: `31b591e`
- Genesis baseline modified on this MegaCD branch: `no`

## MegaCD donor state

- donor submodule: `third_party/MegaCD_MiSTer`
- pinned donor commit: `b1a0f1f42710dd0678c8432fee886b2da836b48c`
- donor clean: `yes`
- Genesis_MiSTer reference clean: `yes`

## Current MegaCD probe result

- map result: `pass`
- fitter result: `POCKET_MEMORY_CAPACITY_EXCEEDED`
- timing ran: `no`
- assembler ran: `no`
- valid artifact generated: `no`
- BIOS probe staged: `no`

## Exact blocker

- block memory usage: `3,523,686 / 3,153,920 (112%)`
- memory overage: `369,766 bits`
- largest memory hierarchy from harvested fit report: `MCD:donor_mcd` at `2,792,096` bits
