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
CORE_ID="gr33k.SegaCD"
UPSTREAM_CORE_ID="ericlewis.Genesis"
PLATFORM_ID="gr33k_segacd"
PLATFORM_FILE="gr33k_segacd.json"
UPSTREAM_PLATFORM_FILE="genesis.json"
DISPLAY_NAME="Sega CD"
DISPLAY_AUTHOR="Gr33k"
DISPLAY_DESCRIPTION="Genesis-based FPGA core with future Sega CD/32X expansion path."
PROJECT_URL="https://github.com/gr33k/FPGA_Pocket_SegaCD"

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

if [[ ! -d "$UPSTREAM_DIR/dist/Cores/$UPSTREAM_CORE_ID" || ! -f "$UPSTREAM_DIR/dist/Platforms/$UPSTREAM_PLATFORM_FILE" ]]; then
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
mkdir -p "$STAGE_ROOT/Cores" "$STAGE_ROOT/Platforms"
cp -R "$UPSTREAM_DIR/dist/Cores/$UPSTREAM_CORE_ID" "$STAGE_ROOT/Cores/$CORE_ID"
cp -f "$UPSTREAM_DIR/dist/Platforms/$UPSTREAM_PLATFORM_FILE" "$STAGE_ROOT/Platforms/$PLATFORM_FILE"

CORE_JSON="$STAGE_ROOT/Cores/$CORE_ID/core.json"
PLATFORM_JSON="$STAGE_ROOT/Platforms/$PLATFORM_FILE"
python3 - <<PY
import json
from pathlib import Path
core_path = Path(r'''$CORE_JSON''')
platform_path = Path(r'''$PLATFORM_JSON''')
core = json.loads(core_path.read_text())
meta = core['core']['metadata']
meta['platform_ids'] = ['$PLATFORM_ID']
meta['shortname'] = '$DISPLAY_NAME'
meta['description'] = '$DISPLAY_DESCRIPTION'
meta['author'] = '$DISPLAY_AUTHOR'
meta['url'] = '$PROJECT_URL'
core_path.write_text(json.dumps(core, indent=4) + "\n")
platform = json.loads(platform_path.read_text())
platform['platform']['name'] = '$DISPLAY_NAME'
platform['platform']['year'] = 1991
platform['platform']['category'] = 'Console'
platform['platform']['manufacturer'] = 'Sega'
platform_path.write_text(json.dumps(platform, indent=2) + "\n")
PY

artifact_name="$(basename "$artifact")"
if [[ "$artifact_name" == *.rbf_r ]]; then
  cp -f "$artifact" "$STAGE_ROOT/Cores/$CORE_ID/bitstream.rbf_r"
  RESULT="READY_FOR_POCKET_SD_SMOKE_TEST"
elif [[ "$artifact_name" == *.rbf ]]; then
  cp -f "$artifact" "$STAGE_ROOT/Cores/$CORE_ID/bitstream.rbf"
  RESULT="CONVERSION_REQUIRED"
else
  RESULT="CONVERSION_REQUIRED"
fi

{
  echo "Result: $RESULT"
  echo "Upstream metadata source: third_party/openFPGA-Genesis/dist"
  echo "Artifact source: ${artifact#$ROOT_DIR/}"
  echo "Stage root: build/pocket_sd_genesis_first_boot"
  echo "Core path: build/pocket_sd_genesis_first_boot/Cores/$CORE_ID"
  echo "Platform path: build/pocket_sd_genesis_first_boot/Platforms/$PLATFORM_FILE"
  echo "Display author: $DISPLAY_AUTHOR"
  echo "Display name: $DISPLAY_NAME"
  echo "Description: $DISPLAY_DESCRIPTION"
  echo "Project URL: $PROJECT_URL"
  echo "Upstream attribution source: dist/Cores/$UPSTREAM_CORE_ID and dist/Platforms/$UPSTREAM_PLATFORM_FILE"
  if [[ "$RESULT" == "CONVERSION_REQUIRED" ]]; then
    echo "Package skeleton staged, but final openFPGA-ready artifact format still needs conversion to bitstream.rbf_r."
  fi
} >> "$PACKAGE_DOC"

{
  echo "# First Genesis SD staging guide"
  echo "Generated: $TIMESTAMP"
  echo
  echo "Result: $RESULT"
  echo
  echo "## Staged folder"
  echo "- build/pocket_sd_genesis_first_boot/"
  echo
  echo "## Copy target"
  echo "Copy the contents of build/pocket_sd_genesis_first_boot/ onto the Pocket SD card root so that Cores/ and Platforms/ land in the expected openFPGA layout."
  echo
  echo "## Candidate paths"
  echo "- build/pocket_sd_genesis_first_boot/Cores/$CORE_ID"
  echo "- build/pocket_sd_genesis_first_boot/Platforms/$PLATFORM_FILE"
  echo
  echo "## Display identity"
  echo "- Author: $DISPLAY_AUTHOR"
  echo "- Name: $DISPLAY_NAME"
  echo "- Current implementation: Genesis only"
  echo "- Future path: Sega CD / 32X investigation later"
  echo
  echo "## Notes"
  echo "- Package identity renamed from $UPSTREAM_CORE_ID to $CORE_ID to avoid upstream-name conflicts."
  echo "- Upstream attribution is preserved via the reused metadata source and project docs."
  echo "- No ROM is bundled."
  echo "- No Sega CD or 32X assets are staged in this build."
  echo "- This is a first boot candidate only."
} > "$GUIDE_DOC"

{
  echo "# First Genesis ROM test plan"
  echo "Generated: $TIMESTAMP"
  echo
  echo "- Current displayed core identity: $DISPLAY_AUTHOR / $DISPLAY_NAME"
  echo "- Current implementation is Genesis only."
  echo "- Future Sega CD and 32X work is deferred."
  echo "- Use one small known-good Genesis .bin or .gen ROM."
  echo "- Do not copy the ROM into git or the staged package."
  echo
  echo "## First hardware checks"
  echo "- Core appears in Pocket menu with the renamed identity"
  echo "- ROM browser opens"
  echo "- ROM loads"
  echo "- Video syncs"
  echo "- Controls respond"
  echo "- Audio is present"
  echo
  echo "## Failure recording"
  echo "Record the exact first failure: missing core, load failure, black screen, no controls, no audio, crash, or reset loop."
} > "$ROM_DOC"
