# MegaCD Pocket memory map

## Genesis side

- Cartridge ROM: Pocket SDRAM
- Genesis work RAM: Pocket SDRAM
- Cartridge save RAM: Pocket SDRAM for first probe

## MegaCD side

- BIOS ROM: Pocket SDRAM, bridge-loaded user asset
- Program RAM: Pocket SDRAM banks 2/3 using donor-style mapping
- Word RAM: donor BRAM path retained for first probe
- backup RAM: donor BRAM path retained for first probe
- CDC RAM: donor BRAM path retained for first probe
- PCM RAM: donor internal RAM path retained for first probe
- sector FIFO: no-disc stub only in this milestone
- command / status registers: donor `MCD` logic

## Probe notes

The first probe avoids silently moving latency-sensitive donor RAM into slower interfaces.
Only BIOS ROM and large cartridge/program memory are mapped onto Pocket SDRAM in the initial lane.
