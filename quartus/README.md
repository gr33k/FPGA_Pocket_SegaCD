# Quartus/openFPGA Documentation Directory (Task 5V)

This directory currently contains documentation only.

No actual Quartus project files are created in this task.

- No `.qpf/.qsf/.sdc/.tcl/.qip` are added.
- No generated outputs (`.sof/.rbf/.rbf_r`) are added.
- No real synthesis build is enabled.
- No runtime compilation success is claimed.
- No game booting is expected at this milestone.

## Why this is documentation-only

Task 5V intentionally creates the directory and planning notes only.
The real Quartus/openFPGA project files remain deferred until a later task creates them in a controlled follow-up.

## Active project plan constraints

- `third_party/Genesis_MiSTer` remains read-only runtime input.
- APF glue / wrappers stay in `apf/` and are not mixed into `third_party`.
- Simulation-only files are excluded from real synthesis.
- Sega CD / Mega-CD and 32X are excluded.
- Memory-controller integration (SDRAM/PSRAM/SRAM controller paths) is deferred.
- APF packaging output generation is deferred.

## Future project files intentionally absent right now

- `quartus/FPGA_Pocket_SegaCD.qpf`
- `quartus/FPGA_Pocket_SegaCD.qsf`
- `quartus/FPGA_Pocket_SegaCD.sdc`
- `quartus/files_apf_scaffold.qsf`
- `quartus/files_genesis_runtime.qsf`
- `quartus/files_constraints.qsf`
- `quartus/openfpga_build.tcl`

## Related planning docs

- [Task 5S skeleton checklist](../docs/TASK5S_QUARTUS_OPENFPGA_PROJECT_SKELETON_CHECKLIST.md)
- [Task 5U dry-run plan](../docs/TASK5U_QUARTUS_PROJECT_DRY_RUN_PLAN.md)
- [Task 5V docs directory plan](../docs/TASK5V_QUARTUS_DOCS_DIRECTORY.md)
- [Quartus project file checklist](../docs/QUARTUS_PROJECT_FILE_CHECKLIST.md)
- [OpenFPGA packaging deferred plan](../docs/OPENFPGA_PACKAGING_DEFERRED_PLAN.md)

