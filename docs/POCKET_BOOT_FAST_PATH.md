# Pocket Boot Fast Path (ASAFP)

## Step 1: No-Quartus project-flow check
- Run `tools/check_genesis_only_project_flow.sh`.
- Confirm shell/listing coherence and forbidden references are clean before host moves.

## Step 2: Genesis-only Quartus host
- Use `docs/GENESIS_ONLY_QUARTUS_PROJECT_FLOW.md` as the host command map.

## Step 3: Run analysis/elaboration
- Run analysis/elaboration only on host (no fitter/assembler/timing).
- Capture first-error output and class blocker source.

## Step 4: Compile blocker fixes
- Address one blocker at a time: missing dependency, mixed-language order, or constraints/project setup.

## Step 5: OpenFPGA package skeleton
- Keep packaging as a skeleton-only pass until stable analysis success is observed.

## Step 6: Pocket smoke boot
- After compile-path stabilization, execute minimal smoke boot with known-good ROM path and report only structural progression.

## Step 7: Expand scope only after smoke
- Gate future scope (deeper parity, optional ROM tooling, then Sega CD/32X) after stable Genesis smoke path.
