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
  count="$(rg --fixed-strings --line-number --max-count 1 -- "- ${cls} | count=" "$WARNING_SUMMARY" 2>/dev/null | sed -E 's/.*count=([0-9]+).*/\1/' || true)"
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

  found="$(rg -n -m 1 "$pattern" "$APF_TOP" "$CORE_TOP" "$QSF" 2>/dev/null | head -n 1 || true)"
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

rel_path() {
  local path="$1"
  printf '%s' "${path/#$ROOT_DIR\//}"
}

emit_blockers() {
  local title="$1"
  local block_now="$2"
  shift 2
  local classes=("$@")

  echo "## $title"
  echo "- blocks timing-review gate now: $block_now"
  echo "- action type: depends_on_class"
  echo

  local cls
  for cls in "${classes[@]}"; do
    local count
    count="$(class_count "$cls")"
    if [[ "$count" == "0" ]]; then
      echo "### $cls"
      echo "- count: 0"
      echo "- status: no active instances"
      echo "- blocks_timing_gate_now: no"
      echo "- source review: none"
      echo "- next step: keep as documentation item until feature expands"
      echo
      continue
    fi

    echo "### $cls"
    echo "- count: $count"

    case "$cls" in
      NON_DEDICATED_CLOCK_ROUTING)
        echo "- reason: clocking constraints path may be too weak for timing review"
        echo "- source: $(sample_source 'non-dedicated')"
        echo "- recommended next task: review clocking topology and constraint intent before timing review"
        echo "- requires: QSF review"
        ;;
      CODE_16406|CODE_16407)
        echo "- reason: PLL/clock pin behavior is timing-sensitive in scaffolded top-level"
        echo "- source: $(sample_source 'clk_74b')"
        echo "- recommended next task: keep as manual timing-review item for first clocking cleanup"
        echo "- requires: APF pin-plan + QSF review"
        ;;
      CODE_19016|CODE_19017)
        echo "- reason: pixel clock muxing impacts timing path review"
        echo "- source: $(sample_source 'current_pix_clk\|pixel')"
        echo "- recommended next task: confirm active branch and fanout before timing gate"
        echo "- requires: source edits + timing documentation"
        ;;
      PLL_RESET_NOT_CONNECTED)
        echo "- reason: reset and recovery behavior may affect deterministic bring-up"
        echo "- source: $(sample_source 'rst')"
        echo "- recommended next task: document intended reset handling and any required source edits"
        echo "- requires: source edits + QSF review"
        ;;
      INCOMPLETE_IO_ASSIGNMENTS|CODE_15714)
        echo "- reason: incomplete APF assignment map creates timing and integration risk"
        echo "- source: $(sample_source 'incomplete I/O assignments\|cart_tran\|pin')"
        echo "- recommended next task: align APF pin mapping and keep unimplemented ports documented"
        echo "- requires: QSF + source review"
        ;;
      PIN_ASSIGNMENT_WARNING|CODE_15610|CODE_21074)
        echo "- reason: input/output constant/no-driver conditions can create timing-opaque paths"
        echo "- source: $(sample_source 'No output dependent on input pin\|output enable\|cart')"
        echo "- recommended next task: confirm expected stubs and document intentional placeholders"
        echo "- requires: source review"
        ;;
      CODE_13009|CODE_13010|CODE_13024|CODE_13032|CODE_13033|CODE_13039|CODE_13040|CODE_13410|NO_OUTPUT_ENABLE|CODE_169064)
        echo "- reason: tri-state or bidirectional behavior affects timing analysis and board-level behavior"
        echo "- source: $(sample_source 'tri-state\|inout\|cart_tran')"
        echo "- recommended next task: keep these as first-pass APF pin and I/O topology checks"
        echo "- requires: source review + optional pin-constraint updates"
        ;;
      IGNORED_FAST_IO_WILDCARD|CODE_176251)
        echo "- reason: wildcard fast I/O behavior can hide timing constraints for output registers"
        echo "- source: $(sample_source 'FAST_OUTPUT_REGISTER\|wildcard')"
        echo "- recommended next task: migrate to explicit per-signal timing intent before timing review"
        echo "- requires: QSF review"
        ;;
      CODE_10259|CODE_10030|CODE_10858|CODE_12241|CODE_292013)
        echo "- reason: these are retained legacy/smoke-only classes in this milestone"
        echo "- source: inherited openFPGA scaffold behavior"
        echo "- recommended next task: monitor while enabling real ROM and controller paths"
        echo "- requires: documentation review"
        ;;
      CODE_14284|CODE_14285|CODE_14320|CODE_287013)
        echo "- reason: synthesized-away or inferred resource behavior in stubbed paths"
        echo "- source: $(sample_source 'synthesized away\|logic cells')"
        echo "- recommended next task: revisit when ROM/memory paths are enabled"
        echo "- requires: documentation review"
        ;;
      *)
        echo "- reason: unlisted class; treat as low-priority until source verification"
        echo "- source: $(sample_source "$cls")"
        echo "- recommended next task: add explicit source mapping before timing closure"
        echo "- requires: source review"
        ;;
    esac

    echo "- blocks_timing_gate_now: $block_now"
    echo
  done
}

