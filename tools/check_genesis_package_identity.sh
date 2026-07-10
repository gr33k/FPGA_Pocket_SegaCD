#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT="$ROOT_DIR/docs/CHECK_GENESIS_PACKAGE_IDENTITY.md"
CORE_DIR="$ROOT_DIR/build/pocket_sd_genesis_first_boot/Cores/gr33k.SegaCD"
PLATFORM_JSON="$ROOT_DIR/build/pocket_sd_genesis_first_boot/Platforms/gr33k_segacd.json"
CORE_JSON="$CORE_DIR/core.json"
IDENTITY_DOC="$ROOT_DIR/docs/FIRST_GENESIS_PACKAGE_IDENTITY.md"
TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
PASS=true

pass() { echo "PASS: $1" >> "$REPORT"; }
fail() { echo "FAIL: $1" >> "$REPORT"; PASS=false; }

{
  echo "# Genesis package identity check"
  echo "Generated: $TIMESTAMP"
  echo
} > "$REPORT"

[[ -d "$CORE_DIR" ]] && pass "Cores/gr33k.SegaCD exists" || fail "Cores/gr33k.SegaCD missing"
[[ -f "$PLATFORM_JSON" ]] && pass "Platforms/gr33k_segacd.json exists" || fail "Platforms/gr33k_segacd.json missing"
[[ -f "$IDENTITY_DOC" ]] && pass "identity doc exists" || fail "identity doc missing"
[[ ! -e "$ROOT_DIR/build/pocket_sd_genesis_first_boot/Cores/ericlewis.Genesis" ]] && pass "old upstream core path not staged" || fail "old upstream core path still staged"

if grep -q '"author": "Gr33k"' "$CORE_JSON"; then
  pass "author is Gr33k"
else
  fail "author is not Gr33k"
fi

if grep -q '"shortname": "Sega CD"' "$CORE_JSON"; then
  pass "core shortname is Sega CD"
else
  fail "core shortname is not Sega CD"
fi

if grep -q '"platform_ids": \[' "$CORE_JSON" && grep -q 'gr33k_segacd' "$CORE_JSON"; then
  pass "core platform_ids contains gr33k_segacd"
else
  fail "core platform_ids does not contain gr33k_segacd"
fi

if grep -q 'genesis' "$CORE_JSON"; then
  fail "platform_ids still contains genesis"
else
  pass "platform_ids no longer contains genesis"
fi

if [[ -e "$ROOT_DIR/build/pocket_sd_genesis_first_boot/Platforms/gr33k.SegaCD.json" ]]; then
  fail "legacy gr33k.SegaCD platform filename still staged"
else
  pass "legacy gr33k.SegaCD platform filename not staged"
fi

if grep -q '"name": "Sega CD"' "$PLATFORM_JSON"; then
  pass "platform name is Sega CD"
else
  fail "platform name is not Sega CD"
fi

if grep -q '"category": "Console"' "$PLATFORM_JSON"; then
  pass "platform category is Console"
else
  fail "platform category is not Console"
fi

if grep -R "ericlewis" "$ROOT_DIR/build/pocket_sd_genesis_first_boot" >/dev/null 2>&1; then
  fail "active staged package still contains ericlewis references"
else
  pass "no active ericlewis identity remains in staged package"
fi

if $PASS; then
  echo >> "$REPORT"
  echo "Result: PASS" >> "$REPORT"
else
  echo >> "$REPORT"
  echo "Result: FAIL" >> "$REPORT"
fi
