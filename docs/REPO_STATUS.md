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

- WORDRAM0 externalized to Pocket SRAM: `yes`
- WORDRAM1 remains internal: `yes`
- CDC RAM moved to MLAB: `yes`
- map result: `pass`
- fitter result: `pass`
- timing ran: `yes`
- assembler ran: `yes`
- valid artifact generated: `yes`
- BIOS probe staged: `yes`

## Exact fit/timing state

- logic utilization: `13,875 / 18,480 ( 75 % )`
- total block memory bits: `2,343,914 / 3,153,920 ( 74 % )`
- total block memory implementation bits: `3,153,920 / 3,153,920`
- M10K blocks: `308 / 308`
- M10K headroom: `0`
- worst setup slack: `0.487`
- worst hold slack: `0.170`
- artifact path: `build/megacd_pocket_artifacts/bitstream.rbf_r`
- staged Pocket folder: `build/pocket_sd_megacd_bios_probe/`
