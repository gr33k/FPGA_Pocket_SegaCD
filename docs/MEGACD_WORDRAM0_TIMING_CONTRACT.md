# MegaCD WORDRAM0 timing contract

- donor source: `src/megacd_pocket/fpga/core/rtl/MCD/MCD.vhd`
- removed implementation: `WORDRAM0 : entity work.spram`
- RAM primitive source: `src/megacd_pocket/fpga/core/rtl/bram.vhd`
- audited primitive behavior:
  - clocked single-port access
  - writes occur on the rising edge
  - output is unregistered at the RAM primitive boundary
  - read-during-write mode is `NEW_DATA_NO_NBE_READ`
- active MCD clock in Pocket lane: `clk_sys = 53.693181 MHz` from `mf_pllbase`
- external adapter contract used in Task 9B:
  - address, write data, and write control are latched for a full `clk_sys` cycle
  - write cycles drive SRAM for the whole cycle and return write-through data to the donor path
  - non-write cycles release SRAM data bus and sample read data on the next rising edge
- caveat:
  - this preserves the synchronous donor-facing contract closely, but real Pocket hardware still must validate the external SRAM path
