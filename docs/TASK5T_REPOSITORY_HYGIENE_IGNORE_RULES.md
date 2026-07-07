# Task 5T — Repository hygiene and generated-output ignore rules

## Goal

This task implements repository hygiene for future Quartus/openFPGA work by adding ignore rules for generated artifacts while keeping source files visible and version-controlled.

It does **not** create Quartus projects, does **not** run synthesis, and does **not** add generated outputs.

- Generated output directories are ignored for predictable workspace hygiene.
- Generated files are ignored to avoid noisy diffs from future build runs.
- Project source files (`.qpf/.qsf/.sdc/.tcl`) are intentionally **not** ignored yet.
- Imported runtime RTL under `third_party/Genesis_MiSTer/` is not ignored.
- Sega CD and 32X support remain excluded from this phase.

## Ignored directories

- `build/`
- `output_files/`
- `db/`
- `incremental_db/`
- `simulation/`
- `greybox_tmp/`

## Ignored file patterns

- `*.sof`
- `*.pof`
- `*.jic`
- `*.rpd`
- `*.rbf`
- `*.rbf_r`
- `*.fit.*`
- `*.sta.*`
- `*.map.*`
- `*.asm.*`
- `*.flow.*`
- `*.qws`
- `*.bak`
- `*.smsg`
- `*.summary`
- `*.done`
- `*.pin`
- `*.qdf`

## Backup file patterns ignored (Quartus/openFPGA source-adjacent)

- `*.qpf.bak`
- `*.qsf.bak`
- `*.sdc.bak`
- `*.tcl.bak`

## What is intentionally not ignored

- `docs/` (planning and status references must remain tracked)
- `apf` metadata JSON files and source files
- `*.qpf`, `*.qsf`, `*.sdc`, `*.tcl` source project files
- `third_party/Genesis_MiSTer/` and `.gitmodules`

## Rationale

- Keeping generated outputs untracked is required before synthesis is enabled so generated noise does not pollute the milestone history.
- Keeping source files unignored preserves reviewability when future Quartus project files are added.
- This repo is still scaffold-only; no APF packaging output or real build artifacts are produced.
- Runtime compilation, ROM streaming per-read changes, and Sega-CD/32X paths remain deferred.

## Next task

- Task 5U should add a **future Quartus project skeleton dry-run plan** that lists human-maintained project files to create later without creating the files in this phase.

