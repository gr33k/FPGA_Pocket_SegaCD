# Third-party import policy

## Purpose

This document defines how upstream runtime code is brought into the scaffold project and how APF-specific work is kept separate.

## Policy

- `third_party/` is reserved for externally sourced code only.
- Upstream code is treated as imported/read-only for this scaffold phase.
- Compatibility glue and adapter logic must live outside `third_party/`, for example:
  - `apf/`
  - `apf/src/fpga/core/`
  - `docs/`
  - `tools/`
- If a local patch is needed in an imported module in the future, the change must be:
  - explicitly approved,
  - documented in planning notes with rationale,
  - isolated and reviewed before applying.
- APF-specific edits must never be hidden inside imported runtime files.
- License files and copyright headers from upstream must be preserved.
- Do not delete or rewrite upstream license files.
- Do not claim final licensing conclusions until upstream license files are present and reviewed.
- No Sega-CD/32X/import expansion is in scope for this feasibility milestone.

## Runtime import posture (Genesis_MiSTer)

- Planned import path: `third_party/Genesis_MiSTer`
- Planned transport: git submodule (Task 5L decision).
- Imported modules are expected to remain boundary inputs for `apf_genesis_base.sv`, while APF logic and stubs remain local.
