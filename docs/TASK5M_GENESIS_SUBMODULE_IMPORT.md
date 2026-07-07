# Task 5M: Genesis_MiSTer git submodule import (scaffold phase)

## Objective

Task 5M adds `Genesis_MiSTer` as a pinned git submodule under `third_party/Genesis_MiSTer` for planned APF runtime integration.

The import is read-only from APF perspective: imported runtime files are kept outside of `apf/` scaffolding and are not modified.

## Executed task details

- Added runtime via submodule:

```bash

git submodule add https://github.com/MiSTer-devel/Genesis_MiSTer.git third_party/Genesis_MiSTer
git submodule update --init --recursive
```

- Submodule is recorded in:
  - `.gitmodules`
  - gitlink entry `third_party/Genesis_MiSTer`

- Verified remote origin in submodule:
  - `https://github.com/MiSTer-devel/Genesis_MiSTer.git`

## Pinned revision

Current submodule head is:

- `adc0c42cfb1fa5d484cc8566767f7d68982bc44a`
- Commit date: `2023-02-24`
- Commit subject: `Release 20230224.`

## Integration constraints (kept)

- No Sega CD/32X files were enabled in APF runtime path.
- APF wrapper/scaffold remains separated from imported runtime.
- Imported runtime is not modified in this repository.
- This import is for dependency planning/integration readiness only; full compile/build integration is still pending.

## What changed outside imported runtime

- APF scaffold documents/manifests updated to point expected runtime locations to `third_party/Genesis_MiSTer/`.

## Next steps

- Continue with dependency compile planning and manifest tightening in upcoming tasks.
- Keep any compatibility glue in APF layers (`apf/`, `docs/`, `tools/`) until runtime integration compile proves complete.
