# Task 6M: No-Quartus Static Genesis Runtime Dependency Preparation

## Purpose
Task 6M is a safe, static fallback that advances planning while the local toolchain is unavailable.

The goal is to prepare source manifests, known dependency notes, and project status artifacts without enabling or compiling anything on this host.

## Constraints
- Do not claim or attempt Quartus synthesis.
- Do not enable Sega CD / 32X / HPS / IOCTL / sys wrapper pathways.
- Do not modify runtime RTL in `third_party/Genesis_MiSTer`.
- Do not run full compile, fitter, assembler, or timing analysis.
- Do not include a real ROM loader, memory arbitration, or runtime bootstrap changes.

## What this task accomplishes
1. Create static-only documentation artifacts:
   - `docs/NO_QUARTUS_FALLBACK_PLAN.md`
   - `docs/GENESIS_RUNTIME_STATIC_DEPENDENCY_REPORT.md`
   - `docs/GENESIS_RUNTIME_CANDIDATE_SOURCE_LIST.md`
2. Keep Quartus project artifacts unchanged and non-active:
   - add a candidate-only manifest file under `quartus/` for review:
     - `quartus/files_genesis_runtime.candidate.qsf`
3. Preserve existing safe state:
   - `Task 5H` scaffold sanity stays intact
   - `Task 6J/6K` toolchain-blocker status remains valid until `quartus_map` is available

## Why this task exists
- Quartus-dependent tasks are blocked by missing local toolchain, so compile-driven progress cannot continue.
- Static dependency prep can continue because it does not require Quartus execution and does not alter runtime behavior.
- This keeps the repo useful with deterministic planning outputs while deferring risky compile-phase changes.

## Safety posture
- Static files only.
- No files are activated into APF runtime build path without a Quartus-capable host and explicit re-check.
- No generated build outputs are produced by this task.

## Why this is not a runtime-compile task
- Without Quartus and without an activated compile list, this task can only reduce uncertainty.
- A real dependency activation pass (compile-driven) will still be done in a future host task once `quartus_map` exists.

## Acceptance criteria
- Static prep docs are committed (or tracked) and clearly marked as non-active.
- `files_genesis_runtime.candidate.qsf` exists for future Quartus source-list activation.
- No changes are made to imported `Genesis_MiSTer` runtime RTL.

## Next step
Task 6N should be:
- Review and refine the candidate runtime source ordering.
- Keep all candidate entries advisory until Quartus run-based verification.
- Keep Sega CD / 32X excluded.
- Avoid any claims of successful compile or gameplay boot.
