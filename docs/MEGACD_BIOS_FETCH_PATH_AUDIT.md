# MegaCD BIOS fetch path audit

## BIOS write path defect

- current defective BIOS write expression: `{8'b01111000, bios_ioctl_addr[17:1]}`
- effective width before fix: 25 bits
- destination width: 24 bits
- corrected BIOS write expression: `{8'b01111000, bios_ioctl_addr[16:1]}`
- corrected width: 24 bits
- expected word-address range: `0x780000` through `0x78FFFF`
- expected byte-address range: `0xF00000` through `0xF1FFFE`
- BIOS read expression: `{8'b01111000, GEN_VA[16:1]}`
- conclusion: corrected BIOS writes and BIOS reads target the same SDRAM region

## Cartridge-versus-BIOS mode defect

- previous CART ROM mode behavior: permanently forced active with `.ROM_MODE(1'b1)`
- impact during BIOS mode: cartridge ROM could continue to claim Genesis ROM space
- required correction: explicit synchronized mode selection so BIOS mode disables cartridge ROM ownership and MegaCD mode only enables after a complete 131072-byte BIOS transfer
