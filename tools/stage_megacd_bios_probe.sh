#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
ART=build/megacd_pocket_artifacts
STAGE=build/pocket_sd_megacd_bios_probe
STATUS_DOC=docs/MEGACD_BIOS_PROBE_PACKAGE_STATUS.md
SD_GUIDE=docs/MEGACD_BIOS_PROBE_SD_GUIDE.md
HW_CHECK=docs/MEGACD_BIOS_PROBE_HARDWARE_CHECKLIST.md
TEMPLATE_DIR=third_party/openFPGA-Genesis/dist/Cores/ericlewis.Genesis
PLATFORM_TEMPLATE=third_party/openFPGA-Genesis/dist/Platforms/genesis.json
CORE_DIR="$STAGE/Cores/Gr33k.SegaCDBiosProbe"
BIT="$ART/bitstream.rbf_r"
rm -rf "$STAGE"
mkdir -p "$STAGE/Cores" "$STAGE/Platforms"
if [[ ! -s "$BIT" ]]; then
  cat > "$STATUS_DOC" <<'DOC'
# MegaCD BIOS probe package status

- result: PACKAGE_STAGING_FAILED
- reason: missing fresh bitstream.rbf_r artifact
DOC
  exit 1
fi
if [[ ! -d "$TEMPLATE_DIR" ]]; then
  cat > "$STATUS_DOC" <<'DOC'
# MegaCD BIOS probe package status

- result: PACKAGE_STAGING_FAILED
- reason: missing upstream genesis package template
DOC
  exit 1
fi
cp -a "$TEMPLATE_DIR" "$CORE_DIR"
cp "$BIT" "$CORE_DIR/bitstream.rbf_r"
cp "$PLATFORM_TEMPLATE" "$STAGE/Platforms/genesis.json"

jq '.core.metadata.platform_ids = ["genesis"]
  | .core.metadata.shortname = "SegaCDBiosProbe"
  | .core.metadata.description = "Experimental MegaCD BIOS probe; no disc support."
  | .core.metadata.author = "Gr33k"
  | .core.metadata.url = "https://github.com/gr33k/FPGA_Pocket_SegaCD"
  | .core.metadata.version = "0.0.1-probe"
  | .core.metadata.date_release = "2026-07-11"
  | .core.framework.target_product = "Analogue Pocket"
  | .core.framework.version_required = "1.1"
  | .core.framework.sleep_supported = false
  | .core.framework.dock.supported = true
  | .core.framework.dock.analog_output = false
  | .core.framework.hardware.link_port = false
  | .core.framework.hardware.cartridge_adapter = -1
  | .core.cores = [{"name":"default","id":0,"filename":"bitstream.rbf_r"}]' \
  "$CORE_DIR/core.json" > "$CORE_DIR/core.json.tmp"
mv "$CORE_DIR/core.json.tmp" "$CORE_DIR/core.json"

cat > "$CORE_DIR/data.json" <<'JSON'
{
  "data": {
    "magic": "APF_VER_1",
    "data_slots": [
      {
        "id": 0,
        "name": "Cartridge",
        "required": false,
        "parameters": "0x109",
        "extensions": ["md", "bin", "gen", "smd"],
        "address": "0x10000000"
      },
      {
        "id": 1,
        "name": "Sega CD BIOS",
        "required": true,
        "parameters": "0x109",
        "extensions": ["rom", "bin"],
        "size_exact": 131072,
        "address": "0x20000000"
      }
    ]
  }
}
JSON

cat > "$CORE_DIR/interact.json" <<'JSON'
{
  "interact": {
    "magic": "APF_VER_1",
    "variables": [
      {
        "name": "Core Status",
        "id": 900,
        "type": "number_u32",
        "enabled": false,
        "address": "0x00E00004"
      },
      {
        "name": "BIOS Bytes",
        "id": 901,
        "type": "number_u32",
        "enabled": false,
        "address": "0x00E0000C"
      },
      {
        "name": "Memory Flags",
        "id": 902,
        "type": "number_u32",
        "enabled": false,
        "address": "0x00E00010"
      },
      {
        "name": "WordRAM Address",
        "id": 903,
        "type": "number_u32",
        "enabled": false,
        "address": "0x00E00014"
      },
      {
        "name": "CDC Read Address",
        "id": 904,
        "type": "number_u32",
        "enabled": false,
        "address": "0x00E00018"
      },
      {
        "name": "CDC Write Address",
        "id": 905,
        "type": "number_u32",
        "enabled": false,
        "address": "0x00E0001C"
      }
    ],
    "messages": []
  }
}
JSON

cat > "$STATUS_DOC" <<'DOC'
# MegaCD BIOS probe package status

- result: BIOS_PROBE_READY_FOR_POCKET
- staging path: build/pocket_sd_megacd_bios_probe/
- core path: build/pocket_sd_megacd_bios_probe/Cores/Gr33k.SegaCDBiosProbe
- platform path: build/pocket_sd_megacd_bios_probe/Platforms/genesis.json
- artifact path: build/pocket_sd_megacd_bios_probe/Cores/Gr33k.SegaCDBiosProbe/bitstream.rbf_r
- artifact sha256: a29780da808bbcf39dc63def45135b9ead6b1ecc748719269f49f774b75eb293
DOC

cat > "$SD_GUIDE" <<'DOC'
# MegaCD BIOS probe SD guide

Copy only:

- build/pocket_sd_megacd_bios_probe/Cores/Gr33k.SegaCDBiosProbe

to:

- SD:/Cores/Gr33k.SegaCDBiosProbe

Do not overwrite the user's existing genesis.json if it is already valid.

The probe remains an alternative core beneath Genesis.

No BIOS is bundled.
No ROM is bundled.
No disc image is bundled.
DOC

cat > "$HW_CHECK" <<'DOC'
# MegaCD BIOS probe hardware checklist

## A. Core visibility

- probe core appears beneath Genesis
- Core Settings opens
- BIOS browser appears on startup

## B. BIOS load

- user selects one Sega CD BIOS
- BIOS file size is exactly 131072 bytes
- BIOS load completes
- BIOS Bytes value increases from zero

## C. Runtime diagnostics

- Core Status value changes after BIOS load
- Memory Flags value changes after BIOS load
- WordRAM Address changes from zero
- CDC Read Address changes from zero
- CDC Write Address changes from zero

## D. User-visible result

- video output present
- audio output present or explicitly silent
- insert-disc or no-disc screen appears
- no black screen
- no reset loop
- no freeze
- Pocket menu remains accessible
DOC
