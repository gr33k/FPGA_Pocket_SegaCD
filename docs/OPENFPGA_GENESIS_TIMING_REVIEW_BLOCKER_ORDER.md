# openFPGA Genesis timing-review blocker order
Generated: 2026-07-08 17:30:54 UTC
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
## Priority 1
- blocks timing-review gate now: yes
- action type: depends_on_class

### NON_DEDICATED_CLOCK_ROUTING
- count: 0
- status: no active instances
- blocks_timing_gate_now: no
- source review: none
- next step: keep as documentation item until feature expands

### CODE_16406
- count: 1
- reason: PLL/clock pin behavior is timing-sensitive in scaffolded top-level
- source: - third_party/openFPGA-Genesis/src/fpga/apf/apf_top.v:49:input   wire            clk_74b, // mainclk1 
- recommended next task: keep as manual timing-review item for first clocking cleanup
- requires: APF pin-plan + QSF review
- blocks_timing_gate_now: yes

### CODE_16407
- count: 1
- reason: PLL/clock pin behavior is timing-sensitive in scaffolded top-level
- source: - third_party/openFPGA-Genesis/src/fpga/apf/apf_top.v:49:input   wire            clk_74b, // mainclk1 
- recommended next task: keep as manual timing-review item for first clocking cleanup
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
- source: - third_party/openFPGA-Genesis/src/fpga/core/core_top.sv:206://   [23:16] rstick_x
- recommended next task: document intended reset handling and any required source edits
- requires: source edits + QSF review
- blocks_timing_gate_now: yes


## Priority 2 - APF / pin / I/O assignment risks
## Priority 2
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
- reason: incomplete APF assignment map creates timing and integration risk
- source: - source not found in captured docs/source snapshots
- recommended next task: align APF pin mapping and keep unimplemented ports documented
- requires: QSF + source review
- blocks_timing_gate_now: yes

### PIN_ASSIGNMENT_WARNING
- count: 0
- status: no active instances
- blocks_timing_gate_now: no
- source review: none
- next step: keep as documentation item until feature expands

### CODE_15610
- count: 8
- reason: input/output constant/no-driver conditions can create timing-opaque paths
- source: - source not found in captured docs/source snapshots
- recommended next task: confirm expected stubs and document intentional placeholders
- requires: source review
- blocks_timing_gate_now: yes

### CODE_21074
- count: 1
- reason: input/output constant/no-driver conditions can create timing-opaque paths
- source: - source not found in captured docs/source snapshots
- recommended next task: confirm expected stubs and document intentional placeholders
- requires: source review
- blocks_timing_gate_now: yes


## Priority 3 - Bidirectional / tri-state / output-enable risks
## Priority 3
- blocks timing-review gate now: yes
- action type: depends_on_class

### CODE_13009
- count: 1
- reason: tri-state or bidirectional behavior affects timing analysis and board-level behavior
- source: - source not found in captured docs/source snapshots
- recommended next task: keep these as first-pass APF pin and I/O topology checks
- requires: source review + optional pin-constraint updates
- blocks_timing_gate_now: yes

### CODE_13010
- count: 21
- reason: tri-state or bidirectional behavior affects timing analysis and board-level behavior
- source: - source not found in captured docs/source snapshots
- recommended next task: keep these as first-pass APF pin and I/O topology checks
- requires: source review + optional pin-constraint updates
- blocks_timing_gate_now: yes

### CODE_13024
- count: 1
- reason: tri-state or bidirectional behavior affects timing analysis and board-level behavior
- source: - source not found in captured docs/source snapshots
- recommended next task: keep these as first-pass APF pin and I/O topology checks
- requires: source review + optional pin-constraint updates
- blocks_timing_gate_now: yes

### CODE_13032
- count: 1
- reason: tri-state or bidirectional behavior affects timing analysis and board-level behavior
- source: - source not found in captured docs/source snapshots
- recommended next task: keep these as first-pass APF pin and I/O topology checks
- requires: source review + optional pin-constraint updates
- blocks_timing_gate_now: yes

### CODE_13033
- count: 5
- reason: tri-state or bidirectional behavior affects timing analysis and board-level behavior
- source: - source not found in captured docs/source snapshots
- recommended next task: keep these as first-pass APF pin and I/O topology checks
- requires: source review + optional pin-constraint updates
- blocks_timing_gate_now: yes

### CODE_13039
- count: 1
- reason: tri-state or bidirectional behavior affects timing analysis and board-level behavior
- source: - source not found in captured docs/source snapshots
- recommended next task: keep these as first-pass APF pin and I/O topology checks
- requires: source review + optional pin-constraint updates
- blocks_timing_gate_now: yes

