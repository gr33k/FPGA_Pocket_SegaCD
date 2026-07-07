# No-Quartus Fallback Plan

## Trigger
Use this path when `quartus_map` is unavailable on the local host.

## Two lanes

### Quartus lane
- Paused until `quartus_map` is available locally.
- Requires:
  - successful `validate_local_quartus_toolchain.sh` pass,
  - `tools/run_quartus_analysis_only_if_available.sh` execution eligibility.
- No runtime source activation during pause.

### Static prep lane
- Allowed:
  - dependency inspection in source,
  - static scan usage,
  - candidate source list drafting.
- Not allowed:
  - activating runtime builds,
  - compile/synthesis,
  - altering third-party runtime files.
- Candidate files may be generated and tracked here without active project inclusion.

## Current hold state
- Local validation is toolchain-blocked.
- APF runtime scaffold remains in the static/inert smoke-test posture.
- No Genesis_MiSTer source files are activated into the Quartus build in this state.

## Workstream (Static Only)
- Maintain compile-facing manifests and documentation only.
- Keep manifest files labeled "candidate", "draft", or "TODO".
- Avoid changing active source lists (`files_genesis_runtime.qsf`) until Quartus can run.
- Keep APF project source list unchanged:
  - `apf_scaffold_sources.f`
  - no full `genesis_runtime_sources.*` activation

## Source file rules
- Candidate file creation is allowed:
  - `quartus/files_genesis_runtime.candidate.qsf`
- Active runtime compile files must not be edited for launch until toolchain is resolved:
  - `quartus/files_genesis_runtime.qsf`
  - runtime stubs/simulation-only placeholders
  - generated Quartus outputs

## Gatekeeping criteria for resuming runtime activation
1. `quartus_map --version` succeeds on the host.
2. Toolchain validation script reports PASS.
3. Analysis-only Quartus pass runs successfully.
4. No unexpected generated artifacts are committed.

## Static deliverables produced now
- `docs/TASK6M_NO_QUARTUS_STATIC_RUNTIME_PREP.md`
- `docs/GENESIS_RUNTIME_STATIC_DEPENDENCY_REPORT.md`
- `docs/GENESIS_RUNTIME_CANDIDATE_SOURCE_LIST.md`
- `quartus/files_genesis_runtime.candidate.qsf`

## Non-goals
- No `system.sv` compile activation.
- No project synthesis.
- No runtime behavior changes.
- No Sega CD/32X.

## Recovery note
This lane does not change the real runtime risk surface; it only increases documentation and planning confidence before toolchain availability.
