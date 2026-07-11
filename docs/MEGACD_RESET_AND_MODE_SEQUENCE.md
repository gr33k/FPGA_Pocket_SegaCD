# MegaCD reset and mode sequence

1. Pocket host reset asserted.
2. PLL lock must assert.
3. Genesis cartridge loader may run independently.
4. BIOS loader may run independently.
5. If no BIOS is present, Genesis-only mode remains available.
6. If BIOS is present, MegaCD mode is enabled.
7. Genesis reset releases once Pocket reset is clear and no active cart load is in progress.
8. MegaCD reset releases only after PLL lock and BIOS load complete.
9. No-disc service stub remains active after MegaCD reset release.
10. Debug register bank exposes lock/reset/mode/activity state.

The design must avoid permanent reset loops when no BIOS is loaded.
