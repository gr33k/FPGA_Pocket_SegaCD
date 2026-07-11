# MegaCD debug registers

- `0x00E00000`: MegaCD probe signature
- `0x00E00004`: baseline MegaCD status flags
- `0x00E00008`: Genesis cart bytes seen
- `0x00E0000C`: BIOS bytes seen
- `0x00E00010`: Word RAM externalization flags
  - bit 4: sub-68000 activity seen
  - bit 3: MCD reset released
  - bit 2: external Word RAM implementation enabled
  - bit 1: external Word RAM write seen
  - bit 0: external Word RAM read/non-write phase seen
- `0x00E00014`: last external Word RAM address sampled
