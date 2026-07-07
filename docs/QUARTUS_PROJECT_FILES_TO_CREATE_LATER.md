# Future Quartus/openFPGA files to create (documentation and placeholder tracking)

The following files were created in Task 5W as non-buildable placeholders:

- `quartus/FPGA_Pocket_SegaCD.qpf`
- `quartus/FPGA_Pocket_SegaCD.qsf`
- `quartus/FPGA_Pocket_SegaCD.sdc`
- `quartus/files_apf_scaffold.qsf`
- `quartus/files_genesis_runtime.qsf`
- `quartus/files_constraints.qsf`

These files are not active build inputs yet and must remain:

- `NON-BUILDABLE PLACEHOLDER`
- `DO NOT RUN SYNTHESIS FROM THIS FILE YET`

## Still deferred after Task 5W

- `quartus/openfpga_build.tcl`
- Real generated output settings and active pin/clock/constraint enforcement
- Real active source manifests beyond placeholders
- APF packaging output generation
- Runtime compile-active Quartus launch scripts

## Task history

- Task 5V created initial Quartus docs-only state.
- Task 5W added placeholder `.qpf/.qsf/.sdc` and include-group files.
- Task 5X is expected to validate the placeholder hygiene, not add synthesis.
