# Task 5X: Quartus placeholder hygiene validation

## Purpose

Task 5X adds a repository hygiene check for the non-buildable Quartus placeholders created in Task 5W. The purpose is to keep scaffold files safe before any attempt to activate real project build artifacts.

## Why this validation exists

- Placeholder files are planning-only artifacts, not a working Quartus flow.
- The project is still at scaffold stage, and mistakes in source lists or forbidden references must be caught before real activation.
- Safety gates should fail fast on output pollution and accidental feature bleed (Sega CD / 32X / packaging / controller/file leakage).

## Files validated

- `quartus/FPGA_Pocket_SegaCD.qpf`
- `quartus/FPGA_Pocket_SegaCD.qsf`
- `quartus/FPGA_Pocket_SegaCD.sdc`
- `quartus/files_apf_scaffold.qsf`
- `quartus/files_genesis_runtime.qsf`
- `quartus/files_constraints.qsf`

## Why the project remains non-buildable

- The files are explicitly marked as placeholders.
- There is no final pin map, active synthesis target, or finalized constraints in place yet.
- Source lists are provisional and meant to be promoted only after compile-order and mixed-language confirmation.

## Why synthesis stays disabled

- No build flow, no synthesis invocation, and no output file generation are introduced by this task.
- The placeholders still carry explicit do-not-run markers.

## Why generated outputs must not be committed

- This scaffold should not produce `*.sof/*.rbf/*.rbf_r/*.pof/*.rpd/*.jic`.
- Build directories such as `build/`, `output_files/`, `db/`, and `incremental_db/` remain deferred and ignored by policy.

## Why runtime is read-only

- `third_party/Genesis_MiSTer` stays read-only for this milestone.
- APF runtime glue and wrappers remain in `apf/` and `apf/src/fpga/core/`.
- Runtime module fixes are handled in later import/build tasks, not in this placeholder verification pass.

## Why Sega CD and 32X remain excluded

- Sega/CD modules and 32X are explicitly excluded from file lists and checks at this milestone.
- No memory-controller/CD-image/special-hardware paths are allowed in placeholder activation yet.

## Next

Task 5Y should define the controlled activation plan to convert these placeholders into a first real Quartus skeleton without enabling synthesis yet. That plan should still keep runtime compile claims off and keep output-free behavior.
