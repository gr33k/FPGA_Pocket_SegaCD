#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT="$ROOT_DIR/docs/FIRST_GENESIS_BOOT_CANDIDATE_CHECK.md"
STATUS="$ROOT_DIR/docs/FIRST_GENESIS_BOOT_CANDIDATE_STATUS.md"
ARTIFACTS="$ROOT_DIR/docs/FIRST_GENESIS_BUILD_ARTIFACTS.md"
PACKAGE="$ROOT_DIR/docs/FIRST_GENESIS_OPENFPGA_PACKAGE_STATUS.md"
GUIDE="$ROOT_DIR/docs/FIRST_GENESIS_SD_STAGING_GUIDE.md"
ROM_PLAN="$ROOT_DIR/docs/FIRST_GENESIS_ROM_TEST_PLAN.md"
TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

ok() { echo "PASS: $1" >> "$REPORT"; }
warn() { echo "WARN: $1" >> "$REPORT"; }

{
  echo "# First Genesis boot candidate check"
  echo "Generated: $TIMESTAMP"
  echo
} > "$REPORT"

[[ -f "$STATUS" ]] && ok "status doc exists" || warn "status doc missing"
[[ -f "$ARTIFACTS" ]] && ok "artifact doc exists" || warn "artifact doc missing"
[[ -f "$PACKAGE" ]] && ok "package status doc exists" || warn "package status doc missing"
[[ -f "$GUIDE" ]] && ok "SD staging guide exists" || warn "SD staging guide missing"
[[ -f "$ROM_PLAN" ]] && ok "ROM test plan exists" || warn "ROM test plan missing"

if git -C "$ROOT_DIR" status --short -- build/genesis_first_boot_artifacts build/pocket_sd_genesis_first_boot | grep -q .; then
  warn "generated build artifacts appear in git status"
else
  ok "generated build artifacts not tracked by git"
fi

if git -C "$ROOT_DIR" status --short third_party/openFPGA-Genesis third_party/Genesis_MiSTer | grep -q .; then
  warn "third_party is dirty"
else
  ok "third_party clean"
fi

rom_like_hits=""
if [[ -d "$ROOT_DIR/build/pocket_sd_genesis_first_boot" ]]; then
  rom_like_hits="$(find "$ROOT_DIR/build/pocket_sd_genesis_first_boot" -type f \( -iname '*.bin' -o -iname '*.gen' -o -iname '*.smd' -o -iname '*.iso' -o -iname '*.cue' -o -iname '*.chd' \) \
    ! -path '*/Cores/*/icon.bin' \
    ! -path '*/Platforms/_images/*.bin' | sed -n '1,20p')"
fi
if [[ -n "$rom_like_hits" ]]; then
  warn "ROM-like files found in staged package"
  echo "$rom_like_hits" >> "$REPORT"
else
  ok "no ROM-like payloads staged beyond expected metadata assets"
fi

status_result="$(awk -F': ' '/^Result:/{print $2; exit}' "$STATUS" 2>/dev/null || true)"
package_result="$(awk -F': ' '/^Result:/{print $2; exit}' "$PACKAGE" 2>/dev/null || true)"
final_result="$status_result"
if [[ -n "$package_result" ]]; then
  final_result="$package_result"
fi

echo >> "$REPORT"
echo "Status result: ${status_result:-unknown}" >> "$REPORT"
echo "Package result: ${package_result:-unknown}" >> "$REPORT"
echo "Final result: ${final_result:-unknown}" >> "$REPORT"
