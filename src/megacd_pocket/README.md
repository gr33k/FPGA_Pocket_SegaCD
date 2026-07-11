# MegaCD Pocket source lane

This lane is a repo-owned Pocket-target integration workspace.

## Source origins

- Pocket wrapper baseline: `third_party/openFPGA-Genesis` commit `98e27aa8229c75ece6b0f39bca414556a88d0b49`
- MegaCD donor baseline: `third_party/MegaCD_MiSTer` commit `b1a0f1f42710dd0678c8432fee886b2da836b48c`

## Design intent

- preserve known-good Genesis baseline on `main`
- keep donor submodule read-only
- copy required source into this lane with original headers preserved
- use Pocket APF shell with donor `gen` + donor `MCD`

## Modified lane files

- `fpga/core/core_top.sv`: Pocket MegaCD integration top for first probe
- `fpga/core/rtl/pocket/cdd_nodisc_stub.sv`: no-disc donor-facing CDD/CDC stub
- `fpga/ap_core.qsf`: repo-owned source manifest for fit probe

## License obligations

This lane contains copied and adapted upstream files from projects with BSD-like and GPL-family licensing. Original headers must remain intact. Upstream attribution must be preserved in repo docs and copied files.
