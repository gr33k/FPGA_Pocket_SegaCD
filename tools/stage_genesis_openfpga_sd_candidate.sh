#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARTIFACT_DIR="$ROOT_DIR/build/genesis_first_boot_artifacts"
UPSTREAM_DIR="$ROOT_DIR/third_party/openFPGA-Genesis"
STAGE_ROOT="$ROOT_DIR/build/pocket_sd_genesis_first_boot"
PACKAGE_DOC="$ROOT_DIR/docs/FIRST_GENESIS_OPENFPGA_PACKAGE_STATUS.md"
GUIDE_DOC="$ROOT_DIR/docs/FIRST_GENESIS_SD_STAGING_GUIDE.md"
ROM_DOC="$ROOT_DIR/docs/FIRST_GENESIS_ROM_TEST_PLAN.md"
TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
RESULT=""
CORE_DIR_NAME="Gr33k.SegaCD"
UPSTREAM_CORE_DIR="ericlewis.Genesis"
PLATFORM_ID="segacd"
PLATFORM_FILE="segacd.json"
UPSTREAM_PLATFORM_FILE="genesis.json"
AUTHOR="Gr33k"
SHORTNAME="SegaCD"
DISPLAY_NAME="Sega CD"
DESCRIPTION="Genesis FPGA core with future Sega CD and 32X expansion."
PROJECT_URL="https://github.com/gr33k/FPGA_Pocket_SegaCD"
ASSET_DIR="$STAGE_ROOT/Assets/segacd/common"

pick_artifact() {
  local choice=""
  for name in bitstream.rbf_r ap_core.rbf_r bitstream.rbf ap_core.rbf ap_core.sof; do
    if [[ -f "$ARTIFACT_DIR/$name" ]]; then
      choice="$ARTIFACT_DIR/$name"
      break
    fi
  done
  echo "$choice"
}

: > "$PACKAGE_DOC"
: > "$GUIDE_DOC"
: > "$ROM_DOC"

artifact="$(pick_artifact)"
{
  echo "# First Genesis openFPGA package status"
  echo "Generated: $TIMESTAMP"
  echo
} > "$PACKAGE_DOC"

if [[ ! -d "$UPSTREAM_DIR/dist/Cores/$UPSTREAM_CORE_DIR" || ! -f "$UPSTREAM_DIR/dist/Platforms/$UPSTREAM_PLATFORM_FILE" ]]; then
  echo "Result: PACKAGE_STAGING_FAILED" >> "$PACKAGE_DOC"
  echo "Missing upstream dist package skeleton under third_party/openFPGA-Genesis/dist" >> "$PACKAGE_DOC"
  exit 0
fi

if [[ -z "$artifact" ]]; then
  echo "Result: CONVERSION_REQUIRED" >> "$PACKAGE_DOC"
  echo "No generated bitstream-like artifact found in build/genesis_first_boot_artifacts" >> "$PACKAGE_DOC"
  exit 0
fi

rm -rf "$STAGE_ROOT"
mkdir -p "$STAGE_ROOT/Cores" "$STAGE_ROOT/Platforms" "$ASSET_DIR" "$STAGE_ROOT/Platforms/_images"
cp -R "$UPSTREAM_DIR/dist/Cores/$UPSTREAM_CORE_DIR" "$STAGE_ROOT/Cores/$CORE_DIR_NAME"
cp -f "$UPSTREAM_DIR/dist/Platforms/$UPSTREAM_PLATFORM_FILE" "$STAGE_ROOT/Platforms/$PLATFORM_FILE"

if [[ -f "$UPSTREAM_DIR/dist/Platforms/_images/genesis.bin" ]]; then
  cp -f "$UPSTREAM_DIR/dist/Platforms/_images/genesis.bin" "$STAGE_ROOT/Platforms/_images/segacd.bin"
fi

CORE_JSON="$STAGE_ROOT/Cores/$CORE_DIR_NAME/core.json"
PLATFORM_JSON="$STAGE_ROOT/Platforms/$PLATFORM_FILE"
python3 - <<PY
import json
from pathlib import Path
core_path = Path(r'''$CORE_JSON''')
platform_path = Path(r'''$PLATFORM_JSON''')
core = json.loads(core_path.read_text())
meta = core['core']['metadata']
meta['platform_ids'] = ['$PLATFORM_ID']
meta['shortname'] = '$SHORTNAME'
meta['description'] = '$DESCRIPTION'
meta['author'] = '$AUTHOR'
meta['url'] = '$PROJECT_URL'
core_path.write_text(json.dumps(core, indent=4) + "\n")
platform = {'platform': {'category': 'Console', 'name': '$DISPLAY_NAME', 'manufacturer': 'Sega', 'year': 1991}}
platform_path.write_text(json.dumps(platform, indent=2) + "\n")
PY

