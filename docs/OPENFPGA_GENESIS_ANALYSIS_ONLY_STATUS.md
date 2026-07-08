# openFPGA-Genesis analysis-only status
Generated: 2026-07-08 02:02:17 UTC

Runner: safe analysis-only for upstream openFPGA-Genesis lane
Upstream dir: /work/third_party/openFPGA-Genesis/src/fpga
Upstream qpf: /work/third_party/openFPGA-Genesis/src/fpga/ap_core.qpf
Upstream qsf: /work/third_party/openFPGA-Genesis/src/fpga/ap_core.qsf
Work dir: /work/build/openfpga_genesis_analysis_work/src/fpga
PROJECT_REVISION found: PROJECT_REVISION = "ap_core"
TOP_LEVEL_ENTITY: TOP_LEVEL_ENTITY apf_top
DEVICE: set_global_assignment -name DEVICE 5CEBA4F23C8
QIP/SDC assignments: 9

Discovery:
Selected quartus_map: /opt/intelFPGA_lite/quartus/bin/quartus_map
Command: /opt/intelFPGA_lite/quartus/bin/quartus_map --read_settings_files=on --write_settings_files=off ap_core -c ap_core --analysis_and_elaboration

BLOCKER: none
Analysis exit: 0
Log file: /work/docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_LOG.txt
Generated-output warning: cleanup removed Quartus artifacts from work project.
Do not commit generated Quartus outputs.
Cleaned items:
- /work/build/openfpga_genesis_analysis_work/src/fpga/output_files
- /work/build/openfpga_genesis_analysis_work/src/fpga/db
- /work/build/openfpga_genesis_analysis_work/src/fpga/incremental_db

Safety confirmation: no quartus_fit/asm/sta/cpf invocation.
No synthesis/fitter/assembler/timing/bitstream generation was requested.
No APF packaging was requested.
