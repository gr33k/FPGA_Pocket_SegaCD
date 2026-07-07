# DO NOT USE FOR SYNTHESIS YET
# COMPILE ORDER IS PROVISIONAL
# DO NOT MODIFY IMPORTED RTL TO SATISFY THIS FILE

# APF boundary files
apf/src/fpga/core/core_top.v
apf/src/fpga/core/rom_preload_ingress_stub.v
apf/src/fpga/core/rom_local_service_stub.v
apf/src/fpga/core/rom_tiny_local_ram_stub.v
apf/apf_genesis_base.sv

# root/system
third_party/Genesis_MiSTer/rtl/system.sv

# CPU 68000
# Direct instantiation from system.sv
third_party/Genesis_MiSTer/rtl/FX68K/fx68k.sv

# Z80/T80
# Direct instantiation from system.sv (VHDL) - compile flow pending
# third_party/Genesis_MiSTer/rtl/T80/T80s.vhd
# third_party/Genesis_MiSTer/rtl/T80/T80.vhd
# third_party/Genesis_MiSTer/rtl/T80/T80_ALU.vhd
# third_party/Genesis_MiSTer/rtl/T80/T80_Reg.vhd
# third_party/Genesis_MiSTer/rtl/T80/T80_MCode.vhd
# third_party/Genesis_MiSTer/rtl/T80/T80pa.vhd

# VDP/video
# Direct instantiation from system.sv (VHDL) - compile flow pending
# third_party/Genesis_MiSTer/rtl/vdp.vhd
# third_party/Genesis_MiSTer/rtl/vdp_common.vhd

# YM/FM audio
# Direct instantiation from system.sv
third_party/Genesis_MiSTer/rtl/jt12/jt12.v
third_party/Genesis_MiSTer/rtl/jt12/jt12_top.v
third_party/Genesis_MiSTer/rtl/jt12/mixer/jt12_genmix.v
third_party/Genesis_MiSTer/rtl/genesis_fm_lpf.v

# PSG/audio tone/noise
# Direct instantiation from system.sv
third_party/Genesis_MiSTer/rtl/jt89/jt89.v
third_party/Genesis_MiSTer/rtl/jt89/jt89_mixer.v
third_party/Genesis_MiSTer/rtl/jt89/jt89_tone.v
third_party/Genesis_MiSTer/rtl/jt89/jt89_noise.v
# third_party/Genesis_MiSTer/rtl/jt89/jt89_vol.v

# memory/helper/support
# Directly instantiated by system.sv
third_party/Genesis_MiSTer/rtl/cheatcodes.sv
third_party/Genesis_MiSTer/rtl/multitap.sv
third_party/Genesis_MiSTer/rtl/EEPROM_STM95.sv
third_party/Genesis_MiSTer/rtl/genesis_lpf.v
# Direct/indirect dependencies in-tree and confirmed for compilation support (static inspection)
third_party/Genesis_MiSTer/rtl/gen_io.sv
third_party/Genesis_MiSTer/rtl/fourway.v
third_party/Genesis_MiSTer/rtl/teamplayer.sv

# VHDL candidates (present in submodule, compile flow pending)
# third_party/Genesis_MiSTer/rtl/SVP/SVP.vhd
# third_party/Genesis_MiSTer/rtl/SVP/SSP160x.vhd
# third_party/Genesis_MiSTer/rtl/SVP/SSP160x_PKG.vhd
# third_party/Genesis_MiSTer/rtl/bram.vhd
# third_party/Genesis_MiSTer/rtl/mlab.vhd

# excluded candidates
# third_party/Genesis_MiSTer/Genesis.sv
# third_party/Genesis_MiSTer/sys/sys_top.v
# third_party/Genesis_MiSTer/sys/hps_io.sv
# third_party/Genesis_MiSTer/rtl/SegaCD*
# third_party/Genesis_MiSTer/rtl/megacd*
# third_party/Genesis_MiSTer/rtl/32x*
# apf/src/fpga/sim/apf_genesis_base_stub.sv
