# Genesis_MiSTer pinned commit (Task 5M)

## Submodule location

`third_party/Genesis_MiSTer`

## Upstream source

`https://github.com/MiSTer-devel/Genesis_MiSTer`

## Pinned commit for this task

- Commit SHA: `adc0c42cfb1fa5d484cc8566767f7d68982bc44a`
- Commit date: `2023-02-24`
- Commit message: `Release 20230224.`

## Why pinned

- Keeps runtime snapshot stable across APF scaffold iterations.
- Avoids accidental drift from floating upstream changes.
- Simplifies provenance and future rollback.

## Verification notes

- Verified locally via:
  - `git -C third_party/Genesis_MiSTer rev-parse HEAD`
  - `git -C third_party/Genesis_MiSTer log -1 --format=%H%n%cs%n%s`

- Expected file origin now available:
  - `third_party/Genesis_MiSTer/rtl/system.sv`
  - additional upstream files as needed by future compile passes.

## Do not edit

- Do not edit `third_party/Genesis_MiSTer` files for APF integration.
- Use compatibility glue in this repo (`apf/`, `docs/`, `tools/`) instead.
