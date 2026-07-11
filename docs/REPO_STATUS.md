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
- map result: `pass`
- fitter result: `POCKET_MEMORY_CAPACITY_EXCEEDED_AFTER_WORDRAM0`
- timing ran: `no`
- assembler ran: `no`
- valid artifact generated: `no`
- BIOS probe staged: `no`

## Exact blocker

- block memory bits: `2,475,110 / 3,153,920 (78%)`
- block memory implementation bits: `3,328,000 / 3,153,920 (106%)`
- M10K blocks: `325 / 308 (106%)`
- M10K overage: `17`
- MCD hierarchy memory after WORDRAM0 move: `1,743,520 bits`
