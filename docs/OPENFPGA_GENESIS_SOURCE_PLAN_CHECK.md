# Task 6Y openFPGA source plan check

Generated: 2026-07-08T17:31:00Z
Advisory check only; exits 0 even if WARNs exist.

PASS: Upstream path exists: ./third_party/openFPGA-Genesis
PASS: Required upstream file exists: ./third_party/openFPGA-Genesis/README.md
PASS: Required upstream file exists: ./third_party/openFPGA-Genesis/src/fpga/core/core_top.sv
PASS: Required upstream file exists: ./third_party/openFPGA-Genesis/src/fpga/apf/apf_top.v
PASS: Required upstream file exists: ./third_party/openFPGA-Genesis/src/fpga/core/rtl/system.sv
PASS: Required planning doc exists: ./docs/OPENFPGA_GENESIS_UPSTREAM_FILE_INVENTORY.md
PASS: Required planning doc exists: ./docs/OPENFPGA_GENESIS_ACTIVE_SOURCE_PLAN.md
PASS: Candidate QSF exists: ./quartus/files_openfpga_genesis_runtime.candidate.qsf
PASS: Candidate QSF has required header markers
PASS: Candidate QSF excludes Sega CD
PASS: Candidate QSF excludes 32X
PASS: Top QSF does not include files_openfpga_genesis_runtime.candidate.qsf
PASS: OpenFPGA plan has no Genesis_MiSTer active reference

## Summary
PASS checks: 13
WARN checks: 0
Result: advisory
