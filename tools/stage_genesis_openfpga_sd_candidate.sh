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

if [[ ! -d "$UPSTREAM_DIR/dist/Cores/ericlewis.Genesis" || ! -f "$UPSTREAM_DIR/dist/Platforms/genesis.json" ]]; then
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
cp -R "$UPSTREAM_DIR/dist/Cores/ericlewis.Genesis" "$STAGE_ROOT/Cores/"
cp -R "$UPSTREAM_DIR/dist/Platforms/." "$STAGE_ROOT/Platforms/"

artifact_name="$(basename "$artifact")"
if [[ "$artifact_name" == *.rbf_r ]]; then
  cp -f "$artifact" "$STAGE_ROOT/Cores/ericlewis.Genesis/bitstream.rbf_r"
  RESULT="READY_FOR_POCKET_SD_SMOKE_TEST"
elif [[ "$artifact_name" == *.rbf ]]; then
  cp -f "$artifact" "$STAGE_ROOT/Cores/ericlewis.Genesis/bitstream.rbf"
  RESULT="CONVERSION_REQUIRED"
else
  RESULT="CONVERSION_REQUIRED"
fi

{
  echo "Result: $RESULT"
  echo "Upstream metadata source: third_party/openFPGA-Genesis/dist"
  echo "Artifact source: ${artifact#$ROOT_DIR/}"
  echo "Stage root: build/pocket_sd_genesis_first_boot"
  echo "Core path: build/pocket_sd_genesis_first_boot/Cores/ericlewis.Genesis"
  echo "Platform path: build/pocket_sd_genesis_first_boot/Platforms"
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
  echo "- build/pocket_sd_genesis_first_boot/Cores/ericlewis.Genesis"
  echo "- build/pocket_sd_genesis_first_boot/Platforms/genesis.json"
  echo
  echo "## Notes"
  echo "- No ROM is bundled."
  echo "- No Sega CD or 32X assets are staged."
  echo "- This is a first boot candidate only."
} > "$GUIDE_DOC"

{
  echo "# First Genesis ROM test plan"
  echo "Generated: $TIMESTAMP"
  echo
  echo "- Test Genesis only."
  echo "- Do not test Sega CD."
  echo "- Do not test 32X."
  echo "- Use one small known-good Genesis .bin or .gen ROM."
  echo "- Do not copy the ROM into git or the staged package."
  echo
  echo "## First hardware checks"
  echo "- Core appears in Pocket menu"
  echo "- ROM browser opens"
  echo "- ROM loads"
  echo "- Video syncs"
  echo "- Controls respond"
  echo "- Audio is present"
  echo
  echo "## Failure recording"
  echo "Record the exact first failure: missing core, load failure, black screen, no controls, no audio, crash, or reset loop."
} > "$ROM_DOC"
