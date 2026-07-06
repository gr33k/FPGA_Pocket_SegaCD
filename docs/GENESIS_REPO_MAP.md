# Genesis_MiSTer Repository Map (Task 1 Baseline)

Source snapshot: `https://github.com/MiSTer-devel/Genesis_MiSTer` (shallow clone at task time).

## Top-level modules
- `sys/sys_top.v` → module `sys_top` (MiSTer board wrapper, external ports, clocks, SDRAM, HDMI/VGA/audio pipes)
- `Genesis.sv` → module `emu` (core wrapper used by `sys_top`)
- `rtl/system.sv` → module `system` (Emulation core logic: CPU, bus, VDP, audio, memory-mapped peripherals)

## CPU modules
- `rtl/FX68K/fx68k.sv` → module `fx68k` (68000), instantiated in `rtl/system.sv`
- `rtl/T80/T80s.vhd` → entity `T80s` (Z80), instantiated in `rtl/system.sv`
- `rtl/T80/T80.vhd` and related entities (`T80_Reg`, `T80_ALU`, `T80_MCode`, `T80pa`) are direct sub-blocks for the Z80 implementation
- `rtl/CODES` and input helpers (`gen_io.sv`, `pad_io`, `gun_io`) are tightly coupled to CPU/memory bus behavior

## VDP / video path
- `rtl/vdp.vhd` (`entity vdp`) = main VDP block, instantiated in `rtl/system.sv`
- `rtl/vdp_common.vhd` = shared VDP support logic
- `rtl/system.sv` handles VDP bus arbitration / status / interrupts and routes pixel data out
- `sys/arcade_video.v` and `sys/video_freak.v` = main video timing/composition/final timing block in wrapper
- `sys/video_mixer.v`, `sys/scandoubler.v`, `sys/vga_out.sv`, `sys/osd.v`, `sys/video_cleaner.sv`, `sys/scanlines.v`, `sys/shadowmask.v`, `sys/hq2x.sv`, `sys/yc_out.sv` are wrapper-side display post-processing / transport modules
- `sys/yg_out` and `audio_out` paths are instantiated through `sys_top` and fed by core outputs

## Audio path
- `rtl/jt12/jt12*.v*` + `rtl/jt12_top` chain (`module jt12`, `jt12_genmix`) for YM2612/PCM synthesis
- `rtl/jt89/jt89.v` for PSG (AY-3-8910 style)
- `rtl/genesis_lpf.v` (`genesis_lpf`, `genesis_fm_lpf`) for model-style filtering
- `rtl/audio_iir_filter.v` and `rtl/jt12` mix filters are additional audio shaping components
- `sys/audio_out.v`, `sys/i2s.v`, `sys/spdif.v`, `sys/sigma_delta_dac.v` are MiSTer-side output/audio transport blocks

## ROM loader / upload path
- `sys/hps_io.sv` handles menu file upload/download signaling and produces `ioctl_*` signals
- `Genesis.sv` implements loader state for `ioctl_download`, sets `rom_sz`, and provides `ROM_ADDR/DATA/WE/REQ/ACK`
- `rtl/ddram.sv` stores uploads as double-data words for runtime fetch path
- `rtl/sdram.sv` handles direct SDRAM writes during download/load
- `rtl/system.sv` consumes ROM read channel (`ROM_ADDR`, `ROM_DATA`, `ROM_REQ`, `ROM_ACK`) and maps ROM regions / quirks per bus source
- `sys/sysmem.sv` bridges to external DDR3 service while keeping `emu` loader and runtime memory traffic separate

## SDRAM dependencies
- Core-visible ports in `Genesis.sv` for SDRAM: `SDRAM_*` and optional `SDRAM2_*`
- Runtime controllers: `rtl/sdram.sv`, `rtl/ddram.sv`
- Low-level DDR wrapper and memory bus handoff in `sys/sys_top.v`: `sysmem_lite`, `ddr_svc`, `sysmem` interface block
- Video/audio/ROM timing can switch to SDRAM path via status bits in `Genesis.sv` (`use_sdr`, `sdram_sz`)

## MiSTer-specific wrapper dependencies
- `sys/hps_io.sv` (status menu, ioctls, DIP/switch status)
- `sys/sys_top.v` (`sys_top` top) and `sys/sysmem.sv` (DDR3 interface)
- `sys/mcp23009.sv` (board button/LED/SDCD glue)
- `sys/audio_out.v`, `sys/vga_out.sv`, `sys/arcade_video.v`, `sys/video_freak.v`, `sys/osd.v`
- `sys/pll_cfg.v`, `sys/pll_audio.v`, `sys/pll_hdmi.v`, `sys/pll.v`, `sys/pll_audio_*.v` + `sys/pll_hdmi_*.v`, `sys/i2c.v` (clock/source/config glue)
- Quartus/board glue files outside RTL runtime (`sys/*.qip`, `sys/*.tcl`, `sys_*.qip`, `Genesis.sv`/`sys_top` config strings)

## Files that should not be touched for this first milestone
- `rtl/FX68K/*` (MC68000 CPU core)
- `rtl/T80/*` (Z80 CPU core)
- `rtl/jt12/*` and `rtl/jt89/*` (audio synthesis cores)
- `rtl/SVP/*` (SVP accelerator path)
- MiSTer wrapper and platform files while verifying baseline compile:
  - `sys/*`
  - board/flow artifacts: `*.qpf`, `*.qsf`, `*.sdc`, `*.qip`, `*.tcl`, `Genesis.srf`, `Genesis_Q13.srf`, `Genesis.qsf`, `Genesis_Q13.qsf`
- release/build artifacts in `releases/*`

## Notes for the feasibility milestone
- Keep first milestone strictly at Genesis base (`68000 + Z80 + VDP + audio`) and avoid any new Mega-CD/CD-specific modules.
- Use `module emu` (inside `Genesis.sv`) as the first compile boundary for Pocket/OpenFPGA migration.
