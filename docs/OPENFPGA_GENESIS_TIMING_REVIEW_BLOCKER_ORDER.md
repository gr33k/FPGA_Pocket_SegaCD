# openFPGA Genesis timing-review blocker order
Generated: 2026-07-08 17:32:07 UTC
Reason: prioritize what must be reviewed before timing-review-only gate

Inputs:
- docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md
- docs/OPENFPGA_GENESIS_FITTER_UNKNOWN_WARNING_REVIEW.md
- docs/OPENFPGA_GENESIS_FITTER_RESOURCE_SUMMARY.md
- docs/OPENFPGA_GENESIS_POST_FITTER_GATE.md
- third_party/openFPGA-Genesis/src/fpga/ap_core.qsf
- third_party/openFPGA-Genesis/src/fpga/apf/apf_top.v
- third_party/openFPGA-Genesis/src/fpga/core/core_top.sv

active_timing_blocker_count: 118

## Priority 1 - Clocking and timing-structure risks
- blocks timing-review gate now: yes
- action type: depends_on_class

### CODE_16406
- count: 1
- reason: PLL/clock pin behavior is timing-sensitive in scaffolded top-level
- source: - source not found in captured docs/source snapshots
- recommended next task: resolve clock routing source intent in QSF and document timing-safe behavior
- requires: APF pin-plan + QSF review
- blocks_timing_gate_now: yes

### CODE_16407
- count: 1
- reason: PLL/clock pin behavior is timing-sensitive in scaffolded top-level
- source: - source not found in captured docs/source snapshots
- recommended next task: review REFCLK routing intent before timing review
- requires: APF pin-plan + QSF review
- blocks_timing_gate_now: yes

### CODE_19016
- count: 1
- reason: pixel clock muxing impacts timing path review
- source: - source not found in captured docs/source snapshots
- recommended next task: confirm active branch and fanout before timing gate
- requires: source edits + timing documentation
- blocks_timing_gate_now: yes

### CODE_19017
- count: 1
- reason: pixel clock muxing impacts timing path review
- source: - source not found in captured docs/source snapshots
- recommended next task: confirm active branch and fanout before timing gate
- requires: source edits + timing documentation
- blocks_timing_gate_now: yes

### PLL_RESET_NOT_CONNECTED
- count: 7
- reason: reset and recovery behavior may affect deterministic bring-up
- source: - source not found in captured docs/source snapshots
- recommended next task: document intended reset handling and any required source edits
- requires: source edits + QSF review
- blocks_timing_gate_now: yes


## Priority 2 - APF / pin / I/O assignment risks
- blocks timing-review gate now: yes
- action type: depends_on_class

### INCOMPLETE_IO_ASSIGNMENTS
- count: 0
- status: no active instances
- blocks_timing_gate_now: no
- source review: none
- next step: keep as documentation item until feature expands

### CODE_15714
- count: 1
- reason: unlisted class; treat as low-priority until source verification
- source: - source not found in captured docs/source snapshots
- recommended next task: add explicit source mapping before timing closure
- requires: source review
- blocks_timing_gate_now: yes

### PIN_ASSIGNMENT_WARNING
- count: 0
- status: no active instances
- blocks_timing_gate_now: no
- source review: none
- next step: keep as documentation item until feature expands

### CODE_15610
- count: 8
- reason: unlisted class; treat as low-priority until source verification
- source: - source not found in captured docs/source snapshots
- recommended next task: add explicit source mapping before timing closure
- requires: source review
- blocks_timing_gate_now: yes

### CODE_21074
- count: 1
- reason: unlisted class; treat as low-priority until source verification
- source: - source not found in captured docs/source snapshots
- recommended next task: add explicit source mapping before timing closure
- requires: source review
- blocks_timing_gate_now: yes


## Priority 3 - Bidirectional / tri-state / output-enable risks
- blocks timing-review gate now: yes
- action type: depends_on_class

### CODE_13009
- count: 1
- reason: unlisted class; treat as low-priority until source verification
- source: - source not found in captured docs/source snapshots
- recommended next task: add explicit source mapping before timing closure
- requires: source review
- blocks_timing_gate_now: yes

### CODE_13010
- count: 21
- reason: unlisted class; treat as low-priority until source verification
- source: - source not found in captured docs/source snapshots
- recommended next task: add explicit source mapping before timing closure
- requires: source review
- blocks_timing_gate_now: yes

### CODE_13024
- count: 1
- reason: unlisted class; treat as low-priority until source verification
- source: - source not found in captured docs/source snapshots
- recommended next task: add explicit source mapping before timing closure
- requires: source review
- blocks_timing_gate_now: yes

### CODE_13032
- count: 1
- reason: unlisted class; treat as low-priority until source verification
- source: - source not found in captured docs/source snapshots
- recommended next task: add explicit source mapping before timing closure
- requires: source review
- blocks_timing_gate_now: yes

### CODE_13033
- count: 5
- reason: unlisted class; treat as low-priority until source verification
- source: - source not found in captured docs/source snapshots
- recommended next task: add explicit source mapping before timing closure
- requires: source review
- blocks_timing_gate_now: yes

### CODE_13039
- count: 1
- reason: unlisted class; treat as low-priority until source verification
- source: - source not found in captured docs/source snapshots
- recommended next task: add explicit source mapping before timing closure
- requires: source review
- blocks_timing_gate_now: yes

### CODE_13040
- count: 1
- reason: unlisted class; treat as low-priority until source verification
- source: - source not found in captured docs/source snapshots
- recommended next task: add explicit source mapping before timing closure
- requires: source review
- blocks_timing_gate_now: yes

### CODE_13410
- count: 64
- reason: unlisted class; treat as low-priority until source verification
- source: - source not found in captured docs/source snapshots
- recommended next task: add explicit source mapping before timing closure
- requires: source review
- blocks_timing_gate_now: yes

### NO_OUTPUT_ENABLE
- count: 0
- status: no active instances
- blocks_timing_gate_now: no
- source review: none
- next step: keep as documentation item until feature expands

### CODE_169064
- count: 1
- reason: unlisted class; treat as low-priority until source verification
- source: - source not found in captured docs/source snapshots
- recommended next task: add explicit source mapping before timing closure
- requires: source review
- blocks_timing_gate_now: yes


## Priority 4 - Fast I/O / register assignment risks
- blocks timing-review gate now: yes
- action type: depends_on_class

### IGNORED_FAST_IO_WILDCARD
- count: 0
- status: no active instances
- blocks_timing_gate_now: no
- source review: none
- next step: keep as documentation item until feature expands

### CODE_176251
- count: 1
- reason: unlisted class; treat as low-priority until source verification
- source: - source not found in captured docs/source snapshots
- recommended next task: add explicit source mapping before timing closure
- requires: source review
- blocks_timing_gate_now: yes


## Cross-checks
- current gate decision: REVIEW_FITTER_WARNINGS_FIRST
- priority1 clocking gate decision: **PRIORITY1_CLOCKING_REVIEW_STILL_REQUIRED**
- top active priority groups should remain REVIEW_FITTER_WARNINGS_FIRST until classes are resolved

- Priority 1 gate remains review-required before timing-review handoff.

## Required next step
- Keep gate at REVIEW_FITTER_WARNINGS_FIRST until high-risk timing groups are reviewed and documented.
