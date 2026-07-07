# Quartus Active Skeleton Status (Task 6A-6B)

## Active skeleton files

- `quartus/FPGA_Pocket_SegaCD.qpf`
- `quartus/FPGA_Pocket_SegaCD.qsf`

These two files are active skeletons and remain non-run.

## APF-only scaffold source include

- `quartus/files_apf_scaffold.qsf`

This file is now active as an APF scaffold source list and includes only:
- `apf/src/fpga/core/core_top.v`
- `apf/src/fpga/core/rom_preload_ingress_stub.v`
- `apf/src/fpga/core/rom_local_service_stub.v`
- `apf/src/fpga/core/rom_tiny_local_ram_stub.v`
- `apf/apf_genesis_base.sv`

## Placeholder files still inactive

- `quartus/FPGA_Pocket_SegaCD.sdc`
- `quartus/files_genesis_runtime.qsf`
- `quartus/files_constraints.qsf`

These still carry non-buildable placeholder intent only.

## Not created yet

- `quartus/openfpga_build.tcl`

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
- Task 6A updated the validator for active-skeleton/placeholder distinction.
- Runtime and constraints source includes remain inactive as expected.
- `apf_genesis_base.sv` still depends on runtime entry points not yet active.
