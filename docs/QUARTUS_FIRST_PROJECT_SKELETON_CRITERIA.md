# First Real Quartus Project Skeleton Criteria (Task 5Y)

This document defines the minimum criteria for the first active Quartus skeleton conversion.

## Criteria

- Human-maintained project files exist and remain authoritative.
- File set is intentionally minimal and no broader activation is attempted.
- Core target remains `apf/src/fpga/core/core_top.v`.
- APF wrapper boundary is `apf/apf_genesis_base.sv`.
- Runtime root dependency is `third_party/Genesis_MiSTer/rtl/system.sv`.
- Simulation-only stubs remain excluded from active compile lists (including
  `apf/src/fpga/sim/apf_genesis_base_stub.sv`).
- Sega CD and 32X remain explicitly excluded.
- HPS/IOCTL framework remains excluded.
- Imported runtime remains read-only and outside APF-specific glue edits.
- No generated outputs are committed.
- No APF packaging is attempted.
- No real runtime compile success or game boot claim is made from this stage.
- No memory-controller integration (PSRAM / SDRAM / SRAM) is active.
- Task 5Z status: top-level skeleton files are active (`qpf` + `qsf`); runtime source activation remains pending.

## Acceptance notes

A skeleton is only considered complete for this milestone when:

- top-level `qpf` + `qsf` are converted,
- source include activation is still pending,
- `files`/`.sdc` placeholders remain non-buildable,
- and the task remains non-run.
