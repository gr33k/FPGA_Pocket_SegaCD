# MegaCD APF disc service next step

First real disc milestone after BIOS probe:

- one deferred APF disc slot
- single-track raw BIN
- 2352-byte sectors unless source review forces a different size
- no CUE parser initially
- no audio tracks
- no CHD
- bridge-side LBA request FSM
- target-command read or deferred data read path
- sector FIFO feeding donor CDC write strobes
- eject / reload handling
