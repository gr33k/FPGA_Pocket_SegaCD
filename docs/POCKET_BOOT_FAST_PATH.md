# Pocket Boot Fast Path

## Step 1: Genesis-only runtime source path active
- Use `quartus/files_genesis_runtime.qsf` as the active Genesis-only source control file.
- Keep `quartus/files_genesis_runtime.candidate.qsf` planning-only only.
- Keep `files_genesis_runtime.candidate.qsf` out of active Quartus sources.

## Step 2: Get Quartus host
- Run on host where `quartus_map` is available.
- Export `QUARTUS_MAP` or `QUARTUS_ROOTDIR` as needed.

## Step 3: Validate toolchain
- Run `tools/validate_local_quartus_toolchain.sh`.
- Only continue on PASS.

## Step 4: Run analysis/elaboration
- Run analysis-only command path (not full synthesis).
- Capture results and first blocker list.

## Step 5: Fix compile blockers (sequential)
- Address only first missing high-confidence dependency before expanding source list.
- Keep Sega CD / 32X and mixed-language expansion out until Genesis path compiles.

## Step 6: Package for openFPGA
- After successful compile-path progress, create/verify the openFPGA package stage.
- Do not claim completion while blockers remain.

## Step 7: Boot a known-good small Genesis ROM
- Structural boot milestone only; no compatibility claim beyond Genesis loading.

## Step 8: Expand scope only after boot success
- Only after practical Genesis booting in-pocket, branch to additional scope:
  - deeper Genesis parity,
  - optional ROM services,
  - then Sega CD / 32X in future milestones.
