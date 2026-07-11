# MegaCD Pocket capacity blocker

- final classification: `POCKET_MEMORY_CAPACITY_EXCEEDED`
- failed resource: `Total block memory bits`
- required: `3,523,686 bits`
- available: `3,153,920 bits`
- over capacity: `369,766 bits`
- failure type: `hard memory capacity limit during fit`
- supporting fitter error: `Error (11802): Can't fit design in device`

## Largest relevant hierarchy evidence

- `MCD:donor_mcd`: `2,792,096` memory bits in `ap_core.fit.rpt`
- `M68K_WRAP:S68K`: `39,584` memory bits in `ap_core.fit.rpt`
- inherited SignalTap / `sld_hub`: about `112` memory bits only, so it is not the primary blocker

## Source-level cause

The copied donor MegaCD lane keeps several large internal memories inside `src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd`:

- `WORDRAM0` internal `spram`
- `WORDRAM1` internal `spram`
- `CDC_RAM` internal `dpram_dif`
- `PCM_RAM` internal `dpram`
- `BRAM_*` internal sub-CPU / backup-style memory path

Program RAM is already pushed onto Pocket SDRAM, but the remaining internal MegaCD memories still push the design over the Pocket block-memory budget.

## Concrete next reduction

- externalize MegaCD internal RAMs in the repo-owned lane, starting with `WORDRAM0` and `WORDRAM1`
- next externalization targets after Word RAM: `CDC_RAM`, `PCM_RAM`, and the `BRAM_*` path
- keep Genesis baseline untouched on `main`
- rerun map and fit only after that memory refactor lands
