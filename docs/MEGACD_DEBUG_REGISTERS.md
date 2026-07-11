# MegaCD debug registers

Bridge debug region: `0x00E00000`

- `0x00E00000`: region / mode summary
- `0x00E00004`:
  - bit0 PLL locked
  - bit1 host reset released
  - bit2 BIOS present
  - bit3 BIOS loading
  - bit4 MegaCD mode enabled
  - bit5 Genesis reset released
  - bit6 MCD reset released
  - bit7 Genesis CPU activity seen
  - bit8 sub-68000 / PRG activity seen
  - bit9 CDD command activity seen
- `0x00E00008`: cartridge byte count seen by loader
- `0x00E0000C`: BIOS byte count seen by loader
