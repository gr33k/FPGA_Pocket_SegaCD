# Quartus Active Skeleton Status (Task 5Z)

## Active skeleton files

- `quartus/FPGA_Pocket_SegaCD.qpf`
- `quartus/FPGA_Pocket_SegaCD.qsf`

These two files are now first active skeletons and remain non-run.

## Still-placeholder files

- `quartus/FPGA_Pocket_SegaCD.sdc`
- `quartus/files_apf_scaffold.qsf`
- `quartus/files_genesis_runtime.qsf`
- `quartus/files_constraints.qsf`

These files still contain non-buildable placeholder constraints/include structure and are intentionally not activated yet.

## Not created yet

- `quartus/openfpga_build.tcl`

No automation script has been created or required in this milestone.

## Not generated

No build outputs are expected:

- `.sof`
- `.rbf`
- `.rbf_r`
- `output_files/`
- `db/`
- `incremental_db/`

## Notes

This is not a successful compile.
This is not synthesis-ready.
No games are expected to boot from this stage.

Validation note:
- Running the current hygiene script after this conversion will show an expected placeholder-marker mismatch for the two active skeleton files.
- Task 6A is expected to update the validator to separate active skeleton handling from placeholder-only policy.
