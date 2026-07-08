#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WARNING_SUMMARY="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md"
REVIEW_DOC="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_UNKNOWN_WARNING_REVIEW.md"
RESOURCE_DOC="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_RESOURCE_SUMMARY.md"
GATE_DOC="$ROOT_DIR/docs/OPENFPGA_GENESIS_POST_FITTER_GATE.md"
PRIORITY1_GATE="$ROOT_DIR/docs/OPENFPGA_GENESIS_PRIORITY1_CLOCKING_GATE.md"
QSF="$ROOT_DIR/third_party/openFPGA-Genesis/src/fpga/ap_core.qsf"
APF_TOP="$ROOT_DIR/third_party/openFPGA-Genesis/src/fpga/apf/apf_top.v"
CORE_TOP="$ROOT_DIR/third_party/openFPGA-Genesis/src/fpga/core/core_top.sv"
OUT_DOC="$ROOT_DIR/docs/OPENFPGA_GENESIS_TIMING_REVIEW_BLOCKER_ORDER.md"
NOW="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

required=(
  "$WARNING_SUMMARY"
  "$REVIEW_DOC"
  "$RESOURCE_DOC"
  "$GATE_DOC"
  "$QSF"
  "$APF_TOP"
  "$CORE_TOP"
)
for file in "${required[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

class_count() {
  local cls="$1"
  local count
  local pattern
  if [[ "$cls" == CODE_* ]]; then
    cls="${cls#CODE_}"
  fi
  if [[ "$cls" == "PLL_RESET_NOT_CONNECTED" ]]; then
    pattern="- ${cls} | count="
  else
    pattern="- CODE_${cls} | count="
  fi
  count="$(rg --fixed-strings --max-count 1 -- "$pattern" "$WARNING_SUMMARY" 2>/dev/null | sed -E 's/.*count=([0-9]+).*/\1/' || true)"
  if [[ -z "$count" ]]; then
    count=0
  fi
  printf '%s' "$count"
}

sample_source() {
  local pattern="$1"
  local found
  local src
  local body

  found="$(rg -n -m 1 -- "$pattern" "$APF_TOP" "$CORE_TOP" "$QSF" 2>/dev/null | head -n 1 || true)"
  if [[ -n "$found" ]]; then
    src="${found%%:*}"
    body="${found#*:}"
    if [[ "$src" == "$ROOT_DIR"* ]]; then
      src="${src#$ROOT_DIR/}"
    fi
    echo "- $src:$body"
    return 0
  fi
  echo "- source not found in captured docs/source snapshots"
}

priority1_note() {
  local p1_decision="${1-PRIORITY1_CLOCKING_REVIEW_STILL_REQUIRED}"
  case "$p1_decision" in
    PRIORITY1_CLOCKING_BLOCKED)
      echo "is blocked before timing-review handoff."
    ;;
    PRIORITY1_CLOCKING_CLEARED_FOR_TIMING_REVIEW)
      echo "is cleared for timing-review handoff, but lower-priority groups may remain active."
    ;;
    *)
      echo "remains review-required before timing-review handoff."
    ;;
  esac
}

if [[ -f "$PRIORITY1_GATE" ]]; then
  p1_decision_line="$(rg -m1 'Current priority1 gate decision:' "$PRIORITY1_GATE" | sed -E 's/.*\*\*([^*]+)\*\*.*/\1/' | tr -d '[:space:]' || true)"
fi
if [[ -z "${p1_decision_line:-}" ]]; then
  p1_decision_line="PRIORITY1_CLOCKING_REVIEW_STILL_REQUIRED"
fi

emit_blockers() {
  local title="$1"
  local block_now="$2"
  shift 2
  local classes=($@)

  local cls
  for cls in "${classes[@]}"; do
    local count
    count="$(class_count "$cls")"
    if [[ "$count" == "0" ]]; then
      echo "### ${cls}"
      echo "- count: 0"
      echo "- status: no active instances"
      echo "- blocks_timing_gate_now: no"
      echo "- source review: none"
      echo "- next step: keep as documentation item until feature expands"
      echo
      continue
    fi

    echo "### ${cls}"
    echo "- count: $count"

    case "$cls" in
      NON_DEDICATED_CLOCK_ROUTING)
        echo "- reason: clocking constraints path may be too weak for timing review"
        echo "- source: $(sample_source 'non-dedicated')"
        echo "- recommended next task: review clocking topology and constraint intent before timing review"
        echo "- requires: QSF review"
        ;;
      CODE_16406)
        echo "- reason: PLL/clock pin behavior is timing-sensitive in scaffolded top-level"
        echo "- source: $(sample_source 'PIN_H16 -to clk_74b\|clk_74b')"
        echo "- recommended next task: resolve clock routing source intent in QSF and document timing-safe behavior"
        echo "- requires: APF pin-plan + QSF review"
        ;;
      CODE_16407)
        echo "- reason: PLL/clock pin behavior is timing-sensitive in scaffolded top-level"
        echo "- source: $(sample_source 'PIN_T17 -to bridge_spiclk\|bridge_spiclk\|inputCLKENA0')"
        echo "- recommended next task: review REFCLK routing intent before timing review"
        echo "- requires: APF pin-plan + QSF review"
        ;;
      CODE_19016|CODE_19017)
        echo "- reason: pixel clock muxing impacts timing path review"
        echo "- source: $(sample_source 'current_pix_clk\|video_rgb_clock')"
        echo "- recommended next task: confirm active branch and fanout before timing gate"
        echo "- requires: source edits + timing documentation"
        ;;
      PLL_RESET_NOT_CONNECTED)
        echo "- reason: reset and recovery behavior may affect deterministic bring-up"
        echo "- source: $(sample_source 'mf_pllbase\|\.rst')"
        echo "- recommended next task: document intended reset handling and any required source edits"
        echo "- requires: source edits + QSF review"
        ;;
      *)
        echo "- reason: unlisted class; treat as low-priority until source verification"
        echo "- source: $(sample_source "$cls")"
        echo "- recommended next task: add explicit source mapping before timing closure"
        echo "- requires: source review"
        ;;
    esac

    if [[ "$title" == "Priority 1 - Clocking and timing-structure risks" ]]; then
      echo "- blocks_timing_gate_now: $block_now"
    else
      echo "- blocks_timing_gate_now: yes"
    fi
    echo
  done
}