all_blocking=0
add_blockers() {
  local cls="$1"
  all_blocking=$((all_blocking + $(class_count "$cls")))
}

for cls in NON_DEDICATED_CLOCK_ROUTING CODE_16406 CODE_16407 CODE_19016 CODE_19017 PLL_RESET_NOT_CONNECTED \
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
  emit_blockers "Priority 1" "yes" \
    NON_DEDICATED_CLOCK_ROUTING CODE_16406 CODE_16407 CODE_19016 CODE_19017 PLL_RESET_NOT_CONNECTED
  echo
  echo "## Priority 2 - APF / pin / I/O assignment risks"
  emit_blockers "Priority 2" "yes" \
    INCOMPLETE_IO_ASSIGNMENTS CODE_15714 PIN_ASSIGNMENT_WARNING CODE_15610 CODE_21074
  echo
  echo "## Priority 3 - Bidirectional / tri-state / output-enable risks"
  emit_blockers "Priority 3" "yes" \
    CODE_13009 CODE_13010 CODE_13024 CODE_13032 CODE_13033 CODE_13039 CODE_13040 CODE_13410 NO_OUTPUT_ENABLE CODE_169064
  echo
  echo "## Priority 4 - Fast I/O / register assignment risks"
  emit_blockers "Priority 4" "yes" \
    IGNORED_FAST_IO_WILDCARD CODE_176251
  echo
  echo "## Priority 5 - Low-priority inherited / smoke-only"
  emit_blockers "Priority 5" "no" \
    CODE_10259 CODE_12241 CODE_10030 CODE_10858 CODE_14284 CODE_14285 CODE_14320 CODE_287013 CODE_292013
  echo
  echo "## Cross-checks"
  gate_decision="$(rg -m1 '^Current gate decision:' "$GATE_DOC" | sed -E 's/.*\*\*([^*]+)\*\*.*/\1/' | tr -d '[:space:]' || true)"
  priority1_status="unknown"
  if [[ -f "$PRIORITY1_GATE" ]]; then
    priority1_status="$(rg -m1 '^Current priority1 gate decision:' "$PRIORITY1_GATE" | sed -E 's/.*:\\s*//; s/[[:space:]]*$//' || true)"
  fi
  if [[ -z "$gate_decision" ]]; then
    gate_decision="unknown"
  fi
  echo "- current gate decision: $gate_decision"
  if [[ -n "$priority1_status" ]]; then
    echo "- priority1 clocking gate decision: $priority1_status"
  else
    echo "- priority1 clocking gate decision: not yet generated"
  fi
  echo "- top active priority groups should remain REVIEW_FITTER_WARNINGS_FIRST until classes are resolved"
  echo
  if [[ "$priority1_status" == "PRIORITY1_CLOCKING_BLOCKED" ]]; then
    echo "- Priority 1 remains blocked; timing-review gating remains conservative."
  elif [[ "$priority1_status" == "PRIORITY1_CLOCKING_REVIEW_STILL_REQUIRED" ]]; then
    echo "- Priority 1 review still required before timing-review progression."
  else
    echo "- Priority 1 gate is clear for timing-review handoff, but lower-priority groups remain active."
  fi
  echo
  echo "## Required next step"
  echo "- Keep gate at REVIEW_FITTER_WARNINGS_FIRST until high-risk timing groups are reviewed and documented."
} > "$OUT_DOC"

echo "Wrote $OUT_DOC"
echo "active_timing_blocker_count=${all_blocking}"
