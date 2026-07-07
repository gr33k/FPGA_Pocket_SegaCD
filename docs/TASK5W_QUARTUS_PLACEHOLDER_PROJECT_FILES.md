# Task 5W — Non-buildable Quartus placeholder project files

## Created files

- `quartus/FPGA_Pocket_SegaCD.qpf`
- `quartus/FPGA_Pocket_SegaCD.qsf`
- `quartus/FPGA_Pocket_SegaCD.sdc`
- `quartus/files_apf_scaffold.qsf`
- `quartus/files_genesis_runtime.qsf`
- `quartus/files_constraints.qsf`

## Why these are placeholders

Each new file begins with explicit markers stating:

- `NON-BUILDABLE PLACEHOLDER`
- `DO NOT RUN SYNTHESIS FROM THIS FILE YET`
- `SOURCE LISTS ARE PROVISIONAL`
- `MIXED-LANGUAGE FLOW IS NOT FINAL`
- `IMPORTED GENESIS_MISTER RTL MUST REMAIN READ-ONLY`

These files are intended for human maintenance and future planning only.
They are not build instructions, not verified compile units, and not ready for
APF/openFPGA synthesis.

## Why no synthesis is run yet

- Runtime compile dependencies are still unresolved and mixed-language ordering is not yet finalized.
- VHDL dependencies remain pending and are not yet folded into a tested build flow.
- APF packaging and output artifact generation is still deferred.
- Genesis-only scaffold remains smoke-test oriented.

## Runtime and scope constraints

- `third_party/Genesis_MiSTer` was added as a submodule and is treated as read-only.
- Runtime APF glue remains outside `third_party`.
- No Sega CD / Mega-CD / 32X modules are included.
- No SDRAM/PSRAM/SRAM controller integration is included.
- No host-per-read ROM streaming behavior is introduced in these project placeholders.
- Runtime ROM behavior is still scaffold-only and does not imply boot capability.

## What each placeholder covers

- `FPGA_Pocket_SegaCD.qpf`: project descriptor skeleton.
- `FPGA_Pocket_SegaCD.qsf`: top-level settings scaffold (placeholder only).
- `FPGA_Pocket_SegaCD.sdc`: constraints placeholder, no timing assertions.
- `files_apf_scaffold.qsf`: APF scaffold source intent.
- `files_genesis_runtime.qsf`: imported runtime root-first placeholder list.
- `files_constraints.qsf`: constraints include placeholder.

## What is intentionally excluded

- `third_party/Genesis_MiSTer/Genesis.sv`
- `third_party/Genesis_MiSTer/sys/sys_top.v`
- MiSTer HPS/IOCTL framework files
- Sega-CD / Mega-CD
- 32X
- APF packaging output files and generated bitstreams
- memory-controller implementation
- save-state and SRAM/CD hardware work

## Next task

Task 5X should validate these placeholders only:

- file existence and marker presence
- forbidden source exclusions
- no generated output files
- no synthesis/packaging claims
