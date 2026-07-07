# DO NOT USE FOR SYNTHESIS YET
# COMPILE ORDER IS PROVISIONAL
# DO NOT MODIFY IMPORTED RTL TO SATISFY THIS FILE

# Core APF boundary files
apf/src/fpga/core/core_top.v
apf/src/fpga/core/rom_preload_ingress_stub.v
apf/src/fpga/core/rom_local_service_stub.v
apf/src/fpga/core/rom_tiny_local_ram_stub.v
apf/apf_genesis_base.sv

# Imported runtime root
third_party/Genesis_MiSTer/rtl/system.sv

# 68000 core (present in submodule, include when confirmed by compile step)
# third_party/Genesis_MiSTer/rtl/FX68K/fx68k.sv
# third_party/Genesis_MiSTer/rtl/FX68K/fx68kAlu.sv
# third_party/Genesis_MiSTer/rtl/FX68K/uaddrPla.sv

# Z80/T80 core (present in submodule, include when confirmed)
# third_party/Genesis_MiSTer/rtl/T80/T80.vhd
# third_party/Genesis_MiSTer/rtl/T80/T80_ALU.vhd
# third_party/Genesis_MiSTer/rtl/T80/T80_Reg.vhd
# third_party/Genesis_MiSTer/rtl/T80/T80_MCode.vhd
# third_party/Genesis_MiSTer/rtl/T80/T80pa.vhd
# third_party/Genesis_MiSTer/rtl/T80/T80s.vhd

# VDP/video helpers
# third_party/Genesis_MiSTer/rtl/vdp.vhd
# third_party/Genesis_MiSTer/rtl/vdp_common.vhd

# YM / FM audio
# third_party/Genesis_MiSTer/rtl/jt12/jt03.v
# third_party/Genesis_MiSTer/rtl/jt12/jt03_acc.v
# third_party/Genesis_MiSTer/rtl/jt12/jt10.v
# third_party/Genesis_MiSTer/rtl/jt12/jt10_acc.v
# third_party/Genesis_MiSTer/rtl/jt12/jt10_adpcm.v
# third_party/Genesis_MiSTer/rtl/jt12/jt12.v
# third_party/Genesis_MiSTer/rtl/jt12/jt12.vhd
# third_party/Genesis_MiSTer/rtl/jt12/jt12_acc.v
# third_party/Genesis_MiSTer/rtl/jt12/jt12_top.v

# PSG / tone/noise
# third_party/Genesis_MiSTer/rtl/jt89/jt89.v
# third_party/Genesis_MiSTer/rtl/jt89/jt89.vhd
# third_party/Genesis_MiSTer/rtl/jt89/jt89_mixer.v
# third_party/Genesis_MiSTer/rtl/jt89/jt89_noise.v
# third_party/Genesis_MiSTer/rtl/jt89/jt89_tone.v
# third_party/Genesis_MiSTer/rtl/jt89/jt89_vol.v

# Memory/helper/support (compile-confirmation pending)
# third_party/Genesis_MiSTer/rtl/ddram.sv
# third_party/Genesis_MiSTer/rtl/sdram.sv
# third_party/Genesis_MiSTer/rtl/genesis_lpf.v
# third_party/Genesis_MiSTer/rtl/audio_iir_filter.v
# third_party/Genesis_MiSTer/rtl/gen_io.sv
# third_party/Genesis_MiSTer/rtl/cheatcodes.sv
# third_party/Genesis_MiSTer/rtl/lightgun.sv
# third_party/Genesis_MiSTer/rtl/multitap.sv
# third_party/Genesis_MiSTer/rtl/teamplayer.sv
# third_party/Genesis_MiSTer/rtl/codes.sv
# third_party/Genesis_MiSTer/rtl/misc.sv
# third_party/Genesis_MiSTer/rtl/mcu.sv
# third_party/Genesis_MiSTer/rtl/EEPROM_STM95.sv
# third_party/Genesis_MiSTer/rtl/fourway.v

# VHDL-only known items in tree (compile flow may need VHDL tool)
# third_party/Genesis_MiSTer/rtl/SVP/SSP160x.vhd
# third_party/Genesis_MiSTer/rtl/SVP/SSP160x_PKG.vhd
# third_party/Genesis_MiSTer/rtl/SVP/SVP.vhd
# third_party/Genesis_MiSTer/rtl/bram.vhd
# third_party/Genesis_MiSTer/rtl/mlab.vhd

# Exclusions for this milestone
# third_party/Genesis_MiSTer/Genesis.sv
# third_party/Genesis_MiSTer/sys/sys_top.v
# third_party/Genesis_MiSTer/sys/hps_io.sv
# third_party/Genesis_MiSTer/rtl/SegaCD*
# third_party/Genesis_MiSTer/rtl/megacd*
# third_party/Genesis_MiSTer/rtl/32x*
# apf/src/fpga/sim/apf_genesis_base_stub.sv
