# openFPGA Genesis Priority-1 clocking action matrix
Generated: 2026-07-08 17:30:54 UTC

Inputs:
- docs/OPENFPGA_GENESIS_PRIORITY1_CLOCKING_REVIEW.md
- docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md
- docs/OPENFPGA_GENESIS_TIMING_REVIEW_BLOCKER_ORDER.md
- timing priority1 gate note: PRIORITY1_CLOCKING_REVIEW_STILL_REQUIRED

## Action guidance by class
### CODE_16406
- current disposition: needs review before timing gate
- evidence quality: missing
- recommended action type: blocked_until_source_evidence
- next_action: review inherited clk_74b clock routing intent and update QSF/source only if project plan approves non-dedicated routing.

### CODE_16407
- current disposition: needs review before timing gate
- evidence quality: missing
- recommended action type: blocked_until_source_evidence
- next_action: keep bridge_spiclk as reviewed timing intent or document the intended limitation before timing-review handoff.

### CODE_19016
- current disposition: needs review before timing gate
- evidence quality: missing
- recommended action type: source_or_qsf_change_required
- next_action: confirm current_pix_clk is intentional video-mux behavior and capture exact branch conditions in docs.

### CODE_19017
- current disposition: needs review before timing gate
- evidence quality: missing
- recommended action type: source_or_qsf_change_required
- next_action: verify mux branch mapping from selected clock source and confirm stable fanout.

### PLL_RESET_NOT_CONNECTED
- current disposition: needs review before timing gate
- evidence quality: partial
- recommended action type: blocked_until_source_evidence
- next_action: document explicit reset source and lock-recovery intent before timing-review handoff.

## Disposition synthesis
- source_or_qsf_change_required: clocking/pin-reset behavior is present and clear in docs but still requires source or QSF update.
- blocked_until_source_evidence: no source evidence found to satisfy review requirement.
- accept_with_timing_caveat: only when current_pix_clk mux behavior is intentional and verified.
- docs_only_followup: no active instances but item retained for post-hoc documentation.
