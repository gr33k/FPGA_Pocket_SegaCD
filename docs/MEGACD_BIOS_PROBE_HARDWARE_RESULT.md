# MegaCD BIOS probe hardware result

- classification: BIOS_FETCH_OR_MODE_MUX_FAILURE
- APF package is visible and operational: yes
- BIOS browser and transfer progress work: yes
- FPGA core settings remain operational: yes
- BIOS execution is not correct: yes
- cartridge execution is not correct while the current BIOS probe mode is active: yes
- source review found a mismatched BIOS SDRAM write address: yes
- source review found cartridge ROM mode forced active during BIOS mode: yes

## Observed hardware behavior

- probe core appears beneath Genesis
- Core Settings remains accessible
- BIOS browser appears
- bios_CD_U.bin loads with a visible progress bar
- first BIOS attempt produced a black screen
- later BIOS attempts produced a solid red screen
- one cartridge reached a Sega logo but did not finish booting
- Sonic the Hedgehog produced a solid red screen
- some cartridges produced black screens
- some produced red screens with scanline-like corruption or flashing
- Pocket core menu remained accessible
- no full Sega CD BIOS screen appeared
- no-disc screen did not appear
- no successful Genesis regression occurred in this probe build
