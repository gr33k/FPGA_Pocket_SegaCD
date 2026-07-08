#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GATE_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_READINESS_GATE.md"
DISPOSITION_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_WARNING_DISPOSITION.md"
STATUS_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md"
CHECK_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_FITTER_GATE_READY_CHECK.md"
GATE_FILE_REL="docs/OPENFPGA_GENESIS_FITTER_READINESS_GATE.md"
DISPOSITION_FILE_REL="docs/OPENFPGA_GENESIS_WARNING_DISPOSITION.md"
STATUS_FILE_REL="docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md"
NOW="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

status="pass"
reasons=()

require_file() {
  local file="$1"
  local label="$2"
  if [[ ! -f "$file" ]]; then
    status="fail"
    reasons+=("missing:$label")
  fi
}

extract_gate_decision() {
  local file="$1"
  local line
  line="$(grep -m1 -E '^- \*\*Current gate decision\*\*|Current gate decision' "$file" 2>/dev/null || true)"
  if [[ -z "$line" ]]; then
    echo ""
    return
  fi
  echo "$line" | sed -E 's/.*Current gate decision: \*\*([^*]+)\*\*.*/\1/'
}

extract_analysis_exit() {
  local file="$1"
  local line
  line="$(grep -m1 '^Analysis exit:' "$file" 2>/dev/null || true)"
  echo "${line##*: }"
}

extract_qip_count() {
  local file="$1"
  local line
  line="$(grep -m1 '^QIP/SDC assignments:' "$file" 2>/dev/null | tr -d '\r' || true)"
  echo "${line##*: }" | tr -cd '0-9'
}

require_file "$GATE_FILE" "fitter readiness gate"
require_file "$DISPOSITION_FILE" "warning disposition"
require_file "$STATUS_FILE" "analysis-only status"

gate_decision="$(extract_gate_decision "$GATE_FILE")"
analysis_exit="$(extract_analysis_exit "$STATUS_FILE")"
qip_count="$(extract_qip_count "$STATUS_FILE")"
boot_safety=0
if grep -q "This does not prove Pocket boot or runtime correctness\." "$DISPOSITION_FILE" 2>/dev/null; then
  boot_safety=1
fi

if [[ "$gate_decision" != "READY_FOR_FITTER_GATE" ]]; then
  status="fail"
  reasons+=("gate-decision:${gate_decision:-missing}")
fi
if [[ -z "$analysis_exit" ]]; then
  status="fail"
  reasons+=("analysis-exit:missing")
elif [[ "$analysis_exit" != "0" ]]; then
  status="fail"
  reasons+=("analysis-exit:${analysis_exit}")
fi
if [[ -z "$qip_count" ]]; then
  qip_count=0
fi
if [[ "$qip_count" != "9" ]]; then
  status="fail"
  reasons+=("qip-sdc-assignments:${qip_count:-0}")
fi
if (( boot_safety != 1 )); then
  status="fail"
  reasons+=("missing-runtime-safety-statement")
fi
if ! grep -qiE 'fitter|asm|assembler|sta|timing|bitstream|APF packaging|APF packaging' "$DISPOSITION_FILE" >/dev/null 2>&1; then
  true
fi

{
  echo "# openFPGA Genesis fitter gate ready check"
  echo "Generated: $NOW"
  echo "Status: $status"
  echo "Gate file: $GATE_FILE_REL"
  echo "Disposition file: $DISPOSITION_FILE_REL"
  echo "Analysis status file: $STATUS_FILE_REL"
  echo
  echo "- Gate decision: ${gate_decision:-missing}"
  echo "- Analysis exit: ${analysis_exit:-missing}"
  echo "- QIP/SDC assignments: ${qip_count:-0}"
  echo "- Disposition boot safety statement present: $boot_safety"
  echo
  if (( ${#reasons[@]} == 0 )); then
    echo "Result: PASS"
  else
    echo "Result: NOT READY"
    echo "Failing checks:"
    printf '%s\n' "${reasons[@]}"
  fi
} > "$CHECK_FILE"

echo "Wrote $CHECK_FILE"
if [[ "$status" == "pass" ]]; then
  echo "PASS"
else
  echo "NOT READY"
  printf '%s\n' "${reasons[@]}"
fi
