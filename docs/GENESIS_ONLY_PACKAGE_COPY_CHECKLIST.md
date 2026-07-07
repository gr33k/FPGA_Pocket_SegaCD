# Genesis-only package copy checklist

## Before copy

- `tools/check_openfpga_package_skeleton.sh` passes.
- `tools/check_pocket_sd_staging.sh` passes with known warnings.
- `POCKET_SD_ROOT` is validated.
- no bitstream exists yet in repository skeleton.

## Before first real boot attempt

- Real bitstream becomes available on Quartus host.
- Do not alter package file names by blind renaming.
- Copy bitstream into expected package path in build release directory.
- Confirm JSON references expected filename in package metadata/docs.
- Copy release package to Pocket staging path from this repo output staging layout.

## Forbidden for now

- No ROM payload files committed
- No BIOS files committed
- No Sega-CD/32X payload folders active
- No fake bitstreams

## After first real bitstream exists

- Re-run:
  - `tools/check_pocket_sd_staging.sh`
  - `tools/stage_pocket_sd_skeleton.sh` (with `DRY_RUN=0`)
- Prepare a smoke boot with a real bootable ROM on a real Pocket host only.
- No claims of successful boot in repository unless confirmed.

