# MegaCD WORDRAM0 externalization plan

- move only `WORDRAM0` to Pocket external SRAM
- keep `WORDRAM1` internal block RAM
- expected reclaimed internal memory: `1,048,576 bits`
- do not introduce dual-bank SRAM arbitration in this pass
- goal: recover Pocket block-memory capacity first
- runtime correctness remains unproven until real Pocket hardware testing
