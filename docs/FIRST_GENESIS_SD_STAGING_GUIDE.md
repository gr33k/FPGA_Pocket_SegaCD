# First Genesis SD staging guide
Generated: 2026-07-11 00:35:26 UTC

Result: READY_FOR_POCKET_SD_SMOKE_TEST

## Delete stale SD entries first
Delete these from the Pocket SD card before copying the refreshed package:
- Cores/ericlewis.Genesis
- Cores/gr33k.SegaCD
- Cores/Gr33k.SegaCD
- Platforms/gr33k.SegaCD.json
- Platforms/gr33k_segacd.json
- Platforms/segacd.json
- Assets/gr33k_segacd
- Assets/segacd

## Copy target
Copy the contents of build/pocket_sd_genesis_first_boot/ onto the Pocket SD card root.

## Staged identity
- Core folder: Cores/Gr33k.SegaCD
- Core author: Gr33k
- Core shortname: SegaCD
- Platform ID: segacd
- Platform file: Platforms/segacd.json
- Asset folder: Assets/segacd/common

## After copying
- Fully shut down the Pocket.
- Remove and reinsert the SD card if needed.
- Power it back on.
- Open openFPGA.
- Look under Console for Sega CD.
