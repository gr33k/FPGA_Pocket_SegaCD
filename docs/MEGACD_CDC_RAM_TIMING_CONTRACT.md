# MegaCD CDC RAM timing contract

Task 9C moves only the donor CDC scratch RAM out of the internal `dpram_dif:CDC_RAM` M10K implementation and into a Pocket-local helper that targets MLAB.

Required functional contract:

- same `clk_sys` clock domain as donor `MCD` and `CDC`
- byte-read port:
  - address: `EXT_CDC_RAM_A_RD[13:0]`
  - data: `EXT_CDC_RAM_DI[7:0]`
- word-write port:
  - address: `EXT_CDC_RAM_A_WR[12:0]`
  - data: `EXT_CDC_RAM_DO[15:0]`
  - strobe: `EXT_CDC_RAM_WE`
- effective storage depth remains 16 KiB total
- read path remains unregistered at the donor boundary
- same-address read/write collision returns the just-written byte (`NEW_DATA_NO_NBE_READ` equivalent)
- no CDC RAM reset/clear requirement exists in donor RTL; only debug flags reset locally

Non-goals for Task 9C:

- no Pocket SRAM use for CDC RAM
- no PCM RAM movement yet
- no change to WORDRAM0 external SRAM path
- no change to WORDRAM1 internal donor RAM path
- no disc service implementation