artifact_name="$(basename "$artifact")"
if [[ "$artifact_name" == *.rbf_r ]]; then
  cp -f "$artifact" "$STAGE_ROOT/Cores/$CORE_DIR_NAME/bitstream.rbf_r"
  RESULT="READY_FOR_POCKET_SD_SMOKE_TEST"
elif [[ "$artifact_name" == *.rbf ]]; then
  cp -f "$artifact" "$STAGE_ROOT/Cores/$CORE_DIR_NAME/bitstream.rbf"
  RESULT="CONVERSION_REQUIRED"
else
  RESULT="CONVERSION_REQUIRED"
fi

{
  echo "Result: $RESULT"
  echo "Upstream metadata source: third_party/openFPGA-Genesis/dist"
  echo "Artifact source: ${artifact#$ROOT_DIR/}"
  echo "Stage root: build/pocket_sd_genesis_first_boot"
  echo "Core folder: Cores/$CORE_DIR_NAME"
  echo "Core author: $AUTHOR"
  echo "Core shortname: $SHORTNAME"
  echo "Platform ID: $PLATFORM_ID"
  echo "Platform file: Platforms/$PLATFORM_FILE"
  echo "Platform display name: $DISPLAY_NAME"
  echo "Asset folder: Assets/segacd/common"
  echo "Upstream attribution source: dist/Cores/$UPSTREAM_CORE_DIR and dist/Platforms/$UPSTREAM_PLATFORM_FILE"
  if [[ -f "$STAGE_ROOT/Platforms/_images/segacd.bin" ]]; then
    echo "Platform image: Platforms/_images/segacd.bin (temporary Genesis-derived artwork)"
  else
    echo "Platform image: not staged"
  fi
} >> "$PACKAGE_DOC"

{
  echo "# First Genesis SD staging guide"
  echo "Generated: $TIMESTAMP"
  echo
  echo "Result: $RESULT"
  echo
  echo "## Delete stale SD entries first"
  echo "Delete these from the Pocket SD card before copying the refreshed package:"
  echo "- Cores/ericlewis.Genesis"
  echo "- Cores/gr33k.SegaCD"
  echo "- Cores/Gr33k.SegaCD"
  echo "- Platforms/gr33k.SegaCD.json"
  echo "- Platforms/gr33k_segacd.json"
  echo "- Platforms/segacd.json"
  echo "- Assets/gr33k_segacd"
  echo "- Assets/segacd"
  echo
  echo "## Copy target"
  echo "Copy the contents of build/pocket_sd_genesis_first_boot/ onto the Pocket SD card root."
  echo
  echo "## Staged identity"
  echo "- Core folder: Cores/$CORE_DIR_NAME"
  echo "- Core author: $AUTHOR"
  echo "- Core shortname: $SHORTNAME"
  echo "- Platform ID: $PLATFORM_ID"
  echo "- Platform file: Platforms/$PLATFORM_FILE"
  echo "- Asset folder: Assets/segacd/common"
  echo
  echo "## After copying"
  echo "- Fully shut down the Pocket."
  echo "- Remove and reinsert the SD card if needed."
  echo "- Power it back on."
  echo "- Open openFPGA."
  echo "- Look under Console for Sega CD."
} > "$GUIDE_DOC"

{
  echo "# First Genesis ROM test plan"
  echo "Generated: $TIMESTAMP"
  echo
  echo "- Current package registers as a separate Sega CD platform."
  echo "- Current core implementation is still Genesis only."
  echo "- Place one known-good Genesis ROM manually in Assets/segacd/common for the first test."
  echo "- Do not copy the ROM into git."
  echo "- Do not test Sega CD or 32X content yet."
  echo
  echo "## First checks"
  echo "- Sega CD appears in the Console list"
  echo "- The core opens"
  echo "- A known-good Genesis ROM can be selected from the staged asset path"
  echo "- Video either appears or black screens"
  echo "- Controls respond"
  echo "- Audio is present"
} > "$ROM_DOC"
