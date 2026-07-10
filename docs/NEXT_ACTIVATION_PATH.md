# Next activation path after Task 8A

## Current milestone status

- Task 8A completed successfully.
- First Genesis-only boot candidate result: `READY_FOR_POCKET_SD_SMOKE_TEST`.
- Generated artifacts exist in ignored build staging:
  - `build/genesis_first_boot_artifacts/bitstream.rbf_r`
  - `build/genesis_first_boot_artifacts/ap_core.rbf`
  - `build/genesis_first_boot_artifacts/ap_core.sof`
- Staged openFPGA SD candidate exists at:
  - `build/pocket_sd_genesis_first_boot/`
- No ROM is bundled.
- No Pocket boot claim has been made.
- No runtime correctness claim has been made.

## Immediate next human action

- Copy the contents of `build/pocket_sd_genesis_first_boot/` to the Pocket SD card root.
- Test one known-good Genesis `.bin` or `.gen` ROM only.
- First checks:
  - core appears in Pocket menu
  - ROM browser opens
  - ROM loads
  - video syncs
  - controls respond
  - audio is present
- Record the exact first failure if boot does not succeed.

## If hardware boot fails

- Use the staged candidate and Task 8A logs first:
  - `docs/FIRST_GENESIS_BOOT_CANDIDATE_STATUS.md`
  - `docs/FIRST_GENESIS_MAP_LOG.txt`
  - `docs/FIRST_GENESIS_FIT_LOG.txt`
  - `docs/FIRST_GENESIS_TIMING_SMOKE_LOG.txt`
  - `docs/FIRST_GENESIS_ASSEMBLER_LOG.txt`
- Then debug in this order:
  - packaging/layout issue
  - ROM-loading behavior
  - video sync/output behavior
  - control mapping
  - audio path

## Constraints carried forward

- Keep Genesis-only scope until a real hardware boot succeeds.
- Do not enable Sega CD or 32X yet.
- Do not bundle ROMs or BIOS files.
- Do not claim runtime correctness until Pocket hardware proves it.
