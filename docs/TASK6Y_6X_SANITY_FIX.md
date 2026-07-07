# Task 6Y: Sanitize 6X source plan and align candidate QSF

## Summary

Task `6Y` refreshed the Task 6X plan artifacts to remove stale scaffold assumptions and to align the openFPGA Genesis planning lane with upstream project intent.

## What was fixed

- Task 6X was not a hard failure; it was a viable planning baseline.
- Candidate QSF planning was corrected from old scaffold assumptions (`DEVICE 10M50...`, `TOP_LEVEL_ENTITY core_top`) to upstream assumptions (`DEVICE 5CEBA4F23C8`, `TOP_LEVEL_ENTITY apf_top`).
- `quartus/files_openfpga_genesis_runtime.candidate.qsf` remains explicitly inactive and planning-only.
- `.v` and `.sv` source classifications were aligned to use `VERILOG_FILE` / `SYSTEMVERILOG_FILE` accordingly.

## Verification performed

- Ran plan checkers and skeleton/status checkers to regenerate reports from the project state.
- Confirmed `third_party/openFPGA-Genesis` remains the intended source lane.
- Confirmed no activation of `Genesis_MiSTer` in the candidate path.
- No Quartus synthesis/fitter/timing/analyzer steps were run.

## Constraints remaining

- Quartus is still required on the build host before any real compile path can start.
- `Genesis_MiSTer` remains reference-only.
- Sega CD / 32X remain excluded.
- This is still not game-boot capable in this milestone.
