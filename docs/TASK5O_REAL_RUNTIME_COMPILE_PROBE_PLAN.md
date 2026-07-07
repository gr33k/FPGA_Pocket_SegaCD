# Task 5O: Real-runtime compile-probe plan

## Purpose

Task 5O defines a conservative, read-only workflow to probe the first compile/elaboration issues for the real runtime boundary chain:

- `apf/src/fpga/core/core_top.v`
- `apf/apf_genesis_base.sv`
- `third_party/Genesis_MiSTer/rtl/system.sv`

It is a planning-and-error-capture step, not a full build task.

## Why this is not full synthesis

- We are not enabling an APF synthesis project in this milestone.
- We are not importing framework wrappers, I/O controllers, memory controllers, or output packaging.
- We are not changing runtime logic or wiring to greenlight gameplay.
- This is intended to capture the earliest actionable compile-time gaps before full dependency finalization.

## Probe constraints and rules

- Imported runtime remains read-only (`third_party/Genesis_MiSTer` not modified).
- Sega CD / Mega-CD modules excluded.
- 32X modules excluded.
- MiSTer HPS/IOCTL/sys framework files excluded.
- No real SDRAM/PSRAM/SRAM controller integration yet.
- No APF synthesis output/project files are added here.

## Probe behavior

`tools/run_genesis_runtime_compile_probe.sh` performs this sequence:

1. Check available local tools in order:
   1. `verilator`
   2. `iverilog`
2. If no supported tool exists:
   - write a documented `not-run` result to `docs/GENESIS_RUNTIME_FIRST_COMPILE_ERRORS.md`
   - exit successfully.
3. If a tool exists:
   - run read-only lint/syntax probing for the current draft filelist
   - append timestamped results and command used to `docs/GENESIS_RUNTIME_FIRST_COMPILE_ERRORS.md`
   - capture first errors/warnings only for next-step dependency tightening.
4. If VHDL mixing prevents meaningful probing under a given tool, document the limitation explicitly.

Expected probe result is to surface missing declarations/includes and module-level blockers, not to force success.

## Exclusions retained for this task

- `third_party/Genesis_MiSTer/Genesis.sv`
- `third_party/Genesis_MiSTer/sys/sys_top.v`
- `third_party/Genesis_MiSTer/sys/hps_io.sv`
- Any Sega-CD/Mega-CD paths
- Any 32X paths
- simulation stub `apf/src/fpga/sim/apf_genesis_base_stub.sv`

## Expected outputs

- [docs/GENESIS_RUNTIME_FIRST_COMPILE_ERRORS.md](docs/GENESIS_RUNTIME_FIRST_COMPILE_ERRORS.md)
- [apf/src/fpga/core/genesis_runtime_compile_probe.draft.f](apf/src/fpga/core/genesis_runtime_compile_probe.draft.f)
- [tools/run_genesis_runtime_compile_probe.sh](tools/run_genesis_runtime_compile_probe.sh)

## Next step (Task 5P)

Use the first-errored declarations from this report to:

- move only confirmed-required runtime files into the compile probe draft/source list,
- keep everything else commented/drafted until confirmed,
- keep imported runtime files read-only,
- continue excluding Sega CD, 32X, and framework/MiSTer integration files.
