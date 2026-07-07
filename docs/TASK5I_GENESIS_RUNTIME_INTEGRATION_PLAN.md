# Task 5I: Genesis_MiSTer runtime integration plan (Draft)

## Scope of this task

This task defines how to integrate imported Genesis_MiSTer runtime RTL into the APF flow later, without changing imported files and without mixing compile paths.

## Required boundary chain (real APF runtime path)

The intended real path is:

- `core_top`
  - `->` `apf_genesis_base`
  - `->` imported `Genesis_MiSTer` runtime (starting at `rtl/system.sv` and dependencies)

`core_top` must only own APF and preloader/scaffold boundaries, while `apf_genesis_base.sv` remains the runtime adapter boundary.

## Required boundary chain (simulation/elaboration path)

For scaffold-only elaboration/sanity today, use:

- `core_top`
  - `->` `apf/src/fpga/sim/apf_genesis_base_stub.sv`

This is the 5H-only path and **must not** be combined with real runtime files in one compile list.

## Explicit do-not-mix rule

- Do not include both `apf_genesis_base.sv` and `apf/src/fpga/sim/apf_genesis_base_stub.sv` in the same active compile source list.
- Do not include both scaffold-elaboration source list and full-runtime source list in one build.

## Boundary ownership

- `apf/apf_genesis_base.sv` is the boundary between Pocket shell and imported runtime.
- APF-specific compatibility work stays in this repo:
  - `core_top`
  - `rom_*_stub` scaffolding and presets
  - reset/preload orchestration

- Imported runtime behavior must not be edited to satisfy APF porting.

## Compatibility safety constraints

- Do not modify any imported Genesis_MiSTer runtime file for this milestone.
- Any compatibility fixes (if required) should be done in APF adapters/stubs, not inside MiSTer modules.
- Do not introduce Sega-CD files in this phase.
- SVP may stay excluded unless a compile dependency in `system.sv` explicitly requires it.
- Save/SRAM behavior remains deferred.
- No host-per-read ROM streaming: runtime ROM reads should continue using APF-side local preload path once enabled.

## Source-list strategy (next phase)

1. Keep current scaffold lists as-is for smoke sanity (Tasks 5E/5H).
2. Create a separate draft manifest for imported RTL (`docs/GENESIS_RUNTIME_SOURCE_MANIFEST_DRAFT.md` and `apf/src/fpga/core/genesis_runtime_sources.todo.f`).
3. Run dependency-oriented compile planning against `core_top -> apf_genesis_base.sv` using real runtime files.
4. Update the draft manifest iteratively: add one confirmed missing module at a time.
5. Do not change imported runtime RTL while stabilizing manifest entries.
6. Promote only after a compile pass confirms each module as available in the checked-in runtime source tree.

## 5J target

Task 5J is to run the real dependency-oriented compile pass against the `apf_genesis_base` boundary, discover the first missing runtime modules from Genesis_MiSTer, and update the draft manifest accordingly.

## 5J result (actual)

Task 5J is now completed as a source-inspection-first pass:

- `apf_genesis_base.sv` instantiates one direct runtime module: `system`.
- `system` is not present in this repository.
- No `system` declaration or other Genesis_MiSTer runtime RTL files were found locally.
- Runtime manifests now carry explicit status (`present / missing / excluded`) and a new dependency probe manifest was added.
