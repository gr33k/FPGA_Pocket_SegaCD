# Genesis_MiSTer runtime source manifest draft
# ------------------------------------------------------------
# Do not use this file as-is for synthesis.
# This is a dependency discovery plan scaffold only.
#
# Real runtime integration MUST keep a strict separation:
# - core_top -> apf_genesis_base.sv (boundary)
# - only then -> imported runtime files
#
# Never include the simulation shim in the runtime build:
# - apf/src/fpga/sim/apf_genesis_base_stub.sv  // DO NOT INCLUDE
#
# Do not include MiSTer wrappers:
# - sys/sys_top.v                              // DO NOT INCLUDE
# - Genesis.sv                                  // DO NOT INCLUDE
#
# Confirmed in current repo:
# apf/apf_genesis_base.sv

# Suggested first-pass runtime dependency draft (commented until compile-confirmed):
# ../Genesis_MiSTer/rtl/system.sv
# ../Genesis_MiSTer/rtl/FX68K/fx68k.sv
# ../Genesis_MiSTer/rtl/T80/T80s.vhd
# ../Genesis_MiSTer/rtl/T80/T80.vhd
# ../Genesis_MiSTer/rtl/T80/T80_Reg.vhd
# ../Genesis_MiSTer/rtl/T80/T80_Addr.vhd
# ../Genesis_MiSTer/rtl/T80/T80_ALU.vhd
# ../Genesis_MiSTer/rtl/T80/T80_MCode.vhd
# ../Genesis_MiSTer/rtl/T80/T80pa.vhd
# ../Genesis_MiSTer/rtl/vdp.vhd
# ../Genesis_MiSTer/rtl/vdp_common.vhd
# ../Genesis_MiSTer/rtl/jt12/jt12.v
# ../Genesis_MiSTer/rtl/jt12/jt12_top.v
# ../Genesis_MiSTer/rtl/jt89/jt89.v
# ../Genesis_MiSTer/rtl/genesis_lpf.v
# ../Genesis_MiSTer/rtl/audio_iir_filter.v
# ../Genesis_MiSTer/rtl/ddram.sv
# ../Genesis_MiSTer/rtl/sdram.sv
# ../Genesis_MiSTer/rtl/genesis_bus.sv
# ../Genesis_MiSTer/rtl/misc.sv
# ../Genesis_MiSTer/rtl/rommap.sv
# ../Genesis_MiSTer/rtl/mcu.sv
