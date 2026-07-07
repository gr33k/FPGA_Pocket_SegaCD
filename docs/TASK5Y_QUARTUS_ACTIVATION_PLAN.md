# Task 5Y — Controlled Quartus Activation Plan

## Controlled activation intent

This repository stays in placeholder-only project mode until explicit safety gates are met. We are not converting all files at once because the scaffold currently includes only verified APF runtime glue and planning artifacts; broad activation can hide mixed-language, source-order, and boundary errors until late.

The plan is intentionally conservative:

- keep generation non-buildable by default
- prove assumptions incrementally
- keep source lists minimal and documented
- avoid any synthetic/packaging behavior until runtime boundary and source ownership are stable

## Why this milestone does not claim synthesis

- No real Quartus/openFPGA build is enabled yet.
- No generated outputs are expected from this branch.
- No compile claim is valid yet because imported Genesis_MiSTer integration is planned only.
- No game boot claim is valid yet.

## Why placeholders stay non-buildable

- Placeholder files (Task 5W) are explicit documentation scaffolds.
- They currently prevent accidental synthesis direction and prevent tool-side side effects.
- They provide a safe surface to document required activations before any active file writes.

## Why this is required before Task 5Z

- Task 5Z only converts top-level shell files to first active skeleton form.
- Gate failures in submodule cleanliness, source ownership, or forbidden dependency exclusion must be prevented before conversion.

## Immutable constraints that remain

- Sega CD and Mega-CD remain excluded.
- 32X remains excluded.
- SD/PS/HD card memory controllers remain deferred.
- No APF package output files are introduced.
- No runtime ROM streaming from APF host per read is introduced.
- No imported runtime RTL is modified.
- APF-specific glue remains outside `third_party/Genesis_MiSTer`.

## Dependency structure preserved

- Real runtime boundary remains:
  - `apf/src/fpga/core/core_top.v`
  - `apf/apf_genesis_base.sv`
  - imported runtime root `third_party/Genesis_MiSTer/rtl/system.sv` (read-only)

## Required activation state before further project moves

1. Hygiene checks pass with no forbidden references.
2. Submodule is initialized and clean.
3. Placeholder conversion has explicit gate and checklist updates.
4. Simulation-only stubs remain excluded from any active list.
5. No generated outputs appear in-tree.
6. Documentation reflects deferred synthesis and deferred packaging.

## Planned next step

- Task 5Z should convert only the top-level `quartus/FPGA_Pocket_SegaCD.qpf` and `.qsf` into a first active skeleton while keeping source include files conservative and synthesis disabled.
