# openFPGA Genesis warning disposition

Generated: 2026-07-08 06:20:14 UTC

- Analysis exit: 0
- Fitter-blocker warning count: 0
- Unknown warning count: 0
- Needs-review warning count: 20
- Harmless warning count: 52
- Final gate decision: **READY_FOR_FITTER_GATE**

This does not prove Pocket boot or runtime correctness.
This only allows the next task to run a controlled fitter-only smoke gate.

## Requested class dispositions

### 12241 (connectivity summary)
- disposition: needs-review
- rationale:
  - 12241 is accepted as pre-fit smoke risk when connectivity detail is not present as detailed text in this analysis output.
  - analysis-only did not emit a detailed text connectivity report in inspected files; this is accepted as pre-fit smoke-risk only.
  - This is not a runtime correctness proof.

### 10259 (SDRAM/default overflow)
- disposition: needs-review
- rationale:
  - 10259 is localized to SDRAM/state math in upstream source.
  - Accepted for this milestone as non-blocking, with a caveat to revisit if fitter/timing/runtime later indicates a concrete issue.

### 10030 / 10858 (ROM/bridge placeholder-like)
- disposition: needs-review / needs-review
- rationale:
  - These warnings are associated with ROM/bridge placeholder and interface-stub paths in the reviewed upstream source.
  - Accepted for this first fitter smoke gate as non-blocking, with follow-up review retained for later milestones.

### Other warnings
- disposition: safe
- rationale:
  - Remaining classes are classified as non-critical for this scaffold-only pre-fitter smoke gate.
  - No hard fitter blockers were identified from the current analysis summaries.

## Gate summary
- If a deeper connectivity text report is still unavailable, this remains an explicit smoke-only caveat.
- No Sega-CD/32X/SAVEs path is enabled in this milestone.
- No ROM runtime correctness claim is being made by this decision.
