#!/usr/bin/env bash
set -euo pipefail

REPORT="docs/OPENFPGA_GENESIS_SUBMODULE_STATUS.md"
ROOT="third_party/openFPGA-Genesis"

{
  echo "# openFPGA-Genesis submodule status"
  echo
  echo "Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo
  echo "## Submodule"
  echo "- Path: \`$ROOT\`"
  echo "- Upstream: https://github.com/opengateware/openFPGA-Genesis"
  echo

  if [ -d "$ROOT/.git" ] || [ -f "$ROOT/.git" ]; then
    echo "- Submodule present: yes"
    echo "- Commit: $(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo unknown)"
  else
    echo "- Submodule present: no"
  fi

  echo
  echo "## Required files"

  for f in \
    "$ROOT/README.md" \
    "$ROOT/src/fpga/core/core_top.sv" \
    "$ROOT/src/fpga/apf/apf_top.v" \
    "$ROOT/src/fpga/core/rtl/system.sv"
  do
    if [ -f "$f" ]; then
      echo "- PASS: $f"
    else
      echo "- WARN: missing $f"
    fi
  done

  echo
  echo "## Pattern checks"

  for pattern in core_bridge_cmd data_loader data_unloader sdram sound_i2s ROM_REQ ROM_ACK video_rgb_clock joystick_0; do
    if grep -R "$pattern" "$ROOT/src/fpga" >/dev/null 2>&1; then
      echo "- PASS: found $pattern"
    else
      echo "- WARN: missing $pattern"
    fi
  done

  echo
  echo "## Policy"
  echo "- Submodule files are read-only."
  echo "- Genesis_MiSTer remains reference-only."
  echo "- Sega CD and 32X remain deferred."
  echo "- No Quartus run occurred in this check."
  echo "- No synthesis or Pocket boot is claimed."
} > "$REPORT"

cat "$REPORT"
exit 0
