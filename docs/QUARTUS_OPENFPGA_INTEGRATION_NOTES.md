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
- [Task 5U dry-run plan](docs/TASK5U_QUARTUS_PROJECT_DRY_RUN_PLAN.md)
- [Quartus files to create later](docs/QUARTUS_PROJECT_FILES_TO_CREATE_LATER.md)
- [Quartus source-group mapping](docs/QUARTUS_SOURCE_GROUP_MAPPING_DRY_RUN.md)
- [OpenFPGA packaging deferred plan](docs/OPENFPGA_PACKAGING_DEFERRED_PLAN.md)
- [Task 5V quartus docs directory](docs/TASK5V_QUARTUS_DOCS_DIRECTORY.md)
- [Quartus mixed-language notes](quartus/notes_mixed_language.md)
- [Task 5X placeholder hygiene validation](docs/TASK5X_QUARTUS_PLACEHOLDER_HYGIENE_VALIDATION.md)
- [Task 5X hygiene report](docs/QUARTUS_PLACEHOLDER_HYGIENE_REPORT.md)
- [Task 6C-6D analysis preflight plan](docs/TASK6C_6D_QUARTUS_ANALYSIS_PREFLIGHT_PLAN.md)
- [Quartus analysis-only command plan](docs/QUARTUS_ANALYSIS_ONLY_COMMAND_PLAN.md)

Current status:
- Actual project creation and file emission remain fully deferred.
- Real synthesis remains disabled in this milestone.
- Runtime compile remains inactive until real project + manifest + mixed-language flow are implemented.
- Task 5W created the documentation-only `quartus/README.md`, `quartus/notes_mixed_language.md` and placeholder project files.
- Task 5X adds `tools/check_quartus_placeholder_hygiene.sh` to document non-buildable placeholder safety.
- Task 5Y added the controlled activation gate checklist and conversion plan before any placeholder becomes active.
- Task 5Z converted the top-level `FPGA_Pocket_SegaCD.qpf`/`.qsf` into active skeleton form.
- Task 6A updated hygiene validation for mixed active-skeleton and placeholder states.
- Task 6B activated the APF-owned `files_apf_scaffold.qsf` source list only.
- Task 6C-6D added an analysis-only preflight script/report and documented the future `quartus_map` command.
- Task 6F added toolchain discovery for Quartus lookup and override behavior.

## Real runtime boundary rules

- Use `apf/apf_genesis_base.sv` in the real runtime path.
- Do not use `apf/src/fpga/sim/apf_genesis_base_stub.sv` in real synthesis.
- Do not use imported MiSTer top-level `Genesis.sv` as the APF top.
- Keep `sys/sys_top.v` and HPS/IOCTL framework files excluded unless explicitly planned and required later.

## Analysis-only vs. build status

- Task 6C-6E added a guarded execution path:
  - `tools/run_quartus_analysis_only_if_available.sh`
- The command used is `quartus_map --analysis_and_elaboration FPGA_Pocket_SegaCD`.
- This remains an analysis/elaboration-only check, not synthesis, fitter, assembler, or timing analysis.
- Runtime and constraints remain inactive, so failures are expected and advisory.
- Captured outputs are now stored in [docs/QUARTUS_ANALYSIS_ONLY_RESULT.md](docs/QUARTUS_ANALYSIS_ONLY_RESULT.md).
- Task 6G-6H classifies current status as **TOOLCHAIN_UNAVAILABLE** and should drive branch selection in this milestone.

## Activation status after 6B

- `docs/QUARTUS_ACTIVATION_GATE_CHECKLIST.md` defines all pre-activation gates.
- Top-level shell conversion was completed in Task 5Z.
- APF source include activation completed in Task 6B.
- Source include for Genesis runtime remains deferred in `quartus/files_genesis_runtime.qsf`.
- `tools/check_quartus_placeholder_hygiene.sh` now handles active-skeleton and placeholder categories separately.
- `apf/src/fpga/sim/apf_genesis_base_stub.sv` remains excluded from active synthesis paths.
- Synthesis remains disabled and no Quartus run output is expected in this milestone.

## Exclusions and deferrals

- Do not include Sega CD / Mega-CD / 32X modules in this milestone.
- Do not include memory-controller integration, save state, or SRAM/Sdram/PSram controllers yet.
- Keep APF metadata/packaging separate from source-order planning in this task.
- Keep real synthesis stubs out of simulation-only directories.
- Actual Quartus/openFPGA project creation remains deferred.

## Mixed-language validation implication

- Mixed-language support must be handled by the future project configuration, not by editing upstream runtime modules.
- VHDL-backed dependencies found in runtime planning are blockers for pure Verilog-only local probe flows.

## Task 6E status

Task 6E is complete as the guarded analysis-only attempt and reporting step.

## Task 6F expectation

Task 6F should classify the first Quartus findings into:

- APF scaffold issues
- missing Genesis runtime dependency issues
- constraint/project setup issues
- expected-not-yet-active issues

## Task 6F status

Task 6F added deterministic Quartus toolchain discovery to the analysis-only runner.

- Discovery checks `QUARTUS_MAP`, then `QUARTUS_ROOTDIR`, PATH, then common IntelFPGA install locations.
- Multiple matches are sorted and first candidate is used; all discovered candidates are recorded.
- Analysis-only discovery/runs remain advisory and do not imply synthesis readiness.

## 6G-6H next branch

- Selected branch: **A (TOOLCHAIN_UNAVAILABLE)**.
- Current actions remain:
  - Document installation/path setup
  - Keep runtime source activation paused
  - Keep all runtime/constraints/integration changes advisory only
- Analysis classification is guidance, not proof of build correctness.
