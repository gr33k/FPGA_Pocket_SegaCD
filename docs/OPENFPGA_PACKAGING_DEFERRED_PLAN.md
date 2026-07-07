# OpenFPGA packaging deferred plan

APF packaging is intentionally deferred in this milestone.

- No `.rbf` or `.rbf_r` outputs are generated yet.
- No final core packaging flow is attempted yet.
- APF packaging metadata is not being created in this task.
- Existing APF metadata stays outside build-source planning and remains static.
- Packaging should be considered only after:
  - successful Quartus compile path
  - proven runtime integration
  - confirmed source manifest and constraints

## Why deferred

- No real synthesis project exists yet.
- Runtime compile is still planning/investigation-only.
- Generated output paths and formats are not validated in this phase.

## Safety constraints retained

- No Sega CD and no 32X packaging paths.
- No memory-controller-dependent packaging assumptions yet.
- No claims that any game can boot.

## Task linkage

- This plan links to Task 5V for documentation-only Quartus folder scaffold and Task 5W+ future implementation work, while keeping packaging gated on successful implementation.

