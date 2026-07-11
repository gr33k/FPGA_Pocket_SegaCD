#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT="$ROOT_DIR/docs/GENESIS_RUNTIME_SMOKE_DEBUG_PLAN.md"
SRC="$ROOT_DIR/third_party/openFPGA-Genesis/src/fpga"
TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

capture() {
  local label="$1"
  local pattern="$2"
  echo "## $label" >> "$REPORT"
  if rg -n "$pattern" "$SRC" | sed -n '1,24p' >> "$REPORT"; then
    true
  else
    echo "No matches found." >> "$REPORT"
  fi
  echo >> "$REPORT"
}

{
  echo "# Genesis runtime smoke debug plan"
  echo "Generated: $TIMESTAMP"
  echo
  echo "Current observed runtime state from hardware smoke:"
  echo "- Core package loads on Pocket"
  echo "- Core settings/menu work"
  echo "- Launching a Genesis ROM produces a black screen"
  echo "- No visible crash/error has been reported"
  echo
  echo "This means packaging and bitstream loading worked, but the runtime execution path still needs evidence."
  echo
  echo "## Suspected failed subsystem"
  echo "- unknown"
  echo
  echo "## Investigation order"
  echo "1. ROM path and preload completion"
  echo "2. Reset release and PLL lock"
  echo "3. CPU execution after ROM load"
  echo "4. Video/VDP activity"
  echo "5. Audio activity"
  echo "6. Controller/input path"
  echo
  echo "## Evidence snapshots"
  echo
} > "$REPORT"

capture "ROM path evidence" 'data_loader|data_unloader|ROM_REQ|ROM_ACK|preload|Cart|Cartridge'
capture "Reset and PLL evidence" 'reset_n|reset|locked|pll|PLL'
capture "Video path evidence" 'video_rgb|video_rgb_clock|current_pix_clk|vdp|pixel'
capture "Audio path evidence" 'sound_i2s|audio_mclk|audio_lrck|audio_dac|audio'
capture "Controller path evidence" 'joystick_0|joystick|pad_|controller|input'

cat >> "$REPORT" <<'EOF2'
## Working hypothesis

The black screen is most likely in one of these buckets:
- ROM payload is not reaching the runtime path the way the core expects.
- Reset/PLL sequencing lets the package load but not the game logic execute.
- CPU runs but VDP/video output never becomes active.

Do not change RTL yet. Capture evidence that narrows the failure to ROM load, reset, CPU, video, audio, input, or unknown first.
EOF2
