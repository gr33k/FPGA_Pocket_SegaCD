# Task 5Z — Top-level Quartus skeleton activation

## What was converted

In Task 5Z, we converted only:

- `quartus/FPGA_Pocket_SegaCD.qpf`
- `quartus/FPGA_Pocket_SegaCD.qsf`

from non-buildable placeholders into a first active-but-not-run project skeleton.

## Why only these files were converted

Task 5Z is intentionally scoped to Phase B of the activation plan:

- top-level `.qpf` and `.qsf` carry project shell identity and basic structure;
- include/constraint files remain placeholders so risky source and constraint behavior is deferred.

This keeps the scaffold conservative while proving human-maintained project skeleton handling.

## Why source include files stay placeholders

The source include files are still conservative placeholders because:

- runtime source ownership is not yet active;
- mixed-language handling is not yet validated;
- simulation-only stubs and unsupported frameworks must remain excluded;
- runtime compile probe plans are deferred to later tasks.

## Why synthesis must not be run yet

The skeleton is intentionally non-runnable. No final pinout, timing, or output settings are enabled.
No generated output configuration is present.

## Why no generated outputs should exist

No Quartus build has been enabled, so `.sof`, `.rbf`, `.rbf_r`, output directories,
and generated cache directories should not exist in-tree at this milestone.

## Why imported runtime remains read-only

`third_party/Genesis_MiSTer` continues to be imported input only.
No imported files are modified or replaced while building the APF project shell.

## Why APF packaging stays deferred

Packaging metadata and output steps are outside this skeleton stage and remain a later milestone.

## Why Sega CD and 32X stay excluded

The scope is Genesis-only feasibility.
Sega-CD / Mega-CD and 32X are explicitly excluded pending dedicated later tasks.

## Task 6A next

Task 6A should update the hygiene validation script to understand:

- active skeleton top-level files (`.qpf/.qsf` in phase-B form), and
- still-locked non-buildable placeholder files (remaining `.qsf/.sdc`).
