#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
CORE=src/megacd_pocket/fpga/core/core_top.sv
DOC=docs/CHECK_MEGACD_BIOS_FETCH_MAPPING.md
status=PASS
failures=()

if rg -n "bios_ioctl_addr\[17:1\]" "$CORE" >/dev/null; then
  status=FAIL
  failures+=("old BIOS write slice bios_ioctl_addr[17:1] still present")
fi
if ! rg -n "\{8'b01111000, bios_ioctl_addr\[16:1\]\}" "$CORE" >/dev/null; then
  status=FAIL
  failures+=("correct BIOS write slice bios_ioctl_addr[16:1] missing")
fi
if ! rg -n "wire \[24:1\] bios_sdram_addr = \{8'b01111000, bios_ioctl_addr\[16:1\]\};" "$CORE" >/dev/null; then
  status=FAIL
  failures+=("width-correct BIOS write wire missing")
fi
if ! rg -n "wire \[24:1\] cart_sdram_addr = \{2'b00, cart_ioctl_addr\[22:1\]\};" "$CORE" >/dev/null; then
  status=FAIL
  failures+=("width-correct cartridge write wire missing")
fi
if ! rg -n "!GEN_ROM_CE_N  \? \{8'b01111000, GEN_VA\[16:1\]\}" "$CORE" >/dev/null; then
  status=FAIL
  failures+=("BIOS read prefix differs from expected 0x78 word base")
fi
if rg -n "\.ROM_MODE\(1'b1\)" "$CORE" >/dev/null; then
  status=FAIL
  failures+=("CART ROM_MODE is still hardcoded to 1'b1")
fi
if ! rg -n "\.ROM_MODE\(cart_mode_sys\)" "$CORE" >/dev/null; then
  status=FAIL
  failures+=("dynamic CART ROM_MODE selection missing")
fi
if ! rg -n "wire cart_loading_sys, bios_loading_sys, cart_mode_sys;" "$CORE" >/dev/null; then
  status=FAIL
  failures+=("synchronized cart/BIOS mode selection signals missing")
fi
if ! rg -n "wire megacd_mode_enabled = bios_load_complete_sys && bios_mode_sys;" "$CORE" >/dev/null; then
  status=FAIL
  failures+=("MegaCD enable gating on exact BIOS completion missing")
fi

first_word=0x780000
last_word=0x78FFFF
first_byte=0xF00000
last_byte=0xF1FFFE
bios_size=131072

{
  echo "# Check MegaCD BIOS fetch mapping"
  echo
  echo "- result: $status"
  echo "- first BIOS write word address: $first_word"
  echo "- last BIOS write word address: $last_word"
  echo "- first BIOS physical byte address: $first_byte"
  echo "- last BIOS physical byte address: $last_byte"
  echo "- BIOS exact size: $bios_size bytes"
  echo "- BIOS read prefix: 8'b01111000"
  echo "- BIOS write prefix: 8'b01111000"
  if ((${#failures[@]})); then
    echo "- failures:"
    for failure in "${failures[@]}"; do
      echo "  - $failure"
    done
  else
    echo "- failures: none"
  fi
} > "$DOC"

cat "$DOC"
[[ "$status" == "PASS" ]]
