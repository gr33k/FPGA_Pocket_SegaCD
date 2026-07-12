# MegaCD debug registers

## Existing registers

- `0x00E00004`: Core Status
- `0x00E00008`: Cartridge Bytes
- `0x00E0000C`: BIOS Bytes
- `0x00E00010`: Memory Flags
- `0x00E00014`: WordRAM Address
- `0x00E00018`: CDC Read Address
- `0x00E0001C`: CDC Write Address

## Added registers

- `0x00E00020`: Mode Flags
- `0x00E00024`: BIOS Last Addr
- `0x00E00028`: BIOS First Word
- `0x00E0002C`: BIOS Last Word

## Mode Flags bit layout

- bit 0: selected cartridge mode
- bit 1: selected BIOS mode
- bit 2: cartridge loading active
- bit 3: BIOS loading active
- bit 4: BIOS finalization pending
- bit 5: BIOS byte count exact
- bit 6: BIOS load complete
- bit 7: MegaCD mode enabled
- bit 8: CART ROM_MODE
- bit 9: MCD ENABLE
