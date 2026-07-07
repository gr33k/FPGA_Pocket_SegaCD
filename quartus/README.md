# Quartus/openFPGA Documentation & Placeholder Skeletons (Task 5W)

Task 5V created Quartus project planning documentation.
Task 5W now adds non-buildable placeholder Quartus project files under `quartus/`.

## Current state

The following files now exist as **human-maintained placeholders only**:

- `quartus/FPGA_Pocket_SegaCD.qpf`
- `quartus/FPGA_Pocket_SegaCD.qsf`
- `quartus/FPGA_Pocket_SegaCD.sdc`
- `quartus/files_apf_scaffold.qsf`
- `quartus/files_genesis_runtime.qsf`
- `quartus/files_constraints.qsf`

These files:

- Contain explicit header markers:
  - `NON-BUILDABLE PLACEHOLDER`
  - `DO NOT RUN SYNTHESIS FROM THIS FILE YET`
  - `SOURCE LISTS ARE PROVISIONAL`
  - `MIXED-LANGUAGE FLOW IS NOT FINAL`
  - `IMPORTED GENESIS_MISTER RTL MUST REMAIN READ-ONLY`
- Are for planning and scaffold hygiene only.
- Do not include executable build settings or output generation.

## What is still disabled

- No real synthesis/build flow is enabled in-tree.
- No APF package output is generated in this milestone.
- No real timing closure/clock strategy is finalized in `*.sdc`.
- No `*.sof`, `*.rbf`, `*.rbf_r`, `output_files/`, `db/`, or `incremental_db/` outputs are expected from this scaffold stage.

## Exclusions still enforced

- `third_party/Genesis_MiSTer` is treated as read-only runtime input for now.
- Sega-CD / Mega-CD and 32X remain excluded.
- Memory-controller integration (SDRAM/PSRAM/SRAM) remains deferred.
- Simulation-only artifacts (including APF core-top stub testbench paths) remain excluded from real build scaffolds.

## Future work

- Task 5X should perform placeholder-hygiene validation only.
- A later task will introduce non-build automation and a real project-file wiring pass.
