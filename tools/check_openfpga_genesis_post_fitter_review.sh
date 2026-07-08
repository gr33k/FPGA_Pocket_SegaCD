#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SUMMARY_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md"
REVIEW_SUMMARY="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_UNKNOWN_WARNING_REVIEW.md"
RESOURCE_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_RESOURCE_SUMMARY.md"
GATE_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_POST_FITTER_GATE.md"
CHECK_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_POST_FITTER_REVIEW_CHECK.md"
SMOKE_CHECK="${ROOT_DIR}/docs/OPENFPGA_GENESIS_FITTER_SMOKE_CHECK.md"
STATUS_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_STATUS.md"
NOW="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

status="pass"
reasons=()

require_file() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    status="fail"
    reasons+=("missing:$file")
    return 1
  fi
}

fitter_smoke_ok() {
  local map_exit fit_exit fit_attempted

  map_exit="$(rg -m1 '^Map exit code:' "$STATUS_FILE" | awk -F': ' '{print $NF}' | tr -d '\r' || true)"
  fit_exit="$(rg -m1 '^Fitter exit code:' "$STATUS_FILE" | awk -F': ' '{print $NF}' | tr -d '\r' || true)"
  fit_attempted="$(rg -m1 '^Fitter attempted:' "$STATUS_FILE" | awk -F': ' '{print $NF}' | tr -d '\r' || true)"

  if [[ "$map_exit" == "0" && "$fit_exit" == "0" && "$fit_attempted" == "yes" ]]; then
    if rg -q "Result: fitter-smoke-pass" "$STATUS_FILE" 2>/dev/null; then
      return 0
    fi
  fi

  if [[ -f "$SMOKE_CHECK" ]] && rg -q "Result: PASS" "$SMOKE_CHECK"; then
    return 0
  fi

  return 1
}

require_file "$SUMMARY_FILE"
require_file "$REVIEW_SUMMARY"
require_file "$RESOURCE_FILE"
require_file "$GATE_FILE"

if [[ -f "$SUMMARY_FILE" ]]; then
  if ! rg -q 'Map errors:' "$SUMMARY_FILE"; then
    status="fail"
    reasons+=("summary-missing-map-errors")
  fi
  if ! rg -q 'Map warnings:' "$SUMMARY_FILE"; then
    status="fail"
    reasons+=("summary-missing-map-warnings")
  fi
  if ! rg -q 'Fitter errors:' "$SUMMARY_FILE"; then
    status="fail"
    reasons+=("summary-missing-fitter-errors")
  fi
  if ! rg -q 'Fitter warnings:' "$SUMMARY_FILE"; then
    status="fail"
    reasons+=("summary-missing-fitter-warnings")
  fi
  if rg -q '^decision=' "$SUMMARY_FILE"; then
    decision="$(rg -m1 '^decision=' "$SUMMARY_FILE" | sed -E 's/^decision=//')"
    case "$decision" in
      READY_FOR_TIMING_REVIEW_GATE|REVIEW_FITTER_WARNINGS_FIRST|BLOCKED_AFTER_FITTER)
        ;;
      *)
        status="fail"
        reasons+=("summary-invalid-decision:$decision")
        ;;
    esac
  else
    status="fail"
    reasons+=("summary-missing-decision")
  fi
fi

if [[ -f "$GATE_FILE" ]]; then
  if ! rg -q 'Current gate decision:' "$GATE_FILE"; then
    status="fail"
    reasons+=("gate-missing-decision-line")
  else
    if ! rg -q 'READY_FOR_TIMING_REVIEW_GATE|REVIEW_FITTER_WARNINGS_FIRST|BLOCKED_AFTER_FITTER' "$GATE_FILE"; then
      status="fail"
      reasons+=("gate-invalid-decision")
    fi
  fi

  for token in "Assembler was not run" "Timing analysis was not run" "Bitstream was not intentionally generated" "APF packaging was not run" "Pocket boot was not proven" "Runtime correctness was not proven"; do
    if ! rg -q "$token" "$GATE_FILE"; then
      status="fail"
      reasons+=("gate-missing-scope:$token")
    fi
  done
fi

if [[ -f "$RESOURCE_FILE" ]]; then
  if ! rg -q "## Resource utilization" "$RESOURCE_FILE"; then
    status="warn"
    reasons+=("resource-missing-section")
  fi
fi

if [[ -f "$REVIEW_SUMMARY" ]]; then
  if ! rg -q "## Unknown warning classes" "$REVIEW_SUMMARY"; then
    status="warn"
    reasons+=("review-missing-unknown-section")
  fi
  if ! rg -q "REVIEW_ENTRY class=" "$REVIEW_SUMMARY"; then
    status="fail"
    reasons+=("review-missing-review-entries")
  fi
fi

if [[ -f "$SMOKE_CHECK" || -f "$STATUS_FILE" ]]; then
  if ! fitter_smoke_ok; then
    status="fail"
    reasons+=("fitter-smoke-not-pass")
  fi
fi

if [[ "$status" == "pass" ]]; then
  if rg -q "decision=BLOCKED_AFTER_FITTER" "$SUMMARY_FILE" "$GATE_FILE"; then
    status="warn"
    reasons+=("blocked-path")
  fi
fi

: > "$CHECK_FILE"
{
  echo "# openFPGA Genesis post-fitter review check (advisory)"
  echo "Generated: $NOW"
  echo "Status: $status"
  echo
  echo "## Files checked"
  echo "- docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md"
  echo "- docs/OPENFPGA_GENESIS_FITTER_UNKNOWN_WARNING_REVIEW.md"
  echo "- docs/OPENFPGA_GENESIS_FITTER_RESOURCE_SUMMARY.md"
  echo "- docs/OPENFPGA_GENESIS_POST_FITTER_GATE.md"
  echo "- docs/OPENFPGA_GENESIS_POST_FITTER_REVIEW_CHECK.md"
  echo
  echo "## Required scope constraints"
  echo "- assembler did not run"
  echo "- timing did not run"
  echo "- bitstream was not intentionally generated"
  echo "- APF packaging was not run"
  echo "- Pocket boot not claimed"
  echo "- runtime correctness not claimed"
  echo
if [[ ${#reasons[@]} -eq 0 ]]; then
    echo "Result: PASS"
    echo "No known blockers in this documentation-only review pass."
  else
    if [[ "$status" == "warn" ]]; then
      echo "Result: WARN"
    elif [[ "$status" == "pass" ]]; then
      echo "Result: PASS"
    else
      echo "Result: FAIL"
    fi
    echo "Issues:"
    for reason in "${reasons[@]}"; do
      echo "- ${reason}"
    done
  fi
} > "$CHECK_FILE"

echo "Result: $status"
if [[ ${#reasons[@]} -gt 0 ]]; then
  printf 'Checks:\n'
  printf '%s\n' "${reasons[@]}"
fi
