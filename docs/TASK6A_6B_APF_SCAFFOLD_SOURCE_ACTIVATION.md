# Task 6A-6B: APF scaffold source activation

## What changed

Task 6A-6B updates the Quartus hygiene workflow and activates only the APF scaffold source include file.

This milestone keeps the project in a non-run, no-synthesis scaffold state while moving from placeholder-only state to an active scaffold source list for APF-owned files.

## 6A: Update hygiene validator for mixed file roles

`tools/check_quartus_placeholder_hygiene.sh` was updated to distinguish:

- Category A: active skeleton files
  - `quartus/FPGA_Pocket_SegaCD.qpf`
  - `quartus/FPGA_Pocket_SegaCD.qsf`
- Category B: non-buildable placeholders
  - `quartus/FPGA_Pocket_SegaCD.sdc`
  - `quartus/files_genesis_runtime.qsf`
  - `quartus/files_constraints.qsf`
- Category C: APF scaffold source include (active list only)
  - `quartus/files_apf_scaffold.qsf`

Each category now has its own marker expectations, and the script still:

- uses `grep` only,
- does not run synthesis,
- does not create build output,
- exits 0 as an advisory check even if failures are found.

## 6B: Activate APF scaffold source include file only

`quartus/files_apf_scaffold.qsf` now contains an active source list limited to APF-owned scaffold files:

- `apf/src/fpga/core/core_top.v`
- `apf/src/fpga/core/rom_preload_ingress_stub.v`
- `apf/src/fpga/core/rom_local_service_stub.v`
- `apf/src/fpga/core/rom_tiny_local_ram_stub.v`
- `apf/apf_genesis_base.sv` (as a `SYSTEMVERILOG_FILE`)

No Genesis_MiSTer runtime source entries are active yet.

## Why this split matters

The new validation now treats top-level active skeleton files separately from placeholder and scaffold-include files. This allows a controlled scaffold milestone where:

- top-level project shell files can be active-but-not-run,
- some source includes can be active for APF-owned files,
- runtime source wiring and full Quartus flow remain explicitly inactive.

## What remains intentionally inactive

- Genesis runtime source list (`quartus/files_genesis_runtime.qsf`) is still placeholder.
- Constraint list (`quartus/files_constraints.qsf`) and SDC (`quartus/FPGA_Pocket_SegaCD.sdc`) are still placeholders.
- APF packaging output flow and any runtime compile automation remain deferred.
- Imported Genesis_MiSTer runtime remains read-only and is not modified.
- Sega CD and 32X files remain excluded.

`apf_genesis_base.sv` still depends on `system.sv` and upstream runtime dependencies.
A build would fail without those active runtime files, which is expected for this milestone.

## Why generated outputs are still forbidden

No Quartus run is enabled and no outputs should be produced in-tree yet. This includes `.sof`, `.rbf`, `.rbf_r`, `output_files/`, and `db/`.

## Task 6C next

Task 6C should document a controlled Quartus analysis-only plan and the exact future command(s) for scaffold verification, while still not running Quartus or producing outputs in this phase.
