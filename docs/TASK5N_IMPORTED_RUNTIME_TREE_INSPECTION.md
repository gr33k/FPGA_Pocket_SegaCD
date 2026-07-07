# Task 5N: Imported runtime tree inspection

## Scope

This is a discovery/planning task only after importing `Genesis_MiSTer` as a submodule. No runtime files were modified.

## Required checks executed

- Confirmed submodule path exists: `third_party/Genesis_MiSTer`
- Confirmed pinned commit via
  - `git -C third_party/Genesis_MiSTer rev-parse HEAD`
  - SHA: `adc0c42cfb1fa5d484cc8566767f7d68982bc44a`
- Confirmed `system` declaration by searching `third_party/Genesis_MiSTer/rtl/system.sv`
  - Match: `module system` exists
- Listed imported runtime files from
  - `find third_party/Genesis_MiSTer -type f \( -name "*.v" -o -name "*.sv" -o -name "*.vhd" -o -name "*.vhdl" \) | sort`
- Ran dependency scan with
  - `python3 tools/scan_verilog_deps.py --root . --entry apf/apf_genesis_base.sv`

## Findings

- `third_party/Genesis_MiSTer` is present and populated.
- `third_party/Genesis_MiSTer/rtl/system.sv` is present and contains `module system`.
- The imported tree contains both Verilog/SystemVerilog and VHDL modules under `third_party/Genesis_MiSTer/rtl/`.
- The scan is useful for advisory visibility but does not replace compile errors as the source of truth.

## Constraint enforcement

Task 5N intentionally did not:

- modify runtime RTL inside `third_party/Genesis_MiSTer`
- create replacement/fake Genesis runtime modules
- add real memory-controller integration
- add APF synthesis output or synthesis project files
- enable Sega CD, 32X, or CD hardware

The task remains pre-active-plumb, planning-focused output only.

## Notes on scanner output

- The scanner reports suspected instantiations and missing modules conservatively.
- It is still advisory due broad pattern exclusion and no compile-elaboration pass in this task.
- `unique` appears as a language-keyword-style advisory artifact in reported misses.
