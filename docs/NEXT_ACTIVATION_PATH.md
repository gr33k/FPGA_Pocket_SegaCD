# Next activation path after Task 8D

## Current package registration

- Core folder: `Cores/Gr33k.SegaCD`
- Core author: `Gr33k`
- Core shortname: `SegaCD`
- Platform ID: `segacd`
- Platform file: `Platforms/segacd.json`
- Platform display name: `Sega CD`
- Asset folder: `Assets/segacd/common`

## SD refresh steps

Delete these from the SD card first:
- `Cores/ericlewis.Genesis`
- `Cores/gr33k.SegaCD`
- `Cores/Gr33k.SegaCD`
- `Platforms/gr33k.SegaCD.json`
- `Platforms/gr33k_segacd.json`
- `Platforms/segacd.json`
- `Assets/gr33k_segacd`
- `Assets/segacd`

Then copy the refreshed contents of `build/pocket_sd_genesis_first_boot/` to the SD root.

After copying:
- fully shut down the Pocket
- remove and reinsert the SD card if needed
- power it back on
- open openFPGA
- look under Console for Sega CD
