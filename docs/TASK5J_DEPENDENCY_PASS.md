# Task 5J: Dependency-oriented planning pass (apf_genesis_base boundary)

## Scope and inspection

For this task we inspected only repository files and did not compile or modify any RTL:

1. `apf/apf_genesis_base.sv` (wrapper boundary file).
2. Queried for module declarations in the repo:
   - `rg -n "^\\s*module\\s+\\w+\\s*\\(" ... -g "*.sv" -g "*.v" -g "*.vhd"`
3. Enumerated present RTL-like files:
   - only scaffold RTL/sim files under `apf/src/fpga/` and `apf/`.
4. Queried for `module system` in the repo (no declaration found).

## What was found

- `apf/apf_genesis_base.sv` directly instantiates:
  - `system u_genesis`.
- The `system` module declaration is **not present** in this repository.
- No imported Genesis_MiSTer `rtl/*.sv|*.v|*.vhd` source files are present locally.
- No `Genesis.sv` or `sys/sys_top.v` style MiSTer wrapper files are present locally.

## Dependency status from this first pass

| Item | Status | Notes |
| --- | --- | --- |
| `apf/apf_genesis_base.sv` | confirmed present | APF boundary wrapper in this repo |
| `system` module source | missing from repo | expected to be imported from Genesis_MiSTer (`rtl/system.sv`) |
| Runtime CPU / VDP / audio modules | missing from repo | expected external/imported modules from Genesis_MiSTer |
| `apf/src/fpga/sim/apf_genesis_base_stub.sv` | intentionally excluded | sim-only scaffold, not for real runtime integration |
| Sega CD modules (`MegaCD`, `SegaCD`, etc.) | intentionally excluded | must not be added for this milestone |
| 32X modules | intentionally excluded | must not be added for this milestone |

## What must stay excluded (for now)

- MiSTer top-level integration wrappers:
  - `Genesis.sv`
  - `sys/sys_top.v`
  - HPS/IOCTL/MiSTer framework files.
- Cartridge/CD/bios support beyond Genesis:
  - Sega CD / Mega-CD loaders and BIOS paths.
- Any real memory controller implementation (SDRAM/PSRAM/SRAM) until the runtime integration plan is ready and explicitly approved.
- Save-state, save-SRAM/CDRAM, or APF runtime disk/image loader paths.

## Why this is not a compile/build pass

- This is a repository-level source-discovery and dependency classification pass only.
- We did not run synthesis or compile/elaboration with full runtime sources.
- We did not alter imported runtime files or create any active Quartus/APF build file.
- No behavior was changed in runtime boundaries.

## Why imported runtime remains unchanged

- Imported Genesis_MiSTer RTL is intentionally kept read-only in this project boundary.
- Compatibility changes, if ever needed, must occur in APF adapter/stub modules.
- This preserves a clean upstream compatibility floor for diffable integration later.

## What must be done in Task 5K

- Add a non-invasive dependency-scanner helper (or documented read-only scan recipe) for module declarations and instantiation usage.
- Use that helper against the real imported Genesis_MiSTer tree (when present) to move from this planning-only state into a confirmed file-level dependency manifest.

