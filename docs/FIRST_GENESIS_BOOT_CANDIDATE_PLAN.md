# First Genesis boot candidate plan

Generated: 2026-07-10 21:02:30 UTC

## Goal

Create the first Genesis-only Analogue Pocket/openFPGA boot candidate from the integrated `third_party/openFPGA-Genesis` source lane.

## Scope

- Genesis only
- No Sega CD
- No 32X
- No ROM bundled
- No runtime correctness claim
- No Pocket boot claim unless real hardware is tested

## Known starting state

- `third_party/openFPGA-Genesis` is the active upstream lane
- Prior `quartus_map` smoke passed
- Prior `quartus_fit` smoke passed
- Fitter smoke result: `FITTER_SMOKE_PASS`
- Priority-1 clocking/timing review warnings still exist

## Intent of Task 8A

This task intentionally attempts:
- timing report generation
- assembler run
- artifact capture
- openFPGA SD candidate staging

This task does not treat the existing warning-review gate as a reason to stop before generating a first hardware candidate. Risk must be documented honestly.

## Artifact hygiene

- Generated artifacts stay under ignored `build/` paths
- No generated Quartus outputs are committed
- No ROMs or BIOS payloads are committed
- Only docs and scripts may be committed