### CODE_13040
- count: 1
- reason: tri-state or bidirectional behavior affects timing analysis and board-level behavior
- source: - source not found in captured docs/source snapshots
- recommended next task: keep these as first-pass APF pin and I/O topology checks
- requires: source review + optional pin-constraint updates
- blocks_timing_gate_now: yes

### CODE_13410
- count: 64
- reason: tri-state or bidirectional behavior affects timing analysis and board-level behavior
- source: - source not found in captured docs/source snapshots
- recommended next task: keep these as first-pass APF pin and I/O topology checks
- requires: source review + optional pin-constraint updates
- blocks_timing_gate_now: yes

### NO_OUTPUT_ENABLE
- count: 0
- status: no active instances
- blocks_timing_gate_now: no
- source review: none
- next step: keep as documentation item until feature expands

### CODE_169064
- count: 1
- reason: tri-state or bidirectional behavior affects timing analysis and board-level behavior
- source: - source not found in captured docs/source snapshots
- recommended next task: keep these as first-pass APF pin and I/O topology checks
- requires: source review + optional pin-constraint updates
- blocks_timing_gate_now: yes


## Priority 4 - Fast I/O / register assignment risks
## Priority 4
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
- reason: wildcard fast I/O behavior can hide timing constraints for output registers
- source: - source not found in captured docs/source snapshots
- recommended next task: migrate to explicit per-signal timing intent before timing review
- requires: QSF review
- blocks_timing_gate_now: yes


## Priority 5 - Low-priority inherited / smoke-only
## Priority 5
- blocks timing-review gate now: no
- action type: depends_on_class

### CODE_10259
- count: 1
- reason: these are retained legacy/smoke-only classes in this milestone
- source: inherited openFPGA scaffold behavior
- recommended next task: monitor while enabling real ROM and controller paths
- requires: documentation review
- blocks_timing_gate_now: no

### CODE_12241
- count: 1
- reason: these are retained legacy/smoke-only classes in this milestone
- source: inherited openFPGA scaffold behavior
- recommended next task: monitor while enabling real ROM and controller paths
- requires: documentation review
- blocks_timing_gate_now: no

### CODE_10030
- count: 13
- reason: these are retained legacy/smoke-only classes in this milestone
- source: inherited openFPGA scaffold behavior
- recommended next task: monitor while enabling real ROM and controller paths
- requires: documentation review
- blocks_timing_gate_now: no

### CODE_10858
- count: 5
- reason: these are retained legacy/smoke-only classes in this milestone
- source: inherited openFPGA scaffold behavior
- recommended next task: monitor while enabling real ROM and controller paths
- requires: documentation review
- blocks_timing_gate_now: no

### CODE_14284
- count: 2
- reason: synthesized-away or inferred resource behavior in stubbed paths
- source: - source not found in captured docs/source snapshots
- recommended next task: revisit when ROM/memory paths are enabled
- requires: documentation review
- blocks_timing_gate_now: no

### CODE_14285
- count: 2
- reason: synthesized-away or inferred resource behavior in stubbed paths
- source: - source not found in captured docs/source snapshots
- recommended next task: revisit when ROM/memory paths are enabled
- requires: documentation review
- blocks_timing_gate_now: no

### CODE_14320
- count: 13
- reason: synthesized-away or inferred resource behavior in stubbed paths
- source: - source not found in captured docs/source snapshots
- recommended next task: revisit when ROM/memory paths are enabled
- requires: documentation review
- blocks_timing_gate_now: no

### CODE_287013
- count: 1
- reason: synthesized-away or inferred resource behavior in stubbed paths
- source: - source not found in captured docs/source snapshots
- recommended next task: revisit when ROM/memory paths are enabled
- requires: documentation review
- blocks_timing_gate_now: no

### CODE_292013
- count: 1
- reason: these are retained legacy/smoke-only classes in this milestone
- source: inherited openFPGA scaffold behavior
- recommended next task: monitor while enabling real ROM and controller paths
- requires: documentation review
- blocks_timing_gate_now: no


## Cross-checks
- current gate decision: REVIEW_FITTER_WARNINGS_FIRST
- priority1 clocking gate decision: Current priority1 gate decision: **PRIORITY1_CLOCKING_REVIEW_STILL_REQUIRED**
- top active priority groups should remain REVIEW_FITTER_WARNINGS_FIRST until classes are resolved

- Priority 1 gate is clear for timing-review handoff, but lower-priority groups remain active.

## Required next step
- Keep gate at REVIEW_FITTER_WARNINGS_FIRST until high-risk timing groups are reviewed and documented.
