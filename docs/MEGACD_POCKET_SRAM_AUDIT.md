# MegaCD Pocket SRAM audit

- SRAM port width: `sram_a[16:0]`, `sram_dq[15:0]`
- control pins present: `sram_oe_n`, `sram_we_n`, `sram_ub_n`, `sram_lb_n`
- current MegaCD lane before Task 9B behavior: tied off in `core_top.sv`
- QSF SRAM pin assignments: present in `src/megacd_pocket/fpga/ap_core.qsf`
- active SRAM users before Task 9B: none in the MegaCD lane
- safety decision: dedicate Pocket SRAM to `WORDRAM0` only in this probe
