#!/usr/bin/env bash
set -euo pipefail

REPORT="docs/POCKET_GENESIS_UPSTREAM_AUDIT_RESULT.md"

{
  echo "# Pocket Genesis upstream audit result"
  echo
  echo "Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo
  echo "## Submodule status"
  git submodule status third_party/openFPGA-Genesis 2>/dev/null || true
  git submodule status third_party/Analogizer_openFPGA-Genesis 2>/dev/null || true
  echo
  echo "## Primary upstream file checks"

  for f in \
    third_party/openFPGA-Genesis/README.md \
    third_party/openFPGA-Genesis/src/fpga/core/core_top.sv \
    third_party/openFPGA-Genesis/src/fpga/apf/apf_top.v \
    third_party/openFPGA-Genesis/src/fpga/core/rtl/system.sv
  do
    if [ -f "$f" ]; then
      echo "PASS: $f"
    else
      echo "WARN: missing $f"
    fi
  done

  echo
  echo "## Secondary upstream file checks"

  for f in \
    third_party/Analogizer_openFPGA-Genesis/README.md \
    third_party/Analogizer_openFPGA-Genesis/src/fpga/core/core_top.sv \
    third_party/Analogizer_openFPGA-Genesis/src/fpga/apf/apf_top.v \
    third_party/Analogizer_openFPGA-Genesis/src/fpga/core/rtl/system.sv
  do
    if [ -f "$f" ]; then
      echo "PASS: $f"
    else
      echo "WARN: missing $f"
    fi
  done

  echo
  echo "## Pattern checks in primary upstream"
  for pattern in core_bridge_cmd data_loader sound_i2s sdram ROM_ACK ROM_REQ video_rgb_clock joystick_0; do
    if grep -R "$pattern" third_party/openFPGA-Genesis/src/fpga  >/dev/null 2>&1; then
      echo "PASS: found pattern "
    else
      echo "WARN: missing pattern "
    fi
  done

  echo
  echo "## Pattern checks in secondary upstream"
  for pattern in core_bridge_cmd data_loader sound_i2s sdram ROM_ACK ROM_REQ video_rgb_clock joystick_0 p1_controls Analogizer; do
    if grep -R "$pattern" third_party/Analogizer_openFPGA-Genesis  >/dev/null 2>&1; then
      echo "PASS: found pattern "
    else
      echo "WARN: missing pattern "
    fi
  done

  echo
  echo "## Current repo caution"
  echo "Current MiSTer scaffold remains research only."
  echo "Do not expand the old scaffold as the main implementation path until this pivot is reviewed."
  echo
  echo "Advisory exit code is always 0."
} > "$REPORT"

cat "$REPORT"
exit 0
