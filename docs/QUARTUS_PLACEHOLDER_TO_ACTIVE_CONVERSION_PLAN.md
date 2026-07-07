# Placeholder to Active Conversion Plan (Task 5Y)

This is a phase-gated conversion roadmap. Each phase is intentionally small and non-harmful if isolated.

## Phase A — Baseline hygiene and documentation

- Keep `quartus/*.qpf|qsf|sdc` and include files in placeholder mode.
- Keep `NON-BUILDABLE PLACEHOLDER` and `DO NOT RUN SYNTHESIS FROM THIS FILE YET` markers.
- Run Task 5Y gate checklist and keep the report attached in `docs/QUARTUS_PLACEHOLDER_HYGIENE_REPORT.md`.
- Confirm source-group assumptions remain documentation-only.

## Phase B — Top-level skeleton activation

- Convert only:
  - `quartus/FPGA_Pocket_SegaCD.qpf`
  - `quartus/FPGA_Pocket_SegaCD.qsf`
- Keep source include list minimal and conservative.
- Do not add device/pin/timing defaults unless independently confirmed.
- Keep synthesis disabled and do not generate outputs.
- Task 5Z status: this phase is now **partially completed**.
  - `qpf` and `qsf` are converted to active skeletons.
  - source include files remain placeholders.

## Phase C — APF scaffold wiring

- Add active APF scaffold source includes next:
  - `apf/src/fpga/core/core_top.v`
  - APF scaffold helper files already planned
- Keep full Genesis runtime include list limited to confirmed files only, and keep simulation-only stub excluded.
- Do not introduce save-state/IOCTL/host bridge build-time behavior beyond scaffold intent.
  - Pending in later milestones.

## Phase D — Mixed-language handling

- Add explicit mixed-language handling only after VHDL dependencies are confirmed.
- Record exact VHDL/Verilog mix behavior in Quartus notes.
- Keep third_party runtime read-only.
- Do not force non-existent or speculative runtime files.

## Phase E — Preliminary constraints

- Add only preliminary and non-final constraints after reset/clock assumptions are confirmed.
- Do not invent or assert final timing for production.
- No APF packaging constraints in this phase.

## Phase F — Early compile/lint probe

- Only if Phases A-E pass, run a local, bounded compile/lint probe.
- Do not commit generated outputs.
- Keep result as advisory and non-boot-signaling.

## Final for this plan

- This plan preserves placeholder safety while enabling first active skeleton formation.
- Task 5Z begins with Phase B and stops before synthesis run.
