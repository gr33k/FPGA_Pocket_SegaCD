# Core identity rename report

## Old identity fields

- Core folder: `Cores/gr33k.Genesis`
- Prior upstream-derived source identity: `Cores/ericlewis.Genesis`
- Platform file: `Platforms/gr33k.Genesis.json`
- Display author in staged `core.json`: `ericlewis`
- Display shortname in staged `core.json`: `Genesis`
- Platform display name: `Genesis`

## New identity fields

- Core folder: `Cores/gr33k.SegaCD`
- Platform ID: `gr33k_segacd`
- Platform file: `Platforms/gr33k_segacd.json`
- Display author: `Gr33k`
- Display core name: `Sega CD`
- Description: `Genesis-based FPGA core with future Sega CD/32X expansion path.`

## Files changed

- `tools/stage_genesis_openfpga_sd_candidate.sh`
- `tools/check_genesis_package_identity.sh`
- `docs/CORE_IDENTITY_RENAME_REPORT.md`
- `docs/FIRST_GENESIS_OPENFPGA_PACKAGE_STATUS.md`
- `docs/FIRST_GENESIS_SD_STAGING_GUIDE.md`
- `docs/REPO_STATUS.md`
- `docs/NEXT_ACTIVATION_PATH.md`

## Attribution preserved

Upstream metadata is still sourced from `third_party/openFPGA-Genesis/dist`, and upstream authorship remains documented in project notes. The staged package identity was changed so the Pocket menu no longer presents this project as the upstream `ericlewis` package.
