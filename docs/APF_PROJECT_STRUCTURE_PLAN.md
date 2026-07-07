# APF Project Structure Plan

## Future project layout target

This milestone keeps planning explicit and does not add a real Quartus project. The target layout for future integration is:

- `apf/src/fpga/core/`
  - APF-facing top module (`core_top.v`)
  - ROM service and preload stubs
  - future local memory glue and runtime adapter modules
- `apf/src/fpga/sim/`
  - simulation-only scaffolding
  - testbenches
- `apf/`
  - APF metadata and wrapper boundary (`apf_genesis_base.sv`)
- `third_party/Genesis_MiSTer/`
  - imported upstream runtime (read-only for this project)
- `tools/`
  - scanners/helpers and non-invasive scripts
- `docs/`
  - planning, status, compile-flow, and integration notes
- `build/`
  - future generated output (not committed unless explicitly needed)
- `quartus/`
  - future Quartus project files (not created in this task)

## Platform integration placement

- APF-specific glue stays in `apf/` and does not modify upstream runtime files.
- Imported runtime stays under `third_party/Genesis_MiSTer` and is not copied.
- Simulation artifacts remain under `apf/src/fpga/sim/` and are never linked into real synthesis flow.

## Source ownership rules

- Keep `apf_genesis_base.sv` as the project boundary adapter.
- Keep `apf/src/fpga/sim/apf_genesis_base_stub.sv` simulation-only.
- Keep runtime RTL unmodified and external under `third_party`.
- Keep Sega-CD/Mega-CD and 32X artifacts excluded until explicitly assigned in future milestones.

## Separation from this task

- This document only defines structure.
- Task 5S added a concrete checklist set for future Quartus/openFPGA skeleton files, generated output ignore rules, and validation steps.
- No project files are created.
- No synthesis success is implied.
- No APF packaging files are added.
