# Task 5R APF Quartus/openFPGA Project Plan

## Why a future Quartus/openFPGA project is needed

- APF-compatible delivery requires a build-time container that owns final source file ordering, pin mappings, and mixed-language integration.
- The current milestone is scaffold-first only (APF wrappers, runtime probes, and planning). It is not yet the place for active synthesis.
- Full Genesis runtime integration must eventually compile through the same top-level project model used by openFPGA targets.

## Why this task does not create a project yet

- This remains a planning milestone only.
- No active synthesis project files are allowed in this task by constraint.
- Existing source-level probes remain separate from real build integration.
- Mixed-language compile capability and source qualification are still pending before a build file would be meaningful.

## Why mixed-language support matters

- The known dependency set includes VHDL-backed modules and modules requiring mixed-language awareness.
- Verilog-only probes are useful for fast checks, but they cannot validate all runtime dependencies.
- A Quartus/openFPGA project is the likely practical point where mixed Verilog/SystemVerilog/VHDL ordering and integration are finalized.

## Runtime read-only boundary

- `third_party/Genesis_MiSTer` is imported and remains read-only.
- Compatibility and APF glue must be implemented outside `third_party/Genesis_MiSTer`.
- No imported runtime file edits are part of this planning task.

## Why APF glue must live outside third_party

- `third_party/Genesis_MiSTer` is reserved for upstream runtime code.
- APF-specific adaptations (pin/bridge/ROM preload and wrapper boundaries) are platform integration work and should remain in `apf/` (and related local docs/scripts), not in upstream runtime folders.

## Exclusions for this milestone

- No Sega CD/32X modules are included.
- No real memory-controller integration yet.
- No HPS/framework glue or MiSTer sys wrappers are included.
- No APF packaging output is created here.

## What does not happen in this task

- No real Quartus/openFPGA project files are created.
- No synthesis success is claimed.
- No game boot or runtime feature claims are made.
- No imported runtime behavior is modified.

## Next step

Task 5S should create a **checklist** for a future Quartus/openFPGA skeleton without creating project files. It should include:

- required project files
- source groups and expected ordering inputs
- generated outputs to ignore
- required validation milestones
- keep/no-keep boundaries between planning and synthesis artifacts
