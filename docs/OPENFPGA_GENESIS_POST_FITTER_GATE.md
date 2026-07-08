# openFPGA Genesis post-fitter gate
Generated: 2026-07-08 09:14:15 UTC

## Inputs
- Fitter smoke status: /Users/phassold/Projects/FPGA_Pocket_SegaCD/docs/OPENFPGA_GENESIS_FITTER_SMOKE_STATUS.md
- Fitter smoke check: /Users/phassold/Projects/FPGA_Pocket_SegaCD/docs/OPENFPGA_GENESIS_FITTER_SMOKE_CHECK.md
- Warning summary: /Users/phassold/Projects/FPGA_Pocket_SegaCD/docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md
- Resource summary: /Users/phassold/Projects/FPGA_Pocket_SegaCD/docs/OPENFPGA_GENESIS_FITTER_RESOURCE_SUMMARY.md

## Gate decision
Current gate decision: **REVIEW_FITTER_WARNINGS_FIRST**

## Evidence
Map exit code: 0
Fitter exit code: 0
Fitter attempted: yes
Fitter smoke check result: PASS
Warning decision: REVIEW_FITTER_WARNINGS_FIRST

## Scope constraints for this task
- Assembler was not run
- Timing analysis was not run
- Bitstream was not intentionally generated
- APF packaging was not run
- Pocket boot was not proven
- Runtime correctness was not proven

## Rationale
- No Quartus assembler/timing/bitstream flow is enabled in this gate
- This gate only controls transition from fitter smoke review to the next timing-review-only step

- Review first: one or more warnings need explicit confirmation before timing review.
