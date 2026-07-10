# FPGA_Pocket_SegaCD repository status

Date: 2026-07-10

## Task 8A status

- Completed the first Genesis-only Pocket boot candidate run from `third_party/openFPGA-Genesis`.
- Scope remained Genesis only:
  - no Sega CD
  - no 32X
  - no ROM bundled
- Real Quartus flow was executed in a disposable work dir under `build/genesis_first_boot_work/src/fpga`.
- Results:
  - `quartus_map` exit: `0`
  - `quartus_fit` exit: `0`
  - `quartus_sta` exit: `0`
  - `quartus_asm` exit: `0`
- Timing summary captured in `docs/FIRST_GENESIS_TIMING_SMOKE_LOG.txt`:
  - worst setup slack: `0.711`
  - worst hold slack: `0.221`
  - unconstrained paths: not reported by the task parser
- Generated artifacts were copied to ignored staging under:
  - `build/genesis_first_boot_artifacts/ap_core.sof`
  - `build/genesis_first_boot_artifacts/ap_core.rbf`
  - `build/genesis_first_boot_artifacts/bitstream.rbf_r`
- openFPGA package staging succeeded using upstream metadata from `third_party/openFPGA-Genesis/dist`.
- Staged SD candidate root:
  - `build/pocket_sd_genesis_first_boot/`
- Package result:
  - `READY_FOR_POCKET_SD_SMOKE_TEST`
- Supporting docs created:
  - `docs/FIRST_GENESIS_BOOT_CANDIDATE_PLAN.md`
  - `docs/FIRST_GENESIS_BOOT_CANDIDATE_STATUS.md`
  - `docs/FIRST_GENESIS_BUILD_ARTIFACTS.md`
  - `docs/FIRST_GENESIS_OPENFPGA_PACKAGE_STATUS.md`
  - `docs/FIRST_GENESIS_SD_STAGING_GUIDE.md`
  - `docs/FIRST_GENESIS_ROM_TEST_PLAN.md`
  - `docs/FIRST_GENESIS_BOOT_CANDIDATE_CHECK.md`
- No generated Quartus outputs or bitstreams are intended for git commit.
- `third_party/openFPGA-Genesis` and `third_party/Genesis_MiSTer` remained clean.
- No Pocket boot or runtime correctness is claimed yet because hardware has not been tested.

## Safety constraints

- No Sega-CD, no 32X, no save-state activation, and no host-per-read ROM streaming changes were introduced in Task 8A.
- `third_party/Genesis_MiSTer` remains reference-only.
- Hardware validation is still required before any runtime correctness claim.
