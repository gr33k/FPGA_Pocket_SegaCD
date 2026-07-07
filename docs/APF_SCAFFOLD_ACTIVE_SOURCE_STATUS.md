# APF Scaffold Active Source Status

## Active APF scaffold sources

- `apf/src/fpga/core/core_top.v`
- `apf/src/fpga/core/rom_preload_ingress_stub.v`
- `apf/src/fpga/core/rom_local_service_stub.v`
- `apf/src/fpga/core/rom_tiny_local_ram_stub.v`
- `apf/apf_genesis_base.sv`

These are the only files currently activated via `quartus/files_apf_scaffold.qsf`.

## Preflight status

- Task 6C-6D preflight script has been added: [tools/preflight_quartus_analysis_only.sh](tools/preflight_quartus_analysis_only.sh)
- Preflight report is recorded at [docs/QUARTUS_PREFLIGHT_CHECK_REPORT.md](docs/QUARTUS_PREFLIGHT_CHECK_REPORT.md).
- APF scaffold source list remains active only.

## Inactive runtime source root

- `quartus/files_genesis_runtime.qsf` remains a non-buildable placeholder.
- No `third_party/Genesis_MiSTer/rtl/system.sv` or other Genesis runtime files are active.

## Inactive runtime dependencies

- Full Genesis runtime (`rtl/system.sv` and required upstream modules) is still inactive.
- Runtime activation remains planned for later tasks.

## Inactive constraints

- `quartus/FPGA_Pocket_SegaCD.sdc`
- `quartus/files_constraints.qsf`

## APF analysis plan status

- The future analysis-only command is documented in [docs/QUARTUS_ANALYSIS_ONLY_COMMAND_PLAN.md](docs/QUARTUS_ANALYSIS_ONLY_COMMAND_PLAN.md).
- Analysis-only execution itself is not run yet.

## Task 6C-6E status

- Task 6C-6E added and executed a guarded attempt flow in [tools/run_quartus_analysis_only_if_available.sh](tools/run_quartus_analysis_only_if_available.sh).
- [docs/QUARTUS_ANALYSIS_ONLY_RESULT.md](docs/QUARTUS_ANALYSIS_ONLY_RESULT.md) captures the latest preflight + `quartus_map --analysis_and_elaboration` execution state.
- `quartus/files_apf_scaffold.qsf` remains active for APF-owned sources.
- `quartus/files_genesis_runtime.qsf` remains inactive placeholder only.
- `docs/QUARTUS_ANALYSIS_ONLY_RESULT.md` is advisory and does not imply runtime build success.

## Inactive APF packaging

- No Quartus/OpenFPGA package/tcl wrapper is active.
- No synthesis/build automation has been enabled.

## Key limitation

`apf/apf_genesis_base.sv` still depends on imported runtime entry points such as `system.sv`.
Real runtime compilation is still not possible until runtime sources are activated.

## Explicit non-goals

- No synthesis success is claimed.
- No gameplay boot is claimed.
- No Sega-CD / 32X runtime path is active.
- No memory-controller integration is active.
