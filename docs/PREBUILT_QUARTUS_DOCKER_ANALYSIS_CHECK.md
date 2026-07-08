# Prebuilt Quartus Docker analysis checker
Generated: 2026-07-08 06:20:18 UTC
Script: tools/docker_run_openfpga_genesis_analysis_prebuilt.sh

PASS: run script exists
PASS: run script executable
PASS: prebuilt status file exists
PASS: run log exists
PASS: supports QUARTUS_PREBUILT_IMAGE override
PASS: container probes for quartus_map command
PASS: container probes quartus_map --version
PASS: run log captures analysis script location check
PASS: runner invocation present
PASS: runner checker invocation present
PASS: wrapper says no forbidden synth/impl path executed
PASS: no disallowed Quartus commands in prebuilt wrapper
PASS: openFPGA status file was refreshed and includes analysis markers
PASS: analysis exit captured: 0

## Summary
Result: PASS
This is an advisory checker (no hard-fail on stale evidence).
PASS: check completed.
