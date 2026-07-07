# Genesis_MiSTer Runtime Source List Draft V1

> Draft status: inactive / planning-only / not used for synthesis yet

- Probe source manifest used for compile dependency capture: `apf/src/fpga/core/genesis_runtime_compile_probe.draft.f`
- Compile order is provisional and not final.

## Intended runtime chain

- `apf/src/fpga/core/core_top.v`
- `apf/apf_genesis_base.sv`
- `third_party/Genesis_MiSTer/rtl/system.sv`

## Source groups confirmed present in imported tree

### System root

- `third_party/Genesis_MiSTer/rtl/system.sv`

### 68000 CPU core

- `third_party/Genesis_MiSTer/rtl/FX68K/fx68k.sv`
- `third_party/Genesis_MiSTer/rtl/FX68K/fx68kAlu.sv`
- `third_party/Genesis_MiSTer/rtl/FX68K/uaddrPla.sv`

### Z80/T80 core

- `third_party/Genesis_MiSTer/rtl/T80/T80.vhd`
- `third_party/Genesis_MiSTer/rtl/T80/T80_ALU.vhd`
- `third_party/Genesis_MiSTer/rtl/T80/T80_Reg.vhd`
- `third_party/Genesis_MiSTer/rtl/T80/T80_MCode.vhd`
- `third_party/Genesis_MiSTer/rtl/T80/T80pa.vhd`
- `third_party/Genesis_MiSTer/rtl/T80/T80s.vhd`

### VDP / video

- `third_party/Genesis_MiSTer/rtl/vdp.vhd`
- `third_party/Genesis_MiSTer/rtl/vdp_common.vhd`

### YM / FM audio

- `third_party/Genesis_MiSTer/rtl/jt12/jt03.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt03_acc.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_acc.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcm.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcm_acc.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcm_cnt.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcm_comb.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcm_dbrom.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcm_div.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcm_drvA.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcm_drvB.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcm_dt.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcm_gain.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcma_lut.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcmb.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcmb_cnt.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcmb_gain.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcmb_interpol.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt10_cen_burst.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12.vhd`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_acc.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_csr.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_div.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_dout.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_eg.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_eg_cnt.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_eg_comb.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_eg_ctrl.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_eg_final.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_eg_pure.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_eg_step.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_exprom.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_fm_uprate.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_kon.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_lfo.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_logsin.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_mmr.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_mod.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_op.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_pcm.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_pcm_interpol.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_pg.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_pg_comb.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_pg_dt.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_pg_inc.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_pg_sum.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_pm.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_reg.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_rst.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_sh.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_sh24.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_sh_rst.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_single_acc.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_sumch.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_timers.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_top.v`
- `third_party/Genesis_MiSTer/rtl/jt12/jt12_top.v`
- `third_party/Genesis_MiSTer/rtl/jt12/mixer/jt12_comb.v`
- `third_party/Genesis_MiSTer/rtl/jt12/mixer/jt12_decim.v`
- `third_party/Genesis_MiSTer/rtl/jt12/mixer/jt12_fm_uprate.v`
- `third_party/Genesis_MiSTer/rtl/jt12/mixer/jt12_genmix.v`
- `third_party/Genesis_MiSTer/rtl/jt12/mixer/jt12_interpol.v`
- `third_party/Genesis_MiSTer/rtl/jt12/mixer/jt12_mixer.v`

### PSG audio

- `third_party/Genesis_MiSTer/rtl/jt89/jt89.v`
- `third_party/Genesis_MiSTer/rtl/jt89/jt89.vhd`
- `third_party/Genesis_MiSTer/rtl/jt89/jt89_mixer.v`
- `third_party/Genesis_MiSTer/rtl/jt89/jt89_noise.v`
- `third_party/Genesis_MiSTer/rtl/jt89/jt89_tone.v`
- `third_party/Genesis_MiSTer/rtl/jt89/jt89_vol.v`

### Memory / helper / support (pending integration)

- `third_party/Genesis_MiSTer/rtl/ddram.sv`
- `third_party/Genesis_MiSTer/rtl/EEPROM_STM95.sv`
- `third_party/Genesis_MiSTer/rtl/cheatcodes.sv`
- `third_party/Genesis_MiSTer/rtl/cofi.sv`
- `third_party/Genesis_MiSTer/rtl/fourway.v`
- `third_party/Genesis_MiSTer/rtl/gen_io.sv`
- `third_party/Genesis_MiSTer/rtl/genesis_lpf.v`
- `third_party/Genesis_MiSTer/rtl/genesis_bus.sv` *(expected by compile pass, not listed in file scan)*
- `third_party/Genesis_MiSTer/rtl/rommap.sv` *(expected by compile pass, not listed in file scan)*
- `third_party/Genesis_MiSTer/rtl/sdram.sv`
- `third_party/Genesis_MiSTer/rtl/codes.sv` *(expected by compile pass, not listed in file scan)*
- `third_party/Genesis_MiSTer/rtl/mcu.sv` *(expected by compile pass, not listed in file scan)*
- `third_party/Genesis_MiSTer/rtl/misc.sv` *(expected by compile pass, not listed in file scan)*
- `third_party/Genesis_MiSTer/rtl/teamplayer.sv`
- `third_party/Genesis_MiSTer/rtl/multitap.sv`
- `third_party/Genesis_MiSTer/rtl/lightgun.sv`
- `third_party/Genesis_MiSTer/rtl/audio_iir_filter.v`
- `third_party/Genesis_MiSTer/rtl/jt12/alt/eg_cnt.v`
- `third_party/Genesis_MiSTer/rtl/jt12/alt/eg_comb.v`
- `third_party/Genesis_MiSTer/rtl/jt12/alt/eg_mux.v`
- `third_party/Genesis_MiSTer/rtl/jt12/alt/eg_step.v`
- `third_party/Genesis_MiSTer/rtl/jt12/alt/eg_step_ram.v`
- `third_party/Genesis_MiSTer/rtl/jt12/dac/jt12_dac.v`
- `third_party/Genesis_MiSTer/rtl/jt12/dac/jt12_dac2.v`
- `third_party/Genesis_MiSTer/rtl/jt12/mixer/jt12_interpol.v`

### VHDL-only runtime modules in tree

- `third_party/Genesis_MiSTer/rtl/SVP/SSP160x.vhd`
- `third_party/Genesis_MiSTer/rtl/SVP/SSP160x_PKG.vhd`
- `third_party/Genesis_MiSTer/rtl/SVP/SVP.vhd`
- `third_party/Genesis_MiSTer/rtl/bram.vhd`
- `third_party/Genesis_MiSTer/rtl/mlab.vhd`
- `third_party/Genesis_MiSTer/rtl/jt12/alt` *(directory subtree)

### Files requiring later compile confirmation

- Many modules above are likely required depending on real `system.sv` instantiation path for strict compile pass.
- The exact compile order and full required set are still to be determined by Task 5O-style probe builds.
