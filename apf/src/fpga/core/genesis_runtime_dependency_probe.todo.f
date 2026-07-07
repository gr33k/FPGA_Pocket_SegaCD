# Genesis runtime dependency probe manifest (Task 5J)
#
# Probe file only: do not use as an active synthesis source list.
# Purpose: record first-pass expected dependencies from the apf_genesis_base boundary.
#
# Status legend:
# - [present] : file exists in this repo today.
# - [missing] : file does not exist in this repo, expected from imported runtime.
# - [excluded]: must not be included in this milestone.
# - [unknown] : not present here and not yet confirmed in compile scan.

# Boundary (confirmed present, currently scaffold-only APF layer)
# [present] apf/apf_genesis_base.sv

# apf_genesis_base direct dependency discovered by inspection:
# system module instantiation: system u_genesis(...).
# [missing] third_party/Genesis_MiSTer/rtl/system.sv  // expected external

# Core and bus dependencies likely referenced by system (all missing from this repo; compile confirmation pending):
# [missing] third_party/Genesis_MiSTer/rtl/FX68K/fx68k.sv
# [missing] third_party/Genesis_MiSTer/rtl/T80/T80s.vhd
# [missing] third_party/Genesis_MiSTer/rtl/T80/T80.vhd
# [missing] third_party/Genesis_MiSTer/rtl/T80/T80_Reg.vhd
# [missing] third_party/Genesis_MiSTer/rtl/T80/T80_Addr.vhd
# [missing] third_party/Genesis_MiSTer/rtl/T80/T80_ALU.vhd
# [missing] third_party/Genesis_MiSTer/rtl/T80/T80_MCode.vhd
# [missing] third_party/Genesis_MiSTer/rtl/T80pa.vhd
# [missing] third_party/Genesis_MiSTer/rtl/vdp.vhd
# [missing] third_party/Genesis_MiSTer/rtl/vdp_common.vhd
# [missing] third_party/Genesis_MiSTer/rtl/jt12/jt12.v
# [missing] third_party/Genesis_MiSTer/rtl/jt12/jt12_top.v
# [missing] third_party/Genesis_MiSTer/rtl/jt89/jt89.v
# [missing] third_party/Genesis_MiSTer/rtl/genesis_lpf.v
# [missing] third_party/Genesis_MiSTer/rtl/audio_iir_filter.v
# [missing] third_party/Genesis_MiSTer/rtl/ddram.sv
# [missing] third_party/Genesis_MiSTer/rtl/sdram.sv
# [missing] third_party/Genesis_MiSTer/rtl/genesis_bus.sv
# [missing] third_party/Genesis_MiSTer/rtl/misc.sv
# [missing] third_party/Genesis_MiSTer/rtl/rommap.sv
# [missing] third_party/Genesis_MiSTer/rtl/codes.sv
# [missing] third_party/Genesis_MiSTer/rtl/mcu.sv

# Explicitly excluded this milestone:
# [excluded] third_party/Genesis_MiSTer/Genesis.sv
# [excluded] third_party/Genesis_MiSTer/sys/sys_top.v
# [excluded] third_party/Genesis_MiSTer/sys/hps_io.sv
# [excluded] third_party/Genesis_MiSTer/rtl/SegaCD*
# [excluded] third_party/Genesis_MiSTer/rtl/32x*
# [excluded] third_party/Genesis_MiSTer/rtl/*sdram_controller*

