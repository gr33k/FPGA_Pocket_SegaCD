#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REVIEW_DOC="$ROOT_DIR/docs/OPENFPGA_GENESIS_PRIORITY1_CLOCKING_REVIEW.md"
GATE_DOC="$ROOT_DIR/docs/OPENFPGA_GENESIS_PRIORITY1_CLOCKING_GATE.md"
TIMING_DOC="$ROOT_DIR/docs/OPENFPGA_GENESIS_TIMING_REVIEW_BLOCKER_ORDER.md"
CHECK_DOC="$ROOT_DIR/docs/OPENFPGA_GENESIS_PRIORITY1_CLOCKING_REVIEW_CHECK.md"
NOW="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

status="pass"
reasons=()

need_file() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    status="fail"
    reasons+=("missing:$file")
    return 1
  fi
}

need_file "$REVIEW_DOC"
need_file "$GATE_DOC"
need_file "$TIMING_DOC"

if [[ -f "$REVIEW_DOC" ]]; then
  if ! rg -q "# openFPGA Genesis Priority-1 clocking review" "$REVIEW_DOC"; then
    status="fail"
    reasons+=("review-missing-header")
  fi
  for cls in NON_DEDICATED_CLOCK_ROUTING CODE_16406 CODE_16407 CODE_19016 CODE_19017 PLL_RESET_NOT_CONNECTED; do
    if ! rg -q "### ${cls}" "$REVIEW_DOC"; then
      status="warn"
      reasons+=("review-missing-class:${cls}")
    fi
  done

  total_items="$(rg -m1 'total priority1 review items:' "$REVIEW_DOC" | sed -E 's/.*: *([0-9]+).*/\\1/' || true)"
  if [[ -z "$total_items" ]]; then
    status="fail"
    reasons+=("review-missing-aggregate")
  fi
fi

if [[ -f "$GATE_DOC" ]]; then
  if ! rg -q 'Current priority1 gate decision:' "$GATE_DOC"; then
    status="fail"
    reasons+=("gate-missing-decision")
  else
    gate_decision="$(rg -m1 'Current priority1 gate decision:' "$GATE_DOC" | awk -F'\\*\\*' '{print $2}' | tr -d '[:space:]' || true)"
    case "$gate_decision" in
      PRIORITY1_CLOCKING_BLOCKED|PRIORITY1_CLOCKING_REVIEW_STILL_REQUIRED)
        ;;
      *)
        status="fail"
        reasons+=("gate-invalid-decision:$gate_decision")
        ;;
    esac
  fi
fi

for token in "fitter: not run" "assembler: not run" "timing: not run" "bitstream: not generated"; do
  if ! rg -q "$token" "$GATE_DOC"; then
    status="warn"
    reasons+=("gate-missing-scope:$token")
  fi
done

{
  echo "# openFPGA Genesis Priority-1 clocking review check"
  echo "Generated: $NOW"
  echo "Status: $status"
  echo
  echo "Files checked:"
  echo "- docs/OPENFPGA_GENESIS_PRIORITY1_CLOCKING_REVIEW.md"
  echo "- docs/OPENFPGA_GENESIS_PRIORITY1_CLOCKING_GATE.md"
  echo "- docs/OPENFPGA_GENESIS_TIMING_REVIEW_BLOCKER_ORDER.md"
  echo
  if [[ ${#reasons[@]} -eq 0 ]]; then
    echo "Result: PASS"
    echo "Priority-1 review and gate file are present and internally referenced."
  else
    if [[ "$status" == "warn" ]]; then
      echo "Result: WARN"
    elif [[ "$status" == "fail" ]]; then
      echo "Result: FAIL"
    else
      echo "Result: PASS"
    fi
    echo "Checklist issues:"
    printf '%s\n' "${reasons[@]}" | sed 's/^/- /'
  fi
} > "$CHECK_DOC"

echo "status=$status"
if [[ ${#reasons[@]} -gt 0 ]]; then
  printf '%s
' "${reasons[@]}"
fi
