#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WARNING_SUMMARY="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md"
FIT_LOG="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt"
MAP_LOG="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt"
QSF="$ROOT_DIR/third_party/openFPGA-Genesis/src/fpga/ap_core.qsf"
CORE_TOP="$ROOT_DIR/third_party/openFPGA-Genesis/src/fpga/core/core_top.sv"
APF_TOP="$ROOT_DIR/third_party/openFPGA-Genesis/src/fpga/apf/apf_top.v"
PLL_QIP="$ROOT_DIR/third_party/openFPGA-Genesis/src/fpga/core/mf_pllbase.qip"
PLL_V="$ROOT_DIR/third_party/openFPGA-Genesis/src/fpga/core/mf_pllbase.v"
DOC="$ROOT_DIR/docs/OPENFPGA_GENESIS_PRIORITY1_CLOCKING_REVIEW.md"

NOW="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

required=("$WARNING_SUMMARY" "$FIT_LOG" "$MAP_LOG" "$QSF" "$CORE_TOP" "$APF_TOP" "$PLL_QIP" "$PLL_V")
for file in "${required[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required file: $file" >&2
    exit 1
  fi
done

rel_path() {
  local path="$1"
  if [[ "$path" == "$ROOT_DIR"* ]]; then
    echo "${path#$ROOT_DIR/}"
  else
    echo "$path"
  fi
}

count_code() {
  local code="$1"
  rg -m 1 "^- CODE_${code}[[:space:]]*\| count=" "$WARNING_SUMMARY" 2>/dev/null \
    | sed -E "s/.*count=([0-9]+).*/\\1/" \
    | tr -dc '0-9' \
    || true
}

count_text() {
  local pattern="$1"
  local count
  count="$(rg -c "$pattern" "$FIT_LOG" "$MAP_LOG" 2>/dev/null | awk -F: '{s+=$2} END {print s+0}')"
  echo "$count"
}

sample_code() {
  local code="$1"
  local sample
  sample="$(rg -m 1 "Warning \(${code}\)" "$FIT_LOG" "$MAP_LOG" 2>/dev/null || true)"
  if [[ -n "$sample" ]]; then
    sample="${sample//$ROOT_DIR\//}"
    echo "- $sample"
  fi
}

sample_text() {
  local pattern="$1"
  local sample
  sample="$(rg -m 1 "$pattern" "$FIT_LOG" "$MAP_LOG" 2>/dev/null || true)"
  if [[ -n "$sample" ]]; then
    sample="${sample//$ROOT_DIR\//}"
    echo "- $sample"
  fi
}

source_ref() {
  local pattern="$1"
  local file="$2"
  local found
  found="$(rg -n -F "$pattern" "$file" 2>/dev/null | head -n 1 || true)"
  if [[ -z "$found" ]]; then
    echo "- source not found in checked docs/source snapshots"
    return
  fi
  local src
  local body
  src="${found%%:*}"
  body="${found#*:}"
  if [[ "$src" == "$ROOT_DIR"* ]]; then
    src="${src#$ROOT_DIR/}"
  fi
  echo "- ${src}:${body}"
}

source_context() {
  local pattern="$1"
  local file="$2"
  local line
  local line_no
  local start
  local end
  local max

  line="$(rg -n -F "$pattern" "$file" 2>/dev/null | head -n 1 || true)"
  if [[ -z "$line" ]]; then
    echo "- source context not found in captured files"
    return
  fi

  line_no="$(echo "$line" | cut -d: -f2)"
  line_no="$(echo "$line_no" | tr -cd '0-9')"
  if [[ -z "$line_no" ]]; then
    echo "- source context parse failed"
    return
  fi

  if ! [[ "$line_no" =~ ^[0-9]+$ ]]; then
    echo "- source context parse failed"
    return
  fi

  start=$((line_no-2))
  end=$((line_no+2))
  if (( start < 1 )); then
    start=1
  fi

  # show compact context if possible (works for both Linux/Mac sed with GNU-like options)
  context="$(sed -n "${start},${end}p" "$file" | sed -e "s#^#line-#" || true)"
  if [[ -n "$context" ]]; then
    echo "- source context around match (lines ${start}-${end}):"
    while IFS= read -r ctx; do
      echo "  $ctx"
    done <<<"$context"
  else
    echo "- source context unavailable"
  fi
}

