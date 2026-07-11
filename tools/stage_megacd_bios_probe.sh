#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
ART=build/megacd_pocket_artifacts
STAGE=build/pocket_sd_megacd_bios_probe
STATUS_DOC=docs/MEGACD_BIOS_PROBE_PACKAGE_STATUS.md
SD_GUIDE=docs/MEGACD_BIOS_PROBE_SD_GUIDE.md
HW_CHECK=docs/MEGACD_BIOS_PROBE_HARDWARE_CHECKLIST.md
rm -rf "$STAGE"
mkdir -p "$STAGE/Cores/Gr33k.SegaCDBiosProbe" "$STAGE/Platforms"
BIT=$(find "$ART" -maxdepth 1 -name 'bitstream.rbf_r' | head -1 || true)
if [[ -z "$BIT" ]]; then
  cat > "$STATUS_DOC" <<DOC
# MegaCD BIOS probe package status

- result: \`PACKAGE_STAGING_FAILED\`
- reason: \`missing fresh bitstream.rbf_r artifact\`
DOC
  exit 1
fi
cp "$BIT" "$STAGE/Cores/Gr33k.SegaCDBiosProbe/bitstream.rbf_r"
UPSTREAM_PLATFORM=$(find third_party/openFPGA-Genesis/dist/Platforms -maxdepth 1 -name 'genesis*.json' | head -1 || true)
if [[ -n "$UPSTREAM_PLATFORM" ]]; then
  cp "$UPSTREAM_PLATFORM" "$STAGE/Platforms/genesis.json"
else
  cat > "$STAGE/Platforms/genesis.json" <<'JSON'
{
  "platform": {
    "category": "Console",
    "name": "Genesis",
    "year": 1988,
    "manufacturer": "Sega"
  }
}
JSON
fi
cat > "$STAGE/Cores/Gr33k.SegaCDBiosProbe/core.json" <<'JSON'
{
  "core": {
    "magic": "APF_VER_1",
    "metadata": {
      "platform_ids": ["genesis"],
      "shortname": "SegaCDBiosProbe",
      "description": "Experimental Pocket MegaCD BIOS bring-up probe. No disc service.",
      "author": "Gr33k",
      "url": "https://github.com/gr33k/FPGA_Pocket_SegaCD"
    }
  }
}
JSON
cat > "$STAGE/Cores/Gr33k.SegaCDBiosProbe/data.json" <<'JSON'
{
  "data": {
    "magic": "APF_VER_1",
    "data_slots": [
      {"id": 0, "name": "Genesis Cartridge", "required": false, "parameters": ["default"], "extensions": ["md", "bin", "gen", "smd"], "address": "0x10000000"},
      {"id": 1, "name": "Sega CD BIOS", "required": false, "parameters": ["default"], "extensions": ["rom", "bin"], "address": "0x20000000"}
    ]
  }
}
JSON
cat > "$STAGE/Cores/Gr33k.SegaCDBiosProbe/input.json" <<'JSON'
{"input":{"magic":"APF_VER_1"}}
JSON
cat > "$STAGE/Cores/Gr33k.SegaCDBiosProbe/interact.json" <<'JSON'
{"interact":{"magic":"APF_VER_1"}}
JSON
cat > "$STAGE/Cores/Gr33k.SegaCDBiosProbe/variants.json" <<'JSON'
{"variants":{"magic":"APF_VER_1"}}
JSON
cat > "$STAGE/Cores/Gr33k.SegaCDBiosProbe/video.json" <<'JSON'
{"video":{"magic":"APF_VER_1"}}
JSON
cat > "$STAGE/Cores/Gr33k.SegaCDBiosProbe/audio.json" <<'JSON'
{"audio":{"magic":"APF_VER_1"}}
JSON
cat > "$SD_GUIDE" <<DOC
# MegaCD BIOS probe SD guide

Copy the contents of \`build/pocket_sd_megacd_bios_probe/\` to the Pocket SD root.

Probe core folder:
- \`Cores/Gr33k.SegaCDBiosProbe\`

Platform file:
- \`Platforms/genesis.json\`

No BIOS is bundled.
No ROM is bundled.
No disc image is bundled.
DOC
cat > "$HW_CHECK" <<DOC
# MegaCD BIOS probe hardware checklist

## A. Genesis regression

- core appears under Genesis
- Sonic the Hedgehog loads
- video works
- audio works
- controls work
- no black screen
- no reset loop

## B. Memory diagnostics

- external WORDRAM0 enabled flag set
- WORDRAM0 read/write activity flags change
- CDC MLAB implementation enabled flag set
- CDC RAM read activity seen
- CDC RAM write activity seen
- no crash during MCD initialization

## C. BIOS probe

- user selects a Sega CD BIOS
- BIOS load completes
- MegaCD mode enables
- MCD reset releases
- sub-68000 activity changes
- BIOS video appears
- insert-disc or no-disc state appears
- no disc gameplay claim
DOC
cat > "$STATUS_DOC" <<DOC
# MegaCD BIOS probe package status

- result: \`BIOS_PROBE_READY_FOR_POCKET\`
- staging path: \`build/pocket_sd_megacd_bios_probe/\`
- core path: \`build/pocket_sd_megacd_bios_probe/Cores/Gr33k.SegaCDBiosProbe\`
- platform path: \`build/pocket_sd_megacd_bios_probe/Platforms/genesis.json\`
DOC