all_blocking=0
add_blockers() {
  local cls="$1"
  all_blocking=$((all_blocking + $(class_count "$cls")))
}

for cls in CODE_16406 CODE_16407 CODE_19016 CODE_19017 PLL_RESET_NOT_CONNECTED \
           INCOMPLETE_IO_ASSIGNMENTS CODE_15714 PIN_ASSIGNMENT_WARNING CODE_15610 CODE_21074 \
           CODE_13009 CODE_13010 CODE_13024 CODE_13032 CODE_13033 CODE_13039 CODE_13040 CODE_13410 NO_OUTPUT_ENABLE CODE_169064 \
           IGNORED_FAST_IO_WILDCARD CODE_176251; do
  add_blockers "$cls"

done

: > "$OUT_DOC"
{
  echo "# openFPGA Genesis timing-review blocker order"
  echo "Generated: $NOW"
  echo "Reason: prioritize what must be reviewed before timing-review-only gate"
  echo
  echo "Inputs:"
  echo "- ${WARNING_SUMMARY#$ROOT_DIR/}"
  echo "- ${REVIEW_DOC#$ROOT_DIR/}"
  echo "- ${RESOURCE_DOC#$ROOT_DIR/}"
  echo "- ${GATE_DOC#$ROOT_DIR/}"
  echo "- ${QSF#$ROOT_DIR/}"
  echo "- ${APF_TOP#$ROOT_DIR/}"
  echo "- ${CORE_TOP#$ROOT_DIR/}"
  echo
  echo "active_timing_blocker_count: ${all_blocking}"
  echo
  echo "## Priority 1 - Clocking and timing-structure risks"
  echo "- blocks timing-review gate now: yes"
  echo "- action type: depends_on_class"
  echo
  emit_blockers "Priority 1 - Clocking and timing-structure risks" "yes" \
    CODE_16406 CODE_16407 CODE_19016 CODE_19017 PLL_RESET_NOT_CONNECTED
  echo
  echo "## Priority 2 - APF / pin / I/O assignment risks"
  echo "- blocks timing-review gate now: yes"
  echo "- action type: depends_on_class"
  echo
  emit_blockers "Priority 2 - APF / pin / I/O assignment risks" "yes" \
    INCOMPLETE_IO_ASSIGNMENTS CODE_15714 PIN_ASSIGNMENT_WARNING CODE_15610 CODE_21074
  echo
  echo "## Priority 3 - Bidirectional / tri-state / output-enable risks"
  echo "- blocks timing-review gate now: yes"
  echo "- action type: depends_on_class"
  echo
  emit_blockers "Priority 3 - Bidirectional / tri-state / output-enable risks" "yes" \
    CODE_13009 CODE_13010 CODE_13024 CODE_13032 CODE_13033 CODE_13039 CODE_13040 CODE_13410 NO_OUTPUT_ENABLE CODE_169064
  echo
  echo "## Priority 4 - Fast I/O / register assignment risks"
  echo "- blocks timing-review gate now: yes"
  echo "- action type: depends_on_class"
  echo
  emit_blockers "Priority 4 - Fast I/O / register assignment risks" "yes" \
    IGNORED_FAST_IO_WILDCARD CODE_176251
  echo

  echo "## Cross-checks"
  gate_decision=""
  gate_decision="$(rg -m1 'Current gate decision:' "$GATE_DOC" | sed -E 's/.*\*\*([^*]+)\*\*.*/\1/' | tr -d '[:space:]' || true)"
  echo "- current gate decision: ${gate_decision:-unknown}"
  p1_gate="$(rg -m1 'Current priority1 gate decision:' "$PRIORITY1_GATE" 2>/dev/null | sed -E 's/.*\*\*([^*]+)\*\*.*/\1/' | tr -d '[:space:]' || true)"
  echo "- priority1 clocking gate decision: **${p1_gate:-unknown}**"
  echo "- top active priority groups should remain REVIEW_FITTER_WARNINGS_FIRST until classes are resolved"
  echo
  echo "- Priority 1 gate $(priority1_note "$p1_decision_line")"
  echo
  echo "## Required next step"
  echo "- Keep gate at REVIEW_FITTER_WARNINGS_FIRST until high-risk timing groups are reviewed and documented."
} > "$OUT_DOC"

echo "Wrote docs/OPENFPGA_GENESIS_TIMING_REVIEW_BLOCKER_ORDER.md"
