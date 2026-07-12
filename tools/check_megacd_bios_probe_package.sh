#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
REPORT=docs/CHECK_MEGACD_BIOS_PROBE_PACKAGE.md
CORE_DIR=build/pocket_sd_megacd_bios_probe/Cores/Gr33k.SegaCDBiosProbe
CORE_JSON="$CORE_DIR/core.json"
DATA_JSON="$CORE_DIR/data.json"
INTERACT_JSON="$CORE_DIR/interact.json"
BIT="$CORE_DIR/bitstream.rbf_r"
FRESH_BIT=build/megacd_pocket_artifacts/bitstream.rbf_r
RESULT=PASS
fail() { RESULT=FAIL; }
json_ok=yes
for f in "$CORE_DIR/audio.json" "$CORE_JSON" "$DATA_JSON" "$CORE_DIR/input.json" "$INTERACT_JSON" "$CORE_DIR/variants.json" "$CORE_DIR/video.json"; do
  [[ -f "$f" ]] || json_ok=no
  [[ -f "$f" ]] && jq empty "$f" >/dev/null 2>&1 || json_ok=no
done
[[ "$json_ok" == yes ]] || fail
core_exists=no; [[ -d "$CORE_DIR" ]] && core_exists=yes || fail
author="$(jq -r '.core.metadata.author // empty' "$CORE_JSON" 2>/dev/null || true)"
shortname="$(jq -r '.core.metadata.shortname // empty' "$CORE_JSON" 2>/dev/null || true)"
platform_ids="$(jq -c '.core.metadata.platform_ids // empty' "$CORE_JSON" 2>/dev/null || true)"
description="$(jq -r '.core.metadata.description // empty' "$CORE_JSON" 2>/dev/null || true)"
version_val="$(jq -r '.core.metadata.version // empty' "$CORE_JSON" 2>/dev/null || true)"
date_release="$(jq -r '.core.metadata.date_release // empty' "$CORE_JSON" 2>/dev/null || true)"
desc_len=${#description}
folder_match=no; [[ "Gr33k.$shortname" == "Gr33k.SegaCDBiosProbe" ]] && folder_match=yes || fail
[[ "$author" == "Gr33k" ]] || fail
[[ "$shortname" == "SegaCDBiosProbe" ]] || fail
[[ "$platform_ids" == '["genesis"]' ]] || fail
[[ $desc_len -le 63 ]] || fail
[[ -n "$version_val" ]] || fail
[[ -n "$date_release" ]] || fail
framework_target="$(jq -r '.core.framework.target_product // empty' "$CORE_JSON" 2>/dev/null || true)"
framework_ver="$(jq -r '.core.framework.version_required // empty' "$CORE_JSON" 2>/dev/null || true)"
dock_supported="$(jq -r '.core.framework.dock.supported // empty' "$CORE_JSON" 2>/dev/null || true)"
hardware_exists=no; jq -e '.core.framework.hardware' "$CORE_JSON" >/dev/null 2>&1 && hardware_exists=yes || fail
cores_exists=no; jq -e '.core.cores | type == "array" and length > 0' "$CORE_JSON" >/dev/null 2>&1 && cores_exists=yes || fail
core_filename="$(jq -r '.core.cores[0].filename // empty' "$CORE_JSON" 2>/dev/null || true)"
[[ "$framework_target" == 'Analogue Pocket' ]] || fail
[[ -n "$framework_ver" ]] || fail
[[ "$dock_supported" == 'true' ]] || fail
[[ "$core_filename" == 'bitstream.rbf_r' ]] || fail
bit_exists=no; [[ -s "$BIT" ]] && bit_exists=yes || fail
bit_size="$(stat -c '%s' "$BIT" 2>/dev/null || echo missing)"
bit_sha="$(sha256sum "$BIT" 2>/dev/null | awk '{print $1}')"
fresh_bit_exists=no; [[ -s "$FRESH_BIT" ]] && fresh_bit_exists=yes || fail
fresh_bit_size="$(stat -c '%s' "$FRESH_BIT" 2>/dev/null || echo missing)"
fresh_bit_sha="$(sha256sum "$FRESH_BIT" 2>/dev/null | awk '{print $1}')"
[[ "$bit_size" == "$fresh_bit_size" ]] || fail
[[ "$bit_sha" == "$fresh_bit_sha" ]] || fail
slot_count="$(jq '.data.data_slots | length' "$DATA_JSON" 2>/dev/null || echo 0)"
[[ "$slot_count" == '2' ]] || fail
slot_names_ok=yes
param_type_ok=yes
slot0_id="$(jq -r '.data.data_slots[0].id' "$DATA_JSON" 2>/dev/null || true)"
slot0_name="$(jq -r '.data.data_slots[0].name' "$DATA_JSON" 2>/dev/null || true)"
slot0_addr="$(jq -r '.data.data_slots[0].address' "$DATA_JSON" 2>/dev/null || true)"
slot1_id="$(jq -r '.data.data_slots[1].id' "$DATA_JSON" 2>/dev/null || true)"
slot1_name="$(jq -r '.data.data_slots[1].name' "$DATA_JSON" 2>/dev/null || true)"
slot1_req="$(jq -r '.data.data_slots[1].required' "$DATA_JSON" 2>/dev/null || true)"
slot1_addr="$(jq -r '.data.data_slots[1].address' "$DATA_JSON" 2>/dev/null || true)"
slot1_size="$(jq -r '.data.data_slots[1].size_exact' "$DATA_JSON" 2>/dev/null || true)"
while IFS= read -r name; do
  [[ ${#name} -le 15 ]] || slot_names_ok=no
done < <(jq -r '.data.data_slots[].name' "$DATA_JSON" 2>/dev/null || true)
while IFS= read -r t; do
  [[ "$t" == 'string' || "$t" == 'number' ]] || param_type_ok=no
done < <(jq -r '.data.data_slots[].parameters | type' "$DATA_JSON" 2>/dev/null || true)
[[ "$slot_names_ok" == yes ]] || fail
[[ "$param_type_ok" == yes ]] || fail
[[ "$slot0_id" == '0' && "$slot0_name" == 'Cartridge' && "$slot0_addr" == '0x10000000' ]] || fail
[[ "$slot1_id" == '1' && "$slot1_name" == 'Sega CD BIOS' && "$slot1_req" == 'true' && "$slot1_addr" == '0x20000000' && "$slot1_size" == '131072' ]] || fail
slot1_ext_ok=no; jq -e '.data.data_slots[1].extensions | index("rom") and index("bin")' "$DATA_JSON" >/dev/null 2>&1 && slot1_ext_ok=yes || fail
interact_ok=no
if jq -e '.interact.variables | length == 10' "$INTERACT_JSON" >/dev/null 2>&1 \
  && jq -e '.interact.variables | map(.name) | index("Mode Flags") and index("BIOS Last Addr") and index("BIOS First Word") and index("BIOS Last Word")' "$INTERACT_JSON" >/dev/null 2>&1; then
  interact_ok=yes
else
  fail
fi
payload_clean=yes
if find "$CORE_DIR" -type f \( -iname '*.rom' -o -iname '*.iso' -o -iname '*.cue' -o -iname '*.chd' -o -iname '*.wav' -o -iname '*.bin' -o -iname '*.gen' -o -iname '*.smd' \) ! -name 'icon.bin' | grep -q .; then
  payload_clean=no
  fail
fi
cat > "$REPORT" <<DOC
# MegaCD BIOS probe package check

- result: $RESULT
- core folder exists: $core_exists
- author is Gr33k: $([[ "$author" == 'Gr33k' ]] && echo yes || echo no)
- shortname is SegaCDBiosProbe: $([[ "$shortname" == 'SegaCDBiosProbe' ]] && echo yes || echo no)
- folder matches author.shortname: $folder_match
- platform_ids equals ["genesis"]: $([[ "$platform_ids" == '["genesis"]' ]] && echo yes || echo no)
- description length <= 63: $([[ $desc_len -le 63 ]] && echo yes || echo no)
- version exists: $([[ -n "$version_val" ]] && echo yes || echo no)
- date_release exists: $([[ -n "$date_release" ]] && echo yes || echo no)
- framework target product valid: $([[ "$framework_target" == 'Analogue Pocket' ]] && echo yes || echo no)
- framework version required present: $([[ -n "$framework_ver" ]] && echo yes || echo no)
- dock supported true: $([[ "$dock_supported" == 'true' ]] && echo yes || echo no)
- framework hardware exists: $hardware_exists
- cores array exists: $cores_exists
- cores[0].filename is bitstream.rbf_r: $([[ "$core_filename" == 'bitstream.rbf_r' ]] && echo yes || echo no)
- bitstream exists: $bit_exists
- staged bitstream matches fresh artifact size: $([[ "$bit_size" == "$fresh_bit_size" ]] && echo yes || echo no)
- staged bitstream matches fresh artifact sha: $([[ "$bit_sha" == "$fresh_bit_sha" ]] && echo yes || echo no)
- exactly two data slots: $([[ "$slot_count" == '2' ]] && echo yes || echo no)
- slot names <= 15 chars: $slot_names_ok
- parameters field type valid: $param_type_ok
- slot 0 valid: $([[ "$slot0_id" == '0' && "$slot0_name" == 'Cartridge' && "$slot0_addr" == '0x10000000' ]] && echo yes || echo no)
- slot 1 valid: $([[ "$slot1_id" == '1' && "$slot1_name" == 'Sega CD BIOS' && "$slot1_req" == 'true' && "$slot1_addr" == '0x20000000' && "$slot1_size" == '131072' ]] && echo yes || echo no)
- slot 1 extensions include rom and bin: $slot1_ext_ok
- required metadata JSON files valid: $json_ok
- debug interact menu present: $interact_ok
- staged payload hygiene clean: $payload_clean
DOC
[[ "$RESULT" == 'PASS' ]]
