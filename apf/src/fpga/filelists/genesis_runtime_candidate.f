# CANDIDATE RUNTIME FILELIST (Task 6M / 6O)
# This file is planning-only and does not drive an active compile.
# Runtime integration remains paused until Quartus validation and analysis pass are available.
# Use this as a compile-target draft only.

# APF boundary wrapper
apf/apf_genesis_base.sv

# Core Genesis runtime entrypoint
third_party/Genesis_MiSTer/rtl/system.sv

# Static-confirmed direct deps from system.sv and initial scan
# (promoted to Task 6O active runtime list)
# [TASK6O-PROMOTED] third_party/Genesis_MiSTer/rtl/cheatcodes.sv
# [TASK6O-PROMOTED] third_party/Genesis_MiSTer/rtl/FX68K/fx68k.sv
# [TASK6O-PROMOTED] third_party/Genesis_MiSTer/rtl/FX68K/fx68kAlu.sv
# [TASK6O-PROMOTED] third_party/Genesis_MiSTer/rtl/FX68K/uaddrPla.sv
# [TASK6O-PROMOTED] third_party/Genesis_MiSTer/rtl/EEPROM_STM95.sv
# [TASK6O-PROMOTED] third_party/Genesis_MiSTer/rtl/multitap.sv
# [TASK6O-PROMOTED] third_party/Genesis_MiSTer/rtl/gen_io.sv
# [TASK6O-PROMOTED] third_party/Genesis_MiSTer/rtl/genesis_lpf.v

third_party/Genesis_MiSTer/rtl/fourway.v
third_party/Genesis_MiSTer/rtl/ddram.sv
third_party/Genesis_MiSTer/rtl/miracle.sv
third_party/Genesis_MiSTer/rtl/lightgun.sv
third_party/Genesis_MiSTer/rtl/teamplayer.sv
#(no wildcard entries: add explicit per-file candidates only)

# FM/PSG/audio-family candidates (confirm after first compile/error pass)
#third_party/Genesis_MiSTer/rtl/jt12/jt12.vhd            (VHDL candidate)
#third_party/Genesis_MiSTer/rtl/jt12/jt12_top.v
#third_party/Genesis_MiSTer/rtl/jt12/jt12.v
#third_party/Genesis_MiSTer/rtl/jt89/jt89.v
#third_party/Genesis_MiSTer/rtl/jt89/jt89.vhd
#third_party/Genesis_MiSTer/rtl/T80/T80s.vhd
#third_party/Genesis_MiSTer/rtl/T80/T80.vhd
#third_party/Genesis_MiSTer/rtl/SVP/SVP.vhd
#third_party/Genesis_MiSTer/rtl/SVP/SSP160x.vhd

# Mixed-language candidates in scan output (explicit and must be confirmed before activation)
#third_party/Genesis_MiSTer/rtl/vdp.vhd
#third_party/Genesis_MiSTer/rtl/vdp_common.vhd
#third_party/Genesis_MiSTer/rtl/brid.vhd
#third_party/Genesis_MiSTer/rtl/mlab.vhd

# Exclusions (kept out of this candidate manifest)
# - MiSTer top wrapper Genesis.sv
# - sys wrappers / HPS IOCTL
# - Sega CD / Mega-CD / 32X runtime files
# - APF packaging and simulation artifacts
