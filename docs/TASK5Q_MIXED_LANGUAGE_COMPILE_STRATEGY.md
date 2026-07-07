# Task 5Q Mixed-Language Compile Strategy

## Why Verilog-only probing is insufficient

Genesis_MiSTer is a mixed-language project. While several top-level dependencies (for example `system.sv`) are Verilog/SystemVerilog, runtime integration still reaches into modules that appear to be VHDL-backed or may require VHDL-visible dependencies in the full dependency chain.

A Verilog-only probe therefore cannot be the final proof of readiness for the real runtime boundary.

## What likely needs mixed-language handling

From static probe context and prior inspections, these groups include VHDL-linked or mixed-language dependency risk:

- Z80/T80 subsystem (`third_party/Genesis_MiSTer/rtl/T80/*`), including `T80s` declarations in VHDL.
- VDP/video subsystem (`third_party/Genesis_MiSTer/rtl/vdp.vhd`, `third_party/Genesis_MiSTer/rtl/vdp_common.vhd`).
- SVP path (`third_party/Genesis_MiSTer/rtl/SVP/*`) which is instantiated/declared in places that may still affect compile order in some modes.
- Memory helpers used by `dpram`/`dpram_dif` instantiations (VHDL files like `third_party/Genesis_MiSTer/rtl/bram.vhd`, possibly others).

## Tool-role guidance

### Verilator

- Helpful for SystemVerilog/Verilog linting and static sanity checks.
- Useful for APF wrapper and pure Verilog/SystemVerilog stub checks.
- Not suitable as the primary runtime compile path where VHDL dependencies are required.

### iverilog

- Useful for limited Verilog/SystemVerilog syntax probing.
- Useful for minimal smoke checks in the APF scaffold shell.
- Not sufficient for VHDL-backed runtime dependencies.

### Quartus/openFPGA project flow

- Long-term expected target for final synthesis and APF packaging.
- Capable of handling mixed-language project setups depending on project and tool configuration.
- Will be the right place for authoritative file ordering and full compile integration.

## Why this remains planning only

- No local mixed-language compile run is performed in this task.
- No runtime source is being added to a synthesis flow.
- No Sega CD/32X paths are being activated.
- Imported runtime RTL is unchanged and remains read-only.
- This phase remains a compile-path planning task, not a bootable runtime milestone.

## Safety and constraints

- Do not modify files in `third_party/Genesis_MiSTer`.
- Do not stream ROM from APF host at runtime.
- Do not add SDRAM/PSRAM/SRAM controller integration yet.
- Do not add real APF synthesis packaging files in this task.
