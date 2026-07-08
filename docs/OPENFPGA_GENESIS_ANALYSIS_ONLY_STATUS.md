# openFPGA-Genesis analysis-only status
Generated: 2026-07-08 06:18:57 UTC

Runner: safe analysis-only for upstream openFPGA-Genesis lane
Upstream dir: /work/third_party/openFPGA-Genesis/src/fpga
Upstream qpf: /work/third_party/openFPGA-Genesis/src/fpga/ap_core.qpf
Upstream qsf: /work/third_party/openFPGA-Genesis/src/fpga/ap_core.qsf
Work dir: /work/build/openfpga_genesis_analysis_work/src/fpga
PROJECT_REVISION found: 
TOP_LEVEL_ENTITY: TOP_LEVEL_ENTITY apf_top
DEVICE: set_global_assignment -name DEVICE 5CEBA4F23C8
QIP/SDC assignments: 9

Discovery:
Selected quartus_map: /opt/intelFPGA_lite/quartus/bin/quartus_map
Quartus version: Version 19.1.0 Build 670 09/22/2019 SJ Lite Edition
Command: /opt/intelFPGA_lite/quartus/bin/quartus_map --read_settings_files=on --write_settings_files=off ap_core -c ap_core --analysis_and_elaboration

BLOCKER: none
Analysis exit: 0
Analysis ran: yes
Captured connectivity evidence into: /work/docs/OPENFPGA_GENESIS_CONNECTIVITY_WARNINGS.txt
Captured report inventory into: /work/docs/OPENFPGA_GENESIS_QUARTUS_REPORT_INVENTORY.txt
Generated-output warning: cleanup removed Quartus artifacts from work project.
Do not commit generated Quartus outputs.
Cleaned items:
- /work/build/openfpga_genesis_analysis_work/src/fpga/output_files
- /work/build/openfpga_genesis_analysis_work/src/fpga/db
- /work/build/openfpga_genesis_analysis_work/src/fpga/incremental_db

Safety confirmation: no quartus_fit/asm/sta/cpf invocation.
No synthesis/fitter/assembler/timing/bitstream generation was requested.
No APF packaging was requested.
Analysis status: complete (pre-fit/elab only)
