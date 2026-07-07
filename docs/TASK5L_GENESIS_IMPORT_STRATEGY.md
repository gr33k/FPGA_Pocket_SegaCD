# Task 5L: Genesis_MiSTer import strategy decision

## Decision (frozen for next milestones)

The import strategy is **git submodule**.

- Upstream repository: `https://github.com/MiSTer-devel/Genesis_MiSTer`
- Target local path: `third_party/Genesis_MiSTer`
- Scope: this task is documentation only; the submodule is not added yet.

## Why this strategy

- Keeps upstream runtime RTL clearly separated from APF scaffold code.
- Makes runtime provenance explicit and auditable by commit.
- Allows explicit pinning to known-good upstream revisions.
- Avoids copy-heavy vendoring drift and local-path fragility.
- Keeps APF glue and compatibility work in this repository.

## Constraints still enforced

- This task does not import the runtime, does not add submodule references yet.
- No Sega CD, no 32X, and no real memory-controller integration is introduced.
- Imported runtime remains unchanged (read-only).
- APF-specific changes remain in:
  - `apf/`
  - `apf/src/fpga/core/`
  - `docs/`
  - `tools/`
- No files in a future `third_party/Genesis_MiSTer` path are edited by APF work unless explicitly moved into a documented exception process.

## Task 5M preview

Task 5M will add the actual pinned submodule and then the dependency manifests can be updated with real `third_party/Genesis_MiSTer` paths after files are present.
