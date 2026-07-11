#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
ART=build/megacd_pocket_artifacts
STAGE=build/pocket_sd_megacd_bios_probe
STATUS_DOC=docs/MEGACD_BIOS_PROBE_PACKAGE_STATUS.md
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
cat > docs/MEGACD_BIOS_PROBE_SD_GUIDE.md <<'DOC'
# MegaCD BIOS probe SD guide

Copy the contents of `build/pocket_sd_megacd_bios_probe/` to the Pocket SD root.

Probe core folder:
- `Cores/Gr33k.SegaCDBiosProbe`

No BIOS is bundled.
No ROM is bundled.
No disc image is bundled.
DOC
cat > docs/MEGACD_BIOS_PROBE_HARDWARE_CHECKLIST.md <<'DOC'
# MegaCD BIOS probe hardware checklist

- core appears under Genesis
- Genesis cartridge ROM can still boot
- video works
- audio works
- controls work
- BIOS can be selected
- BIOS load completes
- MegaCD mode enables
- no permanent reset black screen
- BIOS output appears or a no-disc screen appears
- sub-CPU activity register changes
- CDD command activity register changes
DOC
cat > "$STATUS_DOC" <<DOC
# MegaCD BIOS probe package status

- result: \`BIOS_PROBE_READY_FOR_POCKET\`
- staging path: \`build/pocket_sd_megacd_bios_probe/\`
DOC
