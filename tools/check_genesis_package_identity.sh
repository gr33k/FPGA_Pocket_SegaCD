#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT="$ROOT_DIR/docs/CHECK_GENESIS_PACKAGE_IDENTITY.md"
CORE_DIR="$ROOT_DIR/build/pocket_sd_genesis_first_boot/Cores/Gr33k.SegaCD"
CORE_JSON="$CORE_DIR/core.json"
PLATFORM_JSON="$ROOT_DIR/build/pocket_sd_genesis_first_boot/Platforms/segacd.json"
ASSET_DIR="$ROOT_DIR/build/pocket_sd_genesis_first_boot/Assets/segacd/common"
TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
PASS=true

pass() { echo "PASS: $1" >> "$REPORT"; }
fail() { echo "FAIL: $1" >> "$REPORT"; PASS=false; }

{
  echo "# Genesis package identity check"
  echo "Generated: $TIMESTAMP"
  echo
} > "$REPORT"

[[ -d "$CORE_DIR" ]] && pass "Cores/Gr33k.SegaCD exists" || fail "Cores/Gr33k.SegaCD missing"
[[ ! -e "$ROOT_DIR/build/pocket_sd_genesis_first_boot/Cores/gr33k.SegaCD" ]] && pass "legacy lowercase core folder not staged" || fail "Cores/gr33k.SegaCD still staged"
[[ -f "$PLATFORM_JSON" ]] && pass "Platforms/segacd.json exists" || fail "Platforms/segacd.json missing"
[[ ! -e "$ROOT_DIR/build/pocket_sd_genesis_first_boot/Platforms/gr33k.SegaCD.json" ]] && pass "legacy gr33k.SegaCD platform file not staged" || fail "Platforms/gr33k.SegaCD.json still staged"
[[ ! -e "$ROOT_DIR/build/pocket_sd_genesis_first_boot/Platforms/gr33k_segacd.json" ]] && pass "legacy gr33k_segacd platform file not staged" || fail "Platforms/gr33k_segacd.json still staged"
[[ -d "$ASSET_DIR" ]] && pass "Assets/segacd/common exists" || fail "Assets/segacd/common missing"
[[ -f "$CORE_DIR/bitstream.rbf_r" ]] && pass "bitstream.rbf_r exists" || fail "bitstream.rbf_r missing"

if grep -q '"author": "Gr33k"' "$CORE_JSON"; then pass "author equals Gr33k"; else fail "author is not Gr33k"; fi
if grep -q '"shortname": "SegaCD"' "$CORE_JSON"; then pass "shortname equals SegaCD"; else fail "shortname is not SegaCD"; fi
if grep -q '"platform_ids": \[' "$CORE_JSON" && grep -q '"segacd"' "$CORE_JSON"; then pass "platform_ids contains segacd"; else fail "platform_ids does not contain segacd"; fi
if grep -q 'genesis' "$CORE_JSON"; then fail "platform_ids still contains genesis"; else pass "platform_ids does not contain genesis"; fi
if grep -q 'gr33k_segacd' "$CORE_JSON"; then fail "platform_ids still contains gr33k_segacd"; else pass "platform_ids does not contain gr33k_segacd"; fi
if grep -q '"name": "Sega CD"' "$PLATFORM_JSON"; then pass "platform display name equals Sega CD"; else fail "platform display name is not Sega CD"; fi
if grep -q '"category": "Console"' "$PLATFORM_JSON"; then pass "platform category equals Console"; else fail "platform category is not Console"; fi

if grep -R 'ericlewis' "$ROOT_DIR/build/pocket_sd_genesis_first_boot" >/dev/null 2>&1; then
  fail "active staged package still contains ericlewis identity"
else
  pass "no active ericlewis identity remains"
fi

rom_hits="$(find "$ASSET_DIR" -type f \( -iname '*.bin' -o -iname '*.gen' -o -iname '*.smd' -o -iname '*.iso' -o -iname '*.cue' -o -iname '*.chd' \) | sed -n '1,20p')"
if [[ -n "$rom_hits" ]]; then
  fail "ROM-like file found under Assets/segacd/common"
  echo "$rom_hits" >> "$REPORT"
else
  pass "no ROM is staged under Assets/segacd/common"
fi

if $PASS; then
  echo >> "$REPORT"
  echo "Result: PASS" >> "$REPORT"
else
  echo >> "$REPORT"
  echo "Result: FAIL" >> "$REPORT"
fi
