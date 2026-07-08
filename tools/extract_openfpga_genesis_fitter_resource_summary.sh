#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAP_LOG="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt"
FIT_LOG="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt"
OUT_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_RESOURCE_SUMMARY.md"
NOW="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

if [[ ! -f "$MAP_LOG" || ! -f "$FIT_LOG" ]]; then
  echo "Missing required 7O logs."
  echo "Expected:"
  echo "- $MAP_LOG"
  echo "- $FIT_LOG"
  exit 1
fi

extract_unique() {
  local file="$1"
  local pattern="$2"
  rg "$pattern" "$file" | sort -u
}

selected_device="$(extract_unique "$MAP_LOG" 'intended_device_family' | head -n 1)"
[ -z "$selected_device" ] && selected_device="not captured in current logs"

promoted_clocks="$(rg -n 'global input pin|global clock|promot' "$FIT_LOG" | head -n 40 || true)"
memory_notes="$(rg -n 'RAM|memory|altsyncram|sdram|sram|pll' "$FIT_LOG" "$MAP_LOG" | head -n 60 || true)"
resource_lines="$(rg -n 'Info \(21057\)|Info \(21058\)|Info \(21059\)|Info \(21060\)|Info \(21061\)|Info \(21064\)|Info \(21065\)|Implemented [0-9]+ (device resources|input pins|output pins|bidirectional pins|logic cells|RAM segments|PLLs|DSP elements)' "$MAP_LOG" | head -n 40 || true)"
pin_warning_lines="$(rg -n 'assignment|pin|IO|I/O|no output enable|output enable|permanently disabled|No output dependent|incomplete I/O assignments' "$FIT_LOG" | head -n 80 || true)"
pll_lines="$(rg -n 'LogicLock|(292013)|PLL|altera_pll|pll' "$FIT_LOG" | head -n 80 || true)"
non_dedicated="$(rg -n 'non-dedicated|global input pin|clock routing' "$FIT_LOG" | head -n 60 || true)"
fit_success="$(rg -n 'Quartus Prime Fitter was successful|fit was successful' "$FIT_LOG" | head -n 3 || true)"

: > "$OUT_FILE"
{
  echo "# openFPGA Genesis fitter resource summary"
  echo "Generated: $NOW"
  echo
  echo "## Source files"
  echo "- Map log: $MAP_LOG"
  echo "- Fit log: $FIT_LOG"
  echo
  echo "## Selected device context"
  echo "$selected_device"
  echo
  echo "## Promoted/global clocks"
  if [[ -n "$promoted_clocks" ]]; then
    echo "$promoted_clocks"
  else
    echo "- no captured promoted/global clock lines in map/fitter smoke logs"
  fi
  echo
  echo "## Global clocks and I/O routing notes"
  if [[ -n "$non_dedicated" ]]; then
    echo "$non_dedicated"
  else
    echo "- no non-dedicated clock routing lines were captured in this run"
  fi
  echo
  echo "## Memory block notes"
  if [[ -n "$memory_notes" ]]; then
    echo "$memory_notes"
  else
    echo "- no explicit memory block timing/setup/hold notes found in captured text"
  fi
  echo
  echo "## Resource utilization"
  if [[ -n "$resource_lines" ]]; then
    echo "$resource_lines"
  else
    echo "- current logs do not include complete resource table lines"
    echo "- recommend improving future fitter capture for formal utilization checks before timing gate"
  fi
  echo
  echo "## Pin / I/O assignment warnings"
  if [[ -n "$pin_warning_lines" ]]; then
    echo "$pin_warning_lines"
  else
    echo "- no direct pin warning lines matched in this fit log"
  fi
  echo
  echo "## PLL / IP warning lines"
  if [[ -n "$pll_lines" ]]; then
    echo "$pll_lines"
  else
    echo "- no PLL/IP warning lines matched"
  fi
  echo
  echo "## Completion"
  if [[ -n "$fit_success" ]]; then
    echo "$fit_success"
  else
    echo "- fit completion line not found in committed logs"
  fi
} > "$OUT_FILE"

echo "Wrote $OUT_FILE"
