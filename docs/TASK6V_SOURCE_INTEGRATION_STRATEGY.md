# Task 6V: Source integration strategy decision and activation direction

## Scope

Define the final source strategy for Genesis-only implementation and switch project direction from the MiSTer-based scaffold lane to the Pocket/openFPGA-Genesis lane.

## Decision made

Chosen strategy: **C) Build around a submodule**.

- Upstream upstream candidate: `opengateware/openFPGA-Genesis`.
- Rationale:
  - Keeps upstream runtime core isolated from APF ownership boundaries.
  - Keeps license/compliance boundaries clear.
  - Lets us switch implementation source by updating one submodule boundary.
  - Preserves import provenance and avoids large vendored snapshots.

## Active implementation path direction

- **Primary implementation source target:** `third_party/openFPGA-Genesis` (submodule-based).
- APF-owned files remain the integration shell and stay unchanged unless needed for glue.
- Genesis-only behavior remains the only scope; no Sega-CD/32X/save-state path is added in this milestone.

## Current repo state after Task 6V

- The repo already contains APF scaffolding, package skeletons, and Quartus preflight/check tooling.
- The active runtime-engine target is now documented as **openFPGA-Genesis** (not as a fork-and-rename codebase in-tree).
- No `Genesis_MiSTer` runtime compile activation is part of the active path.

## Deferred items for 6V (planned)

- Add/refresh submodule checkout for `third_party/openFPGA-Genesis` in a follow-up host task.
- Re-point runtime source manifests to actual openFPGA-Genesis paths after submodule presence is verified.
- Keep current APF scaffold and non-runtime docs as-is until submodule + Quartus probe validation catches up.
