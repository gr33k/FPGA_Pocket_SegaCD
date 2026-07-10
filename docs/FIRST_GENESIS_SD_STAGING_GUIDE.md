# First Genesis SD staging guide
Generated: 2026-07-10 21:41:02 UTC

Result: READY_FOR_POCKET_SD_SMOKE_TEST

## Staged folder
- build/pocket_sd_genesis_first_boot/

## Copy target
Copy the contents of build/pocket_sd_genesis_first_boot/ onto the Pocket SD card root so that Cores/ and Platforms/ land in the expected openFPGA layout.

## Candidate paths
- build/pocket_sd_genesis_first_boot/Cores/gr33k.Genesis
- build/pocket_sd_genesis_first_boot/Platforms/gr33k.Genesis.json

## Notes
- Package identity renamed from ericlewis.Genesis to gr33k.Genesis to avoid upstream-name conflicts.
- Upstream attribution is preserved via the reused metadata source and project docs.
- No ROM is bundled.
- No Sega CD or 32X assets are staged.
- This is a first boot candidate only.
