# Quartus/openFPGA Integration Notes

## Planned integration principles

- Final file ordering and build orchestration should be owned by the Quartus/openFPGA project configuration.
- The project must support Verilog, SystemVerilog, and VHDL as required by runtime dependencies.
- `core_top` is the intended APF top for now.

Related checklist docs added in Task 5S:
- [Task 5S skeleton checklist](docs/TASK5S_QUARTUS_OPENFPGA_PROJECT_SKELETON_CHECKLIST.md)
- [Quartus project file checklist](docs/QUARTUS_PROJECT_FILE_CHECKLIST.md)
- [APF build output ignore plan](docs/APF_BUILD_OUTPUT_IGNORE_PLAN.md)
- [APF project validation steps](docs/APF_PROJECT_VALIDATION_STEPS.md)

## Real runtime boundary rules

- Use `apf/apf_genesis_base.sv` in the real runtime path.
- Do not use `apf/src/fpga/sim/apf_genesis_base_stub.sv` in real synthesis.
- Do not use imported MiSTer top-level `Genesis.sv` as the APF top.
- Keep `sys/sys_top.v` and HPS/IOCTL framework files excluded unless explicitly planned and required later.

## Exclusions and deferrals

- Do not include Sega CD / Mega-CD / 32X modules in this milestone.
- Do not include memory-controller integration, save state, or SRAM/Sdram/PSram controllers yet.
- Keep APF metadata/packaging separate from source-order planning in this task.
- Keep real synthesis stubs out of simulation-only directories.
- Actual Quartus/openFPGA project creation remains deferred.

## Mixed-language validation implication

- Mixed-language support must be handled by the future project configuration, not by editing upstream runtime modules.
- VHDL-backed dependencies found in runtime planning are blockers for pure Verilog-only local probe flows.

## Task 5S follow-up

- Task 5S should define a future skeleton checklist for Quartus/openFPGA files and validation steps without creating any files.
