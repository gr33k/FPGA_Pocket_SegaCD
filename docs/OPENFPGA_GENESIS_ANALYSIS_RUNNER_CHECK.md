# openFPGA Genesis analysis-runner check (advisory)

Generated: 2026-07-08T16:14:17Z

PASS: Runner executable: /Users/phassold/Projects/FPGA_Pocket_SegaCD/tools/run_openfpga_genesis_analysis_only.sh
PASS: Runner contains --analysis_and_elaboration
PASS: Runner uses build/openfpga_genesis_analysis_work
PASS: Runner references upstream project path third_party/openFPGA-Genesis/src/fpga
PASS: Runner has connectivity capture helpers
WARN: Runner does not clearly inspect output_files/db-style report paths
PASS: Runner references cleanup directory output_files
PASS: Runner avoids deleting UPSTREAM_DIR
PASS: Runner does not cd into UPSTREAM_DIR
PASS: Runner does not reference forbidden tool token as command: quartus_fit
PASS: Runner does not reference forbidden tool token as command: quartus_asm
PASS: Runner does not reference forbidden tool token as command: quartus_sta
PASS: Runner does not reference forbidden tool token as command: quartus_cpf
PASS: Status file exists: /Users/phassold/Projects/FPGA_Pocket_SegaCD/docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md
PASS: Connectivity warning evidence file exists: /Users/phassold/Projects/FPGA_Pocket_SegaCD/docs/OPENFPGA_GENESIS_CONNECTIVITY_WARNINGS.txt
PASS: Connectivity capture includes detailed report content.
PASS: Connectivity evidence includes structured capture sections.

## Summary
PASS: 16
WARN: 1
FAIL: 0
Result: PASS (advisory)

Result: PASS=16 WARN=1 FAIL=0
PASS: Check complete: /Users/phassold/Projects/FPGA_Pocket_SegaCD/docs/OPENFPGA_GENESIS_ANALYSIS_RUNNER_CHECK.md
