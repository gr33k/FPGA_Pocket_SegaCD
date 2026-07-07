# APF project validation steps (pre-project checklist)

Before any real Quartus/openFPGA project file is added, complete the following checks.

## 1) Confirm submodule readiness

```bash
git submodule update --init --recursive
```

Expect success and a present `third_party/Genesis_MiSTer` directory.

## 2) Confirm pinned runtime commit

```bash
git -C third_party/Genesis_MiSTer rev-parse HEAD
```

Expect the pinned baseline expected by milestone docs for this phase.

## 3) Confirm APF top exists

```bash
test -f apf/src/fpga/core/core_top.v
```

## 4) Confirm APF wrapper boundary exists

```bash
test -f apf/apf_genesis_base.sv
```

## 5) Confirm runtime root exists

```bash
test -f third_party/Genesis_MiSTer/rtl/system.sv
```

## 6) Confirm simulation-only stub is excluded from real build

```bash
test -f apf/src/fpga/sim/apf_genesis_base_stub.sv
```

Keep this file out of real runtime source manifests.

## 7) Confirm excluded CD/32X paths are not active

- `third_party/Genesis_MiSTer`:
  - no Sega-CD / Mega-CD files
  - no 32X files
- `apf/`:
  - no CD/32X integration files

## 8) Confirm VHDL handling is still deferred to future mixed-language flow

- No active runtime compile flow is enabled in this milestone.
- VHDL-backed dependencies are treated as future Quartus flow requirements.

## 9) Confirm imported runtime is not modified

```bash
git status --short third_party/Genesis_MiSTer | cat
```

Expect no local edits from this APF scaffold worktree for runtime RTL.

## 10) Confirm no generated outputs are committed in-tree

- No `*.sof`, `*.rbf`, `*.rbf_r`, `output_files/`, `db/`, `incremental_db/` entries from real Quartus output should be tracked now.

## 11) Confirm synthesis/build remains disabled

- No new `.qpf/.qsf/.sdc/.tcl` (or similar) project files are created in this milestone.
- No synthesis claim is made until a real project skeleton and dependency order are implemented.

## 12) Confirm generated-output ignore rules are present

```bash
git grep -n "Quartus/OpenFPGA generated outputs" .gitignore
test -f .gitignore
```

Expect `.gitignore` to contain the Task 5T generated-output section and ignore patterns.

## 13) Confirm generated outputs are not committed

```bash
git status --short | head
git ls-files | rg -E '(^|/)build/|(^|/)output_files/|(^|/)db/|(^|/)incremental_db/|(^|/)simulation/|(^|/)greybox_tmp/|\.sof$|\.pof$|\.rbf$|\.rbf_r$|\.jic$|\.rpd$|\.qdf$'
```

Expected result: neither tracked files nor uncommitted generated outputs from Quartus/openFPGA should appear.