emit_entry() {
  local cls="$1"
  local count="$2"
  local sample="$3"
  local source="$4"
  local status="$5"
  local action="$6"

  echo "### $cls"
  echo "- total instances: $count"
  if [[ -n "$sample" ]]; then
    echo "- sample: $sample"
  fi
  if [[ -n "$source" ]]; then
    echo "- source: $source"
  fi
  echo "- status: $status"
  echo "- next action: $action"
  echo
}

count_19016="$(count_code 19016)"
count_19017="$(count_code 19017)"
count_16406="$(count_code 16406)"
count_16407="$(count_code 16407)"
count_pll_reset="$(count_text 'RST port on the PLL is not properly connected')"
count_non_dedicated="$(count_code 16406)"

if [[ -z "$count_16406" ]]; then
  count_16406=0
fi
if [[ -z "$count_16407" ]]; then
  count_16407=0
fi
if [[ -z "$count_19016" ]]; then
  count_19016=0
fi
if [[ -z "$count_19017" ]]; then
  count_19017=0
fi
if [[ -z "$count_pll_reset" ]]; then
  count_pll_reset=0
fi
if [[ -z "$count_non_dedicated" ]]; then
  count_non_dedicated=0
fi

total_priority1=$((count_16406 + count_16407 + count_19016 + count_19017 + count_non_dedicated + count_pll_reset))

{
  echo "# openFPGA Genesis Priority-1 clocking review"
  echo "Generated: $NOW"
  echo "Inputs checked:"
  echo "- $(rel_path "$WARNING_SUMMARY")"
  echo "- $(rel_path "$FIT_LOG")"
  echo "- $(rel_path "$MAP_LOG")"
  echo "- $(rel_path "$QSF")"
  echo "- $(rel_path "$CORE_TOP")"
  echo "- $(rel_path "$APF_TOP")"
  echo
  echo "Scope: Priority-1 clock/reset/pixel mux warnings only"
  echo "No Quartus fitter/assembler/timing/bitstream steps are run by this script."
  echo

  echo "## Priority-1 instances"
  emit_entry NON_DEDICATED_CLOCK_ROUTING "$count_non_dedicated" "$(sample_code 16406)" "$(source_ref 'clk_74b' "$QSF")" "needs review before timing gate" "Review QSF clock assignment and pin plan with bridge/pll timing expectations."
  emit_entry CODE_16406 "$count_16406" "$(sample_code 16406)" "$(source_ref 'clk_74b' "$QSF")" "needs review before timing gate" "Review PLL/refclk placement for pocket clock intent before timing gate."
  emit_entry CODE_16407 "$count_16407" "$(sample_code 16407)" "$(source_ref 'bridge_spiclk' "$QSF")" "needs review before timing gate" "Validate REFCLK and clock enable intent from timing review notes."
  emit_entry CODE_19016 "$count_19016" "$(sample_code 19016)" "$(source_ref 'current_pix_clk' "$CORE_TOP")" "needs review before timing gate" "Review pixel clock mux intent and gating before next timing step."
  emit_entry CODE_19017 "$count_19017" "$(sample_code 19017)" "$(source_ref 'current_pix_clk' "$CORE_TOP")" "needs review before timing gate" "Confirm active pix clock branch and fanout mapping before timing cleanup."
  emit_entry PLL_RESET_NOT_CONNECTED "$count_pll_reset" "$(sample_text 'RST port on the PLL is not properly connected')" "$(source_ref 'pll_reset' "$PLL_V")" "needs review before timing gate" "Document PLL reset plan and whether deterministic recovery is required for this milestone."

  echo "## Priority-1 aggregate"
  echo "- total priority1 review items: $total_priority1"
  if (( total_priority1 > 0 )); then
    echo "- required action before timing-gate handoff: still-review-required"
  else
    echo "- required action before timing-gate handoff: review-complete"
  fi
  echo
  echo "## Guidance"
  echo "- This document is clocking-focused and does not authorize fitter/assembler/bitstream."
  echo "- Do not claim runtime correctness from this review-only stage."
  echo "- Coordinate with source-level QSF/APF edits before any timing gate promotion."
} > "$DOC"

echo "Wrote $(rel_path "$DOC")"
