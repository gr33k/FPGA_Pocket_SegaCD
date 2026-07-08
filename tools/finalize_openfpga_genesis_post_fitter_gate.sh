#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATUS_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_STATUS.md"
CHECK_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_SMOKE_CHECK.md"
WARNING_SUMMARY="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md"
RESOURCE_SUMMARY="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_RESOURCE_SUMMARY.md"
OUT_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_POST_FITTER_GATE.md"
NOW="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

required=("$STATUS_FILE" "$CHECK_FILE" "$WARNING_SUMMARY" "$RESOURCE_SUMMARY")
for file in "${required[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required source file: $file"
    exit 1
  fi

done

map_exit="$(rg -m1 '^Map exit code:' "$STATUS_FILE" | awk -F': ' '{print $NF}' | tr -d '\r' || true)"
fitter_exit="$(rg -m1 '^Fitter exit code:' "$STATUS_FILE" | awk -F': ' '{print $NF}' | tr -d '\r' || true)"
fitter_attempted="$(rg -m1 '^Fitter attempted:' "$STATUS_FILE" | awk -F': ' '{print $NF}' | tr -d '\r' || true)"
fit_result_line="$(rg -m1 'Result:' "$CHECK_FILE" | sed 's/.*Result:[[:space:]]*//' | tr -d '\r' || true)"
fit_result="${fit_result_line:-}"

if [[ "$fit_result" == "" ]]; then
  if rg -q 'FITTER_SMOKE_PASS|PASS' "$CHECK_FILE" 2>/dev/null; then
    fit_result="PASS"
  else
    fit_result=""
  fi
fi

warning_decision="$(rg -m1 '^decision=' "$WARNING_SUMMARY" | sed -E 's/^decision=//' || true)"
if [[ "$warning_decision" == "" ]]; then
  warning_decision="REVIEW_FITTER_WARNINGS_FIRST"
fi

critical_classes="$(rg -c 'risk=blocks timing/assembler gate' "$WARNING_SUMMARY" || true)"
unknown_classes="$(rg -c 'risk=unknown' "$WARNING_SUMMARY" || true)"

if [[ "$map_exit" != "0" || "$fitter_exit" != "0" ]]; then
  gate="BLOCKED_AFTER_FITTER"
elif [[ "$fitter_attempted" != "yes" ]]; then
  gate="BLOCKED_AFTER_FITTER"
elif (( ${critical_classes:-0} > 0 )); then
  gate="BLOCKED_AFTER_FITTER"
elif [[ "$warning_decision" == "REVIEW_FITTER_WARNINGS_FIRST" || ${unknown_classes:-0} -gt 0 ]]; then
  gate="REVIEW_FITTER_WARNINGS_FIRST"
else
  gate="READY_FOR_TIMING_REVIEW_GATE"
fi

: > "$OUT_FILE"
{
  echo "# openFPGA Genesis post-fitter gate"
  echo "Generated: $NOW"
  echo
  echo "## Inputs"
  echo "- Fitter smoke status: docs/OPENFPGA_GENESIS_FITTER_SMOKE_STATUS.md"
  echo "- Fitter smoke check: docs/OPENFPGA_GENESIS_FITTER_SMOKE_CHECK.md"
  echo "- Warning summary: docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md"
  echo "- Resource summary: docs/OPENFPGA_GENESIS_FITTER_RESOURCE_SUMMARY.md"
  echo
  echo "## Gate decision"
  echo "Current gate decision: **$gate**"
  echo
  echo "## Evidence"
  echo "Map exit code: ${map_exit:-missing}"
  echo "Fitter exit code: ${fitter_exit:-missing}"
  echo "Fitter attempted: ${fitter_attempted:-missing}"
  echo "Fitter smoke check result: ${fit_result:-missing}"
  echo "Warning decision: ${warning_decision}"
  echo
  echo "## Scope constraints for this task"
  echo "- Assembler was not run"
  echo "- Timing analysis was not run"
  echo "- Bitstream was not intentionally generated"
  echo "- APF packaging was not run"
  echo "- Pocket boot was not proven"
  echo "- Runtime correctness was not proven"
  echo
  echo "## Rationale"
  echo "- No Quartus assembler/timing/bitstream flow is enabled in this gate"
  echo "- This gate only controls transition from fitter smoke review to the next timing-review-only step"
  echo
  case "$gate" in
    READY_FOR_TIMING_REVIEW_GATE)
      echo "- Decision is ready for a timing-review-only next gate, not for assembler or bitstream actions."
      ;;
    REVIEW_FITTER_WARNINGS_FIRST)
      echo "- Review first: one or more warnings need explicit confirmation before timing review."
      ;;
    BLOCKED_AFTER_FITTER)
      echo "- Blocked after fitter smoke because this gate found hard conditions needing local repair before timing review."
      ;;
    *)
      echo "- Decision is defaulted for safety."
      ;;
  esac
} > "$OUT_FILE"

echo "Gate decision: $gate"
echo "Wrote $OUT_FILE"
